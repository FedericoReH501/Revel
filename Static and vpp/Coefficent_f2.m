function [Cl_f2, Cd_f2] = Coefficent_f2(a)
         Cl_f2 = -0.0002*a.^3 - 6e-5*a.^2 + 0.1145*a + 0.4967;
         Cd_f2 = 4e-7*a.^5 - 4e-6*a.^4 - 2e-5*a.^3 + 0.0005*a.^2 + 2e-5*a + 0.0083;
end