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
view(210, 20)

%% Teach function for nova2
disp('Please teach the Nova2 robot by moving it to the desired position and pressing Enter.');
nova2.model.teach();  % Call teach function to manually set the position

%% Optionally, define a trajectory for ur3e (if needed)
% Uncomment the following lines if you want to define a trajectory for ur3e
% qWaypoints2 = [
%     deg2rad([50, 100, 90, 270, 120, 0]);   % Different starting configuration
%     deg2rad([55, 95, 85, 275, 115, 0]);    % Slightly different waypoints for robot2
%     % Add more waypoints as needed...
% ];
% 
% % Interpolate waypoints for robot2
% qMatrix2 = InterpolateWaypointRadians(qWaypoints2, deg2rad(5));  % For robot2
% 
% % Resample qMatrix2 to have a certain number of steps if needed
% qMatrix2_resampled = resampleTrajectory(qMatrix2, maxSteps);

%% Animate the UR3e robot with the defined trajectory (if uncommented above)
% for i = 1:size(qMatrix2_resampled, 1)
%     ur3e.model.animate(qMatrix2_resampled(i, :));  
%     pause(0.1);  % Pause to synchronize the animation
% end

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
