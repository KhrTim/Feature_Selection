% get result of feature selction
clear;
list = dir('result');
list = list(3:end);

rep_size = 50;
max_fs_size = 300;

for k = 1:length(list)
    file_name = list(k).name;
    data_name = replace(file_name, '_exp', '');
    load(data_name);
    load(file_name);
    [~, col] = size(X);
    max_col = min(max_fs_size, col);
    fs_size = 50:50:max_col;
    res = struct('alg', {}, 'acc', {}, 'acc_std', {}, 'nmi', {}, 'nmi_std', {});
    for alg_idx = 1:length(param_struct)
        alg = param_struct(alg_idx).alg;
        param = param_struct(alg_idx).param;
        acc_table = zeros(length(param), length(fs_size));
        nmi_table = zeros(length(param), length(fs_size));
        for param_idx = 1:length(param)
            acc_std_table = zeros(length(param), length(fs_size));
            nmi_std_table = zeros(length(param), length(fs_size));
            fs_list = param_struct(alg_idx).fea;
            fea = fs_list(param_idx,:);
            for fs_idx = 1:length(fs_size)
                fs = fs_size(fs_idx);
                X_fs = X(:, fea(1:fs));
                [acc, nmi] = kmeans_rng(X_fs, Y, rep_size);
                acc_table(param_idx, fs_idx) = acc(1,1);
                acc_std_table(param_idx, fs_idx) = acc(1,2);
                nmi_table(param_idx, fs_idx) = nmi(1,1);
                nmi_std_table(param_idx, fs_idx) = nmi(1,2);
            end
        end
        res(alg_idx).alg = alg;
        res(alg_idx).acc = acc_table;
        res(alg_idx).acc_std = acc_std_table;
        res(alg_idx).nmi = nmi_table;
        res(alg_idx).nmi_std = nmi_std_table;
    end
    save_name = replace(file_name, '_exp', '_res');
    save(save_name, 'res');
end
