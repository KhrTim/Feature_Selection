clear;

fs_size = 10;
data_dir = './data/';
res_dir = './result_fs/';

% Get the list of data files (*.mat)
res_list = dir([res_dir, '*.mat']);
res_list = {res_list.name};

alg_list = {};
% Loop through each data file and load the data
alg_size = 5;
data_size = length(res_list);

nb_acc_mat = zeros(data_size, alg_size);
nb_acc_s_mat = zeros(data_size, alg_size);
tree_acc_mat = zeros(data_size, alg_size);
tree_acc_s_mat = zeros(data_size, alg_size);
nmi_mat = zeros(data_size, alg_size);
for k = 1:data_size
    file_name = res_list{k}(1:end-7);
    load([res_dir, file_name, '_fs.mat'])

    for i = 1:alg_size
        nb_acc_mat(k, i) = res(i).acc_nb(fs_size);
        nb_acc_s_mat(k, i) = res(i).acc_nb_s(fs_size);
        tree_acc_mat(k, i) = res(i).acc_tree(fs_size);
        tree_acc_s_mat(k, i) = res(i).acc_tree_s(fs_size);
        nmi_mat(k, i) = res(i).nmi(fs_size);
    end

end

nb_acc_mat = [nb_acc_mat(end, :); nb_acc_mat(1:end-1, :)];
nb_acc_s_mat = [nb_acc_s_mat(end, :); nb_acc_s_mat(1:end-1, :)];
tree_acc_mat = [tree_acc_mat(end, :); tree_acc_mat(1:end-1, :)];
tree_acc_s_mat = [tree_acc_s_mat(end, :); tree_acc_s_mat(1:end-1, :)];
nmi_mat = [nmi_mat(end, :); nmi_mat(1:end-1, :)];
res_list = res_list';


