% Clear command window and workspace
clc;
clear all;
close all;

% Call EnvSetup function to initialize the environment and both robots (UR3e and Nova2)
[nova2, ur3e, cup, cupLid, milkJug, iceCube, portafilter] = EnvSetup();  % Includes both nova2 and ur3e robots

% Set up the environment with various objects (shelves, barriers, a person model, emergency stops, and a table).
hold on;  % Hold the current plot for multiple objects
axis equal;  % Maintain equal scaling for all axes
axis([-1.8 1.8 -1.8 1.8 -0.1 1.5]);  % Set the axis limits
view(210, 20);

% Define the bounding box at (-0.5, -0.25, 1) with size 50x50x50 cm
boundingBoxMin = [-0.75, -0.5, 0.75];  % Min corner of the box in meters
boundingBoxMax = [-0.25, 0, 1.25];     % Max corner of the box in meters
% Draw the bounding box (optional, for visualization)
plotcube([0.5 0.5 0.5], boundingBoxMin, 0.1, [1 0 0]);  % A red semi-transparent box

%% Teach function for nova2 and UR3e
disp('Please teach the UR3e robot by moving it to the desired position and pressing Enter.');
ur3e.model.teach();  % Call teach function to manually set the position for UR3e
nova2.model.teach();  % Call teach function to manually set the position for Nova2

%% Define a trajectory for UR3e based on the provided joint angles
qWaypoints2 = [
    deg2rad([0, 0, 0, 0, 0, 0]);               % Initial position
    deg2rad([0, -64.8, 137, -151, 0, 0]);      % Rotate
    deg2rad([100, -64.8, 137, -151, 0, 0]);    % Fold
    deg2rad([100, -50.4, 115, -151, 0, 0]);    % Rotate
    deg2rad([122, -50.4, 115, -151, 0, 0]);    % Pick Jug
    deg2rad([122, -64.8, 115, -151, 0, 0]);    % Lift to Reach
    deg2rad([122, -50.4, 115, -151, 0, 0]);    % Put back Jug
    deg2rad([100, -50.4, 115, -151, 0, 0]);    % Rotate
    deg2rad([100, -64.8, 137, -151, 0, 0]);    % Fold
    deg2rad([-22, -64.8, 137, -151, 0, 0]);    % Rotate back to initial fold position
    deg2rad([0, 0, 0, 0, 0, 0]);               % Return to initial position
];

% Interpolate waypoints for UR3e
qMatrix2 = InterpolateWaypointRadians(qWaypoints2, deg2rad(4));  % For UR3e

% Resample qMatrix2 to have a certain number of steps if needed
maxSteps = 600;  % You can adjust the number of steps for smoother/slower motion
qMatrix2_resampled = resampleTrajectory(qMatrix2, maxSteps);

% Define a trajectory for Nova2 (You can define custom waypoints for Nova2 similar to UR3e)
qWaypointsNova2 = [
    deg2rad([0, 0, 0, 0, 0, 0]);               % Initial position
    deg2rad([0, -45, 90, -90, 0, 0]);          % Pick position
    deg2rad([30, -45, 90, -90, 0, 0]);         % Mid position
    deg2rad([30, -60, 90, -120, 0, 0]);        % Lift position
    deg2rad([0, -45, 90, -90, 0, 0]);          % Return to initial
];

% Interpolate waypoints for Nova2
qMatrixNova2 = InterpolateWaypointRadians(qWaypointsNova2, deg2rad(4));  % For Nova2

% Resample qMatrixNova2 to have a certain number of steps if needed
qMatrixNova2_resampled = resampleTrajectory(qMatrixNova2, maxSteps);

% Animate both robots (UR3e and Nova2)
for i = 1:maxSteps
    % Animate UR3e
    ur3e.model.animate(qMatrix2_resampled(i, :));
    
    % Animate Nova2
    nova2.model.animate(qMatrixNova2_resampled(i, :));
    
    % Get UR3e's end-effector position
    ur3eEndEffector = ur3e.model.fkine(qMatrix2_resampled(i, :)).t;  % Translation part of the transformation matrix
    
    % Get Nova2's end-effector position
    nova2EndEffector = nova2.model.fkine(qMatrixNova2_resampled(i, :)).t;  % Translation part of the transformation matrix
    
    % Check for collision with the bounding box for both robots
    if isInsideBoundingBox(ur3eEndEffector, boundingBoxMin, boundingBoxMax)
        disp('Collision detected with UR3e! Movement stopped.');
        break;  % Stop the loop if collision is detected with UR3e
    elseif isInsideBoundingBox(nova2EndEffector, boundingBoxMin, boundingBoxMax)
        disp('Collision detected with Nova2! Movement stopped.');
        break;  % Stop the loop if collision is detected with Nova2
    end
    
    % Add a pause for real-time visualization
    pause(0.05);  % Adjust pause for slower/faster movement
end

%% Collision Detection Function
function isCollision = isInsideBoundingBox(position, boxMin, boxMax)
    isCollision = all(position >= boxMin') && all(position <= boxMax');
end

%% Resampling function to match trajectory length
function qMatrix_resampled = resampleTrajectory(qMatrix, numSteps)
    currentSteps = size(qMatrix, 1);
    qMatrix_resampled = interp1(1:currentSteps, qMatrix, linspace(1, currentSteps, numSteps));
end

%% InterpolateWaypointRadians function
function qMatrix = InterpolateWaypointRadians(waypointRadians, maxStepRadians)
    if nargin < 2
        maxStepRadians = deg2rad(1);
    end

    qMatrix = [];
    for i = 1:size(waypointRadians, 1) - 1
        qMatrix = [qMatrix; FineInterpolation(waypointRadians(i, :), waypointRadians(i + 1, :), maxStepRadians)]; %#ok<AGROW>
    end
end

%% FineInterpolation function
function qMatrix = FineInterpolation(q1, q2, maxStepRadians)
    if nargin < 3
        maxStepRadians = deg2rad(1);
    end
    
    steps = 2;
    while ~isempty(find(maxStepRadians < abs(diff(jtraj(q1, q2, steps))), 1))
        steps = steps + 1;
    end
    qMatrix = jtraj(q1, q2, steps);
end

%% Plotcube Function (to visualize the bounding box)
function plotcube(dim, pos, alpha, color)
    vertex_matrix = [...
        0 0 0; 1 0 0; 1 1 0; 0 1 0; ...
        0 0 1; 1 0 1; 1 1 1; 0 1 1];
    face_matrix = [...
        1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; ...
        1 2 3 4; 5 6 7 8];
    vertex_matrix = vertex_matrix .* dim;
    vertex_matrix = vertex_matrix + repmat(pos, 8, 1);
    patch('Vertices', vertex_matrix, 'Faces', face_matrix, 'FaceColor', color, 'FaceAlpha', alpha);
end
