classdef DualFingerGripper < handle
    properties
        finger1;  % First finger
        finger2;  % Second finger
        baseTr;   % Base transformation for the gripper
    end
    
    methods
        %% Constructor
        function self = DualFingerGripper(baseTr)
            if nargin < 1
                baseTr = eye(4);  % Default base transformation (identity matrix)
            end
            
            % Store the base transformation and spacing
            self.baseTr = baseTr;
            
            % Create two finger instances
            % Position the first finger
            disp('Adding Gripper object #1 to the end effector');
            self.finger1 = GripperFinger(self.baseTr * trotz(pi) * trotx(pi/2));  % First finger
           
            % Position the second finger
            disp('Adding Gripper object #2 to the end effector');
            self.finger2 = GripperFinger(self.baseTr * trotx(pi/2));  % Second finger

            
            % Plot the gripper (two fingers)
            self.PlotGripper();
        end
        
        %% Plot the two fingers of the gripper
        function PlotGripper(self)
            self.finger1.PlotAndColourRobot();
            self.finger2.PlotAndColourRobot();
        end

        %% Method to update gripper base based on the robot's end-effector transformation
        function UpdateGripperPosition(self, endEffectorTr)
            % Update the gripper's base transformation based on the end effector's pose
            self.baseTr = endEffectorTr.T;
            
            % Update each finger's base transformation accordingly
            self.finger1.model.base = self.baseTr * trotz(pi) * trotx(pi/2);
            self.finger2.model.base = self.baseTr * trotx(pi/2);
            
            % Update the plot for both fingers
            self.finger1.model.plot(self.finger1.model.getpos());
            self.finger2.model.plot(self.finger2.model.getpos());
        end
        
        %% Open gripper 
        function OpenGripper(self)
            % Adjust the angles of both fingers to simulate opening/closing
            steps = 50;

            gripperOpen = zeros(1, 3);
            gripperClose = [-0.2513, 0.6912, -0.4398];
            qmato = jtraj(gripperClose, gripperOpen, steps);

            for i = 1:steps
                % Animate the fingers to the given angles
                
                self.finger1.model.animate(qmato(i, :));
                self.finger2.model.animate(qmato(i, :));

                pause(0.01);
            end
        end
        
        %% Close gripper
        function CloseGripper(self)
            % Adjust the angles of both fingers to simulate opening/closing
            steps = 50;

            gripperOpen = zeros(1, 3);
            gripperClose = [-0.2513, 0.6912, -0.4398];
            qmatc = jtraj(gripperClose, gripperOpen, steps);

            for i = 1:steps
                % Animate the fingers to the given angles
                
                self.finger1.model.animate(qmatc(i, :));
                self.finger2.model.animate(qmatc(i, :));

                pause(0.01);
            end
        end
        %% Reset the gripper to a neutral position
        function ResetGripper(self)
            self.CloseGripper();  % Reset to the closed position
        end
    end
end
