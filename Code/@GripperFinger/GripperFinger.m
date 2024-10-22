classdef GripperFinger < RobotBaseClass
    %% RobotiQ 2f-140-gripper
    properties (Access = public)
        plyFileNameStem = 'GripperFinger';  % Name stem for the robot's PLY file
    end

    methods
        %% Define robot function (Constructor)
        function self = GripperFinger(baseTr)
            % Constructor for the Gripper class
            
            % Create the robot model
            self.CreateModel();
            
            if nargin < 1
                baseTr = eye(4);  % Default base transformation (identity matrix)
            end
            
            % Set the base transformation of the gripper model
            self.model.base = baseTr;
            
            % Plot the gripper with a defined color scheme
            self.PlotAndColourRobot();
        end
        
        %% Create the robot model (Kinematic chain)
        function CreateModel(self)
            link(1) = Link('d', 0, 'a', 0.05, 'alpha', 0, 'qlim', deg2rad([-90 90]), 'offset', -deg2rad(16));
            link(2) = Link('d', 0, 'a', 0.045, 'alpha', 0, 'qlim', deg2rad([-90 90]), 'offset', deg2rad(58));
            link(3) = Link('d', 0, 'a', 0.045, 'alpha', 0, 'qlim', deg2rad([-90 90]), 'offset', deg2rad(48));

            % Create the serial link model for the gripper using the 3 revolute joints defined above
            self.model = SerialLink(link, 'name', self.name);
        end
    end
end
