classdef BrewbotTestMovements
    %This class is a collection of movements and helper functions to test
    %GUI's functionality
    
    properties
        nova2;
        ur3e;
        ur3e_defaultPos;
        nova2_defaultPos;
        cup1;
        cupLid; 
        milkJug;
        iceCube; 
        portafilter;
        arduinoObj; % Arduino object for button monitoring;
    end
    
    methods
       function obj = BrewbotTestMovements(r_nova2, r_ur3e, cup, cupLid, milkJug, iceCube, portafilter, arduinoObj)
            % Constructor to initialize the class with robots and serial
            obj.nova2 = r_nova2;
            obj.ur3e = r_ur3e;
            obj.ur3e_defaultPos = zeros(1, obj.ur3e.model.n);
            obj.nova2_defaultPos = zeros(1, obj.nova2.model.n);
            obj.cup1 = cup;
            obj.cupLid = cupLid; 
            obj.milkJug = milkJug;
            obj.iceCube = iceCube; 
            obj.portafilter = portafilter;
            obj.arduinoObj = arduinoObj;  % Store the Arduino object

        end
        
        function stop = checkEmergencyStop(obj, hObject)
            handles = guidata(hObject);  % Retrieve the updated handles
        
            % Initialize stop to false
            stop = false;
        
            % Check if the GUI emergency stop has been triggered
            if handles.isStopped
                disp("Process interrupted by emergency stop (GUI)");
                stop = true;  % Set stop to true if GUI emergency stop is triggered
                return;  % Exit the function early if GUI stop is active
            end
        
            % Check Arduino emergency stop if Arduino object is available
            if ~isempty(obj.arduinoObj)  % Ensure Arduino object is initialized
                try
                    buttonState = readDigitalPin(obj.arduinoObj, 'D2');  % Read from pin 2
                    if buttonState == 1  % Button pressed
                        disp("Process interrupted by emergency stop (Arduino button)");
                        stop = true;  % Set stop to true if Arduino button is pressed
                    end
                catch ME
                    disp("Error reading Arduino pin: " + ME.message);
                    % If there's an error reading the Arduino, you might choose to set stop = true
                    % stop = true;  % Uncomment if you want to stop the process in case of an Arduino error
                end
            else
                disp("Arduino object is not initialized or connected.");
            end
        end

        function espresso_test(obj, hObject)
        % Movement for DobotNova2 (robot1)
        q1Waypoints = [
            deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
            deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]); % Grab cup position
            deg2rad([-7.2, 36, -72, -50.4, 180, 0]);   % Lift cup
            deg2rad([5, 57.6, -122, -21.6, 180, 0]);   % Move to next position (possibly N or intermediary)
            deg2rad([64.8, 57.6, -122, -21.6, 180, 0]);  % Move to machine (approaching cup placement)
            deg2rad([64.8, 43.2, -108, -21.6, 180, 0]);  % Place cup at machine
            deg2rad([57.6, 93.6, -158, -21.6, 180, 0]); % Pull back after placing cup
            deg2rad([0, 93.6, -158, -21.6, 180, 0]);   % Rotate back to initial
            deg2rad([-14.4, 14.4, -28.8, -64.8, 93.6, 0]); % Pick pipe
            deg2rad([7.2, 101, -151, -36, 93.6, 0]);   % Lift pipe
            deg2rad([151, 101, -151, -36, 93.6, 0]);    % Rotate with pipe
            deg2rad([151, 79.2, -130, -36, 93.6, 0]);   % Place pipe
            %add some time
            deg2rad([151, 101, -151, -36, 93.6, 0]);   % Pull pipe back
            deg2rad([86.4, 115, -115, -93.6, 93.6, 0]); % Place pipe (somewhere else)
            %add some time
            deg2rad([50.4, 86.4, -158, -21.6, 180, 0]); % Pull back to prepare for next action
            deg2rad([64.8, 43.2, -108, -21.6, 180, 0]);  % Pick up cup again
            deg2rad([7.2, 57.6, -122, -21.6, 180, 0]); % Pull back with the cup
            deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]); % Place cup back to original position
            deg2rad([0, 0, 0, 0, 0, 0]);              % Return to home position
    
            ];

        qMatrix1 = InterpolateWaypointRadians(q1Waypoints, deg2rad(3));
    
        % Movement for UR3e (robot2)
        q2Waypoints = [
            deg2rad([50, 100, 90, 270, 120, 0]);   % Different starting configuration
            deg2rad([55, 95, 85, 275, 115, 0]);    % Slightly different waypoints for robot2
            deg2rad([60, 90, 80, 280, 110, 0]); 
            deg2rad([65, 85, 75, 285, 105, 0]);
            deg2rad([70, 80, 70, 290, 100, 0]);
            deg2rad([75, 75, 65, 295, 95, 0]);
            deg2rad([80, 70, 60, 300, 90, 0]);
            deg2rad([85, 65, 55, 305, 85, 0]);
            deg2rad([0, 0, 0, 0, 0, 0]);
        ];

        qMatrix2 = InterpolateWaypointRadians(q2Waypoints, deg2rad(5));
    
        % Ensure both robots move for the same number of steps
        steps = max(size(qMatrix1, 1), size(qMatrix2, 1));
    
        % Loop through and move both robots simultaneously
        for i = 1:steps
            % Check for emergency stop
            if checkEmergencyStop(obj, hObject)
                return;
            end
    
            % Move DobotNova2 (robot1)
            if i <= size(qMatrix1, 1)
                obj.nova2.model.animate(qMatrix1(i, :));  % Animate DobotNova2
            else
                obj.nova2.model.animate(qMatrix1(end, :));  % Hold last position
            end
    
            % Move UR3e (robot2)
            if i <= size(qMatrix2, 1)
                obj.ur3e.model.animate(qMatrix2(i, :));  % Animate UR3e
            else
                obj.ur3e.model.animate(qMatrix2(end, :));  % Hold last position
            end
    
            % Pause briefly to simulate real-time animation
            pause(0.05);
        end
    end
        
        function MoveObjects(object, qCurrent, robot)
            tr = robot.model.fkine(qCurrent); 
            vertices = get(object, 'Vertices'); 
            transformedVertices = [vertices, ones(size(vertices, 1), 1)] * tr.T;
            set(object, 'Vertices', transformedVertices(:, 1:3));  
        end



        %% Function to move 2nd joint of UR3e 135 degrees (latte test)
        function latte_test(obj, hObject)
             % Movement for DobotNova2 (robot1)
            q1Waypoints = [
                deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
                deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]); % Grab cup position
                deg2rad([-7.2, 36, -72, -50.4, 180, 0]);   % Lift cup
                deg2rad([5, 57.6, -122, -21.6, 180, 0]);   % Move to intermediary
                deg2rad([64.8, 57.6, -122, -21.6, 180, 0]);  % Move to machine (cup placement)
                deg2rad([64.8, 43.2, -108, -21.6, 180, 0]);  % Place cup
                deg2rad([57.6, 93.6, -158, -21.6, 180, 0]); % Pull back after placing
                deg2rad([0, 93.6, -158, -21.6, 180, 0]);    % Rotate back to initial
                deg2rad([-14.4, 14.4, -28.8, -64.8, 93.6, 0]); % Pick pipe
                deg2rad([7.2, 101, -151, -36, 93.6, 0]);    % Lift pipe
                deg2rad([151, 101, -151, -36, 93.6, 0]);    % Rotate with pipe
                deg2rad([151, 79.2, -130, -36, 93.6, 0]);   % Place pipe
                deg2rad([151, 101, -151, -36, 93.6, 0]);    % Pull pipe back
                deg2rad([86.4, 115, -115, -93.6, 93.6, 0]); % Place pipe somewhere else
                deg2rad([50.4, 86.4, -158, -21.6, 180, 0]); % Pull back for next action
                deg2rad([64.8, 43.2, -108, -21.6, 180, 0]); % Pick up cup again
                deg2rad([7.2, 57.6, -122, -21.6, 180, 0]);  % Pull back with the cup
                deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]);  % Place cup back
                deg2rad([0, 0, 0, 0, 0, 0]);               % Return to home position
            ];

            qMatrix1 = InterpolateWaypointRadians(q1Waypoints, deg2rad(3));

            % Movement for UR3e (robot2)
            q2Waypoints = [
                deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
                deg2rad([0, -72, 108, 0, 0, 0]);          % Fold position
                deg2rad([158, -72, 108, 0, 0, 0]);        % Rotate and move to grab cup
                deg2rad([144, -72, 108, -108, 0, 0]);     % Drop the cup
                deg2rad([144, -57.6, 101, -108, 0, 0]);   % Stretch towards placement
                deg2rad([144, -28.8, 50.4, -108, 0, 0]);  % Grab the cup
                deg2rad([144, -36, 57.6, -108, 0, 0]);    % Pull the cup
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([122, -50.4, 115, -151, 0, 0]);   % Position below frother
                deg2rad([122, -50.4, 115, -151, 0, 0]);
                deg2rad([122, -50.4, 115, -151, 0, 0]);
                deg2rad([122, -50.4, 115, -151, 0, 0]);
                deg2rad([100, -72, 108, -151, 0, 0]);   % Fold arm at frother
                deg2rad([-22, -64.8, 137, -151, 0, 0]);   % Retract after frothing
                deg2rad([0, 0, 0, 0, 0, 0]);              % Return to home position
            ];

            qMatrix2 = InterpolateWaypointRadians(q2Waypoints, deg2rad(5));

            % Ensure both robots move for the same number of steps
            steps = max(size(qMatrix1, 1), size(qMatrix2, 1));

            % Loop through and move both robots simultaneously
            for i = 1:steps
                % Check for emergency stop
                if checkEmergencyStop(obj, hObject)
                    return;
                end

                % Move DobotNova2 (robot1)
                if i <= size(qMatrix1, 1)
                    
                    MoveObjects(obj.cup1, qMatrix1(i, :), obj.nova2);
                    
                    obj.nova2.model.animate(qMatrix1(i, :));  % Animate DobotNova2
                else
                    obj.nova2.model.animate(qMatrix1(end, :));  % Hold last position
                end

                % Move UR3e (robot2)
                if i <= size(qMatrix2, 1)
                    obj.ur3e.model.animate(qMatrix2(i, :));  % Animate UR3e
                else
                    obj.ur3e.model.animate(qMatrix2(end, :));  % Hold last position
                end
                
                drawnow();
                % Pause briefly to simulate real-time animation
                pause(0.05);
            end
        end

        % Helper function to move robot to desired location specified by qMatrix
        % Checks if e-stop was initiated and does not move robot if triggered
        function moveRobot(obj, hObject, robot, qMatrix)
            for i = 1 : size(qMatrix, 1)
                if checkEmergencyStop(obj, hObject)
                    return;
                end

                robot.model.animate(qMatrix(i, :));  % Animate robot to the given configuration
                pause(0.01);
            end
        end

        % Function to move both nova2 and ur3e to their default position
        % (specified in class properties)
        function resetRobots(obj)
            n = 60;  % Amount of steps
            
            q0_nova2 = obj.nova2.model.getpos();
            q0_ur3e = obj.ur3e.model.getpos();
            qMatrix_nova2 = jtraj(q0_nova2, obj.nova2_defaultPos, n);
            qMatrix_ur3e = jtraj(q0_ur3e, obj.ur3e_defaultPos, n);
            
            for i = 1 : n
                obj.nova2.model.animate(qMatrix_nova2(i, :));
                obj.ur3e.model.animate(qMatrix_ur3e(i, :));
                pause(0.01);
            end
        end

    end
end

%% Supporting functions (Interpolate and FineInterpolation)
function qMatrix = InterpolateWaypointRadians(waypointRadians, maxStepRadians)
    if nargin < 2
        maxStepRadians = deg2rad(1);
    end

    qMatrix = [];
    for i = 1:size(waypointRadians, 1) - 1
        qMatrix = [qMatrix; FineInterpolation(waypointRadians(i, :), waypointRadians(i + 1, :), maxStepRadians)]; %#ok<AGROW>
    end
end

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
