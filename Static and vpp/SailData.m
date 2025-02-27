%% Sail data
clc; clear; close all;

%% Lift coefficient
% Approximate data from the graph (TWA in degrees, corresponding CL)
TWA_graf = [0 5 10 15 20 25 30 45 60 75 90 105 120 135 150 165 180]; % True Wind Angle (deg)
Cl_graf =  [0 0.8 1.4 1.57 1.6 1.58 1.57 1.5 1.4 1.3 1.1 0.9 0.7 0.5 0.3 0.1 0]; % Lift Coefficient

% Create interpolated points for a smoother curve
TWA_fine = linspace(0, 180, 180);  % More dense TWA values
Cl_fine = interp1(TWA_graf, Cl_graf, TWA_fine, 'spline'); % Spline interpolation

% Plot the graph
figure;
plot(TWA_graf, Cl_graf, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); hold on; % Data points
plot(TWA_fine, Cl_fine, 'b-', 'LineWidth', 2); % Interpolated curve
xlabel('TWA (deg)');
ylabel('Lift Coefficient');
title('Sail Lift Coefficient vs TWA');
grid on;
legend('Extracted Data', 'Spline Interpolation');

%% Drag coefficient
% Definition of approximate data from the graph
TWA_graf = [0, 10, 30, 50, 70, 90, 110, 130, 150, 170, 180]; % True Wind Angle (deg)
Cd_graf  = [0.05, 0.03, 0.1, 0.25, 0.45, 0.65, 0.9, 1.1, 1.25, 1.35, 1.38]; % Drag Coefficient

% Interpolation for a smooth curve
TWA_fine = linspace(0, 180, 180); % More points for the curve
Cd_fine = interp1(TWA_graf, Cd_graf, TWA_fine, 'spline'); % Spline interpolation

% Plot the interpolated function
figure;
plot(TWA_graf, Cd_graf, 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Original points
hold on;
plot(TWA_fine, Cd_fine, 'b-', 'LineWidth', 2); % Interpolated curve
grid on;
xlabel('TWA (deg)');
ylabel('Drag Coefficient');
title('Interpolation of Sail Aerodynamic Drag');
legend('Estimated Data', 'Spline Interpolation', 'Location', 'NorthWest');

%% save data
save ('SailCoefficent.mat','Cl_fine','Cd_fine'); %save Cl_fine in dati.mat

