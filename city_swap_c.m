function [nbest, c] = city_swap_c(n0, Mdist)

% Finds the best permutation of two cities that minimizes the path
% and returns the best solution found with the corresponding cost.
% If there is no improvement, it returns the initial solution.

c0 = costo(n0, Mdist);
N = length(n0);
A = [0, 0];

% Construct all possible permutations in matrix A
k = 1;
for i = 1:N-1
    for j = i+1:N
        A(k, :) = [i, j];
        k = k + 1;
    end
end

% Compute the cost of each permutation
for cont = 1:k-1
    i = A(cont, 1);
    j = A(cont, 2);
    n = n0;
    n(i) = n0(j);
    n(j) = n0(i);
    cost = costo(n, Mdist);
    % Add a third column to matrix A with the costs of the permutations
    A(cont, 3) = cost;
end

% Find the best permutation and its cost
[c, posbest] = min(A(:, 3));

permbest = A(posbest, 1:2); % Best permutation
% Permutation indices
i = permbest(1); 
j = permbest(2);

% Find the solution given by the best permutation that minimizes the cost
nbest = n0;
nbest(i) = n0(j);
nbest(j) = n0(i);

% If no city swap improved the solution, return the initial solution
if (c0 < c) 
    c = c0;
    nbest = n0;
end
