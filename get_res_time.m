clear;

data_dir = './data/';
res_dir = './result/';

% Get the list of data files (*.mat)
res_list = dir([res_dir, '*.mat']);
res_list = {res_list.name};

alg_list = {};
% Loop through each data file and load the data
alg_size = 5;
data_size = length(res_list);

time_mat = zeros(data_size, alg_size);
for k = 1:data_size
    file_name = res_list{k};
    load([res_dir, file_name])

    for i = 1:alg_size
        time_mat(k, i) = param_struct(i).time;
    end

end
time_mat = [time_mat(end, :); time_mat(1:end-1, :)];
res_list = res_list';


