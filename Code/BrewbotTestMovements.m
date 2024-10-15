classdef BrewbotTestMovements
    %This class is a collection of movements and helper function to test
    %GUI's functionality
    
    properties
        nova2;
        ur3e;
        ur3e_defaultPos;
        nova2_defaultPos;
    end
    
    methods
        function obj = BrewbotTestMovements(r_nova2 ,r_ur3e)
            %BREWBOTTESTMOVEMENTS Construct an instance of this class
            %   create an object of this class which contains robots as
            %   properties
            obj.nova2 = r_nova2;
            obj.ur3e = r_ur3e;
            obj.ur3e_defaultPos = zeros(1, obj.ur3e.model.n);
            obj.nova2_defaultPos = zeros(1, obj.nova2.model.n);
        end
        
        % Returns true if emergency stop is active
        function stop = checkEmergencyStop(~, hObject)
            % Retrieve the updated handles
            handles = guidata(hObject);
    
            % Check if the emergency stop has been triggered
            if handles.isStopped
                disp("Process interrupted by emergency stop");
                stop = true;  % Return true if emergency stop is triggered
            else
                stop = false;  % Return false if not triggered
            end
        end

        % Simple test function to move 1st joint of nova2 180 degrees
        function espresso_test(obj, hObject)
            q = obj.nova2.model.getpos();
            q(1) = q(1) + pi;
            moveRobot(obj, hObject, obj.nova2, q)

        end

        %Simple test function to move 2nd joint of ur3e 135 degrees
        function latte_test(obj, hObject)
            q = obj.ur3e.model.getpos();
            q(2) = q(2) + 3*pi/4;
            moveRobot(obj, hObject, obj.ur3e, q)
        end


        %Helper function to move robot to desired location specified by q.
        %Also checks if e-stop was initiated and does not move robot when
        %it was.
        function moveRobot(obj, hObject, robot, q)

            q0 = robot.model.getpos();
            qMatrix = jtraj(q0, q, 60);
            for i = 1 : size(qMatrix, 1)
                if checkEmergencyStop(obj, hObject)
                    return;
                end

                robot.model.animate(qMatrix(i, :))
                pause(0.01)
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

                obj.nova2.model.animate(qMatrix_nova2(i, :))
                obj.ur3e.model.animate(qMatrix_ur3e(i, :))
                pause(0.01)
            end
        end

    end
end

