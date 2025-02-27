%% Equilibrium of forces in 3 df
clc; clear; close all;

%% Enviroment data
global g ro_air ro_water vb thetaL ; %#ok<GVMIS>

wind_speed = 10; %[knot]
g = 9.81;  % Gravitational constant (m/s^2)
ro_air = 1.225; %[kg/m^3]
ro_water = 1025; %[kg/m^3]
syms  thetaL x_crew vb 

%% Define the components of the system.

wind = Wind(wind_speed,50); % initialize speed[Kn] and Angle[deg]
boat = Boat(wind); % pass the wind to our boat model
crew = Crew(75,[0.3,2]); % define the crew mass[kg] , and range of movemnt 
centerFoil = CenterFoil(thetaL, 0.8, 0.085); % initialize center foil model passing AoA[degree] , span & chord[m]
rudderFoil = RudderFoil(thetaL ,0.3, 0.075); % rudder foil model passing span[m]
sail = Sail(1.07,wind); % pass to the sail X positio[m], and the current wind model


%% Equilibrium equations

eq1 = sail.Thrust - boat.Windage - centerFoil.Drag - rudderFoil.Drag == 0;   % Fx equation
eq2 = centerFoil.Lift + rudderFoil.Lift - crew.Weight - boat.Weight == 0;    % Fz equation
eq3 = centerFoil.Torque + rudderFoil.Torque + sail.Torque + boat.Torque - crew.Weight*x_crew == 0; % My equation

%% Define dynamic initial guess ranges

ranges = [boat.SpeedRange;   % Range for vb
         -5, 5; % Range for thetaL
         crew.range]; % Range for x_crew

%% Solve, print and check for vb, thetaL, and x_crew 

solver(eq1,eq2,eq3,vb,thetaL,x_crew, ranges)



