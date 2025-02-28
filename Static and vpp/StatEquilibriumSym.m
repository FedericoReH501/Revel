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

wind = Wind(vb,wind_speed,60); % initialize speed[Kn] and Angle[deg]
boat = Boat(wind); % pass the wind to our boat model
crew = Crew(75,[0.3,2]); % define the crew mass[kg] , and range of movemnt 
centerFoil = CenterFoil(vb,thetaL, 0.8, 0.085); % initialize center foil model passing AoA[degree] , span & chord[m]
rudderFoil = RudderFoil(vb,thetaL ,0.65, 0.075); % rudder foil model passing span[m]
sail = Sail(1.07,wind); % pass to the sail X positio[m], and the current wind model


%% Equilibrium equations

eq1 = sail.Thrust - boat.Windage - centerFoil.Drag - rudderFoil.Drag == 0;   % Fx equation
eq2 = centerFoil.Lift + rudderFoil.Lift - crew.Weight - boat.Weight == 0;    % Fz equation
eq3 = centerFoil.Torque + rudderFoil.Torque + sail.Torque + boat.Torque - crew.Weight*x_crew == 0; % My equation

eq11 = sail.Thrust - boat.Windage - centerFoil.Drag - rudderFoil.Drag ;   % Fx equation
eq22 = centerFoil.Lift + rudderFoil.Lift - crew.Weight - boat.Weight;    % Fz equation
eq33 = centerFoil.Torque + rudderFoil.Torque + sail.Torque + boat.Torque - crew.Weight*x_crew; % My equation

%% Define dynamic initial guess ranges

ranges = [boat.SpeedRange;   % Range for vb
         -5, 5; % Range for thetaL
         crew.range]; % Range for x_crew

disp(boat.SpeedRange);

%% Solve, print and check for vb, thetaL, and x_crew 

sol = solver(eq1,eq2,eq3,vb,thetaL,x_crew, ranges);

[cin, ceq] = equilibrium_constraints([sol.vb,sol.thetaL,sol.x_crew],eq11,eq22,eq33);
disp('equations');
disp(ceq);


function [cin, ceq] = equilibrium_constraints(x, eq1, eq2, eq3)
    % Extract optimization variables
    syms vb thetaL x_crew
    vb_n = x(1);     % Boat speed
    
    thetaL_n = x(2);       % Foil angle
    x_crew_n = x(3);       % Crew position
    
    
    % Substitute optimization variables into the symbolic expressions
    Fx_eq_val = double(subs(eq1, {vb, thetaL}, {vb_n, thetaL_n}));

    Fz_eq_val = double(subs(eq2, {vb, thetaL}, {vb_n, thetaL_n}));
    My_eq_val = double(subs(eq3, {vb, thetaL, x_crew}, {vb_n, thetaL_n, x_crew_n}));
    
    % Return the residuals of the equations as ceq (equality constraints)
    ceq = [Fx_eq_val; Fz_eq_val; My_eq_val];
    cin = []; % No inequality constraints in this example
end



