function [nova2, ur3e, cup, cupLid, milkJug, iceCube, portafilter] = EnvSetup
    hold on;  % Hold the current plot for multiple objects
    axis equal;  % Maintain equal scaling for all axes
    axis([-1.8 1.8 -1.8 1.8 -0.1 1.5]);  % Set the axis limits
    
    %% Placing environment images
    surf([-2,-2;2,2],[-2,2;-2,2],[0,0;0,0],'CData',imread('FloorImage.jpg'),'FaceColor','texturemap');
    
  
    %% Movable objects
    cup = PlaceObject('Cup.ply', [-0.1, 0.3, 0.65]); % add coffee cup model
    cupLid = PlaceObject('CupLid.ply', [0.1, 0.3, 0.65]); % add coffee lid model
    
    % cupWithLid = PlaceObject('CupWithLid.ply', [-0.1, 0.15, 0.65]); % add cup with lid model
    milkJug = PlaceObject('MilkJug.ply', [0.1, 0.15, 0.65]); % add milk jug model
    
    iceCube = PlaceObject('IceCube.ply', [0, 0.5, 0]); % add ice cube model
    portafilter = PlaceObject('EspressoHandle.ply', [0, 0.4, 0.7]); % add portafilter model (coffee handle)


    %% Non-movable objects
    espressoMachine = PlaceObject('EspressoMachine.ply', [0.35, -0.5, 0.65]); % add espresso machine model
    grinder = PlaceObject('Grinder.ply', [0.9, -0.2, 0.65]); % add coffee grinder model
    iceCubeDispenser = PlaceObject('IceCubeDispenser.ply', [-0.75, -0.5, 0.65]); % add ice cube dispenser model
    table = PlaceObject('Table.ply', [0, 0, 0.4]); % add table
    coffeeBooth = PlaceObject('CoffeeBooth.ply', [-1.35,-0.6,0]); % add coffee booth model

    %% Adding DobotNova2 and UR3e robots to the environment 
    disp('Adding DobotNova2 robot to the environment');
    nova2 = DobotNova2(transl(0.65, 0.3, 0.6));  % Create DobotNova2 robot with initial transform
    ur3e = UR3e(transl(-0.65, 0.3, 0.6)); % Create LinearUR3 robot with initial transform
end

