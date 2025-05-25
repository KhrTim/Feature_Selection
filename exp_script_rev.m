clear;
data_dir = './data/';
output_dir = './result_rev/';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end
file_list = dir('data/*.mat');
parfor k = 1:length(file_list)
%for k = 7:7
    [max_fea, param_struct] = load_expset();
    fprintf('%d Start\n', k);
    if exist([output_dir file_list(k).name], 'file')
        continue;
    end
    %for m = 2:2
    m = 5;
    fea = load([data_dir file_list(k).name], 'fea').fea;
    gnd = load([data_dir file_list(k).name], 'gnd').gnd;
    num_c = length(unique(gnd));
    cate_flag = load([data_dir file_list(k).name], 'cate_flag').cate_flag;  
    if cate_flag == 0
        fea = discretize_width(fea, 10);
    end
    if size(fea, 2) < max_fea
        param_struct(m).fea = zeros(size(param_struct(m).param, 1), size(fea, 2));
        max_fea = size(fea, 2);
    end
    temp_param = param_struct(m).param;
    temp_fea = param_struct(m).fea;
    temp_time = param_struct(m).time;

    for n = 1:size(temp_param, 1)
       tic
       idx =  proposed_quad_rev(fea, max_fea);
       temp_fea(n, :) = idx;
       temp_time(n,1) = toc;
    end
    param_struct(m).fea = temp_fea;
    param_struct(m).time = temp_time;
   
    file_name = file_list(k).name;
    save_dir = strcat(output_dir, file_name);
    save_file(save_dir, param_struct);
    fprintf('%d finish\n', k);
end

function [m, p] = load_expset()
load("exp_setting.mat");
m = max_fea;
p = param_struct;
end

function save_file(save_dir, param_struct)
    save(save_dir, 'param_struct');
end
