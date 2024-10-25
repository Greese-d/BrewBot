rosinit('192.168.27.1'); % If unsure, please ask a tutor
%% Initialize subscriber and services
jointStateSubscriber = rossubscriber('/ur/joint_states','sensor_msgs/JointState');
pause(2); % Pause to give time for a message to appear
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)];
openService = rossvcclient("/onrobot/open", "std_srvs/Trigger");
closeService = rossvcclient("/onrobot/close", "std_srvs/Trigger");

%% Initialize joint names and action client
jointNames = {'shoulder_pan_joint','shoulder_lift_joint', 'elbow_joint', 'wrist_1_joint', 'wrist_2_joint', 'wrist_3_joint'};
[client, goal] = rosactionclient('/ur/scaled_pos_joint_traj_controller/follow_joint_trajectory');
goal.Trajectory.JointNames = jointNames;
goal.GoalTimeTolerance = rosduration(0.05);
bufferSeconds = 1; % Network buffer
durationSeconds = 5; % Motion duration

%% First motion
% Move to first target position
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([86,-61,52,-81,-88,170]); % Target position in degrees
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(7); % Wait for the motion to complete
closeService.call(); % Close gripper

%% Second motion
% Move to second target position
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([50,-61,52,-81,-88,170]); % Second target position
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(7); % Wait for the motion to complete
openService.call(); % Open gripper

%% Third motion
% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([0, 0, 0, 0, 0, 0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(7); % Wait for the motion to complete
closeService.call(); % Close gripper at the end

