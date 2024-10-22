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

%% Teach function for nova2
disp('Please teach the UR3e robot by moving it to the desired position and pressing Enter.');
ur3e.model.teach();  % Call teach function to manually set the position

%% Define a trajectory for UR3e based on the provided joint angles (from the image)
qWaypoints2 = [
    deg2rad([0, 0, 0, 0, 0, 0]);               % Initial position
    deg2rad([0, -64.8, 137, -151, 0, 0]);      % Rotate
    deg2rad([100, -64.8, 137, -151, 0, 0]);    % Fold
    deg2rad([100, -50.4, 115, -151, 0, 0]);    % Rotate
    deg2rad([122, -50.4, 115, -151, 0, 0]);    % Pick Jug
    deg2rad([122, -64.8, 115, -151, 0, 0]);    % Lift to Reach
    % Additional time step is mentioned in the image
    deg2rad([122, -50.4, 115, -151, 0, 0]);    % Put back Jug
    deg2rad([100, -50.4, 115, -151, 0, 0]);    % Rotate
    deg2rad([100, -64.8, 137, -151, 0, 0]);    % Fold
    deg2rad([-22, -64.8, 137, -151, 0, 0]);      % Rotate back to initial fold position
    deg2rad([0, 0, 0, 0, 0, 0]);               % Return to initial position
];

% Interpolate waypoints for UR3e
qMatrix2 = InterpolateWaypointRadians(qWaypoints2, deg2rad(4));  % For UR3e

% Resample qMatrix2 to have a certain number of steps if needed
maxSteps = 600;  % You can adjust the number of steps for smoother/slower motion
qMatrix2_resampled = resampleTrajectory(qMatrix2, maxSteps);

% Animate the UR3e
for i = 1:maxSteps
    ur3e.model.animate(qMatrix2_resampled(i, :));  % Animate UR3e

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
