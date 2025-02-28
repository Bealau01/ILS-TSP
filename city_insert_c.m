function [nbest, cbest] = city_insert_c(n0, Mdist)

% Finds the best insertion of a city in another position that minimizes the path
% and returns the best solution found with the corresponding cost.
% If there is no improvement, it returns the initial solution.

c0 = costo(n0, Mdist);
cbest = c0;
nbest = n0;
N = length(n0);
A = n0; % Initialize matrix with all possible city inserts
k = 1; % Initialize counter
costi = [0, 0]; % Initialize cost vector for each possible city_insert

for i = 1:N
    city = n0(i);
    for j = 1:N  
        if i < j
            A(k, :) = [n0(1:i-1), n0(i+1:j), city, n0(j+1:N)];
            costi(k) = costo(A(k, :), Mdist);
            k = k + 1;
        elseif j < i
            A(k, :) = [n0(1:j-1), city, n0(j:i-1), n0(i+1:N)];
            costi(k) = costo(A(k, :), Mdist);
            k = k + 1;
        end
    end
end

[cmin, pos_min] = min(costi);

if cmin < cbest
    cbest = cmin;
    nbest = A(pos_min, :);
end