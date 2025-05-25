function idx = ufs_alg(name, X, Y, max_fea, param)
if max_fea > size(X, 2)
    m = size(X, 2);
else
    m = max_fea;
end
if size(Y, 2) > 1
    c_num = 2;
else
    c_num = length(unique(Y));
end
switch name
    case 'SLNMF'
        [n, d] = size(X);
        class_num = c_num; 
        r = class_num; 
        l = 20; NIter = 50;
        W = rand(d, class_num);
        H = rand(class_num, d);
        G = rand(class_num, r);

        % Regularization parameters
        alpha = param(1);
        beta = param(2);
        beta1 = param(3);
        gamma = param(4);

        % Run
        [X_new, id]= SLNMF(class_num, X, W, H, G, alpha, beta, beta1, gamma, r, l, NIter);
        idx = id(1:m);
    case 'GRSSLSF'
        B = eye(size(X,2));           % Identity basis
        BB = (B')*B;
        BX = X*(B');
        A = X' * X;                   % Simple dot-product similarity
        P = diag(sum(A,2));

        alpha = param(1);
        beta = param(2);
        gamma = param(3);
        itermax = 30;

        idx = GRSSLFS(X, BB, BX, P, A, alpha, beta, gamma, m, itermax);
    case 'RAFG'
        XT = X';
        alpha = param(1);
        beta = param(2);
        nClass = c_num;
        p = 1;                    % Optional
        k = 5;                    % Optional
        [~, id, ~] = RAFG(XT, alpha, beta, nClass, p, k);
        idx = id(1:m);
    case 'UDS2FS'
        % cant download the package
        [W,~,~] = UDS2FS(X,c_num, m, param(1));
        feature_scores = sum(W.^2, 2);
        [~, sorted_idx] = sort(feature_scores, 'descend');
        idx = sorted_idx(1:20);
    case 'SSDS'
        % Parameters
        c = c_num;              % desired cluster number
        alpha = param(1);        % balance between reconstruction and projection
        beta = param(2);        % sparsity regularization
        gamma = param(3);        % graph regularization
        NITER = 2;         % number of iterations
        group_num = 5;      % divide features into 5 groups
        sigma = param(4);        % Gaussian similarity bandwidth

        % Call the SSDS function
        [Z, score, index] = SSDS(X, c, alpha, beta, gamma, NITER, group_num, sigma);

        % Get top-m feature indices
        idx = index(1:m);
    case 'RUSLP'
        [n, d] = size(X);
        W = rand(d, m);
        F = orth(rand(m, d))';   % orthogonal basis
        G = rand(n, m);

        % Construct Laplacian matrix L (you can also use an existing one)
        S = X * X';                       % Similarity matrix (or use k-NN)
        D = diag(sum(S, 2));             % Degree matrix
        L = D - S;                       % Unnormalized Laplacian

        % Regularization parameters (tune these)
        lambda1 = param(1);
        lambda2 = param(2);
        lambda3 = param(3);%1;
        lambda4 = param(4);%1e-3;
        ITER1 = 30;
        ITER2 = 5;

        [~, feature_idx] = RUSLP(X, m, W, F, G, L, lambda1, lambda2, lambda3, lambda4, ITER1, ITER2);

        % Select top-k features
        top_k = m;
        idx = feature_idx(1:top_k);
    case 'UFS2'
        [b,~,~] = UFS2(X,c_num,param(1),m);
        idx = find(b == 1);
    case 'FSDK'
        [~,~,~,idx,~,~] = FSDK(X,c_num,m,param(1),param(2));
    case 'DFGOC'
        % problem with params
        XTX = X' * X;
        XTX_inv = pinv(XTX);
        [n, d] = size(X);
        c = c_num;
        W = randn(d, c);

        options.NeighborMode = 'KNN';
        options.k = 5;
        options.WeightMode = 'HeatKernel';
        options.t = 1;
        S = lapgraph(X, options);
        D = diag(sum(S, 2));
        L_dat = D - S;

        S_fea = lapgraph(X', options);
        D_fea = diag(sum(S_fea, 2));
        L_fea = D_fea - S_fea;

        alpha = param(1);
        beta = param(2);
        lambd = param(3);
        miu = param(4);
        [idx, ~, ~] = DFGOC(X, XTX, XTX_inv, W, alpha, beta, lambd, miu, c, L_dat, L_fea, m);
    case 'LRPFS'
        options.NeighborMode = 'KNN';
        options.k = 5;
        options.WeightMode = 'HeatKernel';
        options.t=1;
        S = lapgraph(X, options);
        D = diag(sum(S));
        [~, ~, ~, ~, ~, idx] = LRPFS(X, c_num, D, param(1), param(2), m, param(3));
    case 'RSOBC'
        [obj, W,obj_w] = RSC_v(X, c_num, param(1), param(2));
        row_norms = sqrt(sum(W.^2, 2));  % ℓ2 norm of each row (feature)

        [~, sorted_indices] = sort(row_norms, 'descend');  % Sort by importance
        idx = sorted_indices(1:m);           % Top-k indices

    case 'MGAGR'
        [idx, ~,~,~,~] = MGAGR(X, param(1), param(2),param(3),param(4),param(5),param(6));
    case 'MGF2WL'
        % Problems with sizes
        Ai = construct_multiple_graphs(X);
        lambda = param(1);
        gamma = param(2);
        [ ~,v,~,~,obj ] = MGF2WL( X',Ai,lambda,gamma,c_num);
        % X: Original data
        % Ai: multiple graphs
        % lambda2,lambda1: two paras
        % c no. of classes
        [~,idx]=sort(v,'descend');
        % idx is the feature index sorted in decending order
    case 'JMVFG'
        eta = param(1);
        gamma = param(2);
        beta = param(3);
        X_multi = {X};  % Converts single-view to multi-view format for JMVFG
        [ranking, ~, ~] = JMVFG(X_multi, eta, gamma, beta, c_num);
        idx = ranking(1:m);
    case 'LS'
        idx = UFS_LS(X, m);
        idx = idx';
    case 'UDFS'
        idx = udfs(X, c_num, param(1), param(2));
        idx = idx(1, 1:m);
    case 'NDFS'
        idx = NDFS(X, 100, param(1), 1, param(2));
        idx = idx(1, 1:m);
    case 'MCFS'
        idx = MCFS_p(X, m);
    case 'MAX_VAR'
        idx = maxvar(X);
        idx = idx(1:m, 1);
        idx = idx';
    case 'CNAFS'
        [~, ~, idx, ~] = CNAFS(X', c_num, param(1), param(2), param(3), param(4));
        idx = idx(1:m, 1);
        idx = idx';
    case 'DUFS'
        idx = dufs();
        idx = idx(1:m, 1);
        idx = idx';
    case 'EGCFS'
        [~, idx, ~] = EGCFS_TNNLS(X', c_num, param(1), param(2), m);
        idx = idx(1:m, 1);
        idx = idx';
    case 'RUFS'
        % cant download the package
        idx = RUFS(X, c_num, param(1), param(2));
        idx = idx(1:m, 1);
        idx = idx';
    case 'SOCFS'
        idx = SOCFS(X, param(1), param(2));
        idx = idx(1, 1:m);
    case 'U2FS'
        idx = u2fs(X, c_num, m, {});
        idx = idx';
    case 'FMIUFS'
        idx = FMIUFS(X, param(1), m);
    case 'FRUAR'
        idx = FRUAR(X, param(1), m);
    case 'UAR_HKCMI'
        idx=uar_HKCMI(X,param(1),param(2));
    case 'VCSDFS'
        idx = vcsdfs(X, param(1), m, 100);
        idx = idx(1:m, 1);
        idx = idx';
    case 'PROP'
        idx = transpose(proposed(X, m));
    case 'PROPQ'
        idx = transpose(proposed_quad(X, m));
    case 'PROP_REV'
        idx = transpose(proposed_reverse(X, m));
    case 'RANK'
        idx = rankufs(X, c_num, param(1, 1), param(1, 2), param(1, 3));
        idx = idx(1:m, 1);
        idx = idx';
end
end

