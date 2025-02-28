classdef Wind
    properties
        TWS  % True Wind Speed [kn]
        TWA  % True Wind Angle [deg]
        vb
    end
    
    methods
        % Constructor to initialize TWS and TWA
        function obj = Wind(vb,TWS, TWA)
            if nargin > 0
                obj.vb = vb;
                obj.TWS = TWS;
                obj.TWA = TWA;
            end
        end
        
        % Method to calculate Apparent Wind Speed (AWS) [knot]
        function AWS = AWS(obj)
            
            TWS_ms = obj.TWS * 0.51444;  % Convert True Wind Speed from knots to m/s
            TWA_rad = deg2rad(obj.TWA);  % Convert True Wind Angle from degrees to radians
            
            AWS_ms = sqrt((TWS_ms * sin(TWA_rad))^2 + (TWS_ms * cos(TWA_rad) + obj.vb)^2);  % Apparent wind speed in m/s
            AWS = AWS_ms / 0.51444;  % Convert Apparent Wind Speed back to knots
        end
        
        % Method to calculate Apparent Wind Angle (AWA) [degrees]
        function AWA = AWA(obj)
            
            TWS_ms = obj.TWS * 0.51444;  % Convert True Wind Speed from knots to m/s
            TWA_rad = deg2rad(obj.TWA);  % Convert True Wind Angle from degrees to radians
            
            AWA_rad = atan(TWS_ms * sin(TWA_rad) / (TWS_ms * cos(TWA_rad) + obj.vb));  % Apparent Wind Angle in radians
            AWA = rad2deg(AWA_rad);  % Convert Apparent Wind Angle to degrees
        end
    end
end
