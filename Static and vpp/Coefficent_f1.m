function [Cf_f1, Cd_f1] = Coefficent_f1(a)
          Cf_f1 = -0.0002*a.^3 - 8*10^(-5)*a.^2 + 0.1128*a + 0.4;
          Cd_f1 = 2*10^(-7)*a.^5 - 2*10^(-6)*a.^4 - 1*10^(-5)*a.^3 + 0.0003*a.^2 - 0.0004*a + 0.0103;
end