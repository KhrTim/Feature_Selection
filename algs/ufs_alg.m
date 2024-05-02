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
        idx = FMIUFS(X, param(1,1), m);
    case 'FRUAR'
        idx = FRUAR(X, param(1,1), m);
    case 'UAR_HKCMI'
        idx=uar_HKCMI(X,param(1, 1),param(1, 2));
    case 'IUFS'
        idx = iufs(X, m);
        idx = idx';
    case 'VCSDFS'
        idx = vcsdfs(X, param(1, 1), m, 100);
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

