function [Cl_f3,Cd_f3] = Coefficent_f3(a)
          Cl_f3 = -0.0002*a.^3 - 0.0003*a.^2 + 0.1236*a + 0.0037;
          Cd_f3 = -2e-7*a.^5 - 3e-6*a.^4 - 2e-6*a.^3 + 0.0003*a.^2 - 6e-5*a + 0.0091;
end