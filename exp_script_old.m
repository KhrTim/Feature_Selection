clear;
data_dir = './data/';
output_dir = './cross_val_results/';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end


file_list = dir('data/*.mat');
file_names = {file_list.name};

cross_val = 10;

num_measurements = 3; % Number of measurements per algorithm
num_algs = 5;
max_num_features = 10;
% Preallocate the structure array
result = struct('dataset_name', cell(length(file_names), 1), ...
    'algorithms', repmat(struct('name', '', ...
    'measurements', NaN(num_measurements, cross_val), ...
    'mean_measurements', NaN(num_measurements, 1), ...
    'std_measurements', NaN(num_measurements, 1), ...
    'features', NaN(max_num_features, cross_val)), length(file_names), num_algs));

parfor k = 1:length(file_names)
    fprintf('############# Start dataset %s #############\n', file_list(k).name);
    
    

    result(k).dataset_name = file_list(k).name;

    fprintf('%d Start\n', k);
    [~, param_struct] = load_expset();
    max_fea = max_num_features;

    for m = 1:length(param_struct)
        fprintf('----- Start algorithm %s -----\n', param_struct(m).alg);
        
        exp_path = fullfile(output_dir, file_list(k).name, param_struct(m).alg);
        if ~exist(exp_path, 'dir')
            mkdir(exp_path);
        end
	fprintf("Checking files in %s directory.\n", exp_path);
        files = dir(exp_path);

        % Filter out the directories (i.e., include only files)
        files = files(~[files.isdir]);
        
        % Count the number of files
        num_files = length(files);
	fprintf("%d files found\n", num_files);

        cross_val_iter_num = max(0,cross_val - num_files);
	fprintf("Setting number of iterations to %d\n", cross_val_iter_num);
        result(k).algorithms(m).name = param_struct(m).alg;

        orig_fea = load([data_dir file_list(k).name], 'fea').fea;
        gnd = load([data_dir file_list(k).name], 'gnd').gnd;
        num_c = length(unique(gnd));
        cate_flag = load([data_dir file_list(k).name], 'cate_flag').cate_flag;
        if cate_flag == 0
            orig_fea = discretize_width(orig_fea, 2);
        end
        if size(orig_fea, 2) < max_fea
            param_struct(m).fea = zeros(size(param_struct(m).param, 1), size(orig_fea, 2));
        end

        for split_num = 1:cross_val_iter_num
            fprintf('Iteration %d\n', split_num);
            cv = cvpartition(size(orig_fea,1), 'HoldOut', 0.2);

            % Get training and test indices
            train_idx = training(cv);
            test_idx = test(cv);

            % Split the dataset
            train_fea = orig_fea(train_idx, :);
            train_gnd = gnd(train_idx);

            % test_data = fea(test_idx, :);
            % test_dabels = gnd(test_idx);

            alg = param_struct(m).alg;
            if strcmp(alg, 'FMIUFS') == 1
                train_fea = normalize(train_fea);
            end
            temp_param = param_struct(m).param;

            idx =  ufs_alg(alg, train_fea, train_gnd, max_fea, temp_param(1,:));
            result(k).algorithms(m).features(:,split_num) = idx;
            timestamp = datetime('now', 'Format', 'yyyyMMdd_HHmmss');

            % Convert the timestamp to a string
            timestamp_str = char(timestamp);
            
            % Define the base filename
            base_filename = 'data_file_';
            
            % Concatenate the base filename with the timestamp string
            filename = fullfile(exp_path, strcat(base_filename, timestamp_str,'_',string(randi(100))));
            X_new = train_fea(:, idx);
            result(k).algorithms(m).measurements(1, split_num) = gini_impurity(X_new);
            result(k).algorithms(m).measurements(2, split_num) = uniqueness(X_new);
            result(k).algorithms(m).measurements(3, split_num) = ent_s(X_new) / ent_s(train_fea);

            features = result(k).algorithms(m).features(:, split_num);
            measurements = result(k).algorithms(m).measurements(:, split_num);

            save(filename,"-fromstruct",struct("features", features, "measurements", measurements, "train_subset", train_fea));
        end
        
        files = dir(fullfile(exp_path, '*.mat'));  % Assuming the files are .mat files
        results = NaN(length(files), 3);
        % Loop through each file
        for i = 1:length(files)
            % Full path of the current file
            file_path = fullfile(exp_path, files(i).name);
            % Load the file (assuming the file contains a structure variable 'param_struct')
            results(i, :) = load(file_path, 'measurements').measurements;
        end

        for measure_idx = 1:3
            result(k).algorithms(m).mean_measurements(measure_idx) = mean(results(:, measure_idx));
            result(k).algorithms(m).std_measurements(measure_idx) = std(results(:, measure_idx));
        end
        fprintf("Dataset: %s; Algorithm: %s; Gini: %f +/- %f; PDP: %f +/- %f; Ent_ratio: %f +/- %f\n",...
            result(k).dataset_name, result(k).algorithms(m).name, result(k).algorithms(m).mean_measurements(1), result(k).algorithms(m).std_measurements(1),...
            result(k).algorithms(m).mean_measurements(2), result(k).algorithms(m).std_measurements(2), ...
            result(k).algorithms(m).mean_measurements(3), result(k).algorithms(m).std_measurements(3));


    end
    %file_name = file_list(k).name;
    %save_dir = strcat(output_dir, file_name);
    %save_file(save_dir, param_struct);
    fprintf('%d finish\n', k);
end
save('FINAL_RESULT.mat', 'result');

function [m, p] = load_expset()
load("exp_setting.mat");
m = max_fea;
p = param_struct;
end

function save_file(save_dir, param_struct)
save(save_dir, 'param_struct');
end
