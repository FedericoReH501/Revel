%% Equilibrium of forces in 3 df.
clc; clear; close all;

%% Enviroment data
global g ro_air ro_water vb thetaL %#ok<GVMIS>

wind_speed = 10; %[knot]
g = 9.81;  % Gravitational constant (m/s^2)
ro_air = 1.225; %[kg/m^3]
ro_water = 1025; %[kg/m^3]
syms thetaL x_crew vb 

%% Define the components of the system.
wind = Wind(wind_speed,50); % initialize speed [knot] and Angle [deg]
boat = Boat(wind);         % pass the wind to our boat model
crew = Crew(75,[0.3,2]);     % define the crew mass [kg] and range of movement
sail = Sail(1.07,wind);      % pass to the sail X position [m] and the current wind model

% Define the ranges for CenterFoil and RudderFoil (from 0.3 to 1)
centerFoil_range = 0.3:0.1:1;
rudderFoil_range   = 0.3:0.1:1;

% Variables to store the best solution (largest vb)
best_vb = -Inf;
best_sol = []; % [vb, thetaL, x_crew]
best_centerFoil_val = 0;
best_rudderFoil_val = 0;

% Nested loop over the specified ranges
for cf_val = centerFoil_range
    for rf_val = rudderFoil_range
        % Create the foil objects using current loop values
        centerFoil = CenterFoil(thetaL, cf_val, 0.085);
        rudderFoil = RudderFoil(thetaL, rf_val, 0.075);
        
        % Equilibrium equations
        eq1 = sail.Thrust - boat.Windage - centerFoil.Drag - rudderFoil.Drag == 0;   % Fx equation
        eq2 = centerFoil.Lift + rudderFoil.Lift - crew.Weight - boat.Weight == 0;    % Fz equation
        eq3 = centerFoil.Torque + rudderFoil.Torque + sail.Torque + boat.Torque - crew.Weight*x_crew == 0; % My equation
        
        % Define the ranges for the variables: vb, thetaL, and x_crew.
        ranges = [boat.SpeedRange;   % Range for vb
                  -5, 5;            % Range for thetaL
                  crew.range];       % Range for x_crew

        % Attempt to solve the system
        sol = vpasolve([eq1, eq2, eq3], [vb, thetaL, x_crew], ranges);
        
        % Check if a solution was found
        if ~isempty(sol) && isfield(sol, 'vb') && ~isempty(sol.vb)
            vb_sol = double(sol.vb);
            thetaL_sol = double(sol.thetaL);
            x_crew_sol = double(sol.x_crew);
            
            % In case multiple solutions are returned, pick the one with max vb.
            if numel(vb_sol) > 1
                [max_vb, idx] = max(vb_sol);
                vb_sol = max_vb;
                thetaL_sol = thetaL_sol(idx);
                x_crew_sol = x_crew_sol(idx);
            end
            
            % If this solution has a higher boat speed, update the best solution.
            if vb_sol > best_vb
                best_vb = vb_sol;
                best_sol = [vb_sol, thetaL_sol, x_crew_sol];
                best_centerFoil_val = cf_val;
                best_rudderFoil_val = rf_val;
            end
        end
        % If no solution is found in this loop iteration, nothing is saved.
    end
end

% If no valid solution was found overall, return [0, 0, 0].
if isempty(best_sol)
    best_sol = [0, 0, 0];
end

% Display the best solution found (or the default if none were found)
disp(['Best Boat speed (vb):               ', num2str(best_sol(1)), ' m/s']);
disp(['Boat pitch angle (thetaL):          ', num2str(best_sol(2)), ' degrees']);
disp(['Crew longitudinal pos (x_crew):     ', num2str(best_sol(3)), ' m']);
disp(['Best CenterFoil value:              ', num2str(best_centerFoil_val)]);
disp(['Best RudderFoil value:              ', num2str(best_rudderFoil_val)]);
