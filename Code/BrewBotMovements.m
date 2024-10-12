classdef BrewBotMovements  
    % Class responsible for controlling the movements of the UR3e and DobotNova2 
    % This class includes methods for creating various types of drinks
    % (espresso, latte, iced coffee, tea) and helper functions for 
    % specific steps in the brewing process.

    properties
        Property1  % Placeholder property, can be customized as per BrewBot's requirements.
    end
    
    methods
        %% Functions to create drinks (espresso, latte, icedCoffee, tea)
        
        function espressoCreate()
            % Function that creates an espresso drink.
            % Includes steps:
            % 1. Brew espresso (espressoBrew)
            % 2. Finish the drink (finishDrink)

        end

        function latteCreate()
            % Function that creates a latte drink.
            % Includes steps:
            % 1. Brew espresso (espressoBrew)
            % 2. Add milk to the cup (addMilk)
            % 3. Steam the liquid (steamLiquid)
            % 4. Pour milk into the cup (pourMilk)
            % 5. Finish the drink (finishDrink)

        end

        function icedCoffeeCreate()
            % Function that creates an iced coffee drink.
            % Includes steps:
            % 1. Brew espresso (espressoBrew)
            % 2. Add milk (addMilk)
            % 3. Add ice cubes to the cup (addIce)
            % 4. Pour milk into the cup (pourMilk)
            % 5. Finish the drink (finishDrink)

        end

        function teaCreate()
            % Function that creates a tea drink.
            % Includes steps:
            % 1. Place tea bag into the cup (putTeaBag)
            % 2. Steam the liquid (steamLiquid)
            % 3. Finish the drink (finishDrink)
            
        end

        %% Helper functions assisting in the creation of drinks
        
        function espressoBrew()
            % Function to brew an espresso.
            % Involves the DobotNova2 performing these actions:
            % 1. Grabbing a cup
            % 2. Grinding coffee beans
            % 3. Brewing espresso

        end

        function putTeaBag()
            % Function to prepare tea.
            % Involves the UR3e performing these actions:
            % 1. Grab a tea bag
            % 2. Place it into a cup

        end

        function addMilk()
            % Function to pour milk into milk jug.
            % Involves the UR3e performing these actions:
            % 1. Place milk jug into milk dispenser 
            % 2. Pour milk into milk jug 

        end

        function addIce()
            % Function to add ice cubes to a cup.
            % Involves the UR3e performing these actions:
            % 1. Pick up cup
            % 2. Place cup under ice cube dispenser

        end

        function steamLiquid()
            % Function to steam the liquid (milk, water, etc.).
            % Involves the UR3e performing these actions:
            % 1. Pick up milk jug
            % 2. Place jug under a steamer and wait

        end

        function pourMilk()
            % Function to pour steamed milk into the cup.
            % Involves the UR3e and DobotNova2 performing these actions:
            % 1. Pours milk after steaming into a cup

        end

        function finishDrink()
            % Function to finalize the drink preparation.
            % Involves the UR3e performing these actions:
            % 1. Puts a lid on the cup
            % 2. Hands the finished drink to the customer

        end

    end   
end
