clear all
close all
clc

rng(40);

N=20; %number of cities to visit
maxit=150; %maximum number of iterations
tol=0; %Accepted tolerance for worsening of the local optimum (objective function)

fprintf('Number of cities to visit: %d \n',N);

%--------------------------------------------------------------------------
%INSTANCE GENERATION
% Generate the position of the cities randomly on a map of length b and
% height h
b=10; h=10; %can also be input values
%rand(n,m) -> generates an nxm matrix containing random values between 0 and 1
x=b*rand(1,N);  %generate x coordinates of points between 0 and b
y=h*rand(1,N);  %generate y coordinates of points between 0 and h

Mcord=[x;y]; %Matrix of node coordinates

nomi = cell(1, N);
for i = 1:N
    nomi{i} = num2str(i);
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%GENERATE INITIAL SOLUTION (n0)
%Initial solution vector found with greedy Nearest Neighbour and its cost
[n0,c0,Mdist]=Nearest_Neighbour(Mcord);

%Randomly generated solution (not good, if I use this as an initial solution,
%the LS performs many iterations before reaching the local optimum)
%n0=randperm(N);
%c0=costo(n0,Mdist);

figure;
subplot(1,3,1);
%visualize the cities on a map with the best path found by the greedy NN algorithm
%x and y permuted with the addition of the last node to form a Hamiltonian cycle
x_perm0=[x(n0),x(n0(1))];
y_perm0=[y(n0),y(n0(1))];

plot(x,y,'ok',x_perm0,y_perm0,'r-');
title('Initial solution found with greedy');

for i = 1:numel(nomi)
    text(x(i), y(i), nomi{i}, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
end

%Print the best solution found
%disp('Solution initially found with NN:'); disp(n0);
fprintf('Cost of the solution found with NN: %f \n',c0);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%INITIAL LOCAL SEARCH
%Perform a Local Search on the initial solution n0 and find a local optimum n
subplot(1,3,2);
[n,c,it]=LS(n0,Mdist);
x_perm2=[x(n),x(n(1))];
y_perm2=[y(n),y(n(1))];
plot(x,y,'ok',x_perm2,y_perm2,'r-');
title('Initial Local Search');

for i = 1:numel(nomi)
    text(x(i), y(i), nomi{i}, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
end

%Print the solution found with the initial LS, its cost, and the iterations used to find it
%disp('Solution found with initial LS:'); disp(n);
fprintf('Cost of the solution found with initial LS: %f \n',c);
fprintf('Initial LS iterations: %d \n',it); 
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%MAIN WHILE LOOP ILS

%Parameter initialization
iterations=0;
it_senza_migl=0;
maxit_senza_migl=30;
his=n; % history: keeps track of already visited local optima
costi=[c]; %keeps track of the costs of the accepted local optimal solutions in ILS
costi_tot=[c]; %keeps track of the costs of all local optimal solutions found in ILS

%Keep track of the best solution found, its cost, and the iteration in which it was found
cbest=c;
nbest=n;
itbest=0;

accettate=0; %Keeps track of accepted solutions


while iterations<maxit && it_senza_migl<maxit_senza_migl

    np=perturbation(n,Mdist); %Perturbation (diversification move to escape local optimum) np->perturbed move of n
    [n1,c1,it1]=LS(np,Mdist); %Local search on the perturbed solution np -> find local optimum n1

    b=AcceptanceTest(n,n1,Mdist,his,tol);
    if b==true
        n=n1;
        it_senza_migl=0; %A new local optimal solution is found, reset the iteration count
        
        if(c1<cbest)
            cbest=c1;
            nbest=n;
            itbest=iterations;
        end
       
        his=[his;n];
        costi=[costi,c1];
        accettate=accettate+1;
    else
        it_senza_migl=it_senza_migl+1;
    end 
    
    costi_tot=[costi_tot, c1];
    
    fprintf('%d-th local search - Iterations: %d  Cost: %f  Acceptance status: %d \n',iterations,it1,c1,b);
    
    iterations=iterations+1;
end
%--------------------------------------------------------------------------


%Print the reason why ILS stopped
if(iterations==maxit)
    fprintf('Stall reason: maximum number of iterations reached. \n');
elseif(it_senza_migl==maxit_senza_migl)
    fprintf('Stall reason: maximum number of iterations without improvement reached. \n');
end


subplot(1,3,3);
x_perm3=[x(n),x(n(1))];
y_perm3=[y(n),y(n(1))];
plot(x,y,'ok',x_perm3,y_perm3,'r-');
title('ILS');

for i = 1:numel(nomi)
    text(x(i), y(i), nomi{i}, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
end

%--------------------------------------------------------------------------
%BEST SOLUTION FOUND
if c==cbest
    fprintf('The best solution was found with the first LS, with cost: %f \n',c);
else
    fprintf('Cost of the best solution found with ILS at the %d-th iteration: %f \n',itbest,cbest);
end
%--------------------------------------------------------------------------


figure;
subplot(1,2,1);
semilogy((0:accettate),costi,'b-');
title('Cost of accepted local optimal solutions');
xlabel('Accepted local optima');
ylabel('Solution cost');

subplot(1,2,2);
plot(0:iterations,costi_tot,'b-');
title('Cost of local optimal solutions');
xlabel('Found local optima');
ylabel('Solution cost');

fprintf('Number of accepted local optima with worsening tolerance=%d: %d \n',tol,accettate);
fprintf('Path saved with ILS compared to greedy: %f \t In percentage: %f \n',c0-cbest,100*(c0-cbest)/c0);
fprintf('Path saved with Local Search compared to greedy: %f \t In percentage: %f \n',c0-c,100*(c0-c)/c0);
fprintf('Path saved with ILS compared to Local Search: %f \t In percentage: %f \n',c-cbest,100*(c-cbest)/c);
