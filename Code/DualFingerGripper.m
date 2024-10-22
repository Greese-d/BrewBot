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
            self.finger1 = GripperFinger(baseTr);  % First finger
            % Position the first finger at the negative offset
            disp('Adding Gripper object #1 to the end effector');
            self.finger1.model.base = self.baseTr * trotz(pi) * trotx(pi/2);
            
            self.finger2 = GripperFinger(baseTr);  % Second finger
            % Position the first finger at the negative offset
            disp('Adding Gripper object #2 to the end effector');
            self.finger2.model.base = self.baseTr * trotx(pi/2);
            

            
            % Plot the gripper (two fingers)
            self.PlotGripper();
        end
        
        %% Plot the two fingers of the gripper
        function PlotGripper(self)
            self.finger1.PlotAndColourRobot();
            self.finger2.PlotAndColourRobot();
        end

        %% Animate the gripper opening or closing
        function AnimateGripper(self)
            % Adjust the angles of both fingers to simulate opening/closing
            % openingAngle is the angle by which each finger rotates
            steps = 50;

            gripperOpen = zeros(1,3);
            gripperClose = [-0.2513    0.6912   -0.4398];
            qmatc = jtraj(gripperOpen, gripperClose, steps);
            qmato = jtraj(gripperClose, gripperOpen, steps);
            

            for i = 1:steps
                % Animate the fingers to the given angles
                pause(0.01);
                self.finger1.model.animate(qmatc);
                self.finger2.model.animate(qmato);
            end
        end
        
        
        %% Reset the gripper to a neutral position
        function ResetGripper(self)
            % Reset both fingers to the neutral (closed) position
            self.AnimateGripper(0);  % 0 degrees means closed
        end
    end
end