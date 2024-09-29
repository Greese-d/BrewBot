classdef DobotNova2 < RobotBaseClass
    %% LinearUR3: UR3 on a non-standard linear rail

    properties(Access = public)              
        plyFileNameStem = 'DobotNova2';  % Name stem for the robot's PLY file
    end

    methods
        %% Define robot function (Constructor)
        function self = DobotNova2(baseTr)
            if nargin < 3
                if nargin == 2
                    error('If you set useTool you must pass in the toolFilename as well');
                elseif nargin == 0 % Nothing passed
                    baseTr = transl(0,0,0);  
                end             
            else % All passed in 
                self.useTool = useTool;
                toolTrData = load([toolFilename,'.mat']);
                self.toolTr = toolTrData.tool;
                self.toolFilename = [toolFilename,'.ply'];
            end
          
            self.CreateModel();
			self.model.base = self.model.base.T * baseTr;
            self.model.tool = self.toolTr;
            self.PlotAndColourRobot();

            drawnow
        end
        
        %% Create the robot model (Kinematic chain)
        function CreateModel(self)
            link(1) = Link('d',0.2234,'a', 0,'alpha',-pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
            link(2) = Link('d',0,'a',-0.280,'alpha',0,'qlim', deg2rad([-360 360]), 'offset',0);
            link(3) = Link('d',0,'a',-0.225,'alpha',0,'qlim', deg2rad([-360 360]), 'offset', 0);
            link(4) = Link('d',0.1175,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            link(5) = Link('d',0.12,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
            link(6) = Link('d',	0.088,'a',0,'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);
            
            % Create the serial link model for the UR3 on a linear rail
            self.model = SerialLink(link, 'name', self.name);  % Create SerialLink robot model
        end
    end
end
