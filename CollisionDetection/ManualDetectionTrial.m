%% Robotics
% Lab 5 - Question 3: Manually move the robot and check for collisions

function [ ] = ManualCollisionCheck()

    % 1. Define the 3DOF robot model
    L1 = Link('d',0,'a',1,'alpha',0,'qlim',[-pi pi]);
    L2 = Link('d',0,'a',1,'alpha',0,'qlim',[-pi pi]);
    L3 = Link('d',0,'a',1,'alpha',0,'qlim',[-pi pi]);       
    robot = SerialLink([L1 L2 L3],'name','myRobot');                     

    % Define the workspace
    q = zeros(1,3);                                                    
    scale = 0.5;
    workspace = [-2 2 -2 2 -0.05 2];                                       
    robot.plot(q,'workspace',workspace,'scale',scale);                   

    % Define the obstacle (a rectangular prism)
    centerpnt = [2,0,-0.5];
    side = 1.5;
    plotOptions.plotFaces = true;
    [vertex,faces,faceNormals] = RectangularPrism(centerpnt-side/2, centerpnt+side/2,plotOptions);
    axis equal
    camlight

    %% 3.1: Manually move the robot with teach pendant and add waypoints
    q1 = [-pi/4, 0, 0]; % Initial joint configuration
    q2 = [pi/4, 0, 0];  % Final joint configuration

    % Show initial configuration and enable manual control
    robot.animate(q1);
    robot.teach;  % Manually adjust using teach pendant

    % Waypoints with clear formatting for easier editing
    qWaypoints = [
        q1;                                      % Initial waypoint
        deg2rad([-90, -137, 133]);               % Second waypoint
        deg2rad([3.6, -155, 166]);
        deg2rad([68.4, -155, 166]);   
        deg2rad([112, -155, 166]); % Third waypoint
        q2                                       % Final waypoint
    ];

    % Interpolate between waypoints
    qMatrix = InterpolateWaypointRadians(qWaypoints, deg2rad(5));

    % Check for collisions along the trajectory
    collisionDetected = IsCollision(robot, qMatrix, faces, vertex, faceNormals);
    if collisionDetected
        disp('Collision detected!');
    else
        disp('No collision detected.');
    end

    % Animate the robot movement along the trajectory
    robot.animate(qMatrix);

end

%% IsCollision function for collision detection
function result = IsCollision(robot, qMatrix, faces, vertex, faceNormals, returnOnceFound)
    if nargin < 6
        returnOnceFound = false;  % By default, continue even after a collision
    end
    result = false;

    % Loop through joint positions and check for intersections with faces
    for qIndex = 1:size(qMatrix,1)
        % Get the transform of every joint (i.e. start and end of every link)
        tr = GetLinkPoses(qMatrix(qIndex,:), robot);

        % Check each link and triangle face for intersections
        for i = 1 : size(tr,3)-1    
            for faceIndex = 1:size(faces,1)
                vertOnPlane = vertex(faces(faceIndex,1)',:);
                [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)'); 
                if check == 1 && IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
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
function [ transforms ] = GetLinkPoses( q, robot)

    links = robot.links;
    transforms = zeros(4, 4, length(links) + 1);
    transforms(:,:,1) = robot.base;

    for i = 1:length(links)
        L = links(1,i);
        
        current_transform = transforms(:,:, i);
        
        current_transform = current_transform * trotz(q(1,i) + L.offset) * ...
        transl(0,0, L.d) * transl(L.a,0,0) * trotx(L.alpha);
        transforms(:,:,i + 1) = current_transform;
    end
end

%% IsIntersectionPointInsideTriangle
% Function to check if a point is inside a triangle
function result = IsIntersectionPointInsideTriangle(intersectP,triangleVerts)

    u = triangleVerts(2,:) - triangleVerts(1,:);
    v = triangleVerts(3,:) - triangleVerts(1,:);

    uu = dot(u,u);
    uv = dot(u,v);
    vv = dot(v,v);

    w = intersectP - triangleVerts(1,:);
    wu = dot(w,u);
    wv = dot(w,v);

    D = uv * uv - uu * vv;

    % Get and test parametric coordinates (s and t)
    s = (uv * wv - vv * wu) / D;
    if (s < 0.0 || s > 1.0)        % intersectP is outside Triangle
        result = 0;
        return;
    end

    t = (uv * wu - uu * wv) / D;
    if (t < 0.0 || (s + t) > 1.0)  % intersectP is outside Triangle
        result = 0;
        return;
    end

    result = 1;                      % intersectP is in Triangle
end

%% InterpolateWaypointRadians
% Given a set of waypoints, interpolate them to get smooth motion
function qMatrix = InterpolateWaypointRadians(waypointRadians, maxStepRadians)
    if nargin < 2
        maxStepRadians = deg2rad(1);
    end

    qMatrix = [];
    for i = 1: size(waypointRadians,1)-1
        qMatrix = [qMatrix ; FineInterpolation(waypointRadians(i,:),waypointRadians(i+1,:),maxStepRadians)]; %#ok<AGROW>
    end
end

%% FineInterpolation
% Keep calling jtraj until all step sizes are smaller than a given max step size
function qMatrix = FineInterpolation(q1, q2, maxStepRadians)
    if nargin < 3
        maxStepRadians = deg2rad(1);
    end
    
    steps = 2;
    while ~isempty(find(maxStepRadians < abs(diff(jtraj(q1,q2,steps))),1))
        steps = steps + 1;
    end
    qMatrix = jtraj(q1,q2,steps);
end
