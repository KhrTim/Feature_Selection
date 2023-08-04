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
res_mat_max = struct('dat_name', {}, 'acc', {}, 'acc_std', {}, ...
    'nmi', {}, 'nmi_std', {}, 'c', {}, 'c_std', {}, 'ffei', {}, ...
    'sil', {}, 'sil_std', {}, 'dbi', {}, 'dbi_std', {});
res_mat_min = struct('dat_name', {}, 'acc', {}, 'acc_std', {}, ...
    'nmi', {}, 'nmi_std', {}, 'c', {}, 'c_std', {}, 'ffei', {}, ...
    'sil', {}, 'sil_std', {}, 'dbi', {}, 'dbi_std', {});
for k = 1:length(res_list)
    load(res_list{k});
    file_name = data_list{k}(1:end-4);
    % Do something with the data
    res_mat_max(k).dat_name = file_name;
    res_mat_min(k).dat_name = file_name;
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

    min_sil_mat = zeros(alg_size, 10);
    min_sil_std_mat = zeros(alg_size, 10);
    min_dbi_mat = zeros(alg_size, 10);
    min_dbi_std_mat = zeros(alg_size, 10);
    min_acc_mat = zeros(alg_size, 10);
    min_acc_std_mat = zeros(alg_size, 10);
    min_nmi_mat = zeros(alg_size, 10);
    min_nmi_std_mat = zeros(alg_size, 10);
    min_c_mat = zeros(alg_size, 10);
    min_c_std_mat = zeros(alg_size, 10);
    min_ffei_mat = zeros(alg_size, 10);

    for i = 1:alg_size
        target_mat = res(i).sil;
        sil_mat(i, :) = max(target_mat, [], 1);
        min_sil_mat(i, :) = min(target_mat, [], 1);

        target_mat = res(i).dbi;
        dbi_mat(i, :) = max(target_mat, [], 1);
        min_dbi_mat(i, :) = min(target_mat, [], 1);

        target_mat = res(i).acc;
        acc_mat(i, :) = max(target_mat, [], 1);
        min_acc_mat(i, :) = min(target_mat, [], 1);

        target_mat = res(i).nmi;
        nmi_mat(i, :) = max(target_mat, [], 1);
        min_nmi_mat(i, :) = min(target_mat, [], 1);

        target_mat = res(i).c;
        c_mat(i, :) = max(target_mat, [], 1);
        min_c_mat(i, :) = min(target_mat, [], 1);

        target_mat = res(i).ffei;
        ffei_mat(i, :) = max(target_mat, [], 1);
        min_ffei_mat(i, :) = min(target_mat, [], 1);

    end

    res_mat_max(k).sil = sil_mat;

    res_mat_max(k).dbi = dbi_mat;

    res_mat_max(k).acc = acc_mat;

    res_mat_max(k).nmi = nmi_mat;

    res_mat_max(k).c = c_mat;

    res_mat_max(k).ffei = ffei_mat;

    res_mat_min(k).sil = min_sil_mat;

    res_mat_min(k).dbi = min_dbi_mat;

    res_mat_min(k).acc = min_acc_mat;

    res_mat_min(k).nmi = min_nmi_mat;

    res_mat_min(k).c = min_c_mat;

    res_mat_min(k).ffei = min_ffei_mat;

end

save('total_res.mat', 'res_mat_max');
save('total_res.mat', '-append' , 'res_mat_min');
save('total_res.mat', '-append' , 'alg_list');


