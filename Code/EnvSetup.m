classdef EnvSetup
    properties
        nova2;
        ur3e;
        cup;
        cupLid;
        milkJug;
        portafilter;
        teaBag;
        cupWithLid;
        boundingBoxes; % Bounding boxes for collision detection
    end
    
    methods
        function obj = EnvSetup()

            % Setup the environment with objects and bounding boxes
            
            hold on;
            axis equal;
            axis([-1.8 2.1 -1.8 1.8 -0.1 1.5]);
            view([210, 15]);
           
            
            % Place static objects
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

            fireExtinguisher = PlaceObject('fireExtinguisher.ply', [x+0.55, y+0.7, z+0.02]);
            verts = [get(fireExtinguisher,'Vertices'), ones(size(get(fireExtinguisher,'Vertices'),1),1)] * (trotz(pi/2))';
            set(fireExtinguisher,'Vertices',verts(:,1:3));  % Update button vertices after rotation

            emergencyButton = PlaceObject('emergencyStopWallMounted.ply', [x+0.53, y-1.2, z+1.1]);
            verts = [get(emergencyButton,'Vertices'), ones(size(get(emergencyButton,'Vertices'),1),1)] * (trotz(pi/2))';
            set(emergencyButton,'Vertices',verts(:,1:3));  % Update button vertices after rotation

            safetyFence = PlaceObject('barrier1.5x0.2x1m.ply', [x, y-1.85, z]);
            verts = [get(safetyFence,'Vertices'), ones(size(get(safetyFence,'Vertices'),1),1)] * (trotz(pi/2))';
            set(safetyFence,'Vertices',verts(:,1:3));  % Update button vertices after rotation

            %% Can be commented to remove the booth from environment for better view
            coffeeBooth = PlaceObject('CoffeeBooth.ply', [x-1.3, y-0.6, z+0]); % add coffee booth model
            
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

            % Comment out this line if bounding boxes are not needed
            obj = obj.setupBoundingBoxes();
        end

        function obj = setupBoundingBoxes(obj)
            % Define bounding boxes for collision detection
            boundingBoxMin1 = [-0.7, -0.55, 0.65];
            boundingBoxMax1 = [-0.2, -0.2, 1.15];
            boundingBoxMin2 = [0.05, -0.5, 0.65];
            boundingBoxMax2 = [0.85, -0.2, 1.25];
            boundingBoxMin3 = [0.9, -0.3, 0.65];
            boundingBoxMax3 = [1.1, -0.2, 1.15];
            boundingBoxMin4 = [1.25, 0.25, 0];
            dimensions = [0.05, 0.6, 1.0];  % 10x60x100 cm in meters
            boundingBoxMax4 = boundingBoxMin4 + dimensions;
            obj.boundingBoxes = {boundingBoxMin1, boundingBoxMax1; boundingBoxMin2, boundingBoxMax2; 
                boundingBoxMin3, boundingBoxMax3; boundingBoxMin4,boundingBoxMax4};

            % Plot each bounding box
            for i = 1:size(obj.boundingBoxes, 1)
                obj.plotBoundingBox(obj.boundingBoxes{i, 1}, obj.boundingBoxes{i, 2});
            end
        end

        function plotBoundingBox(~, boxMin, boxMax)
            % Plot a 3D bounding box given minimum and maximum coordinates
            vertices = [
                boxMin;                            % Vertex 1
                boxMin(1), boxMax(2), boxMin(3);   % Vertex 2
                boxMax(1), boxMax(2), boxMin(3);   % Vertex 3
                boxMax(1), boxMin(2), boxMin(3);   % Vertex 4
                boxMin(1), boxMin(2), boxMax(3);   % Vertex 5
                boxMin(1), boxMax(2), boxMax(3);   % Vertex 6
                boxMax(1), boxMax(2), boxMax(3);   % Vertex 7
                boxMax(1), boxMin(2), boxMax(3)    % Vertex 8
            ];
            
            % Define faces of the box
            faces = [
                1, 2, 3, 4;  % Bottom face
                5, 6, 7, 8;  % Top face
                1, 2, 6, 5;  % Side face
                2, 3, 7, 6;  % Side face
                3, 4, 8, 7;  % Side face
                4, 1, 5, 8   % Side face
            ];
            
            % Plot the box with transparency
            patch('Vertices', vertices, 'Faces', faces, ...
                  'FaceColor', 'cyan', 'FaceAlpha', 0.1, 'EdgeColor', 'blue');
        end
    end
end
