hold on;  % Hold the current plot for multiple objects
axis equal;  % Maintain equal scaling for all axes
axis([-1.8 1.8 -1.8 1.8 -0.1 1.5]);  % Set the axis limits

%% Placing environment images
%imageData = imread('WallPicture1.jpg');
%wallImage1 = imrotate(imageData, -90);
%imageData = imread('WallPicture2.jpg');
%wallImage2 = imrotate(imageData, -90);
%surf([-1.8,-1.8;1.8,1.8],[1.8,1.8;1.8,1.8],[0,2;0,2],'CData',wallImage1,'FaceColor','texturemap');
%surf([1.8,1.8;1.8,1.8],[-1.8,-1.8;1.8,1.8],[0,2;0,2],'CData',wallImage2,'FaceColor','texturemap');

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

%% Adding DobotNova2 robot to the environment 
disp('Adding DobotNova2 robot to the environment');
robot1 = DobotNova2(transl(0.65, 0.3, 0.6));  % Create LinearUR3 robot with initial transform
robot2 = UR3e(transl(-0.65, 0.3, 0.6));

%firstPos = transl(0.4, 0.5, 0.1);
%steps = 100;

%q1 = zeros(1, 6);
%initialQ = [0,0,0,0,0,0];

%q2 = robot.model.ikcon(firstPos, initialQ);
%qMatrix = jtraj(q1, q2, steps);

%for i = 1:steps
%    robot.model.animate(qMatrix(i, :));
%
%    pause(0.01);
%end 

%robot.model.teach();

