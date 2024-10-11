% Clear command window and workspace
clc;
clear all;
close all;

% Function to set up the environment with various objects (shelves, barriers,
% a person model, emergency stops, and a table).
hold on;  % Hold the current plot for multiple objects
axis equal;  % Maintain equal scaling for all axes
axis([-1.8 1.8 -1.8 1.8 -0.1 1.5]);  % Set the axis limits

%% Place objects in the environment
h = PlaceObject('Cup.ply', [-0.1, 0.3, 0.65]); 
h = PlaceObject('CupLid.ply', [0.1, 0.3, 0.65]); 
h = PlaceObject('CupWithLid.ply', [-0.1, 0.15, 0.65]); 
h = PlaceObject('MilkJug.ply', [0.1, 0.15, 0.65]); 
h = PlaceObject('EspressoHandle.ply', [0, 0.4, 0.7]); 
h = PlaceObject('EspressoMachine.ply', [0.35, -0.5, 0.65]); 
h = PlaceObject('Grinder.ply', [0.9, -0.2, 0.65]); 
h = PlaceObject('IceCubeDispenser.ply', [-0.75, -0.5, 0.65]); 
h = PlaceObject('Table.ply', [0, 0, 0.4]);

%% Add DobotNova2 and UR3e robots to the environment
disp('Adding DobotNova2 robot to the environment');
robot1 = DobotNova2(transl(0.65, 0.3, 0.6));  % Initialize DobotNova2 robot
robot2 = UR3e(transl(-0.65, 0.3, 0.6));      % Initialize UR3e robot
robot1.model.teach;
q1 = deg2rad([-50.9,123 ,137,259,115,0]); %initial position

%% Define waypoints and interpolate movement for DobotNova2
qWaypoints = [
    q1;
    deg2rad([-58.9,123,122,281,115,0]);      % First waypoint
    deg2rad([-58.9,123,137,259,115,0]); 
    deg2rad([-109,87,151,281,118,0]);
    deg2rad([-138,72.6,130,310,93.6,0]);
    deg2rad([-188,72.6,130,310,93.6,0]);
    deg2rad([-188,175,5,360,93.6,0]);
    deg2rad([-196,123,108,302,93.6,0]);
    deg2rad([-138,101,137,302,93.6,0]);     % Second waypoint
];

% Interpolate between waypoints
qMatrix = InterpolateWaypointRadians(qWaypoints, deg2rad(5));

% Animate the robot movement along the trajectory
for i = 1:size(qMatrix, 1)
    robot1.model.animate(qMatrix(i, :));  % Animate current joint configuration
    pause(0.1);                           % Pause to create a smooth animation effect
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
