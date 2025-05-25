function G = cmeans_initialization(X, n, c)
    % Simple initialization: randomly choose c samples as initial centers
    rand_idx = randperm(n, c);
    G = X(:, rand_idx);
end