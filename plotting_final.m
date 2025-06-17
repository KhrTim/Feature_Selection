main_dir = 'cross_val_results_50';
plot_dir = fullfile('plots_eps');
if ~exist(plot_dir, 'dir')
    mkdir(plot_dir);
end

% List of algorithm folder names to exclude
excluded_algorithms = {'PROPS', 'PROP_REV'};  % <-- customize this

datasets = dir(main_dir);
datasets = datasets([datasets.isdir] & ~startsWith({datasets.name}, '.'));


max_k = 10;
current_option = 4;

options = {
    struct('function_name', 'pdp', 'y_label', 'PDP', 'file_prefix','pdp_', 'legend_position', 'northwest'), 
    struct('function_name', 'gini', 'y_label', 'Gini Impurity', 'file_prefix','gini_','legend_position', 'southeast'), 
    struct('function_name', 'ent_ratio', 'y_label', 'Entropy Ratio', 'file_prefix','ent_rat_','legend_position', 'southeast'), 
    struct('function_name', 'nb', 'y_label', 'Naive Bayes Classifier', 'file_prefix','nb_','legend_position', 'northwest'), 
    struct('function_name', 'tree', 'y_label', 'Tree Classifier', 'file_prefix','tree_','legend_position', 'northwest'), 
    struct('function_name', 'nmi', 'y_label', 'Mutual Information', 'file_prefix','nmi_','legend_position', 'northwest'), 
};

parfor d = 1:length(datasets)
    dataset_name = datasets(d).name;
    dataset_path = fullfile(main_dir, dataset_name);

    algorithms = dir(dataset_path);
    algorithms = algorithms([algorithms.isdir] & ~startsWith({algorithms.name}, '.'));

    % Filter out excluded algorithms
    algorithms = algorithms(~ismember({algorithms.name}, excluded_algorithms));

    markers = {'v', 'o', 's', '^', 'd', 'x', '+', '*', '>', '<'};

    fig = figure('Visible', 'off'); 
    hold on;
    legend_entries = {};
    legend_handles = [];

    for a = 1:length(algorithms)
        algo_name = algorithms(a).name;
        algo_path = fullfile(dataset_path, algo_name);

        [feature_counts, avg_scores] = evaluate_feature_selection(algo_path, max_k, options{current_option}.function_name);

        marker_idx = mod(a-1, length(markers)) + 1;

        if strcmpi(algo_name, 'PROP')
            plot_color = 'blue'; % proposed method
        else
            plot_color = [0 0 0]; % black for all others
        end

        h = plot(feature_counts, avg_scores, ...
            'Color', plot_color, ...
            'LineWidth', 1.5, ...
            'Marker', markers{marker_idx}, ...
            'MarkerSize', 6);

        legend_handles(end+1) = h;
        legend_entries{end+1} = algo_name;
    end

    % Style
    xlabel('Number of selected features', 'FontWeight', 'bold');
    ylabel(options{current_option}.y_label, 'FontWeight', 'bold');
    title(erase(dataset_name, '.mat'), 'Interpreter', 'none', 'FontWeight', 'bold');

    lgd = legend(legend_handles, legend_entries, ...
        'Location', options{current_option}.legend_position, ...
        'FontSize', 9);
    set(lgd, 'Box', 'off');

    grid on;
    box off;
    set(gca, 'FontSize', 12);

    % Save as EPS
    filename = fullfile(plot_dir, [options{current_option}.file_prefix, erase(dataset_name, '.mat'), '.eps']);
    saveas(fig, filename, 'epsc');
    fprintf('Saved plot: %s\n', filename);

    % Clean up
    close(fig);
end
