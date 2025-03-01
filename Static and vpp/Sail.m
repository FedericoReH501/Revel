classdef Sail
    properties (Constant)
        % Constants for sail geometry
        Sa = 8.25;      % Sail area [m^2]
        Ar_sail = 3;    % Aspect ratio of sail
        ro_air = 1.225; % Air density [kg/m^3]
        z = 3.05;    % Vertical component of the center of effort [m]
    end
    
    properties
        x;  % Longitudinal component of the center of effort [m]
        wind;  % Wind object containing TWS, AWS, and AWA
    end
    
    methods
        % Constructor to initialize center of effort (x_ce) and wind
        function obj = Sail(x_ce, wind)
            obj.x = x_ce;  % Longitudinal center of effort
            obj.wind = wind;  % Wind object
        end
        
        % Method to calculate Thrust
        function T = Thrust(obj)
            global ro_air
            
            
            % Extract wind parameters from the Wind object
   
            AWA_rad = deg2rad(obj.wind.AWA);   % Convert AWA to radians
            AWA = obj.wind.AWA;


            
            % Apparent wind speed (AWS) and angle (AWA)

            AWS_ms = obj.wind.AWS * 0.51444;
            
            Cl = -2*10^(-8) * AWA^4 + 9*10^(-6) * AWA^3 - 0.0014 * AWA^2 + 0.0744 * AWA + 0.0024;
            Cd = -4*10^(-9)*AWA^4 + 10^(-6)*AWA^3 - 6*10^(-5)*AWA^2 + 0.0067*AWA - 0.0012;
            
            disp('Cl sail');
            disp(Cl);
            disp('Cd sail');
            disp(Cd);
            
            % Induced drag coefficient (numerical)
            
            
            % Compute Lift and Drag (numerical because coefficients are numbers)
            L = 0.5 * Cl * ro_air * Sail.Sa * AWS_ms^2;
            D = 0.5 * (Cd) * ro_air * Sail.Sa * AWS_ms^2;

            
            disp('Sail Lift no Proj');
            disp(L);

            disp('Sail Drag no Proj');
            disp(D);
            
            % Compute Thrust
            T = L * sin(AWA_rad) - D * cos(AWA_rad);
            
        end
        
        % Method to calculate Side Force
        function S = SideForce(obj)
            global vb
            % Load sail aerodynamic coefficients (assumes the MAT file is in the path)
            load('SailCoefficent.mat', 'Cl_fine', 'Cd_fine');
            
            % Extract wind parameters from the Wind object
            
            AWA_rad = deg2rad(obj.wind.AWA);   % Convert AWA to radians
            
            % Apparent wind speed (AWS) and angle (AWA)
            AWS_ms = obj.wind.AWS;
            
            % Retrieve aerodynamic coefficients (numerical values)
            index = round(obj.wind.TWA);       % Assuming TWA is an integer angle
            Cl_sail = Cl_fine(index);          % Numerical
            Cd_sail = Cd_fine(index);          % Numerical
            
            % Induced drag coefficient (numerical)
            Cdi = Cl_sail^2 / (pi * obj.Ar_sail + 0.005);
            
            % Compute Lift and Drag (numerical because coefficients are numbers)
            L_sail = 0.5 * Cl_sail * obj.ro_air * obj.Sa * AWS_ms^2;
            D_sail = 0.5 * (Cd_sail + Cdi) * obj.ro_air * obj.Sa * AWS_ms^2;
            
            % Compute Side Force
            S = L_sail * cos(AWA_rad) + D_sail * sin(AWA_rad);
        end

        function Torque = Torque(obj)
            % Compute Thrust
            T = obj.Thrust();
            
            % Compute Torque (Thrust * z)
            Torque = - T * abs(obj.z);
        end
    end
end
