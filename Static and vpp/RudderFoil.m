classdef RudderFoil
    properties (Constant)
        % Constants and parameters for the rudder foil
        
        t = 0.008;             % Thickness rudder foil [m]
        h = 0.5;               % Immersion [m]
        Cdws = 0.5; 
        x = -0.52; % Longitudinal position from point of reference
        z = -1.13; % Vertical position from point of reference

    end
    
    properties
        thetaL;
        span;  % Main foil span [m]
        cm ; % Mean chord [m]   
        S ;  % Main foil 2D-surface [m^2]
        AR ; % Aspect ratio of center foil
        Cl;   % 3D lift coefficient
        Cd;   % Drag coefficient
        Cdw;  % Wave drag coefficient (assuming it's given or calculated elsewhere)
        Cdi;
    end
    
    methods
        % Constructor
        function obj = RudderFoil(thetaL, span, cm)
            % Initialize the angle of attack and calculate the lift and drag coefficients
            global ro_water;
            obj.thetaL = thetaL;
            obj.span = span;
            obj.cm = cm;
            obj.S = obj.cm * obj.span;
            obj.AR = obj.span^2 / obj.S;
            [cl_rf, cd_rf] = Coefficent_f1(obj.thetaL);  % Assuming Coefficent_f3 calculates cl and cd based on thetaL
            obj.Cl = cl_rf / (1 + 2 / obj.AR); % 3D lift coefficient
            obj.Cd = cd_rf;  % Assign drag coefficient
            obj.Cdw = 0.025 * obj.Cl^2 * obj.cm / obj.h; % Wave drag coefficient
            obj.Cdi = obj.Cl^2 / (pi * obj.AR);  % Induced drag coefficient
            % Additional drag and lift coefficients can be calculated here
        end
        
        % Method to calculate Lift
        function L_rf = Lift(obj)
            global vb ro_water;  % Access the global variable vb (velocity)
            % L_rf = 0.5 * Cl_rf * ro_water * vb^2 * S_rf;
            L_rf = 0.5 * obj.Cl * ro_water * vb^2 * obj.S;
        end
        
        % Method to calculate Drag
        function D_rf = Drag(obj)
            global vb ro_water;  % Access the global variable vb (velocity)
            
            D_rf = 0.5 * ro_water * vb^2 * ((obj.Cd + obj.Cdi + obj.Cdw)* obj.S  + obj.Cdws * obj.t^2);
        end

        function Torque = Torque(obj)
            % Call the Lift and Drag methods
            Lift = obj.Lift();
            Drag = obj.Drag();
            
            % Calculate Torque based on the formula (Drag * z + Lift * x)
            Torque = - Drag * abs(obj.z) - Lift * abs(obj.x);
        end

        function  DisplayGeometry(obj)  
             disp('-----------------------------------')
            disp(['Span: ' num2str(obj.span)]);
            disp(['Chord: ' num2str(obj.cm)]);
            disp(['Surface: ' num2str(obj.S)]);
            disp(['Aspect Ratio: ' num2str(obj.AR)]);
            disp('-----------------------------------')
        end

        function  DisplayForces(obj) 
             disp('-----------------------------------')
             disp('Lift in Kg:')
            disp(obj.Lift/9.81);
            disp('Drag in Kg:')
            disp(obj.Drag/9.81);

            disp('---------------------------------------')
        end
    end
end
