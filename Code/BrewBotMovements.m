classdef BrewBotMovements
    %This class is a collection of movements and helper functions to test
    %GUI's functionality
    
    properties
        nova2;
        ur3e;
        ur3e_defaultPos;
        nova2_defaultPos;
        cup;
        cupLid; 
        milkJug;
        teaBag;
        cupWithLid;

        portafilter;
        cupVertices;
        cupLidVertices;
        milkJugVertices;
        portafilterVertices;
        teaBagVertices;
        cupWithLidVertices;

        cupVerticesInitial;
        cupLidVerticesInitial;
        milkJugVerticesInitial;
        portafilterVerticesInitial;
        teaBagVerticesInitial;
        cupWithLidVerticesInitial;

        arduinoObj; % Arduino object for button monitoring;
        ur3eGripper;
        nova2Gripper;
        
    end
    
    %% Methods with 
    methods (Static)
        %% espresso brew
        function q2Waypoints = GrabCup()
            q2Waypoints = [
                        deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
                        deg2rad([10, 35.2, -85.2, -93.6, 180, -45]); % Grab cup position    
            ];
        end
        
        function q2Waypoints = PlaceCupatMachine()
            q2Waypoints = [
                        deg2rad([10, 35.2, -85.2, -93.6, 180, -45])
                        deg2rad([-7.2, 36, -72, -50.4, 180, 0]);   % Lift cup
                        deg2rad([5, 57.6, -122, -21.6, 180, 0]);   % Move to intermediary
                        deg2rad([64.8, 57.6, -122, -21.6, 180, 0]);  % Move to machine (cup placement)
                        deg2rad([64.8, 43.2, -108, -21.6, 180, 0]);  % Place cup
            ];
        end
        
        function q2Waypoints = MovetoFilter()
            q2Waypoints = [
                        deg2rad([64.8, 43.2, -108, -21.6, 180, 0]);  % Place cup
                        deg2rad([57.6, 93.6, -158, -21.6, 180, 0]); % Pull back after placing
                        deg2rad([0, 93.6, -158, -21.6, 180, 0]);    % Rotate back to initial
                        deg2rad([0, 93.6, -158, -21.6, 180, 0]);    % Rotate back to initial
                        deg2rad([-14.4, 7.4, -28.8, -64.8, 93.6, 0]); % Pick pipe
        
            ];
        end

        function q2Waypoints = PipetoGrinder()
            q2Waypoints = [
                        deg2rad([-14.4, 7.4, -28.8, -64.8, 93.6, 0]); % Pick pipe
                        deg2rad([7.2, 101, -151, -36, 93.6, 0]);    % Lift pipe
                        deg2rad([151, 101, -151, -36, 93.6, 0]);    % Rotate with pipe
                        deg2rad([151, 79.2, -145, -36, 93.6, 0]);
                        deg2rad([151, 79.2, -145, -26, 93.6, 150]);   % Place pipe
        
            ];
        end
        
        function q2Waypoints = PipetoMachine()
            q2Waypoints = [
                        deg2rad([151, 79.2, -145, -26, 93.6, 150]);   % Place pipe
                        deg2rad([151, 79.2, -145, -36, 93.6, 0]);
                        deg2rad([151, 101, -151, -36, 93.6, 0]);    % Pull pipe back
                        deg2rad([86.4, 101, -151, -36, 93.6, 0]);
                        deg2rad([86.4, 115, -115, -93.6, 93.6, 90]); % Place pipe at coffee machine
            ];
        end
        
        function q2Waypoints = MovetoReturnCup()
            q2Waypoints = [
                        deg2rad([86.4, 115, -115, -93.6, 93.6, 90]); % Place pipe at coffee machine
                        deg2rad([50.4, 86.4, -158, -21.6, 180, 0]); % Pull back for next action
                        deg2rad([64.8, 43.2, -108, -21.6, 180, 0]); % Pick up cup again
            ];
        end
        
        function q2Waypoints = ReturnCup()
            q2Waypoints = [
                        deg2rad([64.8, 43.2, -108, -21.6, 180, 0]); % Pick up cup again
                        deg2rad([7.2, 57.6, -122, -21.6, 180, 0]);  % Pull back with the cup
                        deg2rad([-7.2, -15.2, 7.2, -83.6, 180, 0]);  % Place cup back
            ];
        end


        
        function q2Waypoints = MovetoReturnPipe()
            q2Waypoints = [
                        %deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]);
                        deg2rad([-7.2, -15.2, 7.2, -83.6, 180, 0]);  % Place cup back
                        deg2rad([7.2, 57.6, -122, -21.6, 180, 0]);  % Pull back
                        deg2rad([7.2, 86.4, -158, -21.6, 180, 90]); % Pull back for next action
                        deg2rad([50.4, 115, -115, -93.6, 93.6, 90]); % Pull back for next action
                        deg2rad([86.4, 115, -115, -93.6, 93.6, 90]); % Take pipe at coffee machine
            ];
        end

        function q2Waypoints = ReturnPipe()
            q2Waypoints = [
                        deg2rad([86.4, 115, -115, -93.6, 93.6, 90]); % Take pipe at coffee machine
                        deg2rad([86.4, 115, -151, -58.6, 93.6, 0]); % fold
                        deg2rad([7.2, 115, -151, -58.6, 93.6, 0]); % rotate
                        deg2rad([-20.4, 35.4, -72.8, -64.8, 93.6, 0]); % place pipe at initial
            ];
        end

        function q2Waypoints = ReturnHome()
            q2Waypoints = [
                        deg2rad([-20.4, 35.4, -72.8, -64.8, 93.6, 0]); % place pipe at initial
                        deg2rad([0, 0, 0, 0, 0, 0]);               % Return to home position    
            ];
        end
        
        %% add milk to jug
        
        function q2Waypoints = MovetoJug()
            q2Waypoints = [
                        deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
                        deg2rad([0, -72, 108, 0, 0, 0]);          % Fold position (fold arm)
                        deg2rad([158, -72, 108, 0, 0, 0]);        % Rotate and move
                        deg2rad([144, -72, 108, -108, 0, 0]);     % Move down
                        deg2rad([144, -57.6, 101, -108, 0, 0]);   % Stretch towards jug placement
                        deg2rad([144, -18.8, 50.4, -108, 0, 0]);  % Grab the jug
                        
        ];
        end
        
        function q2Waypoints = GrabJug()
            q2Waypoints = [
                        deg2rad([144, -18.8, 50.4, -108, 0, 0]);  % Grab the jug
                        deg2rad([144, -36, 57.6, -108, 0, 0]);    % Pull the jug
                        deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk    
            ];
        end 
        
        function q2Waypoints = PutJugBelowFrother() %add some time before this
            q2Waypoints = [
                        deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                        deg2rad([122, -50.4, 115, -151, 0, 0]);   % Put cup below frother    
            ];
        end 
        
        %% froth milk function
        
        function q2Waypoints = FrothMilk()
            q2Waypoints = [
                        deg2rad([122, -50.4, 115, -151, 0, 0]);    % Pick Jug
                        deg2rad([130, -64.8, 110, -151, 0, 0]);    % Lift to Reach
        ];
        end
        
        function q2Waypoints = FinishFrothing() %add time before this
            q2Waypoints = [
                        deg2rad([130, -64.8, 110, -151, 0, 0]);    % Lift to Reach
                        deg2rad([122, -50.4, 115, -151, 0, 0]);    % Put back Jug    
            ];
        end
        
        %% add ice
        
        function q2Waypoints = MovetoCup()
            q2Waypoints = [
                        deg2rad([122, -50.4, 115, -151, 0, 0]);    % Pick cup
                        deg2rad([162, -50.4, 122, 0, 0, 0]);      % Rotate
                        deg2rad([176, -14.4, 12.2, 5, 108, -90]);  % Grab cup
                
            ];
        end
        
        function q2Waypoints = GetIce()
            q2Waypoints = [
                        deg2rad([176, -14.4, 12.2, 5, 108, -90]);  % Grab cup
                        deg2rad([162, -93.7, 136, -43.2, 79.2, -90]); % Lift cup
                        deg2rad([61.2, -93.7, 136, -43.2, 79.2, -90]); % Rotate
                        deg2rad([61.2, -86.5, 108, -21.6, 79.2, -90]); % Wait for ice   
            ];
        end
        
        function q2Waypoints = ReturnCupWithIce() %add time before this
            q2Waypoints = [
                        deg2rad([61.2, -86.5, 108, -21.6, 79.2, -90]); % Wait for ice
                        deg2rad([61.2, -93.7, 136, -43.2, 79.2, -90]); % Pull
                        deg2rad([162, -93.7, 136, -43.2, 79.2, -90]); % Lift cup
                        deg2rad([176, -14.4, 12.2, 5, 108, -90]);  % drop cup
            ];
        end

        function q2Waypoints = MovetoJugAfterIce() %add time before this
            q2Waypoints = [
                        deg2rad([176, -14.4, 12.2, 5, 108, -90]);  % drop cup
                        deg2rad([162, -57.7, 100, -43.2, 79.2, 0]);  % Put cup down
                        deg2rad([122, -50.4, 115, -151, 0, 0]);    % Pick Jug  
            ];
        end
        %% pour milk into cup functions
        
        function q2Waypoints = PickUpJug()
            q2Waypoints = [
                        deg2rad([122, -50.4, 115, -151, 0, 0]);    % Take milk jug
                        deg2rad([122, -86.4, 151, -151, 0, 0]);    % Fold
                        deg2rad([141, -86.4, 151, -151, 0, 0]);    % Rotate
                        deg2rad([158, -58.8, 80.4, -86.2, 0, 50]);  % Pour    
            ];
        end
        
        function q2Waypoints = PlaceJugBack() %add some time
            q2Waypoints = [
                        deg2rad([158, -58.8, 80.4, -86.2, 0, 50]);  % Pour
                        deg2rad([151, -72.0, 137, -158, 0, 0]);    % Lift
                        deg2rad([136, -72.0, 137, -158, 0, 0]);    
                        deg2rad([136, -38.0, 108, -173, 0, 0]);    % Get in position
                        deg2rad([136, -18.8, 50.4, -108, 0, -10]);   % Put at initial jug position
            
            ];
        end
        
        function q2Waypoints = ReturnBackafterPouring()
            q2Waypoints = [
                        deg2rad([136, -18.8, 50.4, -108, 0, -10]);   % Put at initial jug position
                        deg2rad([115, -38.0, 108, -173, 0, 0]);    % Get in position again
                        deg2rad([115, -59.6, 144, -173, 0, 0]);    % Fold
                        deg2rad([0, -59.6, 144, -173, 0, 0]);      % Rotate
                        deg2rad([0, 0, 0, 0, 0, 0]);               % Initial position
            ];
        end
        %% add tea
        %Nova2 movements
        function q2Waypoints = gotoCupforTea()
            q2Waypoints   = [
                        deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
                        deg2rad([10, 35.2, -85.2, -93.6, 180, -45]); % Grab cup position    
                ];
        end

        function q2Waypoints = moveCupforTea()
            q2Waypoints = [
                        deg2rad([10, 35.2, -85.2, -93.6, 180, -45]); % Grab cup position 
                        deg2rad([-7.2, 49.6, -85.2, -93.6, 180, -45]); % lift cup
                        deg2rad([-7.2, -15.2, 7.2, -83.6, 180, 0]);  % Place cup
                ];
        end

        function q2Waypoints = gobackafterTea()
            q2Waypoints = [
                        deg2rad([-7.2, -15.2, 7.2, -83.6, 180, 0]);  % Place cup back
                        deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
                ];
        end
        %UR3e movements
        function q2Waypoints = movetoTeaBag()
            q2Waypoints = [
                        deg2rad([0, 0, 0, 0, 0, 0]);                        % Initial position
                        deg2rad([0, -86.4, 144, -180, -93.6, 180]);           % Fold position for tea bag
                        deg2rad([173, -86.4, 144, -180, -93.6, 180]);         % Rotate to pour tea bag
                        deg2rad([173, -64.8, 144, -180, -93.6, 180]);         % Lower robot down
            ];
        end

        function q2Waypoints = putTeaBag()
            q2Waypoints = [
                        deg2rad([173, -64.8, 144, -180, -93.6, 180]);         % Lower robot down
                        deg2rad([173, -86.4, 144, -180, -93.6, 180]);         % Lift tea bag up
                        deg2rad([173, -43.2, 50.4, -115, -93.6, 180]);        % Place tea bag in cup
            ];
        end

        function q2Waypoints = otwGrabCup()
            q2Waypoints = [
                        deg2rad([173, -43.2, 50.4, -115, -93.6, 180]);        % Place tea bag in cup
                        deg2rad([187, -43.2, 50.4, -115, -180, 180]);         % Move above cup
                        deg2rad([187, -21.6, 50.4, -115, -180, 180]);         % Grab cup
            ];
        end

        %% add hot water
        
        function q2Waypoints = AddHotWater()
            q2Waypoints = [
                        deg2rad([187, -21.6, 50.4, -115, -180, 180]);         % Grab cup
                        deg2rad([187, -57.6, 108, -144, -180, 180]);          % Fold position to add hot water
                        deg2rad([173, -50.4, 101, -144, -180, 180]);          % Pour hot water
            ];
        end
        
        function q2Waypoints = ReturnHotWaterCup()
            q2Waypoints =[
                        deg2rad([173, -50.4, 101, -144, -180, 180]);          % Pour hot water
                        deg2rad([187, -57.6, 180, -144, -180, 180]);          % Fold to return cup
                        deg2rad([187, -21.6, 50.4, -115, -180, 180]);         % Return cup
            ];
        end
        
        
        function q2Waypoints = ReturnBotBack()
            q2Waypoints =[
                        deg2rad([187, -21.6, 50.4, -115, -180, 180]);         % Return cup
                        deg2rad([345, -21.6, 50.4, -115, -180, 0]);         % Go home
                        deg2rad([0, 0, 0, 0, 0, 0, 0]);                     % Reset to initial position
            ];
        end
        
        %% finish drink function
        
        %% For NOVA2
        
        function q2Waypoints = MovetoLid()
            q2Waypoints = [
                    deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
                    deg2rad([0, 43.2, -108, -14.4, 86.4, 0]);  % Fold position
                    deg2rad([14.4, 43.2, -108, -14.4, 86.4, 0]);  % Pick lid
        
            ];
        end
        
        function q2Waypoints = GrabLid()
            q2Waypoints = [
                    deg2rad([14.4, 43.2, -108, -14.4, 86.4, 0]);  % Pick lid
                    deg2rad([14.4, 57.6, -108, -14.4, 86.4, 0]);  % Lift lid
                    deg2rad([5, 25, -44.2, -67.6, 101.4, 0]);  % Place lid
            ];
        end
        
        function q2Waypoints = ReturnNova2()
            q2Waypoints = [
                    deg2rad([5, 28.8, -51.4, -67.6, 101.4, 0]);  % Place lid
                    deg2rad([14.4, 57.6, -108, -14.4, 86.4, 0]);  % Fold back
                    deg2rad([0, 43.2, -108, -14.4, 86.4, 0]);  % Rotate
                    deg2rad([0, 0, 0, 0, 0, 0]);  % back home  
            ];
        end
        
        %% FOR UR3E
        
        function q2Waypoints = MovetoFinishedCup()
            q2Waypoints = [
                    deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
                    deg2rad([0, -72, 101, 0, 108, 0]);            % Fold position
                    deg2rad([-115, -72, 101, 0, 108, 0]);          % Rotate to cup
                    deg2rad([-187, -72, 101, 0, 108, 0]);       % Rotate and go down
                    deg2rad([-187, -43.2, 57.6, -10, 108, 0]);     % Stretch towards cup placement
            ];
        end
        
        function q2Waypoints = PickUpFinishedCup()
            q2Waypoints = [
                    deg2rad([-187, -43.2, 57.6, -10, 108, 0]); % Stretch towards cup placement
                    deg2rad([-187, -72, 101, -10, 108, 0]);       %  grab up
                    deg2rad([-115, -72, 101, -10, 108, 0]);          % Rotate 
                    deg2rad([0, -10, 7.2, 0, 93.6, 0]);         % Place Cup
            ];
        end
        
        function q2Waypoints = ReturnUR3e()
            q2Waypoints = [
                   deg2rad([0, -10, 7.2, 0, 93.6, 0]);         % Place Cup
                   deg2rad([0, 0, 0, 0, 0, 0]);                % Return to home position
            ];
        end
    end

    %% Initialisation method
    methods
        function obj = BrewBotMovements(env, arduinoObj)
            % Constructor to initialize the class with robots and serial

            obj.nova2 = env.nova2;
            obj.ur3e = env.ur3e;

            obj.ur3e_defaultPos = zeros(1, obj.ur3e.model.n);
            obj.nova2_defaultPos = zeros(1, obj.nova2.model.n);
            

            obj.cup = env.cup;
            obj.cupVertices = get(obj.cup, 'Vertices');
            obj.cupVerticesInitial = obj.cupVertices;

            obj.cupLid = env.cupLid;
            obj.cupLidVertices = get(obj.cupLid, 'Vertices'); 
            obj.cupLidVerticesInitial = obj.cupLidVertices;

            obj.milkJug = env.milkJug;
            obj.milkJugVertices = get(obj.milkJug, 'Vertices'); 
            obj.milkJugVerticesInitial = obj.milkJugVertices;

            obj.portafilter = env.portafilter;
            obj.portafilterVertices = get(obj.portafilter, 'Vertices');
            obj.portafilterVerticesInitial = obj.portafilterVertices;
            
            obj.teaBag = env.teaBag;
            obj.teaBagVertices = get(obj.teaBag, 'Vertices');
            obj.teaBagVerticesInitial = obj.teaBagVertices;

            obj.cupWithLid = env.cupWithLid;
            obj.cupWithLidVertices = get(obj.cupWithLid, 'Vertices');
            obj.cupWithLidVerticesInitial = obj.cupWithLidVertices;

            obj.arduinoObj = arduinoObj;  % Store the Arduino object
            
            % Creating grippers
            %obj.ur3eGripper = DualFingerGripper(); % Creating gripper for UR3e
            %obj.nova2Gripper = DualFingerGripper(); % Creating gripper for DobotNova2
            %obj.attachGripperToRobot(obj.ur3eGripper, obj.ur3e); % Attaching gripper to UR3e
            %obj.attachGripperToRobot(obj.nova2Gripper, obj.nova2); % Attaching gripper to DobotNova2
         

            view(210, 15)
        end
        
        %% Stop robots when emergency button is pressed
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
            end
        end


        %% Method to move objects attached to end-effector of robot
        function moveObjects(~, object, qCurrent, robot, vertices)
            % Compute the end-effector transformation matrix
            tr = robot.model.fkine(qCurrent); 

            objectCenter = mean(vertices);
            vertices = vertices - objectCenter;  % Shift vertices to center the object

            % Transform the object's vertices only relative to the current end-effector position
            % Use the transformation matrix 'tr' directly to compute the new vertices
            
            if size(vertices, 1) == 18834 % Translation for portafilter

                % Transform the vertices using the new end-effector pose
                transformedVertices = [vertices,ones(size(vertices,1),1)] * (tr.T * troty(pi) * trotz(pi/2) * transl(0, -0.15, -0.05))';
                % Update the object's vertices
                set(object, 'Vertices', transformedVertices(:, 1:3));

            elseif size(vertices, 1) == 24912 % Translation for lid 

                % Transform the vertices using the new end-effector pose
                transformedVertices = [vertices,ones(size(vertices,1),1)] * (tr.T  * trotx(pi) * transl(0, 0, 0))';
                % Update the object's vertices
                set(object, 'Vertices', transformedVertices(:, 1:3));

            elseif size(vertices, 1) == 29278 % Translation for cup with lid 

                % Transform the vertices using the new end-effector pose
                transformedVertices = [vertices,ones(size(vertices,1),1)] * (tr.T * trotx(-pi/2) * transl(0, -0.07, 0.05))';
                % Update the object's vertices
                set(object, 'Vertices', transformedVertices(:, 1:3));

            elseif size(vertices, 1) == 2745 % Translation for cup with lid 

                transformedVertices = [vertices,ones(size(vertices,1),1)] * (tr.T * trotx(pi/2) * troty(-pi/2) * transl(0, 0.05, 0.035))';
                % Update the object's vertices
                set(object, 'Vertices', transformedVertices(:, 1:3));

            else 

                % Transform the vertices using the new end-effector pose
                transformedVertices = [vertices,ones(size(vertices,1),1)] * (tr.T * trotx(pi/2) * troty(-pi/2) * transl(0, 0.05, 0))';
                % Update the object's vertices
                set(object, 'Vertices', transformedVertices(:, 1:3));

            end
        end
        

        %% Method to move gripper at the UR3e robot's end effector
        function attachGripperToRobot(~, gripper, robot)
            % Retrieve the current transformation of the robot's end effector
            endEffectorTr = robot.model.fkine(robot.model.getpos());
            
            % Update the gripper's base transformation to match the end effector's position
            gripper.UpdateGripperPosition(endEffectorTr);
        end
        

        %% Reset objects to initial position
        function resetObjects(obj)
            % Reset vertices to initial positions
            disp("Reseting objects to initial positions");

            cupTransformedVertices= [obj.cupVerticesInitial,ones(size(obj.cupVerticesInitial,1),1)];
            % Update the object's vertices
            set(obj.cup, 'Vertices', cupTransformedVertices(:, 1:3));
            set(obj.cup, 'Visible', 'on');

            cupLidTransformedVertices= [obj.cupLidVerticesInitial,ones(size(obj.cupLidVerticesInitial,1),1)];
            % Update the object's vertices
            set(obj.cupLid, 'Vertices', cupLidTransformedVertices(:, 1:3));
            set(obj.cupLid, 'Visible', 'on');

            milkJugTransformedVertices= [obj.milkJugVerticesInitial,ones(size(obj.milkJugVerticesInitial,1),1)];
            % Update the object's vertices
            set(obj.milkJug, 'Vertices', milkJugTransformedVertices(:, 1:3));
            

            portafilterTransformedVertices= [obj.portafilterVerticesInitial,ones(size(obj.portafilterVerticesInitial,1),1)];
            % Update the object's vertices
            set(obj.portafilter, 'Vertices', portafilterTransformedVertices(:, 1:3));

            teaBagTransformedVertices= [obj.teaBagVerticesInitial,ones(size(obj.teaBagVerticesInitial,1),1)];
            % Update the object's vertices
            set(obj.teaBag, 'Vertices', teaBagTransformedVertices(:, 1:3));
            set(obj.teaBag, 'Visible', 'on');

            cupWithLidTransformedVertices= [obj.cupWithLidVerticesInitial,ones(size(obj.cupWithLidVerticesInitial,1),1)];
            % Update the object's vertices
            set(obj.cupWithLid, 'Vertices', cupWithLidTransformedVertices(:, 1:3));
            set(obj.cupWithLid, 'Visible', 'off');
            
        end

        %% Robot's program execution
        
        % Function to handle receiving a new order
        function handleOrder(obj, hObject)
            handles = guidata(hObject);
            disp("Received a new order: " + handles.order_list(end))
            disp("Current list of orders: " + handles.order_list(:))
            obj.updateOrderListDisplay(hObject)
            

            % Only start processing orders if not already brewing
            if ~handles.isBrewing
                handles.isBrewing = true;  % Set isBrewing to true in handles
                guidata(hObject, handles); % Sync GUI data
                obj.ProcessOrders(hObject);  % Start order processing
            end
        end
        
        % Processing orders - Calls for making drinks go here
        % this function observes orders from GUI)
        function ProcessOrders(obj, hObject)
            handles = guidata(hObject);

            % while ~isempty(handles.order_list)
            while ~isempty(handles.order_list)
                order = handles.order_list(1);  % Get the first order
                disp("Brewbot is making the order for " + order);  % Execute the order

                % Process the order (espresso_test or other functions)
                switch order
                    case "Espresso"
                        obj.espressoCreate(hObject);

                    case "Flat white"
                        obj.flatwhiteCreate(hObject);

                    case "Latte"
                        obj.latteCreate(hObject);

                    case "Ice coffee"
                        obj.iceCoffeeCreate(hObject);

                    case "Tea"
                        obj.teaCreate(hObject);
                        pause(5)

                    otherwise
                        disp("Invalid item ordered")
                end
                
                handles = guidata(hObject);
                if isempty(handles.order_list)
                    break
                end

                disp("Order is complete");
                
                resetObjects(obj);

                % Remove the processed order
                handles = guidata(hObject);
                handles.order_list(1) = [];
                guidata(hObject, handles);  % Update GUI data
                obj.updateOrderListDisplay(hObject)

            end

            % Set isBrewing to false only when all orders are processed
            handles.isBrewing = false;
            guidata(hObject, handles);  % Sync GUI data
        end

        function updateOrderListDisplay(~, hObject)
            handles = guidata(hObject);

            % Display first five orders (or fewer if less than 5 orders)
            orderListText = "Orders: " + strjoin(handles.order_list(1:min(5, end)), ', ');
            set(handles.ordersTxt, 'String', orderListText);  % Assuming txt_orderList is the display text field

            guidata(hObject, handles);  % Save updates
        end
        
        %% Methods for drinks
        function espressoCreate(obj, hObject)
            % Function that creates an espresso drink.
            
            % Grab cup (Nova2 only)
            nova2Waypoints = BrewBotMovements.GrabCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);
            
            % Place cup at machine (Nova2 only)
            nova2Waypoints = BrewBotMovements.PlaceCupatMachine();
            obj.moveRobot(hObject, nova2Waypoints, obj.cup, obj.cupVertices, [], [], []);
            
            % Move to filter (Nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoFilter();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []); 
            
            %Portafilter to Grinder (Nova2 only)
            nova2Waypoints = BrewBotMovements.PipetoGrinder();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, [], [], []);
            pause(3);

            %portafilter to machine (Nova2 only)
            nova2Waypoints = BrewBotMovements.PipetoMachine();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, [], [], []);
            pause(5);

            %Return Cup move to it only (Nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoReturnCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %Return Cup (Nova2 only)
            nova2Waypoints = BrewBotMovements.ReturnCup();
            obj.moveRobot(hObject, nova2Waypoints, obj.cup, obj.cupVertices, [], [], []);

            %move to return filter (Nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoReturnPipe();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %return filter (Nova2 only)
            nova2Waypoints = BrewBotMovements.ReturnPipe();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, [], [], []);

            %Return to initial for nova2 (Nova2 only)
            nova2Waypoints = BrewBotMovements.ReturnHome();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %move to cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoLid();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %place cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.GrabLid();
            obj.moveRobot(hObject, nova2Waypoints, obj.cupLid, obj.cupLidVertices, [], [], []);

            %Nova return home + Ur3 move to cup
            nova2Waypoints = BrewBotMovements.ReturnNova2();
            ur3eWaypoints =  BrewBotMovements.MovetoFinishedCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);
            
            set(obj.cup, 'Visible', 'off');
            set(obj.cupLid, 'Visible', 'off');
            set(obj.cupWithLid, 'Visible', 'on');
            %UR3e pick up cup (Ur3e only)
            ur3eWaypoints =  BrewBotMovements.PickUpFinishedCup();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.cupWithLid, obj.cupWithLidVertices); %it should be cup with lid
            
            
            %UR3e return (UR3e only)
            ur3eWaypoints =  BrewBotMovements.ReturnUR3e();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, [], []); %it should be cup with lid\
            pause(3);
            set(obj.cupWithLid, 'Visible', 'off');

        end

        function latteCreate(obj, hObject)
            % Function that creates a latte drink.

            % Grab cup + Move to milk jub movement
            nova2Waypoints = BrewBotMovements.GrabCup();
            ur3eWaypoints = BrewBotMovements.MovetoJug();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);
            
            % Place cup at machine + Grab Jug
            nova2Waypoints = BrewBotMovements.PlaceCupatMachine();
            ur3eWaypoints = BrewBotMovements.GrabJug();
            obj.moveRobot(hObject, nova2Waypoints, obj.cup, obj.cupVertices, ur3eWaypoints, obj.milkJug, obj.milkJugVertices);
            pause(5);

            % Move to filter + Put Jug Below Frother
            nova2Waypoints = BrewBotMovements.MovetoFilter();
            ur3eWaypoints = BrewBotMovements.PutJugBelowFrother();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, obj.milkJug, obj.milkJugVertices); 
            
            %Portafilter to Grinder + Froth Milk
            nova2Waypoints = BrewBotMovements.PipetoGrinder();
            ur3eWaypoints = BrewBotMovements.FrothMilk();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, ur3eWaypoints, obj.milkJug, obj.milkJugVertices);
            pause(3);

            %portafilter to machine + Finish Frothing
            nova2Waypoints = BrewBotMovements.PipetoMachine();
            ur3eWaypoints =  BrewBotMovements.FinishFrothing();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, ur3eWaypoints, obj.milkJug, obj.milkJugVertices);
            pause(5);

            %Return Cup move to it only (Nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoReturnCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %Return Cup (Nova2 only)
            nova2Waypoints = BrewBotMovements.ReturnCup();
            obj.moveRobot(hObject, nova2Waypoints, obj.cup, obj.cupVertices, [], [], []);

            %move to return filter + pour milk
            nova2Waypoints = BrewBotMovements.MovetoReturnPipe();
            ur3eWaypoints =  BrewBotMovements.PickUpJug();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, obj.milkJug, obj.milkJugVertices);

            %return filter + place milk jug back
            nova2Waypoints = BrewBotMovements.ReturnPipe();
            ur3eWaypoints =  BrewBotMovements.PlaceJugBack();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, ur3eWaypoints, obj.milkJug, obj.milkJugVertices);

            %Return to initial for nova2 and ur3e
            nova2Waypoints = BrewBotMovements.ReturnHome();
            ur3eWaypoints =  BrewBotMovements.ReturnBackafterPouring();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);

            %move to cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoLid();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %place cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.GrabLid();
            obj.moveRobot(hObject, nova2Waypoints, obj.cupLid, obj.cupLidVertices, [], [], []);

            %Nova return home + Ur3 move to cup
            nova2Waypoints = BrewBotMovements.ReturnNova2();
            ur3eWaypoints =  BrewBotMovements.MovetoFinishedCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);
           

            set(obj.cup, 'Visible', 'off');
            set(obj.cupLid, 'Visible', 'off');
            set(obj.cupWithLid, 'Visible', 'on');
            %UR3e pick up cup (Ur3e only)
            ur3eWaypoints =  BrewBotMovements.PickUpFinishedCup();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.cupWithLid, obj.cupWithLidVertices); %it should be cup with lid
            
            
            %UR3e return (UR3e only)
            ur3eWaypoints =  BrewBotMovements.ReturnUR3e();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, [], []); %it should be cup with lid

            pause(3);
            set(obj.cupWithLid, 'Visible', 'off');
        end

        function iceCoffeeCreate(obj, hObject)
            % Function that creates an ice coffee drink.

            % Grab cup + Move to milk jub movement
            nova2Waypoints = BrewBotMovements.GrabCup();
            ur3eWaypoints = BrewBotMovements.MovetoJug();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);

            
            % Place cup at machine + Grab Jug
            nova2Waypoints = BrewBotMovements.PlaceCupatMachine();
            ur3eWaypoints = BrewBotMovements.GrabJug();
            obj.moveRobot(hObject, nova2Waypoints, obj.cup, obj.cupVertices, ur3eWaypoints, obj.milkJug, obj.milkJugVertices);
            pause(5);
            
            % Move to filter + Put Jug Below Frother
            nova2Waypoints = BrewBotMovements.MovetoFilter();
            ur3eWaypoints = BrewBotMovements.PutJugBelowFrother();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, obj.milkJug, obj.milkJugVertices);

            %Portafilter to Grinder (Nova2 only)
            nova2Waypoints = BrewBotMovements.PipetoGrinder();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, [], [], []);
            pause(3);

            %portafilter to machine (Nova2 only)
            nova2Waypoints = BrewBotMovements.PipetoMachine();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, [], [], []);
            pause(5);

            %Return Cup move to it only (Nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoReturnCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %Return Cup (Nova2 only)
            nova2Waypoints = BrewBotMovements.ReturnCup();
            obj.moveRobot(hObject, nova2Waypoints, obj.cup, obj.cupVertices, [], [], []);

            %Move to return filter (Nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoReturnPipe();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %Return filter + Move to cup to add ice
            nova2Waypoints = BrewBotMovements.ReturnPipe();
            ur3eWaypoints = BrewBotMovements.MovetoCup();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, ur3eWaypoints, [], []);

            %Nova2 Return + add ice to cup (UR3e only)
            nova2Waypoints = BrewBotMovements.ReturnHome();
            ur3eWaypoints = BrewBotMovements.GetIce();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, obj.cup, obj.cupVertices);

            pause(3);

            %Return cup with ice (UR3e only)
            ur3eWaypoints = BrewBotMovements.ReturnCupWithIce();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.cup, obj.cupVertices);

            %Go back to jug to start pouring (UR3e only)
            ur3eWaypoints = BrewBotMovements.MovetoJugAfterIce();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, [], []);

            %pick up jug start pouring (UR3e only)
            ur3eWaypoints = BrewBotMovements.PickUpJug();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.milkJug, obj.milkJugVertices);

            pause(3);

            %place jug back after pouring (UR3e only)
            ur3eWaypoints = BrewBotMovements.PlaceJugBack();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.milkJug, obj.milkJugVertices);

            %Go to initial after pouring
            ur3eWaypoints = BrewBotMovements.ReturnBackafterPouring();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, [], []);

            %move to cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoLid();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %place cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.GrabLid();
            obj.moveRobot(hObject, nova2Waypoints, obj.cupLid, obj.cupLidVertices, [], [], []);

            %Nova return home + Ur3 move to cup
            nova2Waypoints = BrewBotMovements.ReturnNova2();
            ur3eWaypoints =  BrewBotMovements.MovetoFinishedCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);
            
            set(obj.cup, 'Visible', 'off');
            set(obj.cupLid, 'Visible', 'off');
            set(obj.cupWithLid, 'Visible', 'on');
            %UR3e pick up cup (Ur3e only)
            ur3eWaypoints =  BrewBotMovements.PickUpFinishedCup();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.cupWithLid, obj.cupWithLidVertices); %it should be cup with lid

            %UR3e return (UR3e only)
            ur3eWaypoints =  BrewBotMovements.ReturnUR3e();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, [], []); %it should be cup with lid
                        
            pause(3);
            set(obj.cupWithLid, 'Visible', 'off');
        end

        function flatwhiteCreate (obj, hObject)
             % Grab cup + Move to milk jug movement
            nova2Waypoints = BrewBotMovements.GrabCup();
            ur3eWaypoints = BrewBotMovements.MovetoJug();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);
            
            % Place cup at machine + Grab Jug
            nova2Waypoints = BrewBotMovements.PlaceCupatMachine();
            ur3eWaypoints = BrewBotMovements.GrabJug();
            obj.moveRobot(hObject, nova2Waypoints, obj.cup, obj.cupVertices, ur3eWaypoints, obj.milkJug, obj.milkJugVertices);
            pause(3);

            % Move to filter + Put Jug Below Frother
            nova2Waypoints = BrewBotMovements.MovetoFilter();
            ur3eWaypoints = BrewBotMovements.PutJugBelowFrother();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, obj.milkJug, obj.milkJugVertices); 

            %Portafilter to Grinder + Froth Milk
            nova2Waypoints = BrewBotMovements.PipetoGrinder();
            ur3eWaypoints = BrewBotMovements.FrothMilk();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, ur3eWaypoints, obj.milkJug, obj.milkJugVertices);
    
            %portafilter to machine + Finish Frothing
            nova2Waypoints = BrewBotMovements.PipetoMachine();
            ur3eWaypoints =  BrewBotMovements.FinishFrothing();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, ur3eWaypoints, obj.milkJug, obj.milkJugVertices);
            pause(5);

            %Return Cup move to it only (Nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoReturnCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %Return Cup (Nova2 only)
            nova2Waypoints = BrewBotMovements.ReturnCup();
            obj.moveRobot(hObject, nova2Waypoints, obj.cup, obj.cupVertices, [], [], []);

            %move to return filter + pour milk
            nova2Waypoints = BrewBotMovements.MovetoReturnPipe();
            ur3eWaypoints =  BrewBotMovements.PickUpJug();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, obj.milkJug, obj.milkJugVertices);

            %return filter + place milk jug back
            nova2Waypoints = BrewBotMovements.ReturnPipe();
            ur3eWaypoints =  BrewBotMovements.PlaceJugBack();
            obj.moveRobot(hObject, nova2Waypoints, obj.portafilter, obj.portafilterVertices, ur3eWaypoints, obj.milkJug, obj.milkJugVertices);

            %Return to initial for nova2 and ur3e
            nova2Waypoints = BrewBotMovements.ReturnHome();
            ur3eWaypoints =  BrewBotMovements.ReturnBackafterPouring();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);

            %move to cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoLid();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %place cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.GrabLid();
            obj.moveRobot(hObject, nova2Waypoints, obj.cupLid, obj.cupLidVertices, [], [], []);

            %Nova return home + Ur3 move to cup
            nova2Waypoints = BrewBotMovements.ReturnNova2();
            ur3eWaypoints =  BrewBotMovements.MovetoFinishedCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);

            set(obj.cup, 'Visible', 'off');
            set(obj.cupLid, 'Visible', 'off');
            set(obj.cupWithLid, 'Visible', 'on');
            %UR3e pick up cup (Ur3e only)
            ur3eWaypoints =  BrewBotMovements.PickUpFinishedCup();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.cupWithLid, obj.cupWithLidVertices); %it should be cup with lid

            %UR3e return (UR3e only)
            ur3eWaypoints =  BrewBotMovements.ReturnUR3e();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, [], []); %it should be cup with lid
            
            pause(3);
            set(obj.cupWithLid, 'Visible', 'off');
        end

        function teaCreate(obj, hObject)
            % Function that creates a tea drink.
            %Go to cup (Nova2 only)
            nova2Waypoints = BrewBotMovements.gotoCupforTea();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %Move cup (Nova2 only)
            nova2Waypoints = BrewBotMovements.moveCupforTea();
            obj.moveRobot(hObject, nova2Waypoints, obj.cup, obj.cupVertices, [], [], []);

            %Nova go back + UR3e move to tea bag
            nova2Waypoints = BrewBotMovements.gobackafterTea();
            ur3eWaypoints =  BrewBotMovements.movetoTeaBag();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);

            %Put tea bag in cup (UR3e only)
            ur3eWaypoints =  BrewBotMovements.putTeaBag();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.teaBag, obj.teaBagVertices);
            set(obj.teaBag, 'Visible', 'off');
            
            %move to grab cup for water (UR3e only)
            ur3eWaypoints =  BrewBotMovements.otwGrabCup;
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, [], []);

            %Grab cup for water (UR3e only)
            ur3eWaypoints =  BrewBotMovements.AddHotWater;
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.cup, obj.cupVertices);


            %Return cup with hot water (UR3e only)
            ur3eWaypoints =  BrewBotMovements.ReturnHotWaterCup;
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.cup, obj.cupVertices);

            %Return ur3e back (UR3e only)
            ur3eWaypoints =  BrewBotMovements.ReturnBotBack;
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, [], []);

            %move to cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.MovetoLid();
            obj.moveRobot(hObject, nova2Waypoints, [], [], [], [], []);

            %place cup lid (nova2 only)
            nova2Waypoints = BrewBotMovements.GrabLid();
            obj.moveRobot(hObject, nova2Waypoints, obj.cupLid, obj.cupLidVertices, [], [], []);

            %Nova return home + Ur3 move to cup
            nova2Waypoints = BrewBotMovements.ReturnNova2();
            ur3eWaypoints =  BrewBotMovements.MovetoFinishedCup();
            obj.moveRobot(hObject, nova2Waypoints, [], [], ur3eWaypoints, [], []);

            set(obj.cup, 'Visible', 'off');
            set(obj.cupLid, 'Visible', 'off');
            set(obj.cupWithLid, 'Visible', 'on');
            %UR3e pick up cup (Ur3e only)
            ur3eWaypoints =  BrewBotMovements.PickUpFinishedCup();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, obj.cupWithLid, obj.cupWithLidVertices); %it should be cup with lid

            %UR3e return (UR3e only)
            ur3eWaypoints =  BrewBotMovements.ReturnUR3e();
            obj.moveRobot(hObject, [], [], [], ur3eWaypoints, [], []); %it should be cup with lid
            
            pause(3);
            set(obj.cupWithLid, 'Visible', 'off');
        end


        %% Helper function to move robot to desired location specified by qMatrix
        % Checks if e-stop was initiated and does not move robot if triggered
        function moveRobot(obj, hObject, nova2Waypoints, nova2MovedObject, nova2Vertices, ur3eWaypoints, ur3eMovedObject, ur3eVertices)
            if ~isempty(nova2Waypoints)
                nova2QMatrix = InterpolateWaypointRadians(nova2Waypoints, deg2rad(3));
            else 
                nova2QMatrix = [];
            end 
            if ~isempty(ur3eWaypoints)
                ur3eQMatrix = InterpolateWaypointRadians(ur3eWaypoints, deg2rad(5));
            else 
                ur3eQMatrix = [];
            end

            % Ensure both robots move for the same number of steps
            steps = max(size(nova2QMatrix, 1), size(ur3eQMatrix, 1)); % make a function
            
            % Loop through and move both robots simultaneously
            for i = 1:steps
                % Check for emergency stop
                if checkEmergencyStop(obj, hObject)
                    return;
                end
                
                if ~isempty(nova2Waypoints)
                    % Move DobotNova2 (robot1)
                    if i <= size(nova2QMatrix, 1)
    
                        if ~isempty(nova2MovedObject)
                            obj.moveObjects(nova2MovedObject, nova2QMatrix(i, :), obj.nova2, nova2Vertices);
                        end
    
                        %obj.attachGripperToRobot(obj.nova2Gripper, obj.nova2);
                        obj.nova2.model.animate(nova2QMatrix(i, :));  % Animate DobotNova2
                    else
                        obj.nova2.model.animate(nova2QMatrix(end, :));  % Hold last position
                    end
                end 

                if ~isempty(ur3eWaypoints)
                    % Move UR3e (robot2)
                    if i <= size(ur3eQMatrix, 1)
                    
                        
                        %obj.attachGripperToRobot(obj.ur3eGripper, obj.ur3e);
                        
                        if ~isempty(ur3eMovedObject) 
                            obj.moveObjects(ur3eMovedObject, ur3eQMatrix(i, :), obj.ur3e, ur3eVertices);
                        end
                         
                        obj.ur3e.model.animate(ur3eQMatrix(i, :));  % Animate UR3e
                    else
                        obj.ur3e.model.animate(ur3eQMatrix(end, :));  % Hold last position
                    end
                end

                    drawnow();
                    % Pause briefly to simulate real-time animation
                    pause(0.001);
            end
        end


        %% Function to move both nova2 and ur3e to their default position
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

            resetObjects(obj);
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
