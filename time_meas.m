clear;
data_dir = './data/';
output_dir = './perf_results/';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end
rng('default');  % Resets to modern default RNG settings
rng('shuffle');
file_list = dir('perf_check/*.mat');
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
    fprintf("Preprocessed dataset size: [%d %d]\n", size(orig_fea));

    for m = 1:length(param_struct)
        fprintf('----- Start algorithm %s -----\n', param_struct(m).alg);
        exp_path = fullfile(output_dir, file_list(k).name, param_struct(m).alg);
        if ~exist(exp_path, 'dir')
            mkdir(exp_path);
        end
        if size(orig_fea, 2) < max_fea
            param_struct(m).fea = zeros(size(param_struct(m).param, 1), size(orig_fea, 2));
        end


        train_fea = orig_fea;
        train_gnd = gnd;

        alg = param_struct(m).alg;

        if strcmp(alg, 'FMIUFS') == 1
            train_fea = normalize(train_fea);
        end
        temp_param = param_struct(m).param;

        t1 = tic;
        idx =  ufs_alg(alg, train_fea, train_gnd, max_fea, temp_param);
        elapsed_time = toc(t1);
        timestamp = datetime('now', 'Format', 'yyyyMMdd_HHmmss');

        % Convert the timestamp to a string
        timestamp_str = char(timestamp);

        % Define the base filename
        base_filename = 'data_file_';

        % Concatenate the base filename with the timestamp string
        filename = fullfile(exp_path, strcat(base_filename, timestamp_str,'_',string(randi(10000))));
        X_new = train_fea(:, idx);

        features = idx;
        res = uniqueness(X_new);
        fprintf("Uniqueness: %f\n",res);
        saveStructAsJSON(filename, struct("time", elapsed_time, "uniqueness", res, "ent_ratio", ent(X_new)/ent(train_fea)));
    end
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
