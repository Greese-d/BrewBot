%% espresso brew
function q2Waypoints = GrabCup()
    q2Waypoints = [
                deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
                deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]); % Grab cup position
                deg2rad([-7.2, 36, -72, -50.4, 180, 0]);   % Lift cup
    ];
end

function q2Waypoints = PlaceCupatMachine()
    q2Waypoints = [
                deg2rad([-7.2, 36, -72, -50.4, 180, 0]);   % Lift cup
                deg2rad([5, 57.6, -122, -21.6, 180, 0]);   % Move to intermediary
                deg2rad([64.8, 57.6, -122, -21.6, 180, 0]);  % Move to machine (cup placement)
                deg2rad([64.8, 43.2, -108, -21.6, 180, 0]);  % Place cup
    ];
end

function q2Waypoints = PipetoGrinder()
    q2Waypoints = [
                deg2rad([64.8, 43.2, -108, -21.6, 180, 0]);  % Place cup
                deg2rad([57.6, 93.6, -158, -21.6, 180, 0]); % Pull back after placing
                deg2rad([0, 93.6, -158, -21.6, 180, 0]);    % Rotate back to initial
                deg2rad([-14.4, 14.4, -28.8, -64.8, 93.6, 0]); % Pick pipe
                deg2rad([7.2, 101, -151, -36, 93.6, 0]);    % Lift pipe
                deg2rad([151, 101, -151, -36, 93.6, 0]);    % Rotate with pipe
                deg2rad([151, 79.2, -130, -36, 93.6, 0]);   % Place pipe

    ];
end

function q2Waypoints = PipetoMachine()
    q2Waypoints = [
                deg2rad([151, 79.2, -130, -36, 93.6, 0]);   % Place pipe
                deg2rad([151, 101, -151, -36, 93.6, 0]);    % Pull pipe back
                deg2rad([86.4, 115, -115, -93.6, 93.6, 0]); % Place pipe at coffee machine
                deg2rad([50.4, 86.4, -158, -21.6, 180, 0]); % Pull back for next action
    ];
end

function q2Waypoints = ReturnCup()
    q2Waypoints = [
                deg2rad([50.4, 86.4, -158, -21.6, 180, 0]); % Pull back for next action
                deg2rad([64.8, 43.2, -108, -21.6, 180, 0]); % Pick up cup again
                deg2rad([7.2, 57.6, -122, -21.6, 180, 0]);  % Pull back with the cup
                deg2rad([-7.2, -7.2, 7.2, -93.6, 180, 0]);  % Place cup back
                deg2rad([7.2, 57.6, -122, -21.6, 180, 0]);  % Pull back
    ];
end

function q2Waypoints = ReturnPipe()
    q2Waypoints = [
                deg2rad([7.2, 57.6, -122, -21.6, 180, 0]);  % Pull back
                deg2rad([50.4, 86.4, -158, -21.6, 180, 0]); % Pull back for next action
                deg2rad([86.4, 115, -115, -93.6, 93.6, 0]); % Take pipe at coffee machine
                deg2rad([86.4, 115, -151, -58.6, 93.6, 0]); % fold
                deg2rad([7.2, 115, -151, -58.6, 93.6, 0]); % rotate
                deg2rad([-14.4, 14.4, -28.8, -64.8, 93.6, 0]); % place pipe at initial
                deg2rad([0, 0, 0, 0, 0, 0]);               % Return to home position    
    ];
end

%% add milk to jug

function q2Waypoints = MovetoJug()
    q2Waypoints = [
                deg2rad([0, 0, 0, 0, 0, 0]);              % Initial position
                deg2rad([0, -72, 108, 0, 0, 0]);          % Fold position (fold arm)
                deg2rad([158, -72, 108, 0, 0, 0]);        % Rotate and move
                deg2rad([144, -72, 108, -108, 0, 0]);     % Move down
                deg2rad([144, -57.6, 101, -108, 0, 0]);   % Stretch towards jug placement
                
];
end

function q2Waypoints = GrabJug()
    q2Waypoints = [
                deg2rad([144, -57.6, 101, -108, 0, 0]);   % Stretch towards cup placement
                deg2rad([144, -28.8, 50.4, -108, 0, 0]);  % Grab the jug
                deg2rad([144, -36, 57.6, -108, 0, 0]);    % Pull the jug
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk    
    ];
end 

function q2Waypoints = PutJugBelowFrother() %add some time before this
    q2Waypoints = [
                deg2rad([93.6, -50.4, 115, -151, 0, 0]);  % Pour milk
                deg2rad([122, -50.4, 115, -151, 0, 0]);   % Put cup below frother    
    ];
end 

%% froth milk function

function q2Waypoints = FrothMilk()
    q2Waypoints = [
                deg2rad([122, -50.4, 115, -151, 0, 0]);    % Pick Jug
                deg2rad([122, -64.8, 115, -151, 0, 0]);    % Lift to Reach
];
end

function q2Waypoints = FinishFrothing() %add time before this
    q2Waypoints = [
                deg2rad([122, -64.8, 115, -151, 0, 0]);    % Lift to Reach
                deg2rad([122, -50.4, 115, -151, 0, 0]);    % Put back Jug    
    ];
end

%% add ice

function q2Waypoints = MovetoCup()
    q2Waypoints = [
                deg2rad([122, -50.4, 115, -151, 0, 0]);    % Pick Jug
                deg2rad([162, -50.4, 122, 0, 0, 0]);      % Rotate
        
    ];
end

function q2Waypoints = GetIce()
    q2Waypoints = [
                deg2rad([162, -57.7, 100, -43.2, 79.2, 0]);  % Grab cup
                deg2rad([162, -93.7, 136, -43.2, 79.2, 0]); % Lift cup
                deg2rad([61.2, -93.7, 136, -43.2, 79.2, 0]); % Rotate
                deg2rad([61.2, -86.5, 108, -21.6, 79.2, 0]); % Wait for ice   
    ];
end

function q2Waypoints = ReturnCupWithIce() %add time before this
    q2Waypoints = [
                deg2rad([61.2, -86.5, 108, -21.6, 79.2, 0]); % Wait for ice
                deg2rad([61.2, -93.7, 136, -43.2, 79.2, 0]); % Pull
                deg2rad([162, -93.7, 136, -43.2, 79.2, 0]); % Lift cup
                deg2rad([162, -57.7, 100, -43.2, 79.2, 0]);  % Put cup down
                deg2rad([122, -50.4, 115, -151, 0, 0]);    % Pick Jug  
    ];
end
%% pour milk function

function q2Waypoints = PickUpJug()
    q2Waypoints = [
                deg2rad([122, -50.4, 115, -151, 0, 0]);    % Take milk jug
                deg2rad([122, -86.4, 151, -151, 0, 0]);    % Fold
                deg2rad([141, -86.4, 151, -151, 0, 0]);    % Rotate
                deg2rad([151, -64.8, 93.4, -86.2, 0, 0]);  % Pour    
    ];
end

function q2Waypoints = PlaceJugBack() %add some time
    q2Waypoints = [
                deg2rad([151, -64.8, 93.4, -86.2, 0, 0]);  % Pour
                deg2rad([151, -72.0, 137, -158, 0, 0]);    % Lift
                deg2rad([151, -72.0, 137, -158, 0, 0]);    % Rotate
                deg2rad([115, -38.0, 108, -173, 0, 0]);    % Get in position
                deg2rad([140, -16.4, 50.2, -130, 0, 0]);   % Put at initial jug position
    
    ];
end

function q2Waypoints = ReturnBackafterPouring()
    q2Waypoints = [
                deg2rad([140, -16.4, 50.2, -130, 0, 0]);   % Put at initial jug position
                deg2rad([115, -38.0, 108, -173, 0, 0]);    % Get in position again
                deg2rad([115, -59.6, 144, -173, 0, 0]);    % Fold
                deg2rad([0, -59.6, 144, -173, 0, 0]);      % Rotate
                deg2rad([0, 0, 0, 0, 0, 0]);               % Initial position
    ];
end

%% add hot water

function q2Waypoints = CupforHotWater()
    q2Waypoints = [
                deg2rad([0, 0, 0, 0, 0, 0]);               % Initial position
                deg2rad([0, -50.4, 122, 0, 0, 0]);         % Fold
                deg2rad([162, -50.4, 122, 0, 0, 0]);      % Rotate
                deg2rad([162, -43.3, 78.4, -36, 79.2, 0]);  % Grab cup
                    
    ];
end

function q2Waypoints = AddHotWater()
    q2Waypoints =[
                deg2rad([162, -43.3, 78.4, -36, 79.2, 0]);  % Grab cup
                deg2rad([162, -50.5, 71.2, -21.6, 79.2, 0]); % Lift cup
                deg2rad([150, -50.5, 71.2, -21.6, 79.2, 0]); % Rotate
                deg2rad([150, -72.1, 100, -28.8, 79.2, 0]); % Pour Water     
    ];
end

function q2Waypoints = ReturnCupWater() % add time before
    q2Waypoints =[
                deg2rad([150, -72.1, 100, -28.8, 79.2, 0]); % Pour Water
                deg2rad([150, -50.5, 71.2, -21.6, 79.2, 0]); % Lower cup
                deg2rad([162, -50.5, 71.2, -21.6, 79.2, 0]); % Rotate
                deg2rad([162, -43.3, 78.4, -36, 79.2, 0]);  % Drop cup    
    ];
end

function q2Waypoints = ReturnBotBack()
    q2Waypoints =[
                deg2rad([162, -43.3, 78.4, -36, 79.2, 0]);  % Drop cup
                deg2rad([162, -50.4, 122, 0, 0, 0]);      % Fold arm
                deg2rad([0, -50.4, 122, 0, 0, 0]);         % Rotate
                deg2rad([0, 0, 0, 0, 0, 0]);               % Return to initial position     
    ];
end

%% finish drink function

%for NOVA2

function q2Waypoints = MovetoLid()
    q2Waypoints = [
            deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
            deg2rad([0, 43.2, -108, -14.4, 86.4, 0]);  % Fold position
            deg2rad([14.4, 43.2, -108, -14.4, 86.4, 0]);  % Pick lid

    ];
end

function q2Waypoints = GrabLid()
    q2Waypoints = [
            deg2rad([14.4, 43.2, -108, -14.4, 86.4, 0]);  % Pick lid
            deg2rad([14.4, 57.6, -108, -14.4, 86.4, 0]);  % Lift lid
            deg2rad([14.4, 28.8, -50.4, -57.6, 86.4, 0]);  % Place lid
    ];
end

function q2Waypoints = ReturnNova2()
    q2Waypoints = [
            deg2rad([14.4, 28.8, -50.4, -57.6, 86.4, 0]);  % Place lid
            deg2rad([14.4, 57.6, -108, -14.4, 86.4, 0]);  % Fold back
            deg2rad([0, 43.2, -108, -14.4, 86.4, 0]);  % Rotate
            deg2rad([0, 0, 0, 0, 0, 0]);  % back home  
    ];
end

%FOR UR3E

function q2Waypoints = MovetoFinishedCup()
    q2Waypoints = [
            deg2rad([0, 0, 0, 0, 0, 0]);  % Initial Position
            deg2rad([0, -72, 101, 0, 108, 0]);            % Fold position
            deg2rad([-115, -72, 101, 0, 108, 0]);          % Rotate to cup
            deg2rad([-187, -72, 101, 0, 108, 0]);       % Rotate and go down
            deg2rad([-187, -43.2, 57.6, 0, 108, 0]);     % Stretch towards cup placement
            deg2rad([-187, -72, 101, 0, 108, 0]);       %  grab up
    ];
end

function q2Waypoints = PickUpFinishedCup()
    q2Waypoints = [
            deg2rad([-187, -72, 101, 0, 108, 0]);       %  grab up
            deg2rad([-115, -72, 101, 0, 108, 0]);          % Rotate 
            deg2rad([0, -10, 7.2, 0, 93.6, 0]);         % Place Cup
    ];
end

function q2Waypoints = ReturnUR3e()
    q2Waypoints = [
           deg2rad([0, -10, 7.2, 0, 93.6, 0]);         % Place Cup
           deg2rad([0, 0, 0, 0, 0, 0]);                % Return to home position
    ];
end