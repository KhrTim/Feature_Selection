clear;
output_dir = './result/';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end
file_list = dir('data/*.mat');
for k = 3:3
    load exp_setting.mat
    fprintf('%d Start\n', k);
    fea = load(file_list(k).name, 'fea').fea;
    gnd = load(file_list(k).name, 'gnd').gnd;
    for m = 9:length(param_struct)
        if size(fea, 2) < max_fea
            param_struct(m).fea = zeros(size(param_struct(m).param, 1), size(fea, 2));
        end
        alg = param_struct(m).alg;
        temp_param = param_struct(m).param;
        temp_fea = param_struct(m).fea;
        temp_time = param_struct(m).time;
        fea = normalize(fea);
        parfor n = 1:length(temp_param)
           tic
           idx =  ufs_alg(alg, fea, gnd, max_fea, temp_param(n,:));
           temp_fea(n, :) = idx;
           temp_time(n,1) = toc;
        end
        param_struct(m).fea = temp_fea;
        param_struct(m).time = temp_time;
        fprintf('%s finish\n', alg);
        file_name = file_list(k).name;
        file_name = replace(file_name, '.mat', '_exp_add.mat'); 
        save_dir = strcat(output_dir, file_name);
        save(save_dir, 'param_struct');
    end
    fprintf('%d finish\n', k);
end
