function n = city_swap(n0)

% n -> mutated vector
% n0 -> vector to be mutated
% city swap consists of randomly swapping two cities
% Example of a neighborhood for S-TSP (used as a diversification move)

N = length(n0);
t = randperm(N);
t1 = t(1); % t1 and t2 are the positions where the cities are swapped
t2 = t(2);

n = n0;
n(t1) = n0(t2);
n(t2) = n0(t1);
