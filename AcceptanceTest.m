function b = AcceptanceTest(n,n1,Mdist,his,tol)

% Determines whether the new solution found with local search (starting from the perturbed solution) 
% should be accepted or not

% The function returns true if n1 is accepted and false otherwise (b is a boolean)
% n -> old solution
% n1 -> new solution

% Accepted if the cost of n1 is less than n+tol and if n1 is not a 
% previously visited local optimum (i.e., it is not a row of the history matrix)

c = costo(n, Mdist);
c1 = costo(n1, Mdist);

if c1 < c + tol && ~any(all(his == n1, 2)) 
    b = true;
else 
    b = false;
end
