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
    case 'MGAGR'
        [idx, ~,~,~,~] = MGAGR(X, param(1), param(2),param(3),param(4),param(5),param(6));
    case 'MGF2WL'
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
    case 'CDMVFS'
        % param = [alpha, beta, gamma, num_views]
        alpha = param(1);
        beta = param(2);
        gamma = param(3);
        v = param(4);  % number of views to split into
        
        n = size(X, 1); % number of samples
        d = size(X, 2); % total number of features
        class_num = c_num;

        % Ensure divisible feature size (or truncate last few features)
        view_size = floor(d / v);
        fea = cell(1, v);
        for i = 1:v
            start_idx = (i - 1) * view_size + 1;
            if i == v
                end_idx = d; % take remaining features
            else
                end_idx = i * view_size;
            end
            fea{i} = X(:, start_idx:end_idx);
        end

        % Call CDMvFS
        [P, ~] = CDMvFS(fea, alpha, beta, gamma, n, v, class_num);

        % Merge projections
        allP = [];
        for num = 1:v
            allP = [allP; P{num}];
        end

        % Score features using L2 norm
        W1 = vecnorm(allP, 2, 2);  % efficient row-wise norm
        [~, index] = sort(W1, 'descend');
        idx = index(1:m);
    case 'TRCA_CGL'
        [score] = TRCA_CGL(X, X_fea, view_num, N, d, c_num, params);
        [~, index] = sort(score,'descend');
        selecteddata = X_fea(:, index(1 : feaRange(j)));

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
        idx = NDFS(X, 100, param(1, 1), 1, param(1, 2));
        idx = idx(1, 1:m);
    case 'MCFS'
        idx = MCFS_p(X, m);
    case 'MAX_VAR'
        idx = maxvar(X);
        idx = idx(1:m, 1);
        idx = idx';
    case 'CNAFS'
        [~, ~, idx, ~] = CNAFS(X', c_num, param(1, 1), param(1, 2), param(1, 3), param(1, 4));
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
        idx = RUFS(X, c_num, param(1, 1), param(1, 2));
        idx = idx(1:m, 1);
        idx = idx';
    case 'SOCFS'
        idx = SOCFS(X, param(1, 1), param(1, 2));
        idx = idx(1, 1:m);
    case 'U2FS'
        idx = u2fs(X, c_num, m, {});
        idx = idx';
    case 'FMIUFS'
        idx = FMIUFS(X, param(1,1), m);
    case 'FRUAR'
        idx = FRUAR(X, param(1,1), m);
    case 'UAR_HKCMI'
        idx=uar_HKCMI(X,param(1, 1),param(1, 2));
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

