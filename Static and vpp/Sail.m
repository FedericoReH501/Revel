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
            global vb
            % Load sail aerodynamic coefficients (assumes the MAT file is in the path)
            load('SailCoefficent.mat', 'Cl_fine', 'Cd_fine');
            
            % Extract wind parameters from the Wind object
   
            AWA_rad = deg2rad(obj.wind.AWA);   % Convert AWA to radians


            
            % Apparent wind speed (AWS) and angle (AWA)
            AWS_ms = obj.wind.AWS* 0.51444;
            
            
            % Retrieve aerodynamic coefficients (numerical values)
            index = round(obj.wind.TWA);       % Assuming TWA is an integer angle
            
            Cl_sail = Cl_fine(index);          % Numerical
            Cd_sail = Cd_fine(index);          % Numerical
            

            
            % Induced drag coefficient (numerical)
            Cdi = Cl_sail^2 / (pi * obj.Ar_sail + 0.005);
            
            % Compute Lift and Drag (numerical because coefficients are numbers)
            L_sail = 0.5 * Cl_sail * obj.ro_air * obj.Sa * AWS_ms^2;
            D_sail = 0.5 * (Cd_sail + Cdi) * obj.ro_air * obj.Sa * AWS_ms^2;

            

            
            % Compute Thrust
            T = L_sail * sin(AWA_rad) - D_sail * cos(AWA_rad);
            
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
