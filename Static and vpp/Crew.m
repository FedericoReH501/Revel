classdef Crew
    properties (Constant)
        z = 0.85;           % Vertical position of crew's center of gravity (m)
    end
    
    properties
        mass;  % Mass of the crew member (kg)
        range;
    end
    
    methods
        % Constructor to initialize mass
        function obj = Crew(mass,range)
            if nargin > 0
                obj.mass = mass;  % Initialize mass if provided
                obj.range = range;
            end
        end
        
        % Method to calculate the weight (mass * g)
        function weight = Weight(obj)
            global g;  % Access the global variable g
            weight = obj.mass * g;  % Calculate weight using mass and global g
        end
        
        % Method to display crew's constant properties
        function displayInfo(obj)
            fprintf('Crew x-range: [%.2f, %.2f] m\n', Crew.crew_Range(1), Crew.Range(2));
            fprintf('Crew z-position: %.2f m\n', Crew.z_crew);
            fprintf('Crew mass: %.2f kg\n', obj.mass);
        end
    end
end
