function [n,c,it] = LS(n0,Mdist)

maxit=100; 
it=0;
c0=costo(n0,Mdist);
tol=0; % Tolerance for solution in local search, used for city swap and city insert
cbest=c0; % Initialize best cost
nbest=n0; % Initialize best solution

LocalSearch=6;

% LS stops if the same local optimum as the previous one is found or
% if a predetermined maximum number of iterations is reached
while it<maxit 

    switch LocalSearch
        case 1
        % LS with 2-opt neighborhood
        [n,c]=two_opt(n0,Mdist);

        % Check to verify the diversity of the new local optimum compared
        % to the previous one:
        if all(n==n0) % if the new local optimum is the same -> stop, same attraction basin
            break;
        else % otherwise, continue searching for the local optimum 
            n0=n;
        end

        case 2
        % LS with 3-opt neighborhood
        [n,c]=three_opt(n0,Mdist);

        if all(n==n0) % if the new local optimum is the same -> stop, same attraction basin
            break;
        else % otherwise, continue searching for the local optimum
            n0=n;
        end

        case 3
        % LS with city_insert neighborhood
        n=city_insert(n0);
        c=costo(n,Mdist);

        % (if there is no improvement or slight worsening)
        if c>cbest+tol % if n is worse than the best solution within a certain tolerance 
            n0=n; % try another insertion
        end
        % Otherwise, continue from the newly found one
        
        % Keep track of the best solution found and its cost
        % to return it as output
        if c<cbest
            cbest=c;
            nbest=n;
        end

        case 4
        % LS with city_swap neighborhood
        n=city_swap(n0);
        c=costo(n,Mdist);

        if c>cbest+tol % if n0 is better than n within a certain tolerance
            n0=n; % try another swap
        end 
        % Otherwise, continue from the newly found one

        % Keep track of the best solution found and its cost
        % to return it as output
        if c<cbest
            cbest=c;
            nbest=n;
        end

        case 5
        % LS with city_swap_c neighborhood
        [n,c]=city_swap_c(n0,Mdist);
        
        if all(n==n0) % If there is no more improvement, stop -> local optimum 
            break;
        else % Otherwise, continue
            n0=n;
        end

        case 6
        % LS with city_insert_c neighborhood
        [n,c]=city_insert_c(n0,Mdist);
        
        if all(n==n0) % If there is no more improvement, stop -> local optimum 
            break;
        else % Otherwise, continue
            n0=n;
        end

    end

    % Keep track of the number of iterations executed
    it=it+1;
end

% In the case of random city insert and city swap, return the best solution
% and its related cost found in maxit iterations
if LocalSearch==3||LocalSearch==4
    n=nbest;
    c=cbest;
end