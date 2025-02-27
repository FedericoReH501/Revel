function solver(eq1 ,eq2 ,eq3 ,x1 ,x2 ,x3 , ranges)
    
    sol = vpasolve([eq1, eq2, eq3], [x1, x2, x3], ranges);

    vb_sol = double(sol.vb);
    thetaL_sol = double(sol.thetaL);
    x_crew_sol = double(sol.x_crew);


    disp(['Boat speed (vb):               ', num2str(vb_sol), ' m/s']);
    disp(['Boat pitch angle (thetaL):     ', num2str(thetaL_sol), ' degrees']);
    disp(['Crew longitudinal pos (x_crew):', num2str(x_crew_sol), ' m']);
    disp(' ');

end