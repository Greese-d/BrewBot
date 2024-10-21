classdef BrewbotTestMovements
    %This class is a collection of movements and helper functions to test
    %GUI's functionality
    
    properties
        nova2;
        ur3e;
        ur3e_defaultPos;
        nova2_defaultPos;
        arduinoObj;  % Arduino object for button monitoring;
    end
    
    methods
       function obj = BrewbotTestMovements(r_nova2, r_ur3e, arduinoObj)
            % Constructor to initialize the class with robots and serial
            obj.nova2 = r_nova2;
            obj.ur3e = r_ur3e;
            obj.ur3e_defaultPos = zeros(1, obj.ur3e.model.n);
            obj.nova2_defaultPos = zeros(1, obj.nova2.model.n);
            obj.arduinoObj = arduinoObj;  % Store the Arduino object
        end
        
        % Returns true if either emergency stop (GUI or Arduino button) is active
        function stop = checkEmergencyStop(obj, hObject)
            handles = guidata(hObject);  % Retrieve the updated handles
    
            % Check if the GUI emergency stop has been triggered
            if handles.isStopped
                disp("Process interrupted by emergency stop (GUI)");
                stop = true;  % Return true if GUI emergency stop is triggered
                return;
            end
            
            buttonState = readDigitalPin(obj.arduinoObj, 'D2');  % Read from pin 2
            if buttonState == 1  % Button pressed
                disp("Process interrupted by emergency stop (Arduino button)");
                stop = true;  % Return true if Arduino button is pressed
            else
                stop = false;  % Return false if neither stop is triggered
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


        % Function to move 2nd joint of UR3e 135 degrees (latte test)
        function latte_test(obj, hObject)
            q = obj.ur3e.model.getpos();
            q(2) = q(2) + 3*pi/4;
            moveRobot(obj, hObject, obj.ur3e, q)
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
