clc;
close all;
clear all;

[nova2, ur3e] = EnvSetup;
pause();


for i=0:0.2:360
    view(210+i, 15)
    pause(0.01)
end