%% Equilibrium of forces in 3 df
clc; clear; close all;

%% Enviroment data
global g ro_air ro_water ; %#ok<GVMIS>

wind_speed = 10; %[knot]
g = 9.81;  % Gravitational constant (m/s^2)
ro_air = 1.225; %[kg/m^3]
ro_water = 1025; %[kg/m^3]
syms  thetaL x_crew vb y

%% Define the components of the system.

wind = Wind(wind_speed,50); % initialize speed[Kn] and Angle[deg]
boat = Boat(wind); % pass the wind to our boat model
crew = Crew(75,[0.3,2]); % define the crew mass[kg] , and range of movemnt 
centerFoil = CenterFoil(vb,thetaL, 0.8, 0.085); % initialize center foil model passing AoA[degree] , span & chord[m]
rudderFoil = RudderFoil(vb,thetaL ,0.3, 0.075); % rudder foil model passing span[m]
sail = Sail(1.07,wind); % pass to the sail X positio[m], and the current wind model


%% Equilibrium equations

Fx_eq = sail.Thrust - boat.Windage - centerFoil.Drag - rudderFoil.Drag ;   % Fx equation
Fz_eq = centerFoil.Lift + rudderFoil.Lift - crew.Weight - boat.Weight ;    % Fz equation
My_eq = centerFoil.Torque + rudderFoil.Torque + sail.Torque + boat.Torque - crew.Weight*x_crew ; % My equation

%% Define Optimization Problem

opt_fun = @(x) -x(1);  % We want to maximize boat speed (negative for minimization)

% Initial guess for the variables
x0 = [7, 2, mean(crew.range)];

% Lower and upper bounds for the variables
lb = [0, -5, crew.range(1)];
ub = [12, 5, crew.range(2)];

%% Defining equilibrium constrain

% Set optimization options
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');

% Run the optimization
[x_opt, fval] = fmincon(opt_fun, x0, [], [], [], [], lb, ub, @(x) equilibrium_constraints(x, Fx_eq, Fz_eq, My_eq), options);

% Extract results
best_vb = -fval; % Convert back to positive vb
best_thetaL = x_opt(2);
best_x_crew = x_opt(3);

% Display results
disp(['Optimal Boat Speed: ', num2str(best_vb), ' m/s']);
disp(['Optimal Foil Angle (thetaL): ', num2str(best_thetaL), ' degrees']);
disp(['Optimal Crew Position (x_crew): ', num2str(best_x_crew), ' m']);
function [cin, ceq] = equilibrium_constraints(x, Fx_eq, Fz_eq, My_eq)
    % Extract optimization variables
    syms vb thetaL x_crew
    vb_n = x(1);           % Boat speed
    thetaL_n = x(2);       % Foil angle
    x_crew_n = x(3);       % Crew position
    
    
    % Substitute optimization variables into the symbolic expressions
    Fx_eq_val = double(subs(Fx_eq, {vb, thetaL}, {vb_n, thetaL_n}));

    Fz_eq_val = double(subs(Fz_eq, {vb, thetaL}, {vb_n, thetaL_n}));
    My_eq_val = double(subs(My_eq, {vb, thetaL, x_crew}, {vb_n, thetaL_n, x_crew_n}));
    
    % Return the residuals of the equations as ceq (equality constraints)
    ceq = [Fx_eq_val; Fz_eq_val; My_eq_val];
    cin = []; % No inequality constraints in this example
end