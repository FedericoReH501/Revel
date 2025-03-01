% Equilibrium of forces in 3 df
clc; clear; close all;

%% Enviroment data
global g ro_air ro_water ; %#ok<GVMIS>

wind_speed = 10; %[knot]
g = 9.81;  % Gravitational constant (m/s^2)
ro_air = 1.225; %[kg/m^3]
ro_water = 1025; %[kg/m^3]


%% Define the components of the system.

s1 = [7.6599,0.21457,0.3];
S2 = [7.2545,1.4405,0.3 ];

wind = Wind(S2(1),wind_speed,60); % initialize speed[Kn] and Angle[deg]
boat = Boat(wind); % pass the wind to our boat model
crew = Crew(75,[0.3,2]); % define the crew mass[kg] , and range of movemnt 
centerFoil = CenterFoil(S2(1),S2(2), 0.9, 0.085); % initialize center foil model passing AoA[degree] , span & chord[m]
rudderFoil = RudderFoil(S2(1),S2(2) ,0.6, 0.075); % rudder foil model passing span[m]
sail = Sail(1.07,wind); % pass to the sail X positio[m], and the current wind model


%% Equilibrium equations


eq11 = sail.Thrust - boat.Windage - centerFoil.Drag - rudderFoil.Drag ;   % Fx equation
eq22 = centerFoil.Lift + rudderFoil.Lift - crew.Weight - boat.Weight;    % Fz equation
eq33 = centerFoil.Torque + rudderFoil.Torque + sail.Torque + boat.Torque - crew.Weight * S2(3); % My equation

disp('Equations');
disp(eq11);
disp(eq22);
disp(eq33);
disp('-------------');

FoilDrag =   centerFoil.Drag + rudderFoil.Drag;
TotalDrag = boat.Windage + FoilDrag;
TotalThrust = sail.Thrust;
totlLift = centerFoil.Lift + rudderFoil.Lift;
TotalWeight =  crew.Weight + boat.Weight;

disp('Foil drag');
disp(FoilDrag);

disp('Total drag');
disp(TotalDrag);

disp('total thrust');
disp(TotalThrust);

disp('Total lift');
disp(totlLift);

disp('Total Weight');
disp(TotalWeight);
