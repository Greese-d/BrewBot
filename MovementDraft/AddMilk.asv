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

%% Define a trajectory for UR3e
qWaypoints2 = [
    deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
    deg2rad([0, -72, 108, 0, 0, 0]);          % Fold position (fold arm)
    deg2rad([158, -72, 108, 0, 0, 0]);        % Rotate and move to grab the cup
    deg2rad([144, -72, 108, -108, 0, 0]);     % Drop the cup
    deg2rad([144, -57.6, 101, -108, 0, 0]);   % Stretch towards cup placement
    deg2rad([144, -28.8, 50.4, -108, 0, 0]);  % Grab the cup
    deg2rad([144, -36, 57.6, -108, 0, 0]);    % Pull the cup
    deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
    %wait time
    deg2rad([122, -50.4, 115, -151, 0, 0]);   % Put cup below frother
    deg2rad([100, -72, 108, -151, 0, 0]);   % Fold arm at frother
    deg2rad([-22, -64.8, 137, -151, 0, 0]);   % Retract after frothing
    deg2rad([0, 0, 0, 0, 0, 0]);              % Return to home position
];

% Interpolate waypoints for UR3e
qMatrix2 = InterpolateWaypointRadians(qWaypoints2, deg2rad(4));  % For UR3e

% Resample qMatrix2 to have a certain number of steps if needed
maxSteps = 600;  % You can adjust the number of steps for smoother/slower motion
qMatrix2_resampled = resampleTrajectory(qMatrix2, maxSteps);

%% Animate the UR3e robot with the defined trajectory
pourMilkPose = deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Define the "pour milk" position
tolerance = 1e-2;  % Define a small tolerance for comparison
pouringMilk = false;  % Flag to indicate if pouring milk action is done

for i = 1:size(qMatrix2_resampled, 1)
    ur3e.model.animate(qMatrix2_resampled(i, :));  % Animate UR3e

    % Check if the current configuration is close to the "pour milk" position and pouring not done yet
    if ~pouringMilk && all(abs(qMatrix2_resampled(i, :) - pourMilkPose) < tolerance)
        disp('Pouring milk, waiting for 5 seconds...');
        pause(5);  % Add a 5-second delay after "pour milk"
        pouringMilk = true;  % Set the flag to true so it only happens once
    end

    pause(0.05);  % Adjust pause for slower movement
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
