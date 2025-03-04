function sol = symSolver(eqns, vars)
    assume(vars, 'real');
    sol = solve(eqns, vars, 'ReturnConditions', true);

    % Check if a solution is found by examining the fields.
    solFields = fieldnames(sol);
    found = false;
    for i = 1:length(solFields)
        % Check each variable field; if any field is non-empty, we assume a solution exists.
        if ~isempty(sol.(solFields{i}))
            found = true;
            break;
        end
    end

    if found
        disp('Solution found:');
        disp(sol);
    else
        disp('Not able to find solution.');
    end
end
