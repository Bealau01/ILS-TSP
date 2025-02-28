function vm = double_bridge(v)

%--------------------------------------------------------------------------
% Select 4 randomly permissible (non-adjacent) edges, identified by 4 nodes
% (left node of the edge)
num_sel = 4; % Number of nodes to select
ind_sel = []; % Vector of selected indices
N = length(v);
j = 1;
M = N;

% Select 4 nodes that are not adjacent
while length(ind_sel) < num_sel
    % Generate a random node
    i = randi([j, M]);
    
    % Check if the node is not adjacent to the others selected
    if isempty(ind_sel) || all(abs(ind_sel - i) > 1)
        if i == 1
            M = N-1;
        elseif i == N
            j = 2;
        end
        ind_sel = [ind_sel, i];
    end
end

% Indices of selected nodes
ind_sel = sort(ind_sel);

% Selected nodes
% nodes_sel = v(ind_sel);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Change the connections
ia = ind_sel(1);
ib = ia + 1;

ic = ind_sel(2);
id = ic + 1;

ie = ind_sel(3);
i_f = ie + 1;

ig = ind_sel(4);
ih = ig + 1;

P1 = v(1:ia);
P2 = v(ib:ic);
P3 = v(id:ie);
P4 = v(i_f:ig);
P5 = v(ih:N);

vm = [P1, P4, P3, P2, P5]; % Final solution found with double bridge
%--------------------------------------------------------------------------
