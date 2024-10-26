% Clear command window and workspace
clc;
clear all;
close all;

% Call EnvSetup function to initialize the environment and nova2 only
[nova2, ur3e, cup, cupLid, milkJug, iceCube, portafilter] = EnvSetup();  % Includes both nova2 and ur3e robots

% Set up the environment with various objects (shelves, barriers,
% a person model, emergency stops, and a table).
hold on;  % Hold the current plot for multiple objects
axis equal;  % Maintain equal scaling for all axes
axis([-1.8 1.8 -1.8 1.8 -0.1 1.5]);  % Set the axis limits
view(210, 20)

% Define a list of functions in the desired order for nova2
actions = {@GrabCup, @PlaceCupatMachine, @PipetoGrinder, @PipetoMachine, @ReturnCup, @ReturnPipe};

% Interpolation and resampling settings
maxSteps = 600;
maxStepRadians = deg2rad(5);

% Loop through each action function
for k = 1:length(actions)
    % Get the current action waypoints
    qWaypoints = actions{k}();
    
    % Interpolate the waypoints for smooth motion
    qMatrix = InterpolateWaypointRadians(qWaypoints, maxStepRadians);
    
    % Resample for uniform steps
    qMatrix_resampled = resampleTrajectory(qMatrix, maxSteps);
    
    % Animate the nova2 robot with the current trajectory
    for i = 1:size(qMatrix_resampled, 1)
        nova2.model.animate(qMatrix_resampled(i, :));  % Animate nova2
        pause(0.01);  % Adjust pause for slower/faster movement
    end
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

%% Action Functions
function q2Waypoints = GrabCup()
    q2Waypoints = [
        deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
        deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]); % Grab cup position
        deg2rad([-7.2, 36, -72, -50.4, 180, 0]);   % Lift cup
    ];
end

function q2Waypoints = PlaceCupatMachine()
    q2Waypoints = [
        deg2rad([-7.2, 36, -72, -50.4, 180, 0]);   % Lift cup
        deg2rad([5, 57.6, -122, -21.6, 180, 0]);   % Move to intermediary
        deg2rad([64.8, 57.6, -122, -21.6, 180, 0]); % Move to machine (cup placement)
        deg2rad([64.8, 43.2, -108, -21.6, 180, 0]); % Place cup
    ];
end

function q2Waypoints = PipetoGrinder()
    q2Waypoints = [
        deg2rad([64.8, 43.2, -108, -21.6, 180, 0]); % Place cup
        deg2rad([57.6, 93.6, -158, -21.6, 180, 0]); % Pull back after placing
        deg2rad([0, 93.6, -158, -21.6, 180, 0]);    % Rotate back to initial
        deg2rad([-14.4, 14.4, -28.8, -64.8, 93.6, 0]); % Pick pipe
        deg2rad([7.2, 101, -151, -36, 93.6, 0]);    % Lift pipe
        deg2rad([151, 101, -151, -36, 93.6, 0]);    % Rotate with pipe
        deg2rad([151, 79.2, -130, -36, 93.6, 0]);   % Place pipe
    ];
end

function q2Waypoints = PipetoMachine()
    q2Waypoints = [
        deg2rad([151, 79.2, -130, -36, 93.6, 0]);   % Place pipe
        deg2rad([151, 101, -151, -36, 93.6, 0]);    % Pull pipe back
        deg2rad([86.4, 115, -115, -93.6, 93.6, 0]); % Place pipe at coffee machine
        deg2rad([50.4, 86.4, -158, -21.6, 180, 0]); % Pull back for next action
    ];
end

function q2Waypoints = ReturnCup()
    q2Waypoints = [
        deg2rad([50.4, 86.4, -158, -21.6, 180, 0]); % Pull back for next action
        deg2rad([64.8, 43.2, -108, -21.6, 180, 0]); % Pick up cup again
        deg2rad([7.2, 57.6, -122, -21.6, 180, 0]);  % Pull back with the cup
        deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]);  % Place cup back
        deg2rad([7.2, 57.6, -122, -21.6, 180, 0]);  % Pull back
    ];
end

function q2Waypoints = ReturnPipe()
    q2Waypoints = [
        deg2rad([7.2, 57.6, -122, -21.6, 180, 0]);  % Pull back
        deg2rad([50.4, 86.4, -158, -21.6, 180, 0]); % Pull back for next action
        deg2rad([86.4, 115, -115, -93.6, 93.6, 0]); % Take pipe at coffee machine
        deg2rad([86.4, 115, -151, -58.6, 93.6, 0]); % Fold
        deg2rad([7.2, 115, -151, -58.6, 93.6, 0]);  % Rotate
        deg2rad([-14.4, 14.4, -28.8, -64.8, 93.6, 0]); % Place pipe at initial
        deg2rad([0, 0, 0, 0, 0, 0]);               % Return to home position    
    ];
end
