%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paul's drag calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Drag Ddrift] = Dragcalculations2(U, Udrift, S)

% % Variables that need updating
% U=5;            %(m/s)
% Udrift=0.1;     %(m/s)
% S=3;            %(m^3)

% Constants
Cdrift=1.28;
l=3.961;    %boat length
d=1000;     %water density
g=9.81; 
u=1e-3;     %dynamic viscosity of water

F=U/(g*l)^(1/2);    %froude no.
R=U*l*d/u;          %reynolds no.

Cf=0.075/(log10(R)-2)^2;        %frictional drag coefficient

x=0:0.02:0.86;
y=[0.35 0.35 0.35 0.35 0.35 0.35 0.35 0.35 0.35 0.35 0.36 0.38 0.4 0.46 0.53 0.62 0.7 0.88 1.3 1.82 2.4 2.84 3.15 3.35 3.44 3.46 3.43 3.38 3.3 3.2 3.1 3 2.9 2.81 2.73 2.65 2.58 2.52 2.45 2.39 2.32 2.26 2.2 2.15]*1e-3;

Cr=interp1(x,y,F);                      %residual (shape + wave) drag coefficient

Cd=Cf+Cr;

Drag=0.5*Cd*d*S*U^2;                    %total water drag force (N)

Ddrift=0.5*Cdrift*d*(0.5*S)*Udrift;     %total Drag resistance to drift (N)