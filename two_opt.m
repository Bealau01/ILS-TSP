function [n,c] = two_opt(n0,Mdist)

% 2-opt neighborhood
% Generate all moves in the 2-opt neighborhood and find the best solution 
% through exhaustive search (n) with cost c
% If no move is better, it means the current solution is a local optimum for the neighborhood
% There are N*(N-3)/2 ways to select and replace two edges.

N=length(n0);
c0=costo(n0,Mdist);

A=[0,0];

%--------------------------------------------------------------------------
% Construct all possible pairs of non-adjacent edges
% i and j are the left endpoints of the selected edges
% The matrix A contains all pairs of edges (rows)
k=1;

for i=2:N-2
    for j=i+2:N
        A(k,:)=[i,j];
        k=k+1;
    end
end

for j=3:N-1
    A(k,:)=[1,j];
    k=k+1;
end
%--------------------------------------------------------------------------

g_best=0;
n=n0;
c=c0;
%--------------------------------------------------------------------------
% Find the best solution, which minimizes the cost increase
for k0=1:k-1
    pair=A(k0,:); % selected pair (row of matrix A)
    i=pair(1); % Left index of the first edge to be removed
    j=pair(2); % Left index of the second edge to be removed

    P1=n0(1:i);
    P2=n0(i+1:j);
    P3=n0(j+1:N);

    % Compute the new solution by swapping the edges and its cost
    ns=[P1, flip(P2), P3];
    c_ns=costo(ns,Mdist);

    % Compute the cost change by subtracting old solution cost
    gain=c_ns-c0;

    if gain<g_best
        g_best=gain;
        n=ns;
        c=c_ns;
    end

end
%--------------------------------------------------------------------------
