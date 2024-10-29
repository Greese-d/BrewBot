classdef EnvSetup
    properties
        % Define properties for each environment object
        nova2;
        ur3e;
        cup;
        cupLid;
        milkJug;
        portafilter;
        teaBag
        cupWithLid;
        
        % Axes and view settings
        axisLimits;
        viewAngles;
    end
    
    methods
        function obj = EnvSetup()
            % Constructor method that sets up the environment
            obj = obj.setupEnvironment();
        end
        
        function obj = setupEnvironment(obj)
            % This function sets up the environment, replacing the old EnvSetup function
            
            hold on;  % Hold the current plot for multiple objects
            axis equal;  % Maintain equal scaling for all axes
            obj.axisLimits = [-1.8 1.8 -1.8 1.8 -0.1 1.5];
            axis(obj.axisLimits);  % Set the axis limits
            obj.viewAngles = [210, 15];
            view(obj.viewAngles);
            
            %% Initial coordinates to move the environment along 3 axes
            x = 0.2;
            y = 0;
            z = 0;
            
            %% Placing environment images (optional)
            % Add images as needed here
            
            surf([-2,-2;2,2],[-2,2;-2,2],[0,0;0,0],'CData',imread('FloorImage.jpg'),'FaceColor','texturemap');
            
            %% Non-movable objects setup
            espressoMachine = PlaceObject('EspressoMachine.ply', [x+0.25, y-0.5, z+0.65]);
            grinder = PlaceObject('Grinder.ply', [x+0.8, y-0.2, z+0.65]);
            iceCubeDispenser = PlaceObject('IceCubeDispenser.ply', [x-0.65, y-0.55, z+0.65]);
            milkDispenser = PlaceObject('MilkDispenser.ply', [x-0.3, y-0.25, z+0.66]);
            table = PlaceObject('Table.ply', [x+0, y+0, z+0.4]);
            teaBox = PlaceObject('TeaBox.ply', [x-0.27, y+0.45, z+0.6]);
            fireExtinguisher = PlaceObject('TeaBox.ply', [x-0.27, y+0.45, z+0.6]);
            emergencyButton = PlaceObject('TeaBox.ply', [x-0.27, y+0.45, z+0.6]);

            
            %% Adding DobotNova2 and UR3e robots to the environment
            disp('Adding DobotNova2 robot to the environment');
            obj.nova2 = DobotNova2(transl(x+0.6, y+0.3, z+0.6));
            
            disp('Adding UR3e robot to the environment');
            obj.ur3e = UR3e(transl(x-0.6, y+0.3, z+0.6));
            
            %% Create new instances of movable objects
            obj.cup = PlaceObject('Cup.ply', [x+0.15, y+0.2, z+0.65]);
            obj.cupLid = PlaceObject('CupLid.ply', [x+0.1, y+0.3, z+0.65]);
            obj.milkJug = PlaceObject('MilkJug.ply', [x-0.05, y+0.25, z+0.65]);
            obj.portafilter = PlaceObject('EspressoHandle.ply', [x+0.05, y+0.4, z+0.7]);
            obj.teaBag = PlaceObject('TeaBag.ply', [x-0.34, y+0.35, z+0.6]);
            obj.cupWithLid = PlaceObject('CupWithLid.ply', [x, y+0.35, z+0.65]);
            

            set(obj.cupWithLid, 'Visible', 'off');
        end 
    end
end
