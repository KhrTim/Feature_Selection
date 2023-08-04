clear;

data_dir = './data/';
res_dir = './result_fs/';

% Get the list of data files (*.mat)
data_list = dir([data_dir, '*.mat']);
data_list = {data_list.name};

res_list = dir([res_dir, '*.mat']);
res_list = {res_list.name};
alg_list = {};
% Loop through each data file and load the data
res_mat = struct('dat_name', {}, 'acc', {}, 'acc_std', {}, ...
    'nmi', {}, 'nmi_std', {}, 'c', {}, 'c_std', {}, 'ffei', {}, ...
    'sil', {}, 'sil_std', {}, 'dbi', {}, 'dbi_std', {});
for k = 1:length(res_list)
    load(res_list{k});
    file_name = data_list{k}(1:end-4);
    % Do something with the data
    res_mat(k).dat_name = file_name;
    alg_size = length(res);
    
    if k == 1
        for i = 1:alg_size
            alg_list{i} = res(i).alg;
        end
    end
    
    sil_mat = zeros(alg_size, 10);
    sil_std_mat = zeros(alg_size, 10);
    dbi_mat = zeros(alg_size, 10);
    dbi_std_mat = zeros(alg_size, 10);
    acc_mat = zeros(alg_size, 10);
    acc_std_mat = zeros(alg_size, 10);
    nmi_mat = zeros(alg_size, 10);
    nmi_std_mat = zeros(alg_size, 10);
    c_mat = zeros(alg_size, 10);
    c_std_mat = zeros(alg_size, 10);
    ffei_mat = zeros(alg_size, 10);


    for i = 1:alg_size
        target_mat = res(i).sil;
        sil_mat(i, :) = mean(target_mat, 1);
        sil_std_mat(i, :) = mean(res(i).sil_std);

        target_mat = res(i).dbi;
        dbi_mat(i, :) = mean(target_mat, 1);
        dbi_std_mat(i, :) = mean(res(i).dbi_std);

        target_mat = res(i).acc;
        acc_mat(i, :) = mean(target_mat, 1);
        acc_std_mat(i, :) = mean(res(i).acc_std);

        target_mat = res(i).nmi;
        nmi_mat(i, :) = mean(target_mat, 1);
        nmi_std_mat(i, :) = mean(res(i).nmi_std);

        target_mat = res(i).c;
        c_mat(i, :) = mean(target_mat, 1);
        c_std_mat(i, :) = mean(res(i).c_std);

        target_mat = res(i).ffei;
        ffei_mat(i, :) = mean(target_mat, 1);

    end
    res_mat(k).sil = sil_mat;
    res_mat(k).sil_std = sil_std_mat;
    res_mat(k).dbi = dbi_mat;
    res_mat(k).dbi_std = dbi_std_mat;
    res_mat(k).acc = acc_mat;
    res_mat(k).acc_std = acc_std_mat;
    res_mat(k).nmi = nmi_mat;
    res_mat(k).nmi_std = nmi_std_mat;
    res_mat(k).c = c_mat;
    res_mat(k).c_std = c_std_mat;
    res_mat(k).ffei = ffei_mat;
end

for i = 1:length(res_list)
    for j = 1:length(alg_list)
        [max_mat_acc(i,j), idx] = max(res_mat(i).acc(j, :));
        max_mat_acc_std(i,j) = res_mat(i).acc_std(j, idx);
        [max_mat_nmi(i,j), idx] = max(res_mat(i).nmi(j, :));
        max_mat_nmi_std(i,j) = res_mat(i).nmi_std(j, idx);
    end
end 

save('total_res_mean.mat', 'res_mat');
save('total_res_mean.mat', '-append', 'alg_list');
save('total_res_mean.mat', '-append', 'max_mat_acc');
save('total_res_mean.mat', '-append', 'max_mat_nmi');
save('total_res_mean.mat', '-append', 'max_mat_acc_std');
save('total_res_mean.mat', '-append', 'max_mat_nmi_std');


