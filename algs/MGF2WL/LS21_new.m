function W = LS21_new(X_prime, Y, v, gamma)
% LS21_new: Solves for W in min_W ||X_prime' * W - Y||_F^2 + gamma * ||W||_2,1
%   Inputs:
%     X_prime:   Transposed data matrix (features x samples, as X' was passed from Optimize_W)
%     Y:         Target subspace (samples x nClass)
%     v:         An optional weighting vector or parameter. Its usage is unclear without context.
%                Assuming it might be sample weights (samples x 1). If so,
%                the objective could be weighted least squares:
%                min_W ||diag(v) * (X_prime' * W - Y)||_F^2 + gamma * ||W||_2,1
%     gamma:     Regularization parameter for the L2,1-norm.
%
%   Outputs:
%     W:         The optimized projection/weight matrix (features x nClass).

    [n_features, n_samples] = size(X_prime); % X_prime is features x samples
    [~, n_class] = size(Y);

    % Handle 'v' - if it's sample weights, apply them.
    % Assuming v is a column vector of weights for samples.
    if ~isempty(v) && numel(v) == n_samples
        V_diag = diag(v);
        % Weighted least squares:
        % (X_prime * V_diag * X_prime') * W - X_prime * V_diag * Y
        % This applies if W is features x something.
        % If the original problem is min ||(X W - Y)||^2, then with sample weights v, it's
        % min ||diag(v) (X W - Y)||^2 = min (X W - Y)' diag(v)^2 (X W - Y)
        % For X_prime' (samples x features) * W (features x nClass) - Y (samples x nClass)
        % Objective becomes: ||diag(v) * (X_prime' * W - Y)||_F^2
        % Derivative: 2 * X_prime * V_diag^2 * (X_prime' * W - Y) + gamma * D_W * W = 0
        % (X_prime * V_diag^2 * X_prime' + gamma * D_W) * W = X_prime * V_diag^2 * Y
        % Let's use V_diag_sq = V_diag^2 = diag(v.^2)
        V_diag_sq = diag(v.^2);
    else
        % No sample weights or 'v' is used for something else.
        V_diag_sq = eye(n_samples); % Identity matrix for no weighting
    end

    W = zeros(n_features, n_class); % Initialize W

    maxIter = 100;
    tol = 1e-4;

    for iter = 1:maxIter
        W_old = W;

        % --- Step 1: Compute the diagonal weight matrix D_W for L2,1-norm ---
        % D_W(i,i) = 1 / (2 * ||w_i||_2) where w_i is the i-th ROW of W.
        D_W = zeros(n_features, n_features);
        for i = 1:n_features
            row_norm = norm(W(i, :), 2);
            if row_norm < 1e-8
                D_W(i, i) = 1 / (2 * 1e-8);
            else
                D_W(i, i) = 1 / (2 * row_norm);
            end
        end

        % --- Step 2: Update W ---
        % (X_prime * V_diag_sq * X_prime' + gamma * D_W) * W = X_prime * V_diag_sq * Y
        A_mat = X_prime * V_diag_sq * X_prime' + gamma * D_W;
        B_mat = X_prime * V_diag_sq * Y;

        % Solve for W
        W = A_mat \ B_mat;

        % Check for convergence
        if norm(W - W_old, 'fro') / norm(W_old, 'fro') < tol
            break;
        end
    end
end