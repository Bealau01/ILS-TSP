function [n, c, Mdist0] = Nearest_Neighbour(Mcord)

% Mcord -> 2xN matrix with node coordinates
% [n,c] -> solution found with the greedy algorithm and its cost (n is not a cycle)
% Mdist -> distance matrix between nodes

% Function that returns an initial solution found using the Nearest Neighbour greedy algorithm
% A node is chosen randomly
% The smallest edge containing the chosen node is selected (ensuring it does not include a node already chosen previously)
% The solution is constructed

dim=size(Mcord); % Dimension of M 
N=dim(2); % Number of columns-nodes N
x=Mcord(1,:);
y=Mcord(2,:);

inf=100;
Mdist=inf*ones(N); % Initialize the distance matrix

% Create the distance matrix (upper triangular), elements below the diagonal are set to inf

for i=1:(N-1)
for j=(i+1):N   
      Mdist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2); 
end
end

% Since the costs will be modified, store a copy of the distance matrix in Mdist0
Mdist0=Mdist;

p=randi(N); % Select a random starting node to build the solution
n=[p];

% Construct the sequence of nodes to be taken

for i=1:(N-1)
% For the selected node p, check both the rows and columns (which 
% determine the distance of edges with one of the two endpoints being p)
% and choose the smallest one (m1 or m2), identifying the next node
[m1,ns1]=min(Mdist(p,:)); % Find the next node with the minimum distance. m -> minimum distance found, ns -> next node
[m2,ns2]=min(Mdist(:,p)); 

if m1<=m2
    ns=ns1;
else
    ns=ns2;
end

% Once the node with the minimum distance from p is selected,
% update the distances, setting to inf the ones that should not be considered anymore
% (i.e., those related to node p -> p should not be selected again)
Mdist(p,:)=inf*ones(1,N);
Mdist(:,p)=inf*ones(1,N);

n=[n,ns]; % Construct the solution
p=ns; % Iterate the process on the chosen node ns

end

% Cost of the Hamiltonian cycle found
c=costo(n,Mdist0);
