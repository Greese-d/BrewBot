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
%h = PlaceObject('Cup.ply', [0, 0, 0]); 
%h = PlaceObject('CupLid.ply', [0, 0.2, 0]); 
%h = PlaceObject('CupWithLid.ply', [0.2, 0, 0]); 
%h = PlaceObject('IceCube.ply', [0, 0.5, 0]); 
%h = PlaceObject('EspressoHandle.ply', [0.2, 0.2, 0]); 
h = PlaceObject('EspressoMachine.ply', [0.7, -0.5, 0.7]); 
h = PlaceObject('Grinder.ply', [1.3, -0.2, 0.7]); 
h = PlaceObject('Table.ply', [0, 0, 0.4]); 