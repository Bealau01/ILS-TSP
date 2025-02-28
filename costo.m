function c = costo(n, Mdist)

% Calculates the cost of a Hamiltonian cycle (distance)
% n is not a cycle
% Make the distance matrix symmetric
%! The diagonal does not have 0, but inf
Mdist = triu(Mdist) + triu(Mdist, 1)';

N = length(n);

% Make n a cycle
n = [n, n(1)];

% Initialize the cost
c = 0;

% Compute the cost of the path
for i = 1:N
    c = c + Mdist(n(i), n(i+1));
end