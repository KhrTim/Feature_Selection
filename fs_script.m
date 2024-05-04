% get result of feature selction
clear;

data_dir = './data/';
% list of data which name has '.mat'
data_list = dir([data_dir, '*.mat']);
data_list = {data_list.name};

fs_dir = './result/';
fs_list = dir([fs_dir, '*.mat']);
fs_list = {fs_list.name};

save_dir = './result_fs/';
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

rep_size = 10;
max_fs_size = 300;
pctRunOnAll warning('off');
%for k = 1:6
for k = 1:length(fs_list)
    k
    load([data_dir data_list{k}]);
    data_name = data_list{k}(1:end-4);
    load([fs_dir strcat(data_name, '.mat')]);
    [~, col] = size(fea);
    max_col = min(max_fs_size, col);
    fs_size = 1:max_col;
    res = struct('alg', {}, 'pdp', {}, 'ent', {},...
        'acc_nb', {}, 'acc_nb_s', {}, 'acc_tree', {}, 'acc_tree_s', {}, ...
        'nmi', {}, 'dis', {}, 'dis_s', {});
    for alg_idx = 1:length(param_struct)
        alg = param_struct(alg_idx).alg;
        res(alg_idx).alg = alg;
        table_pdp = zeros(1, length(fs_size));
        table_ent = zeros(1, length(fs_size));
        table_acc_nb = zeros(1, length(fs_size));
        table_acc_nb_s = zeros(1, length(fs_size));
        table_acc_tree = zeros(1, length(fs_size));
        table_acc_tree_s = zeros(1, length(fs_size));
        table_nmi = zeros(1, length(fs_size));
        table_dis = zeros(1, length(fs_size));
        table_dis_s = zeros(1, length(fs_size));
        fs_list = param_struct(alg_idx).fea;
        if cate_flag == 0
            fea = discretize_width(fea, 10);
        end
        parfor fs_idx = 1:length(fs_size)
            fs = fs_size(fs_idx);
            X_fs = fea(:, fs_list(1:fs));
            table_pdp(1, fs_idx) = uniqueness(X_fs);
            table_ent(1, fs_idx) = ent_s(X_fs);
            [table_acc_nb(1, fs_idx), table_acc_nb_s(1, fs_idx), table_acc_tree(1, fs_idx), table_acc_tree_s(1, fs_idx)] = acc_nb_tree(X_fs, gnd);
            table_nmi(1, fs_idx) = nmi_s(X_fs, gnd);
            [table_dis(1, fs_idx), table_dis_s(1, fs_idx)] = descriacc(X_fs);
        end
        res(alg_idx).pdp = table_pdp;
        res(alg_idx).ent = table_ent;
        res(alg_idx).acc_nb = table_acc_nb;
        res(alg_idx).acc_nb_s = table_acc_nb_s;
        res(alg_idx).acc_tree = table_acc_tree;
        res(alg_idx).acc_tree_s = table_acc_tree_s;
        res(alg_idx).nmi = table_nmi;
        res(alg_idx).dis = table_dis;
        res(alg_idx).dis_s = table_dis_s;
    end
    save_name = strcat(save_dir, data_name, '_fs.mat');
    save_file(save_name, res);
end

function save_file(save_dir, res)
    save(save_dir, 'res');
end
