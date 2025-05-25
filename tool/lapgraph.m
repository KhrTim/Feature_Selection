function L = lapgraph(X, options)
    % Simple graph Laplacian example using k-nearest neighbors and heat kernel
    % X: data samples (d x n)
    % options.k: number of neighbors
    % options.t: heat kernel parameter
    
    n = size(X, 2);
    k = options.k;
    t = options.t;
    
    % Compute pairwise distances
    D = squareform(pdist(X'));
    
    % Construct adjacency matrix W with kNN and heat kernel
    W = zeros(n,n);
    for i = 1:n
        [~, idx] = sort(D(i,:));
        neighbors = idx(2:k+1);  % exclude itself
        for j = neighbors
            W(i,j) = exp(-D(i,j)^2 / (2*t^2));
            W(j,i) = W(i,j); % symmetric
        end
    end
    
    % Degree matrix
    Dg = diag(sum(W, 2));
    
    % Graph Laplacian
    L = Dg - W;
end
