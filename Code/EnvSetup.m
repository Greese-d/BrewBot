function [nova2, ur3e, cup, cupLid, milkJug, iceCube, portafilter] = EnvSetup
    hold on;  % Hold the current plot for multiple objects
    axis equal;  % Maintain equal scaling for all axes
    axis([-1.8 1.8 -1.8 1.8 -0.1 1.5]);  % Set the axis limits
    view(210, 20)
    
    %% Initial coordinates to move the environemnt along 3 axis
    x = 0.2;
    y = 0;
    z = 0;
    
    %% Placing environment images
    %imageData = imread('WallPicture1.jpg');
    %wallImage1 = imrotate(imageData, -90);
    %imageData = imread('WallPicture2.jpg');
    %wallImage2 = imrotate(imageData, -90);
    %surf([-1.8,-1.8;1.8,1.8],[1.8,1.8;1.8,1.8],[0,2;0,2],'CData',wallImage1,'FaceColor','texturemap');
    %surf([1.8,1.8;1.8,1.8],[-1.8,-1.8;1.8,1.8],[0,2;0,2],'CData',wallImage2,'FaceColor','texturemap');
    
    surf([-2,-2;2,2],[-2,2;-2,2],[0,0;0,0],'CData',imread('FloorImage.jpg'),'FaceColor','texturemap');
    
    
    %% Non-movable objects
    espressoMachine = PlaceObject('EspressoMachine.ply', [x+0.25, y-0.5, z+0.65]); % add espresso machine model
    grinder = PlaceObject('Grinder.ply', [x+0.8, y-0.2, z+0.65]); % add coffee grinder model
    iceCubeDispenser = PlaceObject('IceCubeDispenser.ply', [x-0.65, y-0.55, z+0.65]); % add ice cube dispenser model
    milkDispenser = PlaceObject('MilkDispenser.ply', [x-0.3, y-0.25, z+0.66]); % add milk dispenser model
    table = PlaceObject('Table.ply', [x+0, y+0, z+0.4]); % add table
    
    % Can be commented to remove the booth from environment for better view
    coffeeBooth = PlaceObject('CoffeeBooth.ply', [x-1.3, y-0.6, z+0]); % add coffee booth model
    
    
    %% Movable objects
    cup = PlaceObject('Cup.ply', [x-0.1, y+0.3, z+0.65]); % add coffee cup model
    cupLid = PlaceObject('CupLid.ply', [x+0.1, y+0.3, z+0.65]); % add coffee lid model
    
    % cupWithLid = PlaceObject('CupWithLid.ply', [x-0.1, y+0.15, z+0.65]); % add cup with lid model
    milkJug = PlaceObject('MilkJug.ply', [x+0.1, y+0.15, z+0.65]); % add milk jug model
    
    iceCube = PlaceObject('IceCube.ply', [x+0, y+0.5, z+0]); % add ice cube model
    portafilter = PlaceObject('EspressoHandle.ply', [x+0, y+0.4, z+0.7]); % add portafilter model (coffee handle)
    
    
    %% Adding DobotNova2 robot to the environment 
    disp('Adding DobotNova2 robot to the environment');
    nova2 = DobotNova2(transl(x+0.6, y+0.3, z+0.6));  % Create Nova2 robot with initial transform
    
    disp('Adding UR3e robot to the environment');
    ur3e = UR3e(transl(x-0.6, y+0.3, z+0.6));   % Create UR3e robot with intial transform
end

