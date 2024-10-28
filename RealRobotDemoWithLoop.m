rosinit('192.168.27.1'); % Initialize ROS connection

%% Initialize subscriber, services, and action client
jointStateSubscriber = rossubscriber('/ur/joint_states','sensor_msgs/JointState');
pause(2); % Allow time for messages
openService = rossvcclient("/onrobot/open", "std_srvs/Trigger");
closeService = rossvcclient("/onrobot/close", "std_srvs/Trigger");

jointNames = {'shoulder_pan_joint','shoulder_lift_joint', 'elbow_joint', 'wrist_1_joint', 'wrist_2_joint', 'wrist_3_joint'};
[client, goal] = rosactionclient('/ur/scaled_pos_joint_traj_controller/follow_joint_trajectory');
goal.Trajectory.JointNames = jointNames;
goal.GoalTimeTolerance = rosduration(0.05);
bufferSeconds = 1; % Network buffer
durationSeconds = 5; % Motion duration

%% Waypoint Functions
function q2Waypoints = MovetoJug()
    q2Waypoints = [
        deg2rad([0, 0, 0, 0, 0, 0]);
        deg2rad([0, -72, 108, 0, 0, 0]);
        deg2rad([158, -72, 108, 0, 0, 0]);
        deg2rad([144, -72, 108, -108, 0, 0]);
        deg2rad([144, -57.6, 101, -108, 0, 0]);
        deg2rad([144, -28.8, 50.4, -108, 0, 0]);
    ];
end

function q2Waypoints = GrabJug()
    q2Waypoints = [
        deg2rad([144, -28.8, 50.4, -108, 0, 0]);
        deg2rad([144, -36, 57.6, -108, 0, 0]);
        deg2rad([93.6, -50.4, 115, -151, 0, 0]);
    ];
end

function q2Waypoints = PutJugBelowFrother()
    q2Waypoints = [
        deg2rad([93.6, -50.4, 115, -151, 0, 0]);
        deg2rad([122, -50.4, 115, -151, 0, 0]);
    ];
end

function q2Waypoints = FrothMilk()
    q2Waypoints = [
        deg2rad([122, -50.4, 115, -151, 0, 0]);
        deg2rad([122, -64.8, 115, -151, 0, 0]);
    ];
end

function q2Waypoints = FinishFrothing()
    q2Waypoints = [
        deg2rad([122, -64.8, 115, -151, 0, 0]);
        deg2rad([122, -50.4, 115, -151, 0, 0]);
    ];
end

function q2Waypoints = PickUpJug()
    q2Waypoints = [
        deg2rad([122, -50.4, 115, -151, 0, 0]);
        deg2rad([122, -86.4, 151, -151, 0, 0]);
        deg2rad([141, -86.4, 151, -151, 0, 0]);
        deg2rad([151, -64.8, 93.4, -86.2, 0, 0]);
    ];
end

function q2Waypoints = PlaceJugBack()
    q2Waypoints = [
        deg2rad([151, -64.8, 93.4, -86.2, 0, 0]);
        deg2rad([151, -72.0, 137, -158, 0, 0]);
        deg2rad([115, -38.0, 108, -173, 0, 0]);
        deg2rad([140, -16.4, 50.2, -130, 0, 0]);
    ];
end

function q2Waypoints = ReturnBackafterPouring()
    q2Waypoints = [
        deg2rad([140, -16.4, 50.2, -130, 0, 0]);
        deg2rad([115, -38.0, 108, -173, 0, 0]);
        deg2rad([115, -59.6, 144, -173, 0, 0]);
        deg2rad([0, -59.6, 144, -173, 0, 0]);
        deg2rad([0, 0, 0, 0, 0, 0]);
    ];
end

%% Function to Move Robot Using q2Waypoints
function moveRobot(waypoints, client, goal, jointStateSubscriber, durationSeconds, bufferSeconds)
    currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)';
    currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

    % Initialize the start point
    startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
    startJointSend.Positions = currentJointState_123456;
    startJointSend.TimeFromStart = rosduration(0);

    % Initialize trajectory points array
    goal.Trajectory.Points = [startJointSend];

    % Loop through each waypoint
    for i = 1:size(waypoints, 1)
        endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
        endJointSend.Positions = waypoints(i, :);
        endJointSend.TimeFromStart = rosduration(i * durationSeconds);
        goal.Trajectory.Points = [goal.Trajectory.Points; endJointSend];
    end

    % Set header stamp and send goal
    goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
    sendGoal(client, goal);
    pause(durationSeconds * size(waypoints, 1) + bufferSeconds); % Wait for completion
end

%% Execute Movements Based on q2Waypoints
% List of functions for each sequence
q2WaypointsList = {@MovetoJug, @GrabJug, @PutJugBelowFrother, @FrothMilk, ...
                   @FinishFrothing, @PickUpJug, @PlaceJugBack, @ReturnBackafterPouring};

% Loop through each motion sequence
for i = 1:length(q2WaypointsList)
    waypoints = q2WaypointsList{i}(); % Get waypoints for the current movement

    % Perform gripper action as needed
    if i == 2
        closeService.call(); % Close gripper for GrabJug
    elseif i == 4
        openService.call(); % Open gripper for FrothMilk
    end

    % Move the robot through the current waypoints
    moveRobot(waypoints, client, goal, jointStateSubscriber, durationSeconds, bufferSeconds);
end

% Final position and close gripper
moveRobot(deg2rad([0, 0, 0, 0, 0, 0]), client, goal, jointStateSubscriber, durationSeconds, bufferSeconds); % Return to home position
closeService.call(); % Final gripper close
