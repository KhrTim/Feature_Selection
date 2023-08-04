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
    case 'LS'
        idx = UFS_LS(X, m);
        idx = idx';
    case 'UDFS'
        idx = udfs(X, c_num, param(1, 1), param(1, 2));
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
        [~, idx, ~] = EGCFS_TNNLS(X', c_num, param(1, 1), param(1, 2), m);
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
        idx = FMIUFS(X, param(1,1));
        idx = idx(1, 1:m);
    case 'IUFS'
        idx = iufs(X, m);
        idx = idx';
    case 'VCSDFS'
        idx = vcsdfs(X, param(1, 1), m, 100);
        idx = idx(1:m, 1);
        idx = idx';
    case 'PROP'
        switch param(1, 1)
            case 1
        % case 1 class size ew discretize
                X_dis = discretize_width(X, c_num);
                idx = transpose(proposed(X_dis, m));
        % case 2 class size ef discretize
            case 2
                X_dis = discretize_freq(X, c_num);
                idx = transpose(proposed(X_dis, m));
            case 3
                % case 3 10 bin ew discretize
                X_dis = discretize_width(X, 10);
                idx = transpose(proposed(X_dis, m));
            case 4
                % case 4 10 bin ef discretize
                X_dis = discretize_freq(X, 10);
                idx = transpose(proposed(X_dis, m));
            case 5
                % case 5 laim discretize
                Y_copy = double((Y==1:c_num));
                X_dis = discretize_laim(X, Y_copy);
                idx = transpose(proposed(X_dis, m));
        end
    case 'RANK'
        idx = rankufs(X, c_num, param(1, 1), param(1, 2), param(1, 3));
        idx = idx(1:m, 1);
        idx = idx';
end
end

