% Clear command window and workspace
clc;
clear all;
close all;

% Initialize the Environment class
env = EnvSetup();

% Access environment objects
nova2 = env.nova2;
ur3e = env.ur3e;
cup = env.cup;
cupLid = env.cupLid;
milkJug = env.milkJug;
portafilter = env.portafilter;
baby = env.baby;
babyVertices = get(baby, 'Vertices');



% Set up the environment with various objects (shelves, barriers, a person model, emergency stops, and a table).
hold on;  % Hold the current plot for multiple objects
axis equal;  % Maintain equal scaling for all axes

% Define the bounding boxes
boundingBoxMin1 = [-0.7, -0.55, 0.65];
boundingBoxMax1 = [-0.2, -0.2, 1.15];
plotcube([0.5, 0.4, 0.6], boundingBoxMin1, 0.1, [1, 0, 0]);

boundingBoxMin2 = [0.05, -0.5, 0.65];
boundingBoxMax2 = [0.85, -0.2, 1.25];
plotcube([0.8, 0.3, 0.6], boundingBoxMin2, 0.1, [0, 0, 1]);

% Third bounding box at (0.75, -0.5, 0.65) with size 50x25x50 cm
boundingBoxMin3 = [0.9, -0.3, 0.65];                     % Min corner of the third box
boundingBoxMax3 = [1.1, -0.2, 1.15];  % Max corner of the third box
plotcube([0.2, 0.2, 0.5], boundingBoxMin3, 0.1, [0, 1, 0]);  % A green semi-transparent box

% Define bounding box 4
boundingBoxMin4 = [1.25, 0.25, 0];
dimensions = [0.05, 0.6, 1.0];  % 10x60x100 cm in meters
boundingBoxMax4 = boundingBoxMin4 + dimensions;
plotcube(dimensions, boundingBoxMin4, 0.1, [0, 1, 0]);  % Green semi-transparent box

% Store bounding box data
boundingBoxes = {boundingBoxMin1, boundingBoxMax1; boundingBoxMin2, boundingBoxMax2; boundingBoxMin3, boundingBoxMax3; boundingBoxMin4, boundingBoxMax4};

%% Define trajectories for UR3e and Nova2
qWaypoints2 = [
    deg2rad([0, 0, 0, 0, 0, 0]);
    deg2rad([0, -64.8, 137, -151, 0, 0]);
    deg2rad([100, -64.8, 137, -151, 0, 0]);
    deg2rad([0, 0, 0, 0, 0, 0]);
];
qMatrix2 = InterpolateWaypointRadians(qWaypoints2, deg2rad(4));
qMatrix2_resampled = resampleTrajectory(qMatrix2, 600);

qWaypointsNova2 = [
    deg2rad([0, 0, 0, 0, 0, 0]);               % Initial position
    deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]); % Grab cup position
    deg2rad([-7.2, 36, -72, -50.4, 180, 0]);   % Lift cup
    deg2rad([5, 57.6, -122, -21.6, 180, 0]);   % Move to intermediary
    deg2rad([64.8, 57.6, -122, -21.6, 180, 0]); % Move to machine
    deg2rad([64.8, 43.2, -108, -21.6, 180, 0]); % Place cup
    deg2rad([57.6, 93.6, -158, -21.6, 180, 0]); % Pull back after placing
    deg2rad([0, 93.6, -158, -21.6, 180, 0]);    % Rotate back to initial
    deg2rad([-14.4, 14.4, -28.8, -64.8, 93.6, 0]); % Pick pipe
    deg2rad([7.2, 101, -151, -36, 93.6, 0]);    % Lift pipe
    deg2rad([151, 101, -151, -36, 93.6, 0]);    % Rotate with pipe
    deg2rad([151, 79.2, -130, -36, 93.6, 0]);   % Place pipe
    deg2rad([151, 101, -151, -36, 93.6, 0]);    % Pull pipe back
];
qMatrixNova2 = InterpolateWaypointRadians(qWaypointsNova2, deg2rad(4));
qMatrixNova2_resampled = resampleTrajectory(qMatrixNova2, 600);
c = 0;
% Animate both robots
for i = 2:size(qMatrix2_resampled, 1)  % Start loop from the second step to avoid initial collision check
    % Animate UR3e and Nova2
    ur3e.model.animate(qMatrix2_resampled(i, :));
    nova2.model.animate(qMatrixNova2_resampled(i, :));
    c = c - 0.05;
    x = transl(c, 0, 0);
    transformedVertices = [babyVertices,ones(size(babyVertices,1),1)] * (x)';
    % Update the object's vertices
    set(baby, 'Vertices', transformedVertices(:, 1:3));
    % Get end-effector positions

    babyPosition = mean(transformedVertices(:, 1:3), 1);


    ur3eEndEffector = ur3e.model.fkine(qMatrix2_resampled(i, :)).t;
    nova2EndEffector = nova2.model.fkine(qMatrixNova2_resampled(i, :)).t;
    
    %% for the light plane

    % Collision check for each bounding box
    for j = 1:size(boundingBoxes, 1)
        % Check collision for UR3e
        if isInsideBoundingBox(ur3eEndEffector, boundingBoxes{j, 1}, boundingBoxes{j, 2})
            disp('Collision detected with UR3e! Movement stopped. Please reset');
            return;
        end
        % Check collision for Nova2
        if isInsideBoundingBox(nova2EndEffector, boundingBoxes{j, 1}, boundingBoxes{j, 2})
            disp('Collision detected with Nova2! Movement stopped. Please reset');
            return;
        end

        %% this is for an object that passes through the plane
        % Check collision for cup
        if isInsideBoundingBox(babyPosition', boundingBoxes{j, 1}, boundingBoxes{j, 2})
            disp('Object coming in! Movement stopped. Please reset');
            return;
        end
    end

    pause(0.05);
end

% Functions for collision, trajectory, and plotting
function isCollision = isInsideBoundingBox(position, boxMin, boxMax)
    isCollision = all(position >= boxMin') && all(position <= boxMax');
end

function qMatrix_resampled = resampleTrajectory(qMatrix, numSteps)
    currentSteps = size(qMatrix, 1);
    qMatrix_resampled = interp1(1:currentSteps, qMatrix, linspace(1, currentSteps, numSteps));
end

function qMatrix = InterpolateWaypointRadians(waypointRadians, maxStepRadians)
    if nargin < 2
        maxStepRadians = deg2rad(1);
    end
    qMatrix = [];
    for i = 1:size(waypointRadians, 1) - 1
        qMatrix = [qMatrix; FineInterpolation(waypointRadians(i, :), waypointRadians(i + 1, :), maxStepRadians)]; %#ok<AGROW>
    end
end

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

function plotcube(dim, pos, alpha, color)
    vertex_matrix = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1];
    face_matrix = [1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8];
    vertex_matrix = vertex_matrix * diag(dim);
    vertex_matrix = vertex_matrix + ones(8, 1) * pos;
    patch('Vertices', vertex_matrix, 'Faces', face_matrix, 'FaceColor', color, 'FaceAlpha', alpha);
end




