% Clear command window and workspace
clc;
clear all;
close all;

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

