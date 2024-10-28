rosinit('192.168.27.1'); % If unsure, please ask a tutor
%% Initialize subscriber and services
jointStateSubscriber = rossubscriber('/ur/joint_states','sensor_msgs/JointState');
pause(2); % Pause to give time for a message to appear
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)];
openService = rossvcclient("/onrobot/open", "std_srvs/Trigger");
closeService = rossvcclient("/onrobot/close", "std_srvs/Trigger");
pauseTime = 7;

%% Initialize joint names and action client
jointStateSubscriber.LatestMessage

jointNames = {'shoulder_pan_joint','shoulder_lift_joint', 'elbow_joint', 'wrist_1_joint', 'wrist_2_joint', 'wrist_3_joint'};

[client, goal] = rosactionclient('/ur/scaled_pos_joint_traj_controller/follow_joint_trajectory');
goal.Trajectory.JointNames = jointNames;
goal.Trajectory.Header.Seq = 1;
goal.Trajectory.Header.Stamp = rostime('Now','system');
goal.GoalTimeTolerance = rosduration(0.05);
bufferSeconds = 1; % This allows for the time taken to send the message. If the network is fast, this could be reduced.
durationSeconds = 5; % This is how many seconds the movement will take


% Move to first target position
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([0.3,0.3,0.3,0.3,0.3,0]); % Target position in degrees
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
closeService.call(); % Close gripper

% Move to second target position
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([0,-72,108,0,0,0]); % Second target position
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%openService.call(); % Open gripper

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([158,-72,108,0,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end


% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([144,-72,108,-108,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end


% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([144,-57.6,101,-108,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([144,-28.8,50.4,-108,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([144,-36,57.6,-108,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([122,-36,57.6,-108,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([122,-72,122,-151,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([93.6,-50.4,115,-151,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([122,-50.4,115,-151,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([129,-64.8,115,-151,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([122,-50.4,115,-151,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([122,-86.4,151,-151,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([144,-86.4,151,-151,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

% Move to zero position and close gripper
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Get current joint state
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]; % Reorder joints

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = deg2rad([151,-64.8,93.4,-86.2,0,0]); % Move to home position (all joints at zero)
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend]; % Set trajectory points
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds); % Add buffer
sendGoal(client,goal); % Send the goal

pause(pauseTime); % Wait for the motion to complete
%closeService.call(); % Close gripper at the end

