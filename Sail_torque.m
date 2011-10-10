% Discretize sail, calculate Force and hence Torque around mast + z
% using basic units of m, N

%%%%%%%%%%%%%%%%%%%%%%%% Define sail geometry %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Le=5.570;        %sail leach (m)
ch1=0.965;       %sail chord length at point 1 (m)
ch2=1.720;       %sail chord length at point 2 (m)
ch3=2.330;       %sail chord length at point 3 (m)
ch4=2.740;       %sail chord length at point 4 (m)

ex1=ch2-ch1;
ex2=ch3-ch2;
ex3=ch4-ch3;

h1=(((0.25*Le)^2)-((ch1)^2))^0.5;   %sail section 1 height (m)
h2=(((0.25*Le)^2)-((ex1)^2))^0.5;   %sail section 2 height (m)
h3=(((0.25*Le)^2)-((ex2)^2))^0.5;   %sail section 3 height (m)
h4=(((0.25*Le)^2)-((ex3)^2))^0.5;   %sail section 4 height (m)

hT=h1+h2+h3+h4; %total sail height (m)

sail_height=0;  %height of base of sail above axis of rotation


%%%%%%%%%%%%%%%%%%%%%% Calculating coefficients %%%%%%%%%%%%%%%%%%%%%%%%%%

v=5                          %apparant wind speed (ms^-1)
ro=1;                        %set water density (kgm^-3)
apparant_wind_angle=5        %angle of wind with respect to boat (degrees)
sail_angle=25                %angle of sail with respect to boat (degrees)
angle_of_attack=apparant_wind_angle+sail_angle; %angle of attack (degrees)


%polynomials for coefficient calculation

Cl=(-2.34*(10^-19)*(angle_of_attack^10))+(2.28*(10^-16)*(angle_of_attack^9))+(-9.23*(10^-14)*(angle_of_attack^8))+(2.01*(10^-11)*(angle_of_attack^7))+(-2.52*(10^-9)*(angle_of_attack^6))+(1.79*(10^-7)*(angle_of_attack^5))+(-6.08*(10^-6)*(angle_of_attack^4))+(2.24*(10^-5)*(angle_of_attack^3))+(3.03*(10^-3)*(angle_of_attack^2))+(-2.54*(10^-3)*(angle_of_attack))+5.6*(10^-3)
Cd=(-4.89*(10^-21)*(angle_of_attack^10))+(3.39*(10^-18)*(angle_of_attack^9))+(-9.63*(10^-16)*(angle_of_attack^8))+(1.55*(10^-13)*(angle_of_attack^7))+(-2.03*(10^-11)*(angle_of_attack^6))+(2.73*(10^-9)*(angle_of_attack^5))+(-2.7*(10^-7)*(angle_of_attack^4))+(1.19*(10^-5)*(angle_of_attack^3))+(3.63*(10^-5)*(angle_of_attack^2))+(2.69*(10^-3)*(angle_of_attack))+6.01*(10^-2)

%%%%%%%%%%%%%%%%%%%%%%% Calculating T round mast+ z %%%%%%%%%%%%%%%%%%%%%%%

% For sail section 1

area_old=0;     %set starting conditions
lift_old=0;
drag_old=0;
torque_y_old=0;
torque_z_old=0;

for i=1:h1;
  
   area=i*1*(ch1/h1);                         %calculate strip area
   lift=Cl*(0.5*ro*(v^2))*area;               %calculate lift force on strip
   torque_y=lift*(0.25*(i*(ch1/h1)));         %calculate associated torque
   drag=Cd*ro*((v^2)/2)*area;                 %calculate drag force on strip
   torque_z=drag*((hT-i)+sail_height);        %calculate associated torque
   
   section1_lift=lift_old+lift;               %add up total lift
   section1_torque_y=torque_y_old+torque_y;   %add up total torque
   section1_drag=drag_old+drag;               %add up total drag
   section1_torque_z=torque_z_old+torque_z;   %add up total torque
   
   torque_y_old=section1_torque_y;
   lift_old=section1_lift;
   torque_z_old=section1_torque_z;
   drag_old=section1_drag;
   
   area_1=area;   
end


% For section 2

area_old=0;     %set starting conditions
lift_old=0;
drag_old=0;
torque_y_old=0;
torque_z_old=0;

for i=1:h2;
  
   area=ch1+(i*1*(ex1/h2));                   %calculate strip area
   lift=Cl*(0.5*ro*(v^2))*area;               %calculate lift force on strip
   torque=lift*(0.25*(ch1+(i*(ex1/h2))));     %calculate associated torque
   drag=Cd*ro*((v^2)/2)*area;                 %calculate drag force on strip
   torque_z=drag*((hT-h1-i)+sail_height);     %calculate associated torque
   
   section2_lift=lift_old+lift;               %add up total lift
   section2_torque_y=torque_y_old+torque_y;   %add up total torque
   section2_drag=drag_old+drag;               %add up total drag
   section2_torque_z=torque_z_old+torque_z;   %add up total torque
   
   torque_y_old=section2_torque_y;
   lift_old=section2_lift;
   torque_z_old=section2_torque_z;
   drag_old=section2_drag;
   
   area_2=area;   
end


% For section 3

area_old=0;     %set starting conditions
lift_old=0;
drag_old=0;
torque_y_old=0;
torque_z_old=0;

for i=1:h3;
  
   area=ch2+(i*1*(ex2/h3));                   %calculate strip area
   lift=Cl*(0.5*ro*(v^2))*area;               %calculate lift force on strip
   torque_y=lift*(0.25*(ch2+(i*(ex2/h3))));   %calculate associated torque
   drag=Cd*ro*((v^2)/2)*area;                 %calculate drag force on strip
   torque_z=drag*((hT-h2-i)+sail_height);     %calculate associated torque
   
   section3_lift=lift_old+lift;               %add up total lift
   section3_torque_y=torque_y_old+torque_y;   %add up total torque
   section3_drag=drag_old+drag;               %add up total drag
   section3_torque_z=torque_z_old+torque_z;   %add up total torque
   
   torque_y_old=section3_torque_y;
   lift_old=section3_lift;
   torque_z_old=section3_torque_z;
   drag_old=section3_drag;
   
   area_3=area; 
end


% For section 4

area_old=0;     %set starting conditions
lift_old=0;
drag_old=0;
torque_y_old=0;
torque_z_old=0;

for i=1:h4;
  
   area=ch3+(i*1*(ex3/h4));                    %calculate strip area
   lift=Cl*(0.5*ro*(v^2))*area;                %calculate lift force on strip
   torque_y=lift*(0.25*(ch3+(i*(ex3/h4))));    %calculate associated torque
   drag=Cd*ro*((v^2)/2)*area;                  %calculate drag force on strip
   torque_z=drag*((hT-h3-i)+sail_height);      %calculate associated torque
   
   section4_lift=lift_old+lift;                %add up total lift
   section4_torque_y=torque_y_old+torque_y;    %add up total torque
   section4_drag=drag_old+drag;                %add up total drag
   section4_torque_z=torque_z_old+torque_z;    %add up total torque
   
   torque_y_old=section4_torque_y;
   lift_old=section4_lift;
   torque_z_old=section4_torque_z;
   drag_old=section4_drag;
   
   area_4=area; 
end


%%%%%%%%%%%%%%%%%%%% Displaying Calculated Forces %%%%%%%%%%%%%%%%%%%%%%%%%
    
sail_area=area_1+area_2+area_3+area_4

total_lift = section4_lift+section3_lift+section2_lift+section1_lift
total_torque_y = section4_torque_y+section3_torque_y+section2_torque_y+section1_torque_y
total_drag = section4_drag+section3_drag+section2_drag+section1_drag
total_torque_z = section4_torque_z+section3_torque_z+section2_torque_z+section1_torque_z
