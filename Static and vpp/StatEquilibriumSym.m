%% Equilibrium of forces in 3 df
clc; clear; close all;

%% Enviroment data
global g ro_air ro_water ; %#ok<GVMIS>

wind_speed = 10; %[knot]
g = 9.81;  % Gravitational constant (m/s^2)
ro_air = 1.225; %[kg/m^3]
ro_water = 1025; %[kg/m^3]
syms  thetaL x_crew vb 

%% Define the components of the system.

wind = Wind(vb,wind_speed,70); % initialize speed[Kn] and Angle[deg]
boat = Boat(wind); % pass the wind to our boat model
crew = Crew(75,[0.3,2]); % define the crew mass[kg] , and range of movemnt 

centerFoil = CenterFoil(vb, thetaL, 1.5, 0.12); % initialize center foil model passing AoA[degree] , span & chord[m]
rudderFoil = RudderFoil(vb, thetaL ,1, 0.075); % rudder foil model passing span[m]

centerVertical = Vertical(vb,0.3,0.12);
rudderVertical = Vertical(vb,0.2,0.12);

sail = Sail(1.07,wind); % pass to the sail X positio[m], and the current wind model


%% Equilibrium equations

eq1 = sail.Thrust - boat.Windage - centerFoil.Drag - rudderFoil.Drag - centerVertical.Drag - rudderVertical.Drag == 0;   % Fx equation
eq2 = centerFoil.Lift + rudderFoil.Lift - crew.Weight - boat.Weight == 0;    % Fz equation
eq3 = centerFoil.Torque + rudderFoil.Torque + centerVertical.Torque + rudderVertical.Torque + sail.Torque + boat.Torque - crew.Weight*x_crew == 0; % My equation


%% Define dynamic initial guess ranges

ranges = [boat.SpeedRange;   % Range for vb
         -5, 15; % Range for thetaL
         crew.range]; % Range for x_crew

%% Solve, print and check for vb, thetaL, and x_crew 

sol = solver(eq1,eq2,eq3,vb,thetaL,x_crew, ranges);





