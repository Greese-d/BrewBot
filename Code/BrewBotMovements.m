classdef BrewBotMovements  
    % Class responsible for controlling the movements of the UR3e and DobotNova2 
    % This class includes methods for creating various types of drinks
    % (espresso, latte, iced coffee, tea) and helper functions for 
    % specific steps in the brewing process.
    
    properties
        nova2       % DobotNova2 robot
        ur3e        % UR3e robot
        cup         % Coffee cup
        cupLid      % Coffee cup lid
        milkJug     % Milk jug
        iceCube     % Ice cube
        portafilter % Espresso portafilter (coffee handle)
        ur3e_defaultPos; % Default position of UR3e robot
        nova2_defaultPos; % Default position of DobotNova2 robot
    end
    
    methods
        % Constructor method to initialize the environment and robots
        function obj = BrewBotMovements()
            % Call EnvSetup function to initialize environment and objects
            [obj.nova2, obj.ur3e, obj.cup, obj.cupLid, obj.milkJug, obj.iceCube, obj.portafilter] = EnvSetup();
            obj.ur3e_defaultPos = zeros(1, obj.ur3e.model.n);
            obj.nova2_defaultPos = zeros(1, obj.nova2.model.n);
        end
        
        %% Functions to create drinks (espresso, latte, icedCoffee, tea)
        
        function espressoCreate(obj)
            % Function that creates an espresso drink.
            % Includes steps:
            % 1. Brew espresso (espressoBrew)
            % 2. Finish the drink (finishDrink)

            obj.espressoBrew();
            obj.finishDrink();
        end

        function latteCreate(obj)
            % Function that creates a latte drink.
            % Includes steps:
            % 1. Brew espresso (espressoBrew)
            % 2. Add milk to the cup (addMilk)
            % 3. Steam the liquid (steamLiquid)
            % 4. Pour milk into the cup (pourMilk)
            % 5. Finish the drink (finishDrink)

            obj.espressoBrew();
            obj.addMilk();
            obj.steamLiquid();
            obj.pourMilk();
            obj.finishDrink();
        end

        function icedCoffeeCreate(obj)
            % Function that creates an iced coffee drink.
            % Includes steps:
            % 1. Brew espresso (espressoBrew)
            % 2. Add milk (addMilk)
            % 3. Add ice cubes to the cup (addIce)
            % 4. Pour milk into the cup (pourMilk)
            % 5. Finish the drink (finishDrink)

            obj.espressoBrew();
            obj.addMilk();
            obj.addIce();
            obj.pourMilk();
            obj.finishDrink();
        end

        function teaCreate(obj)
            % Function that creates a tea drink.
            % Includes steps:
            % 1. Place tea bag into the cup (putTeaBag)
            % 2. Steam the liquid (steamLiquid)
            % 3. Finish the drink (finishDrink)

            obj.putTeaBag();
            obj.steamLiquid();
            obj.finishDrink();
        end

        %% Helper functions assisting in the creation of drinks
        
        function espressoBrew(obj)
            % Function to brew an espresso.
            % Involves the DobotNova2 performing these actions:
            % 1. Grabbing a cup (obj.cup)
            % 2. Grinding coffee beans (obj.portafilter)
            % 3. Brewing espresso

            disp('Brewing espresso using DobotNova2...');
            % Add commands for DobotNova2 to move and brew the espresso
        end

        function putTeaBag(obj)
            % Function to prepare tea.
            % Involves the UR3e performing these actions:
            % 1. Grab a tea bag
            % 2. Place it into a cup (obj.cup)

            disp('Placing tea bag using UR3e...');
            % Add commands for UR3e to place the tea bag
        end

        function addMilk(obj)
            % Function to pour milk into milk jug.
            % Involves the UR3e performing these actions:
            % 1. Place milk jug (obj.milkJug) under dispenser
            % 2. Pour milk into the cup

            disp('Pouring milk using UR3e...');
            % Add commands for UR3e to pour the milk
        end

        function addIce(obj)
            % Function to add ice cubes to a cup.
            % Involves the UR3e performing these actions:
            % 1. Pick up cup (obj.cup)
            % 2. Place cup under ice cube dispenser (obj.iceCube)

            disp('Adding ice cubes using UR3e...');
            % Add commands for UR3e to add ice cubes
        end

        function steamLiquid(obj)
            % Function to steam the liquid (milk, water, etc.).
            % Involves the UR3e performing these actions:
            % 1. Pick up milk jug (obj.milkJug)
            % 2. Place jug under a steamer

            disp('Steaming liquid using UR3e...');
            % Add commands for UR3e to steam the liquid
        end

        function pourMilk(obj)
            % Function to pour steamed milk into the cup.
            % Involves the UR3e and DobotNova2 performing these actions:
            % 1. Pours milk after steaming into a cup (obj.cup)

            disp('Pouring milk using DobotNova2...');
            % Add commands for DobotNova2 to pour the milk
        end

        function finishDrink(obj)
            % Function to finalize the drink preparation.
            % Involves the UR3e performing these actions:
            % 1. Puts a lid on the cup (obj.cupLid)
            % 2. Hands the finished drink to the customer

            disp('Finishing drink using UR3e...');
            % Add commands for UR3e to put the lid and serve the drink
        end
        

        %% Helper service functions e-stop, reset

        % Returns true if emergency stop is active
        function stop = checkEmergencyStop(~, hObject)
            % Retrieve the updated handles
            handles = guidata(hObject);
    
            % Check if the emergency stop has been triggered
            if handles.isStopped
                disp("Process interrupted by emergency stop");
                stop = true;  % Return true if emergency stop is triggered
            else
                stop = false;  % Return false if not triggered
            end
        end

        % Function to move both nova2 and ur3e to their default position
        % (specified in class properties)
        function resetRobots(obj)
            n = 60;  % Amount of steps
            q0_nova2 = obj.nova2.model.getpos();
            q0_ur3e = obj.ur3e.model.getpos();
            qMatrix_nova2 = jtraj(q0_nova2, obj.nova2_defaultPos, n);
            qMatrix_ur3e = jtraj(q0_ur3e, obj.ur3e_defaultPos, n);
            
            for i = 1 : n

                obj.nova2.model.animate(qMatrix_nova2(i, :))
                obj.ur3e.model.animate(qMatrix_ur3e(i, :))
                pause(0.01)
            end
        end
    end   
end