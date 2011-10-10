%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paul's Wetted surface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [S V] = WettedSurfaceAndVolume(roll, mass)


% % roll and mass inputs
% roll=5;
% mass=100;

% constants
d=1000;         %water density

r=[0 5 10 15 0 5 10 15 0 5 10 15 0 5 10 15 0 5 10 15];

m=[60.8 53.2 52.6 59.9 84.5 88.6 88.4 84.6 109.8 108.8 106.3 107.8 136.1 135.5 133.1 141.3 163.9 169.2 166.9 164.34];

s=[2.452 2.396 2.412 2.512 2.633 2.671 2.6905 2.703 2.804 2.8045 2.8085 2.859 2.96 2.9615 2.9685 3.0595 3.109 3.14 3.1525 3.1765];

x=linspace(0,15);
y=linspace(52,170);

[X,Y]=meshgrid(x,y);

Z=griddata(r,m,s,X,Y,'cubic');

% Wetted surface area
S=interp2(X,Y,Z,roll,mass);
% Submerged volume
V=mass/d;