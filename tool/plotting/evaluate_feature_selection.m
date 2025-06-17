function [feature_counts, avg_scores] = evaluate_feature_selection(folder_path, max_features, eval_fn_name)
% EVALUATE_FEATURE_SELECTION evaluates a set of features across multiple cross-validations.
% 
%   folder_path: folder containing .mat files for each fold.
%   max_features: maximum number of features to consider incrementally.
%   eval_fn_name: a string specifying the evaluation metric. Supported values:
%                'gini'      - uses gini_impurity function,
%                'pdp'       - uses uniqueness function,
%                'ent_ratio' - evaluates ent_s(X_new)/ent_s(train_samples).
%                'nb'        - naive bayes classifier
%                'tree'      - tree classifier
%                'nmi'       - mutual information
%
% Each .mat file should contain at least:
%   - 'features': a ranking vector with feature indices.
%   - 'train_subset': a matrix where columns correspond to features.
%
% The function returns:
%   - feature_counts: a vector [1, 2, ..., max_features].
%   - avg_scores: averaged scores across folds for each incremental feature set.

files = dir(fullfile(folder_path, '*.mat'));
num_folds = length(files);

if num_folds == 0
    error('No .mat files found in the specified folder.');
end

avg_scores = zeros(1, max_features);
feature_counts = 1:max_features;

for k = 1:max_features
    fold_scores = zeros(1, num_folds);
    
    for i = 1:num_folds
        data = load(fullfile(folder_path, files(i).name));
        
        if ~isfield(data, 'features')
            error('Each .mat file must contain the ''features'' variable.');
        end
        if ~isfield(data, 'train_subset')
            error('Each .mat file must contain the ''train_subset'' variable.');
        end
        
        train_samples = data.train_subset;
        idx = data.features;
        % Filter out invalid indices
        idx = idx(~isnan(idx) & idx > 0 & idx <= size(train_samples, 2));
        
        % Make sure we have at least k features
        if length(idx) < k
            error('Fold %d does not have enough features in ''features'' for k = %d.', i, k);
        end
        top_k_features = idx(1:k);
        X_new = train_samples(:, top_k_features);
        train_gnd = data.train_gnd;
        
        % Evaluate based on the selected metric.
        if strcmp(eval_fn_name, 'gini')
            fold_scores(i) = gini_impurity(X_new);
        elseif strcmp(eval_fn_name, 'pdp')
            fold_scores(i) = uniqueness(X_new);
        elseif strcmp(eval_fn_name, 'ent_ratio')
            % Ensure ent_s function is defined. This computes entropy as a measure.
            fold_scores(i) = ent_s(X_new) / ent_s(train_samples);
        elseif strcmp(eval_fn_name, 'tree')
            [~, ~, table_acc_tree, ~] = acc_nb_tree(X_new, train_gnd);
            fold_scores(i) = table_acc_tree;
        elseif strcmp(eval_fn_name, 'nb')
            [table_acc_nb, ~, ~, ~] = acc_nb_tree(X_new, train_gnd);
            fold_scores(i) = table_acc_nb;
        elseif strcmp(eval_fn_name, 'nmi')
            fold_scores(i) = nmi_s(X_new, train_gnd);
        else
            error('Unsupported evaluation function name: %s', eval_fn_name);
        end
    end
    
    avg_scores(k) = mean(fold_scores);
end

end