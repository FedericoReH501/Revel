classdef Boat
    properties (Constant)
        mass = 50;   % Mass of the boat in kg
        xg = 1.6;     % Position of the center of gravity in the x-direction (m)
        zg = 0.45;     % Position of the center of gravity in the z-direction (m)
        
        Ax = 2; % Projected area on yz plane of hull, mast, rig, and crew     
        x_windage = 3.5; % Longitudinal position of windage drag
        z_windage = 1;   % Vertical position of windage drag
        Cd_w = 1.13; % Drag coefficient for windage

    end

    properties
        wind;
        SpeedRange;
    end
    
    methods
        % Constructor (optional, if needed for further initialization)
        function obj = Boat(wind)
            if nargin > 0
                
                obj.wind = wind;  % Assign the Wind object to the wind property
                obj.SpeedRange = [obj.wind.TWS * 0.51444 * 0.7, obj.wind.TWS * 0.51444*1.5];
            
            end
            % Constants are set, so no need for initialization here
        end
        
        % Method to calculate weight (mass * g)
        function weight = Weight(obj)
            global g;  % Access the global variable g
            weight = Boat.mass * g;  % Calculate weight using mass and global g
        end
        
        % Method to display boat's constant properties
        function displayInfo(obj)
            fprintf('Boat mass: %.2f kg\n', Boat.mass);
            fprintf('Boat xg: %.2f m\n', Boat.xg);
            fprintf('Boat zg: %.2f m\n', Boat.zg);
        end

        function D_windage = Windage(obj)
            % Define windage parameters
            global ro_air;

            AWS = obj.wind.AWS();  % Apparent Wind Speed in knots
            AWA = obj.wind.AWA();  % Apparent Wind Angle in degrees
            % Calculate windage drag
            D_windage = 0.5 * obj.Cd_w * ro_air * obj.Ax * (AWS)^2 * cos(AWA);
        end

        function Torque = Torque(obj)
            % Calculate weight and windage
            weight = obj.Weight();  % Weight of the boat
            D_windage = obj.Windage();  % Windage drag
            
            % Calculate the torque (Weight * xg - Windage * zce)
            Torque = - weight * abs(obj.xg) + D_windage * abs(obj.z_windage);
        end

        %function SpeedRange = SpeedRange(obj)
           % wind_ms =obj.wind.TWS * 0.51444;
           % SpeedRange = [wind_ms * 0.7,wind_ms*1.5];
            
       % end
    end
end
