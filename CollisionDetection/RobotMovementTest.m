% Clear command window and workspace
clc;
clear all;
close all;

% Call EnvSetup function to initialize the environment and objects
[nova2, ur3e, cup, cupLid, milkJug, iceCube, portafilter] = EnvSetup();

% Function to set up the environment with various objects (shelves, barriers,
% a person model, emergency stops, and a table).
hold on;  % Hold the current plot for multiple objects
axis equal;  % Maintain equal scaling for all axes
axis([-1.8 1.8 -1.8 1.8 -0.1 1.5]);  % Set the axis limits

%% Define waypoints for robot1 (DobotNova2)
q1 = deg2rad([-50.9, 123, 137, 259, 115, 0]); % initial position
qWaypoints1 = [
    deg2rad([0, 0, 0, 0, 0, 0]);
    q1;
    deg2rad([-58.9, 123, 122, 281, 115, 0]);      % First waypoint
    deg2rad([-58.9, 123, 137, 259, 115, 0]); 
    deg2rad([-109, 87, 151, 281, 118, 0]);
    deg2rad([-138, 72.6, 130, 310, 93.6, 0]);
    deg2rad([-188, 72.6, 130, 310, 93.6, 0]);
    deg2rad([-188, 175, 5, 360, 93.6, 0]);
    deg2rad([-196, 123, 108, 302, 93.6, 0]);
    deg2rad([-138, 101, 137, 302, 93.6, 0]);     % Second waypoint
];

%% Define different waypoints for robot2 (UR3e)
qWaypoints2 = [
    deg2rad([50, 100, 90, 270, 120, 0]);   % Different starting configuration
    deg2rad([55, 95, 85, 275, 115, 0]);    % Slightly different waypoints for robot2
    deg2rad([60, 90, 80, 280, 110, 0]); 
    deg2rad([65, 85, 75, 285, 105, 0]);
    deg2rad([70, 80, 70, 290, 100, 0]);
    deg2rad([75, 75, 65, 295, 95, 0]);
    deg2rad([80, 70, 60, 300, 90, 0]);
    deg2rad([85, 65, 55, 305, 85, 0]);
];

% Interpolate waypoints for robot1 and robot2
qMatrix1 = InterpolateWaypointRadians(qWaypoints1, deg2rad(5));  % For robot1
qMatrix2 = InterpolateWaypointRadians(qWaypoints2, deg2rad(5));  % For robot2

% Ensure both matrices have the same number of steps by using the larger size
maxSteps = max(size(qMatrix1, 1), size(qMatrix2, 1));

% Resample qMatrix1 and qMatrix2 to have maxSteps rows
qMatrix1_resampled = resampleTrajectory(qMatrix1, maxSteps);
qMatrix2_resampled = resampleTrajectory(qMatrix2, maxSteps);

%% Animate both robots with different trajectories
for i = 1:maxSteps
    % Animate robot1 with its resampled trajectory
    nova2.model.animate(qMatrix1_resampled(i, :));  
    
    % Animate robot2 with its resampled trajectory
    ur3e.model.animate(qMatrix2_resampled(i, :));  
    
    pause(0.1);  % Pause to synchronize the animation
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
