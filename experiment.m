clear;
data_dir = './data/';
output_dir = './cross_val_results_50/';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end


file_list = dir('data/*.mat');
file_names = {file_list.name};

cross_val = 10;


num_algs = 11;
max_num_features = 50;
% Preallocate the structure array
result = struct('dataset_name', cell(length(file_names), 1), ...
    'algorithms', repmat(struct('name', '', ...
    'features', NaN(max_num_features, cross_val)), length(file_names), num_algs));

for k = 1:length(file_names)
    fprintf('############# Start dataset %s #############\n', file_list(k).name);



    result(k).dataset_name = file_list(k).name;

    fprintf('%d Start\n', k);
    [~, param_struct] = load_expset('real_experiment.json');
    max_fea = max_num_features;


    orig_fea = load([data_dir file_list(k).name], 'fea').fea;
    gnd = load([data_dir file_list(k).name], 'gnd').gnd;
    num_c = length(unique(gnd));
    cate_flag = load([data_dir file_list(k).name], 'cate_flag').cate_flag;
    if cate_flag == 0
        % orig_fea = discretize_width(orig_fea, 10);
        orig_fea = binarize_by_mean(orig_fea);
    else
        orig_fea = one_hot_encode_columns(orig_fea);
    end

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
            
            t1 = tic;
            disp("Start");
            idx =  ufs_alg(alg, train_fea, train_gnd, max_fea, temp_param);
            elapsed_time = toc(t1);
            disp("End");
            
            % If the number of selected features is greater than
            % number of features in dataset, pad with NaN
            if length(idx) < max_fea
                idx(end+1:max_fea) = NaN;
            elseif length(idx) > max_fea
                idx = idx(1:max_fea);
            end
            result(k).algorithms(m).features(:,split_num) = idx;
            timestamp = datetime('now', 'Format', 'yyyyMMdd_HHmmss');

            % Convert the timestamp to a string
            timestamp_str = char(timestamp);

            % Define the base filename
            base_filename = 'data_file_';

            % Concatenate the base filename with the timestamp string
            filename = fullfile(exp_path, strcat(base_filename, timestamp_str,'_',string(randi(10000))));
            % idx = idx(~isnan(idx) & idx > 0 & idx <= size(train_fea, 2));
            features = result(k).algorithms(m).features(:, split_num);

            save(filename,"-fromstruct",struct("features", features, "train_subset", train_fea, "time", elapsed_time, "train_idx", train_idx, 'train_gnd', train_gnd));
        end
    end
    %file_name = file_list(k).name;
    %save_dir = strcat(output_dir, file_name);
    %save_file(save_dir, param_struct);
    fprintf('%d finish\n', k);
end
save('FINAL_RESULT.mat', 'result');

function [m, p] = load_expset(filename)
s = loadStructFromJSON(filename);
m = s.max_fea;
p = s.param_struct;
end

function save_file(save_dir, param_struct)
save(save_dir, 'param_struct');
end
