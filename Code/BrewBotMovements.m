classdef BrewBotMovements  
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = untitled(inputArg1,inputArg2)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        % latte = pick cup + createEspresso + warm up milk + close lid + give it to customer 
        
        %% MAIN DRINK FUCNTIONS
        fucntion Latte % creates latte 
            brewEspressoShot
            frothMilk
            giveDrinkToCustomer 
        end


        %% HELPER FUCNTIONS
        fucntion brewEspressoShot 
            % programm movements for creating coffee  
            pick cup
            grind coffee
            create Espress
        end
    end   
end
