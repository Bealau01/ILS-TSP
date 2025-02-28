function n = perturbation(ni,Mdist)

% Starting from an initial solution ni, finds the perturbed solution n
% Uses a diversification move to escape the local optimum 

pert=5;

switch pert
    case 1
        % Perform double bridge
        n=double_bridge(ni);
    case 2
        % Perform 3-opt            
        [n,c]=three_opt(ni,Mdist);
    case 3
        % Perform 2-opt
        [n,c]=two_opt(ni,Mdist);
    case 4
        % Perform city swap (useful with a reduced number of cities)
        n=city_swap(ni);
    case 5
        % Perform city insert
        n=city_insert(ni);
    case 6
        % Perform certain city swap
        [n,c]=city_swap_c(ni,Mdist);
    case 7
        % Perform certain city insert
        [n,c]=city_insert_c(ni,Mdist);
end
