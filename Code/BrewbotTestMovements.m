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
            obj.ur3e_defaultPos = zeros(obj.ur3e.model.n);
            obj.nova2_defaultPos = zeros(obj.nova2.model.n);
        end
        
        function stop = checkEmergencyStop(hObject)
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

        function espresso_test2(obj, hObject)
            q = obj.nova2.model.getpos();
            q(1) = q(1) + pi;
            moveRobot(obj, hObject, obj.nova2, q)

        end

        function moveRobot(~, hObject, robot, q)
            
            if checkEmergencyStop(hObject)
                    return;
            end

            q0 = robot.getpos();
            qMatrix = jtraj(q0, q, 60);
            for i = 1 : size(qMatrix)
                robot.model.animate(qMatrix(i))
                pause(0.01)
            end
             
        end
    end
end

