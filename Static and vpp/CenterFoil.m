classdef CenterFoil
    properties (Constant)
        t = 0.014;                  % Thickness of center foil [m]
        h = 0.5;                    % Immersion depth [m]
        Cdws = 0.5; 
        x = 2.05; % Longitudinal position from center of reference
        z = -1.22; % Vertical position from center of reference
    end
    
    properties
        vb;
        thetaL; %AOA
        span;   % Main foil span [m]
        cm;  %average chord
        S ;  % Main foil 2D-surface [m^2]
        AR ; % Aspect ratio of center foil
        Cl;   % 3D lift coefficient
        Cd;   % Drag coefficient
        Cdw;  % Wave drag coefficient (assuming it's given or calculated elsewhere)
        Cdi;
        
    end
    
    methods
        % Constructor
        function obj = CenterFoil(vb ,thetaL, span , cm)
            % Initialize the angle of attack and calculate the lift and drag coefficients
            global ro_water;
            obj.vb = vb;
            obj.thetaL = thetaL;
            obj.span = span;
            obj.cm = cm;
            obj.S = obj.cm * obj.span;
            obj.AR = obj.span^2 / obj.S;
          
            [cl_cf, cd_cf] = Coefficent_f1(obj.thetaL);  % Assuming Coefficent_f1 calculates cl and cd based on thetaL
            obj.Cl = cl_cf / (1 + 2 / obj.AR); % 3D lift coefficient
            obj.Cd = cd_cf;  % Assign drag coef;ficient
            obj.Cdw = 0.025*obj.Cl^2*obj.cm/obj.h;
            obj.Cdi = obj.Cl^2/(pi*obj.AR);
            % Assuming the induced drag, wave drag, and wetted surface drag coefficients are given or calculated
        end
        
        % Method to calculate Lift
        function Lift = Lift(obj)
            global ro_water;  % Access the global variable vb (velocity)
            % Lift = 0.5 * Cl_cf * ro_water * vb^2 * S_cf;
            Lift = 0.5 * obj.Cl * ro_water * obj.vb^2 * obj.S;
        end
        
        % Method to calculate Drag
        function Drag = Drag(obj)
            global ro_water;  % Access the global variable vb (velocity)
            % Drag = 0.5 * ro_water * vb^2 * ((cd_cf + Cdi_cf + Cdw_cf) * S_cf + Cdws_cf * t_cf^2);
            Drag = 0.5 * ro_water * obj.vb^2 * ((obj.Cd + obj.Cdi + obj.Cdw)*obj.S + obj.Cdws * obj.t^2) ;
        end

        function Torque = Torque(obj) %% Total torque (to the origin)
            % Call the Lift and Drag methods
            Lift = obj.Lift();
            Drag = obj.Drag();
            
            % Calculate Torque based on the formula (Drag * z + Lift * x)
            Torque = - Drag * abs(obj.z) + Lift * abs(obj.x);
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
