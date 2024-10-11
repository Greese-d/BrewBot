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
objectHandles{1} = PlaceObject('Cup.ply', [-0.1, 0.3, 0.65]); 
objectHandles{2} = PlaceObject('CupLid.ply', [0.1, 0.3, 0.65]); 
objectHandles{3} = PlaceObject('CupWithLid.ply', [-0.1, 0.15, 0.65]); 
objectHandles{4} = PlaceObject('MilkJug.ply', [0.1, 0.15, 0.65]); 
objectHandles{5} = PlaceObject('EspressoHandle.ply', [0, 0.4, 0.7]); 
objectHandles{6} = PlaceObject('EspressoMachine.ply', [0.35, -0.5, 0.65]); 
objectHandles{7} = PlaceObject('Grinder.ply', [0.9, -0.2, 0.65]); 
objectHandles{8} = PlaceObject('IceCubeDispenser.ply', [-0.75, -0.5, 0.65]); 
objectHandles{9} = PlaceObject('Table.ply', [0, 0, 0.4]);

%% Add DobotNova2 and UR3e robots to the environment
disp('Adding DobotNova2 robot to the environment');
robot1 = DobotNova2(transl(0.65, 0.3, 0.6));  % Initialize DobotNova2 robot
robot2 = UR3e(transl(-0.65, 0.3, 0.6));      % Initialize UR3e robot
robot1.model.teach;
q1 = deg2rad([0,0 ,0,0,0,0]); % initial position

%% Define waypoints and interpolate movement for DobotNova2
qWaypoints = [
    q1;
    deg2rad([-58.9,123,122,281,115,0]);      % First waypoint
    deg2rad([-58.9,123,137,259,115,0]); 
    deg2rad([-109,87,151,281,118,0]);
    deg2rad([-138,72.6,130,310,93.6,0]);
    deg2rad([-108,72.6,130,310,93.6,0]); 
    deg2rad([-108,175,5,360,93.6,0]); 
    deg2rad([-196,123,108,302,93.6,0]);
    deg2rad([-138,101,137,302,93.6,0]);     % Second waypoint
];

% Interpolate between waypoints
qMatrix = InterpolateWaypointRadians(qWaypoints, deg2rad(5));

% Animate the robot movement along the trajectory
for i = 1:size(qMatrix, 1)
    % Animate current joint configuration
    robot1.model.animate(qMatrix(i, :));  
    pause(0.1);                           % Pause to create a smooth animation effect

    % Get the end effector position for collision checking
    endEffectorPos = robot1.model.fkine(qMatrix(i, :));  % Forward kinematics to get position
    endEffectorPosition = endEffectorPos(1:3, 4)';  % Extract the position from the transformation matrix

    % Check for collisions with objects
    collisionDetected = CheckCollision(endEffectorPosition, objectHandles);
    if collisionDetected
        disp('Collision detected! Stopping the robot.');
        robot1.model.animate(q1);  % Optionally reset to initial position
        break;  % Exit the loop if a collision is detected
    end
end

%% CheckCollision function
function collisionDetected = CheckCollision(endEffectorPosition, objectHandles)
    % Initialize collision flag
    collisionDetected = false;

    % Check against each object
    for i = 1:length(objectHandles)
        objBoundingBox = GetObjectBoundingBox(objectHandles{i}); % Get bounding box for each object
        PlotBoundingBox(objBoundingBox, 'b');  % Use blue for object bounding boxes

        % Check if the end effector position is within the object's bounding box
        if IsInsideBoundingBox(endEffectorPosition, objBoundingBox)
            collisionDetected = true; % Set collision flag if the end effector is inside the bounding box
            break; % Exit the loop
        end
    end
end

%% GetObjectBoundingBox function
function boundingBox = GetObjectBoundingBox(objectHandle)
    % This function should extract the bounding box for the object
    % Replace this with actual bounding box extraction logic if available
    % For example, if objectHandle is a structure containing bounding box data
    boundingBox = [-0.15, 0.15, 0.25, 0.35, 0.6, 0.7]; % Example, replace with actual values
end

%% IsInsideBoundingBox function
function inside = IsInsideBoundingBox(position, boundingBox)
    % Check if the position is inside the bounding box
    inside = ...
        (position(1) >= boundingBox(1) && position(1) <= boundingBox(2) && ... % X
         position(2) >= boundingBox(3) && position(2) <= boundingBox(4) && ... % Y
         position(3) >= boundingBox(5) && position(3) <= boundingBox(6));       % Z
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

%% PlotBoundingBox function
function PlotBoundingBox(boundingBox, color)
    % Create a 3D wireframe box based on the bounding box coordinates
    % boundingBox format: [xmin, xmax, ymin, ymax, zmin, zmax]
    
    % Define the vertices of the bounding box
    vertices = [
        boundingBox(1), boundingBox(3), boundingBox(5);
        boundingBox(2), boundingBox(3), boundingBox(5);
        boundingBox(2), boundingBox(4), boundingBox(5);
        boundingBox(1), boundingBox(4), boundingBox(5);
        boundingBox(1), boundingBox(3), boundingBox(6);
        boundingBox(2), boundingBox(3), boundingBox(6);
        boundingBox(2), boundingBox(4), boundingBox(6);
        boundingBox(1), boundingBox(4), boundingBox(6)
    ];

    % Define the edges that connect the vertices
    edges = [
        1, 2; 1, 4; 1, 5;
        2, 3; 2, 6;
        3, 4; 3, 7;
        4, 8;
        5, 6; 5, 7;
        6, 7; 6, 8;
        7, 8; 8, 5
    ];

    % Plot the edges of the box
    hold on;  % Ensure the bounding box is plotted on top of other objects
    for i = 1:size(edges, 1)
        line(vertices(edges(i, :), 1), vertices(edges(i, :), 2), vertices(edges(i, :), 3), 'Color', color, 'LineWidth', 2);
    end
end
