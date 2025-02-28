function [n,c] = three_opt(n0,Mdist)

% Construct all admissible triples of edges to be removed (they must not be adjacent)
% For each of these, build the 4 solutions obtainable by combining the
% edges to obtain a Hamiltonian cycle (discard the three combinations that
% would produce a 2-opt since they swap only 2 of the 3 edges)
% Choose the best one based on the cost of the new solution produced

N=length(n0);
A=zeros(1,3);
count=1;
c0=costo(n0,Mdist);
gbest_ass=0; % Initialize the best gain among all found solutions
cbest_ass=c0; % Initialize the best cost among all found solutions
nbest_ass=n0; % Initialize the best solution among all

%--------------------------------------------------------------------------
% Construct all admissible triples: i,j,k are the indices of the left
% end of the edge
for i=2:(N-4)
    for j=i+2:(N-2)
        for k=j+2:N
            A(count,:)=[i,j,k];
            count=count+1;
        end
    end
end

for j=3:N-3
    for k=j+2:N-1
        A(count,:)=[1,j,k];
        count=count+1;
    end
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% For each of these triples, construct P1,P2,P3,P4 and generate the 4
% admissible cycles, computing their cost and choosing the best one for each triple

n0=[n0,n0(1)];

for counter=1:count-1
    triple=A(counter,:); % Selected triple
    i=triple(1); % Index indicating the left node of the first selected edge
    j=triple(2); % Index indicating the left node of the second selected edge
    k=triple(3); % Index indicating the left node of the third selected edge

    P1=n0(1:i);
    P2=n0(i+1:j);
    P3=n0(j+1:k);
    P4=n0(k+1:N);

    % Construct the 4 solutions and their cost:
    S1=[P1,flip(P3),P2,P4];
    c1=costo(S1,Mdist);
    S2=[P1,P3,flip(P2),P4];
    c2=costo(S2,Mdist);
    S3=[P1,P3,P2,P4];
    c3=costo(S3,Mdist);
    S4=[P1,flip(P2),flip(P3),P4];
    c4=costo(S4,Mdist);

    S=[S1;S2;S3;S4];
    costs=[c1,c2,c3,c4];

    % Cost of solution with new edges - initial solution cost = cost of inserted edges - cost of removed edges
    gain=[c1-c0,c2-c0,c3-c0,c4-c0]; 
    % Choose the best among the 4
    [gbest,ind_gbest]=min(gain);
    cbest=costs(ind_gbest);

    % Update the best found solution and its cost
    if gbest < gbest_ass
        gbest_ass=gbest;
        cbest_ass=cbest;
        nbest_ass=S(ind_gbest,:);
    end

end
%--------------------------------------------------------------------------

% Return the best found solution and its cost
n=nbest_ass;
c=cbest_ass;
