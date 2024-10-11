function [nova2, ur3e] = EnvSetup
    % Function to set up the environment with various objects (shelves, barriers,
    % a person model, emergency stops, and a table).
    hold on;  % Hold the current plot for multiple objects
    axis equal;  % Maintain equal scaling for all axes
    axis([-1.8 1.8 -1.8 1.8 -0.1 1.5]);  % Set the axis limits
    
    
    %% Place the shelf object on the table
    % Load and place a shelf at the specified position
    h = PlaceObject('Cup.ply', [-0.1, 0.3, 0.65]); 
    h = PlaceObject('CupLid.ply', [0.1, 0.3, 0.65]); 
    
    h = PlaceObject('CupWithLid.ply', [-0.1, 0.15, 0.65]); 
    h = PlaceObject('MilkJug.ply', [0.1, 0.15, 0.65]); 
    
    %h = PlaceObject('IceCube.ply', [0, 0.5, 0]); 
    h = PlaceObject('EspressoHandle.ply', [0, 0.4, 0.7]); 
    h = PlaceObject('EspressoMachine.ply', [0.35, -0.5, 0.65]); 
    
    h = PlaceObject('Grinder.ply', [0.9, -0.2, 0.65]); 
    h = PlaceObject('IceCubeDispenser.ply', [-0.75, -0.5, 0.65]); 
    
    h = PlaceObject('Table.ply', [0, 0, 0.4]); 
    
    %% Adding DobotNova2 and UR3e robots to the environment 
    disp('Adding DobotNova2 robot to the environment');
    nova2 = DobotNova2(transl(0.65, 0.3, 0.6));  % Create LinearUR3 robot with initial transform
    ur3e = UR3e(transl(-0.65, 0.3, 0.6));
end

