function n = city_insert(n0)

% n0 -> solution to be mutated
% n -> mutated solution

N = length(n0);

i = randi(N);
city = n0(i);
j = randi(N);

% Ensure the vector does not remain unchanged
while i == j || abs(i - j) == 1 
    j = randi(N);
end

if i < j
    n = [n0(1:i-1), n0(i+1:j), city, n0(j+1:N)];
else
    n = [n0(1:j-1), city, n0(j:i-1), n0(i+1:N)];
end
