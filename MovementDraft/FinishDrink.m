% Clear command window and workspace
clc;
clear all;
close all;

% Call EnvSetup function to initialize the environment and UR3e only
[nova2, ur3e, cup, cupLid, milkJug, iceCube, portafilter] = EnvSetup();  % Includes both nova2 and ur3e robots

% Function to set up the environment with various objects (shelves, barriers,
% a person model, emergency stops, and a table).
hold on;  % Hold the current plot for multiple objects
axis equal;  % Maintain equal scaling for all axes
axis([-1.8 1.8 -1.8 1.8 -0.1 1.5]);  % Set the axis limits
view(210, 20)

%% Teach function for Nova2
disp('Please teach the Nova2 robot by moving it to the desired position and pressing Enter.');
nova2.model.teach();  % Call teach function to manually set the position

%% Nova2 Waypoints from the image
qWaypoints_nova2 = [
    deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
    deg2rad([0, 43.2, -108, -14.4, 86.4, 0]);  % Fold position
    deg2rad([14.4, 43.2, -108, -14.4, 86.4, 0]);  % Pick lid
    deg2rad([14.4, 57.6, -108, -14.4, 86.4, 0]);  % Lift lid
    deg2rad([14.4, 28.8, -50.4, -57.6, 86.4, 0]);  % Place lid
    deg2rad([14.4, 57.6, -108, -14.4, 86.4, 0]);  % Fold back
    deg2rad([0, 43.2, -108, -14.4, 86.4, 0]);  % Rotate
    deg2rad([0, 0, 0, 0, 0, 0]);  % back home
];

% Interpolate waypoints for Nova2
qMatrix_nova2 = InterpolateWaypointRadians(qWaypoints_nova2, deg2rad(4));  % For Nova2

%% UR3e Waypoints from the image
qWaypoints_ur3e = [
    deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
    deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
    deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
    deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
    deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
    deg2rad([0, -72, 101, 0, 108, 0]);            % Fold position
    deg2rad([-115, -72, 101, 0, 108, 0]);          % Rotate to cup
    deg2rad([-187, -72, 101, 0, 108, 0]);       % Rotate and drop the cup
    deg2rad([-187, -43.2, 57.6, 0, 108, 0]);     % Stretch towards cup placement
    deg2rad([-187, -72, 101, 0, 108, 0]);       % Rotate and drop the cup
    deg2rad([-115, -72, 101, 0, 108, 0]);          % Rotate to cup
    deg2rad([0, -10, 7.2, 0, 93.6, 0]);         % Place Cup
    deg2rad([0, -10, 7.2, 0, 93.6, 0]);         % Place Cup
    deg2rad([0, -10, 7.2, 0, 93.6, 0]);         % Place Cup
    deg2rad([0, -10, 7.2, 0, 93.6, 0]);         % Place Cup
    deg2rad([0, -10, 7.2, 0, 93.6, 0]);         % Place Cup
    deg2rad([0, 0, 0, 0, 0, 0]);                % Return to home position
];

% Interpolate waypoints for UR3e
qMatrix_ur3e = InterpolateWaypointRadians(qWaypoints_ur3e, deg2rad(4));  % For UR3e

% Find the maximum length for synchronization
maxSteps = max(size(qMatrix_nova2, 1), size(qMatrix_ur3e, 1));

% Resample both Nova2 and UR3e to have the same number of steps
qMatrix_nova2_resampled = resampleTrajectory(qMatrix_nova2, maxSteps);
qMatrix_ur3e_resampled = resampleTrajectory(qMatrix_ur3e, maxSteps);

%% Animate both Nova2 and UR3e with synchronized motion
for i = 1:maxSteps
    nova2.model.animate(qMatrix_nova2_resampled(i, :));  % Animate Nova2
    ur3e.model.animate(qMatrix_ur3e_resampled(i, :));    % Animate UR3e

    % Add a pause for real-time visualization
    pause(0.05);  % Adjust pause for slower/faster movement
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
