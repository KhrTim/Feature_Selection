clear;
data_dir = './data/';
output_dir = './dataset_analysis/';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end
rng('default');  % Resets to modern default RNG settings
rng('shuffle');
file_list = dir('data/*.mat');
file_names = {file_list.name};

cross_val = 1;

num_measurements = 3; % Number of measurements per algorithm
num_algs = 5;
max_num_features = 10;

for k = 1:length(file_names)
    fprintf('############# Start dataset %s #############\n', file_list(k).name);




    fprintf('%d Start\n', k);
    [~, param_struct] = load_expset("exp_set.json");
    max_fea = max_num_features;


    orig_fea = load([data_dir file_list(k).name], 'fea').fea;
    orig_fea_size = size(orig_fea);
    fprintf("Original dataset size: [%d %d]\n", size(orig_fea));
    gnd = load([data_dir file_list(k).name], 'gnd').gnd;
    num_c = length(unique(gnd));
    cate_flag = load([data_dir file_list(k).name], 'cate_flag').cate_flag;
    if cate_flag == 0
        % orig_fea = discretize_width(orig_fea, 10);
        orig_fea = binarize_by_mean(orig_fea);
    else
        orig_fea = one_hot_encode_columns(orig_fea);
    end
    preprocessed_fea_size = size(orig_fea);
    fprintf("Preprocessed dataset size: [%d %d]\n", size(orig_fea));
    filename = fullfile(output_dir, strcat(file_list(k).name,'_',string(randi(10000))));
    saveStructAsJSON(filename, struct("orig", orig_fea_size,"preprocessed", preprocessed_fea_size));
    fprintf('%d finish\n', k);
end

function [m, p] = load_expset(filename)
s = loadStructFromJSON(filename);
m = s.max_fea;
p = s.param_struct;
end

function save_file(save_dir, param_struct)
save(save_dir, 'param_struct');
end
