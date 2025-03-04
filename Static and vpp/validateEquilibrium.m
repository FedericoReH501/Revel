function isEquilibrium = validateEquilibrium(sol,wind_speed,wind_angle)
% Equilibrium of forces in 3 df


%% Enviroment data
global g ro_air ro_water ; %#ok<GVMIS>

 %[knot]
g = 9.81;  % Gravitational constant (m/s^2)
ro_air = 1.225; %[kg/m^3]
ro_water = 1025; %[kg/m^3]


%% Define the components of the system.

wind = Wind(sol(1),wind_speed,wind_angle); % initialize speed[Kn] and Angle[deg]
boat = Boat(wind); % pass the wind to our boat model
crew = Crew(75,[0.3,2]); % define the crew mass[kg] , and range of movemnt

centerVertical = Vertical(sol(1), 0.3, 0.12);
rudderVertical = Vertical(sol(1), 0.2, 0.12);

centerFoil = CenterFoil(sol(1), sol(2), sol(4) , 0.1); % initialize center foil model passing AoA[degree] , span & chord[m]
rudderFoil = RudderFoil(sol(1), sol(2) , sol(5), 0.06); % rudder foil model passing span[m]

sail = Sail(1.07,wind); % pass to the sail X positio[m], and the current wind model


%% Equilibrium equations


eq1 = sail.Thrust - boat.Windage - centerFoil.Drag - rudderFoil.Drag - centerVertical.Drag - rudderVertical.Drag ;   % Fx equation
eq2 = centerFoil.Lift + rudderFoil.Lift - crew.Weight - boat.Weight;    % Fz equation
eq3 = centerFoil.Torque + rudderFoil.Torque + centerVertical.Torque + rudderVertical.Torque + sail.Torque + boat.Torque - crew.Weight * sol(3); % My equation

tol = 1e-1; 

    % Evaluate the equations (if they are symbolic, convert to numeric)
    val1 = double(eq1);
    val2 = double(eq2);
    val3 = double(eq3);
    
    % Check if each residual is within tolerance
    if (abs(val1) < tol) && (abs(val2) < tol) && (abs(val3) < tol)
        % Print a message with a green check mark
        % The check mark character is Unicode U+2714 ("✔").
        fprintf('✔ The system is in equilibrium.\n');
        isEquilibrium = true;
    else
        % Print a message indicating the system is not in equilibrium.
        % Alternatively, you could print an "X" or similar symbol.
        fprintf('✗ The system is NOT in equilibrium.\n');
        isEquilibrium = false;
    end
end
