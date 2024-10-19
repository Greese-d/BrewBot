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

% Define the cup's pick-up location (for example, at the center of the table)
cupPickLocation = [0, 0, 0];  % Replace with the actual position of the cup in your environment

% Place the cup in the scene using cup.ply
cupObject = PlaceObject('cup.ply');  % Place the cup in the scene
axis equal;

% Set the cup's position to the defined pick-up location
cupVertices = get(cupObject, 'Vertices');
transformedCupVertices = [cupVertices, ones(size(cupVertices, 1), 1)] * transl(cupPickLocation)';
set(cupObject, 'Vertices', transformedCupVertices(:, 1:3)); % Cup placed at its pick-up location

% Now, we will animate the robot to pick up the cup
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

% Interpolate waypoints for robot1
qMatrix1 = InterpolateWaypointRadians(qWaypoints1, deg2rad(5));  % For robot1

%% Resample qMatrix1 to have a certain number of steps
maxSteps = size(qMatrix1, 1);
qMatrix1_resampled = resampleTrajectory(qMatrix1, maxSteps);

%% Animate robot and pick up the cup
for i = 1:maxSteps
    % Animate robot1 with its resampled trajectory
    nova2.model.animate(qMatrix1_resampled(i, :));
    
    % After reaching the first waypoint, simulate picking up the cup
    if i == 3  % This corresponds to the index of the first waypoint
        pickUpCup(nova2, cupPickLocation);  % Pass cup position to the pick-up function
    end
    
    pause(0.1);  % Pause to synchronize the animation
end

% Move to the second waypoint and place the cup
nova2.model.animate(qWaypoints1(10, :));  % Move to the second waypoint
pause(1);  % Pause for clarity
releaseCup(nova2);  % Simulate releasing the cup

function pickUpCup(nova2, cupPosition)
    % Move to above the cup
    aboveCupPosition = cupPosition + [0, 0, 0.1];  % Adjust height above the cup

    % Compute the required joint angles to reach above the cup
    qAboveCup = nova2.model.ikine(transl(aboveCupPosition), 'mask', [1, 1, 1, 0, 0, 0]); 

    % Move the robot to the position above the cup
    nova2.model.animate(qAboveCup);  
    pause(0.5);  % Pause for stability

    % Simulate closing the gripper to pick up the cup
    disp('Picking up the cup...');
    pause(0.5);  % Simulate the time taken to grasp the cup

    % Move the cup higher to avoid collision
    liftedPosition = qAboveCup; % Use the current joint angles for lifting
    liftedPosition(3) = liftedPosition(3) + 0.1;  % Lift the Z coordinate higher

    % Calculate new joint angles for the lifted position
    qLifted = nova2.model.ikine(transl(aboveCupPosition + [0, 0, 0.1]), 'mask', [1, 1, 1, 0, 0, 0]);  
    nova2.model.animate(qLifted);  % Animate to the new lifted position
    pause(0.5);  % Pause after lifting
end

function releaseCup(nova2)
    % Move down to the second waypoint's position to release the cup
    disp('Releasing the cup...');
    pause(0.5);  % Simulate the time taken to release the cup

    % Simulate opening the gripper to release the cup
    % Here you might call a function to open the gripper
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
