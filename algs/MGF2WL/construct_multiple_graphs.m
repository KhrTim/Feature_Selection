function Ai = construct_multiple_graphs(X)

% X: Original data matrix (d features x n samples)

[d, n] = size(X); % d = number of features, n = number of samples
k_knn = 10;       % k for KNN graphs as specified in the paper
m_graphs = 5;     % Total number of graphs

Ai = zeros(n, n, m_graphs); % Initialize Ai: n x n x m_graphs

% Ensure X is transposed if your distance functions expect samples as rows
% pdist2 and pdist typically expect samples as rows.
X_samples_as_rows = X'; % n samples x d features

%% Calculate pairwise Euclidean distances (needed for heat kernel and binary graphs)
% This avoids recalculating it multiple times
DistSq_Euclidean = squareform(pdist(X_samples_as_rows, 'euclidean').^2); % Squared Euclidean distances
Dist_Euclidean = sqrt(DistSq_Euclidean); % Euclidean distances

% Calculate average Euclidean distance (needed for heat kernel graphs)
% Exclude self-distances (diagonal is 0)
non_zero_distances = Dist_Euclidean(Dist_Euclidean > 0);
avg_euclidean_distance = mean(non_zero_distances(:));
% Or, if you prefer to take the mean of all distances, including 0 on diagonal:
% avg_euclidean_distance = mean(Dist_Euclidean(:));


%% Graph 1, 2, 3: Heat Kernel Graphs
% Formula: S_ij = exp(- ||xi - xj||^2 / (2 * t * d_bar))
% d_bar is avg_euclidean_distance
t_values = [0.1, 1, 10];
graph_idx_counter = 1;

for t = t_values
    fprintf('Constructing Heat Kernel Graph with t = %.1f...\n', t);
    
    % Calculate the full similarity matrix for this t
    S_heat_kernel_full = exp(-DistSq_Euclidean / (2 * t * avg_euclidean_distance));
    
    % Now apply KNN selection (k=10)
    S_heat_kernel_knn = zeros(n, n);
    
    % Find k_knn nearest neighbors based on the Euclidean distance (the base for the kernel)
    % This is crucial: the KNN selection is based on the *original* distance, not the kernel value.
    % The paper says "five traditional and simple predefined KNN graphs ... three heat kernel graphs"
    % This implies the *structure* of the graph (which edges exist) is KNN based on Euclidean distance,
    % but the *weights* on those edges are given by the heat kernel.
    
    [~, sorted_indices] = sort(Dist_Euclidean, 2); % Sort based on Euclidean distance
    
    for i = 1:n
        % Get k_knn nearest neighbors for point i (excluding itself)
        neighbors = sorted_indices(i, 2:k_knn+1);
        
        % Assign heat kernel weight to the edges with these neighbors
        for j_idx = 1:length(neighbors)
            j = neighbors(j_idx);
            S_heat_kernel_knn(i, j) = S_heat_kernel_full(i, j);
        end
    end
    
    % Make the graph symmetric (if not already done by construction)
    % It's often good practice for similarity graphs in spectral methods
    S_heat_kernel_knn = max(S_heat_kernel_knn, S_heat_kernel_knn');
    
    % Ensure no self-loops with weight (diagonal should be 0 or 1, often 0 for graph Laplacian)
    S_heat_kernel_knn = S_heat_kernel_knn - diag(diag(S_heat_kernel_knn)); % Set diagonal to 0
    
    Ai(:,:,graph_idx_counter) = S_heat_kernel_knn;
    graph_idx_counter = graph_idx_counter + 1;
end


%% Graph 4: Binary Graph (Euclidean distance, k=10 KNN)
fprintf('Constructing Binary Graph...\n');
S_binary = zeros(n, n);

% Find k_knn nearest neighbors based on Euclidean distance
[~, sorted_indices] = sort(Dist_Euclidean, 2);

for i = 1:n
    neighbors = sorted_indices(i, 2:k_knn+1);
    S_binary(i, neighbors) = 1;
end

% Make symmetric
S_binary = max(S_binary, S_binary');

% Ensure no self-loops
S_binary = S_binary - diag(diag(S_binary));

Ai(:,:,graph_idx_counter) = S_binary;
graph_idx_counter = graph_idx_counter + 1;


%% Graph 5: Cosine Graph (k=10 KNN)
fprintf('Constructing Cosine Graph...\n');
S_cosine = zeros(n, n);

% Calculate Cosine Similarity for all pairs
% Cosine similarity is dot product divided by product of magnitudes
% It ranges from -1 to 1. Higher values mean more similar.
% If X is normalized (columns sum to 1 or have unit L2 norm), then X'*X gives cosine similarity.
% Assuming X is your original d x n data matrix
% Normalize columns of X (samples) to unit L2 norm
X_norm = X ./ sqrt(sum(X.^2, 1));
Cosine_Sim_full = X_norm' * X_norm; % This will be n x n

% Find k_knn nearest neighbors based on Cosine Similarity (not distance)
% For similarity, higher values mean closer, so we sort in descending order.
[~, sorted_indices_cosine] = sort(Cosine_Sim_full, 2, 'descend');

for i = 1:n
    % Get k_knn nearest neighbors for point i (excluding itself, which is similarity 1)
    % The first element will be itself (similarity 1), so start from 2.
    neighbors_cosine = sorted_indices_cosine(i, 2:k_knn+1);
    
    % Assign cosine similarity as weight to the edges with these neighbors
    for j_idx = 1:length(neighbors_cosine)
        j = neighbors_cosine(j_idx);
        S_cosine(i, j) = Cosine_Sim_full(i, j);
    end
end

% Make symmetric
S_cosine = max(S_cosine, S_cosine');

% Ensure no self-loops (diagonal is already 1, set to 0)
S_cosine = S_cosine - diag(diag(S_cosine));

Ai(:,:,graph_idx_counter) = S_cosine;
% graph_idx_counter is now 6, but we're done.

end