% Create the robot
robot = DobotNova2(transl(0.5, 0, 0));
robot.model.teach;
% Define waypoints
qWaypoints = [
    deg2rad([14.4, 0, 0, 0, 0, 0]);      % Second waypoint
    deg2rad([122, 0, 0, 0, 0, 0]);       % Third waypoint
];

% Interpolate between waypoints
qMatrix = InterpolateWaypointRadians(qWaypoints, deg2rad(5));

% Animate the robot movement along the trajectory
for i = 1:size(qMatrix, 1)
    robot.model.animate(qMatrix(i, :));  % Animate current joint configuration
    pause(0.1);                           % Pause to create a smooth animation effect
end

%% IsCollision function for collision detection
function result = IsCollision(robot, qMatrix, faces, vertex, faceNormals, returnOnceFound)
    if nargin < 6
        returnOnceFound = false;  % By default, continue even after a collision
    end
    result = false;

    % Loop through joint positions and check for intersections with faces
    for qIndex = 1:size(qMatrix, 1)
        % Get the transform of every joint (i.e. start and end of every link)
        tr = GetLinkPoses(qMatrix(qIndex, :), robot);

        % Check each link and triangle face for intersections
        for i = 1:size(tr, 3) - 1    
            for faceIndex = 1:size(faces, 1)
                vertOnPlane = vertex(faces(faceIndex, 1)', :);
                [intersectP, check] = LinePlaneIntersection(faceNormals(faceIndex, :), vertOnPlane, tr(1:3, 4, i)', tr(1:3, 4, i + 1)'); 
                if check == 1 && IsIntersectionPointInsideTriangle(intersectP, vertex(faces(faceIndex, :), :))
                    plot3(intersectP(1), intersectP(2), intersectP(3), 'g*');
                    disp('Collision detected at point:');
                    disp(intersectP);
                    result = true;
                    % Continue moving even after collision
                    if returnOnceFound
                        return;
                    end
                end
            end    
        end
    end
end

%% GetLinkPoses function for collision checking
function [transforms] = GetLinkPoses(q, robot)
    links = robot.links;
    transforms = zeros(4, 4, length(links) + 1);
    transforms(:, :, 1) = robot.base;

    for i = 1:length(links)
        L = links(1, i);
        
        current_transform = transforms(:, :, i);
        
        current_transform = current_transform * trotz(q(1, i) + L.offset) * ...
            transl(0, 0, L.d) * transl(L.a, 0, 0) * trotx(L.alpha);
        transforms(:, :, i + 1) = current_transform;
    end
end

%% IsIntersectionPointInsideTriangle
% Function to check if a point is inside a triangle
function result = IsIntersectionPointInsideTriangle(intersectP, triangleVerts)
    u = triangleVerts(2, :) - triangleVerts(1, :);
    v = triangleVerts(3, :) - triangleVerts(1, :);

    uu = dot(u, u);
    uv = dot(u, v);
    vv = dot(v, v);

    w = intersectP - triangleVerts(1, :);
    wu = dot(w, u);
    wv = dot(w, v);

    D = uv * uv - uu * vv;

    % Get and test parametric coordinates (s and t)
    s = (uv * wv - vv * wu) / D;
    if (s < 0.0 || s > 1.0)  % intersectP is outside Triangle
        result = 0;
        return;
    end

    t = (uv * wu - uu * wv) / D;
    if (t < 0.0 || (s + t) > 1.0)  % intersectP is outside Triangle
        result = 0;
        return;
    end

    result = 1;  % intersectP is in Triangle
end

%% InterpolateWaypointRadians
% Given a set of waypoints, interpolate them to get smooth motion
function qMatrix = InterpolateWaypointRadians(waypointRadians, maxStepRadians)
    if nargin < 2
        maxStepRadians = deg2rad(1);
    end

    qMatrix = [];
    for i = 1:size(waypointRadians, 1) - 1
        qMatrix = [qMatrix; FineInterpolation(waypointRadians(i, :), waypointRadians(i + 1, :), maxStepRadians)]; %#ok<AGROW>
    end
end

%% FineInterpolation
% Keep calling jtraj until all step sizes are smaller than a given max step size
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
