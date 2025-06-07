base_dir = 'cross_val_results_50'; % CHANGE THIS
datasets = dir(base_dir);
results = struct();
num_features_for_classifiers = 20;

for i = 1:length(datasets)
    dataset_name = datasets(i).name;
    

    if datasets(i).isdir && ~startsWith(dataset_name, '.')
        ds_full_path = fullfile('all_datasets',dataset_name);
        data = load(ds_full_path);
        gnd = data.gnd;
        
        dataset_path = fullfile(base_dir, dataset_name);
        algorithms = dir(dataset_path);
        
        for j = 1:length(algorithms)
            algorithm_name = algorithms(j).name;
            if algorithms(j).isdir && ~startsWith(algorithm_name, '.')
                algorithm_path = fullfile(dataset_path, algorithm_name);
                mat_files = dir(fullfile(algorithm_path, '*.mat'));
                
                % Preallocate storage for evaluations
                eval_metrics = struct('gini', [], 'uniqueness', [], 'ent_rat', [], 'time', [], 'nmi',[], 'table_acc_nb',[],...
                    'table_acc_tree',[]);
                
                for k = 1:length(mat_files)
                    file_path = fullfile(algorithm_path, mat_files(k).name);
                    disp(file_path);
                    data = load(file_path); % assumes variables: features, train_subset, time
                    
                    % === Your custom evaluation logic here ===
                    % For example:
                    % acc = some_accuracy_fn(data.features, data.train_subset);
                    % [prec, rec] = some_precision_recall_fn(...);
                    
                    % Placeholder dummy results
                    train_samples = data.train_subset;
                    % disp(train_samples);
                    idx = data.features;
                    % If the number of selected features is greater than
                    % number of features in dataset, it is padded with NaNs
                    idx = idx(~isnan(idx) & idx > 0 & idx <= size(train_samples, 2));
                    if num_features_for_classifiers > 0
                        idx = idx(1:min(num_features_for_classifiers, length(idx)));
                    end
                    X_new = train_samples(:, idx);
                    train_gnd = data.train_gnd;



                    gini = gini_impurity(X_new);
                    uniq = uniqueness(X_new);
                    ent = ent_s(X_new) / ent_s(train_samples);
                    t = data.time;
                    
                    [table_acc_nb, ~, table_acc_tree, ~] = acc_nb_tree(X_new, train_gnd);
                    % table_acc_tree = 1;
                    % table_acc_nb = 1;
                    nmi = nmi_s(X_new, train_gnd);

                    % Collect results
                    eval_metrics.gini(end+1) = gini;
                    eval_metrics.uniqueness(end+1) = uniq;
                    eval_metrics.ent_rat(end+1) =  ent;
                    eval_metrics.time(end+1) = t;
                    eval_metrics.nmi(end+1) = nmi;
                    eval_metrics.table_acc_nb(end+1) = table_acc_nb;
                    eval_metrics.table_acc_tree(end+1) = table_acc_tree;



                end
                % Compute mean and std
                result_struct = struct();
                fields = fieldnames(eval_metrics);
                for f = 1:length(fields)
                    field = fields{f};
                    values = eval_metrics.(field);
                    result_struct.([field '_mean']) = mean(values);
                    result_struct.([field '_std']) = std(values);
                end

                % Store in main results
                % safe_dataset = matlab.lang.makeValidName(dataset_name);
                % safe_algorithm = matlab.lang.makeValidName(algorithm_name);
                % disp(datasets(i).name);
                [~, dataset_name, ~] = fileparts(datasets(i).name);
                [~, algorithm_name, ~] = fileparts(algorithms(j).name);
                dataset_name = matlab.lang.makeValidName(dataset_name);
                results.(dataset_name).(algorithm_name) = result_struct;
            end
        end
    end
end

% Optionally save the results
saveStructAsJSON('evaluation_results_20',results);
