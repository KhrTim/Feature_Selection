clear;

data_dir = './data/';
res_dir = './result_fs_iter_fd/';

% Get the list of data files (*.mat)
res_list = dir([res_dir, '*.mat']);
res_list = {res_list.name};


alg_list = {};
% Loop through each data file and load the data
alg_size = 5;
data_size = length(res_list);
min_pdp = ones(data_size, alg_size) .* 500;

total_res = struct('pdp', zeros(data_size, alg_size), 'ent', zeros(data_size, alg_size), ...
    'acc_nb', zeros(data_size, alg_size), 'acc_nb_s', zeros(data_size, alg_size), ...
    'acc_tree', zeros(data_size, alg_size), 'acc_tree_s', zeros(data_size, alg_size), ...
    'nmi', zeros(data_size, alg_size));

for k = 1:data_size
    file_name = res_list{k}(1:end-7);
    load([res_dir, file_name, '_fs.mat'])
    fs_size = size(res(1).pdp, 2);
    pdp_mat = zeros(alg_size, fs_size);
    ent_mat = zeros(alg_size, fs_size);
    nb_acc_mat = zeros(alg_size, fs_size);
    nb_acc_s_mat = zeros(alg_size, fs_size);
    tree_acc_mat = zeros(alg_size, fs_size);
    tree_acc_s_mat = zeros(alg_size, fs_size);
    nmi_mat = zeros(alg_size, fs_size);

    for i = 1:alg_size
        flag_pdp = 0;
        for j = 1:fs_size
            pdp_mat(i, j) = res(i).pdp(j);
            ent_mat(i, j) = res(i).ent(j);
            nb_acc_mat(i, j) = res(i).acc_nb(j);
            nb_acc_s_mat(i, j) = res(i).acc_nb_s(j);
            tree_acc_mat(i, j) = res(i).acc_tree(j);
            tree_acc_s_mat(i, j) = res(i).acc_tree_s(j);
            nmi_mat(i, j) = res(i).nmi(j);
            if flag_pdp == 0 && res(i).pdp(j) == 1
                min_pdp(k, i) = j;
                flag_pdp = 1;
            end
        end
    end

    pdp_mat = [pdp_mat(end, :); pdp_mat(1:end-1, :)];
    ent_mat = [ent_mat(end, :); ent_mat(1:end-1, :)];
    nb_acc_mat = [nb_acc_mat(end, :); nb_acc_mat(1:end-1, :)];
    nb_acc_s_mat = [nb_acc_s_mat(end, :); nb_acc_s_mat(1:end-1, :)];
    tree_acc_mat = [tree_acc_mat(end, :); tree_acc_mat(1:end-1, :)];
    tree_acc_s_mat = [tree_acc_s_mat(end, :); tree_acc_s_mat(1:end-1, :)];
    nmi_mat = [nmi_mat(end, :); nmi_mat(1:end-1, :)];

    total_res(k).pdp = pdp_mat;
    total_res(k).ent = ent_mat;
    total_res(k).acc_nb = nb_acc_mat;
    total_res(k).acc_nb_s = nb_acc_s_mat;
    total_res(k).acc_tree = tree_acc_mat;
    total_res(k).acc_tree_s = tree_acc_s_mat;
    total_res(k).nmi = nmi_mat;
end

min_pdp = [min_pdp(:, end), min_pdp(:, 1:end-1)];
res_list = res_list';
save('total_res_iter.mat', 'total_res', 'min_pdp', 'res_list');
