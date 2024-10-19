% Clear command window and workspace
clc;
clear all;
close all;

% Create the DobotNova2 robot model
baseTr = transl(0, 0, 0);  % Base transformation for the robot
nova2 = DobotNova2(baseTr); % Initialize the robot
hold on

% Define the initial position of the cup and the target position
cupPickLocation = [0, 3, 0];  % Initial position of the cup
targetLocation = [2, 0, 0];    % Target position to move the cup

% Place the cup in the scene using cup.ply
cupObject = PlaceObject('cup.ply');  % Place the cup in the scene

% Set the cup's position to the defined pick-up location
cupVertices = get(cupObject, 'Vertices');
transformedCupVertices = [cupVertices, ones(size(cupVertices, 1), 1)] * transl(cupPickLocation)';
set(cupObject, 'Vertices', transformedCupVertices(:, 1:3)); % Cup placed at its pick-up location

% Define waypoints for robot1 (DobotNova2)
qInitial = deg2rad([-50.9, 123, 137, 259, 115, 0]); % Initial position
qAboveCup = nova2.model.ikine(transl(cupPickLocation + [0, 0, 0.1]), 'mask', [1, 1, 1, 0, 0, 0]); % Above cup position
qTarget = nova2.model.ikine(transl(targetLocation + [0, 0, 0.1]), 'mask', [1, 1, 1, 0, 0, 0]); % Above target position
qFinal = nova2.model.ikine(transl(targetLocation), 'mask', [1, 1, 1, 0, 0, 0]); % Final position at target

% Define waypoints
qWaypoints = [qInitial; qAboveCup; qTarget; qFinal];

% Interpolate waypoints for smooth movement
qMatrix = InterpolateWaypointRadians(qWaypoints, deg2rad(5));  % For robot1

% Create a figure for the animation
figure;
hold on;
axis equal;
view(3); % Set 3D view
axis([-1 3 -1 4 -0.5 2]); % Set axis limits for better visibility
grid on;

% Animate robot and pick up the cup
maxSteps = size(qMatrix, 1);
for i = 1:maxSteps
    % Animate robot with its trajectory
    nova2.model.animate(qMatrix(i, :));
    
    % Ensure the cup is always visible
    set(cupObject, 'Vertices', transformedCupVertices(:, 1:3)); % Keep cup in position

    % Simulate picking up the cup when above the cup
    if i == 2  % This corresponds to the index of the position above the cup
        disp('Picking up the cup...');
        pause(0.5);  % Simulate time to grasp the cup
        % Lift the cup higher
        nova2.model.animate(qMatrix(i, :) + [0, 0, 0.1]); 
        pause(0.5);
    end

    pause(0.1);  % Pause to synchronize the animation
end

% Simulate placing the cup at the target location
disp('Placing the cup at the target location...');
pause(0.5);  % Simulate time to place the cup

% Animate down to the final position
nova2.model.animate(qFinal);
pause(0.5);  % Pause for clarity

% Release the cup
disp('Cup has been placed at the target location.');

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
