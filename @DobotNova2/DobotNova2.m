classdef DobotNova2 < RobotBaseClass
    %% LinearUR3: UR3 on a non-standard linear rail

    properties(Access = public)              
        plyFileNameStem = 'DobotNova2';  % Name stem for the robot's PLY file
    end

    methods
        %% Define robot function (Constructor)
        function self = DobotNova2(baseTr)
            % Call to create the robot model
            self.CreateModel();
            
            % If no base transform is provided, use the identity matrix
            if nargin < 1
				baseTr = eye(4);  % Identity matrix as default base transformation
            end
            
            % Set the base transformation of the robot
            self.model.base = self.model.base.T * baseTr * trotx(pi/2) * troty(pi/2);

            % Plot the robot with its defined color scheme
            self.PlotAndColourRobot();
        end
        
        %% Create the robot model (Kinematic chain)
        function CreateModel(self)
            link(1) = Link('d',0.2234,'a', 0,'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
            link(2) = Link('d',0.1175,'a',0.280,'alpha',0,'qlim', deg2rad([0 180]), 'offset',0);
            link(3) = Link('d',-0.1175,'a',0.225,'alpha',0,'qlim', deg2rad([-360 360]), 'offset', 0);
            link(4) = Link('d',0.1175,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            link(5) = Link('d',0.120,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
            link(6) = Link('d',	0.088,'a',0,'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);
            
            % Create the serial link model for the UR3 on a linear rail
            self.model = SerialLink(link, 'name', self.name);  % Create SerialLink robot model
        end
    end
end
