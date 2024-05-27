clear;
% Make line plot
fig_path = './figures_nb/';
if ~exist(fig_path, 'dir')
  mkdir(fig_path);
end
load("origin_filename.mat");

res_path = './result_fs_uni/';
data_path = './data/';

data_list = dir([data_path, '*.mat']);
res_list = dir([res_path, '*.mat']);
max_fs_size = 100;

cer_idx = 4;
for idx = 1: length(res_list)
  load([res_path, res_list(idx).name]);

  data_name = res_list(idx).name(1:end-7);
  load([data_path, data_name, '.mat']);
  col = size(fea, 2);
  fs_size = 1:10;
  perf_table = [];
  res_cell = struct2cell(res);
  res_cell = res_cell(cer_idx,:,:);

  for k = 1:length(res)
    perf_table = [perf_table; cell2mat(res_cell(1, 1, k))];
  end
  
  line_style = {'-o', '-s', '-^', '-d', '-v'};
  line_sytle2 = {'--o', '-s', '--^', '--d', '-v'};
  line_color = {'k', 'k', 'k', 'k', 'b'};
  line_color2 = {'c', 'k', 'c', 'c', 'b'};
  plot(fs_size, perf_table(5,:), line_style{5}, 'Color', line_color{5}, 'LineWidth', 2, 'MarkerSize', 8);
  hold on;
  for i = 1:4
    plot(fs_size, perf_table(i,:), line_style{i}, 'Color', line_color{i}, 'LineWidth', 2, 'MarkerSize', 8);
    hold on;
  end
  data_name = [upper(data_name(1)) data_name(2:end)];
  plot(fs_size, perf_table(5,:), line_style{5}, 'Color', line_color{5}, 'LineWidth', 2, 'MarkerSize', 8);
  data_name = [upper(data_name(1)) data_name(2:end)];
  title(data_name, 'FontSize', 35);
  set(gca, 'LooseInset', get(gca, 'TightInset'));
  set(gca, 'FontName', 'Times New Roman');
  % Set axis
  % Set label
  set(gca, 'XTick', fs_size);
  xlim([max(0, fs_size(1) - 1), fs_size(end) + 1]);
  % Set label name
  xlabel('Number of selected features', 'FontSize', 40);
  ylabel('Accuracy', 'FontSize', 40);
  
  % Set legend
  legend('Proposed', 'EGC', 'U2', 'VSCD', 'FMIU' , 'Location', 'SouthEast', 'FontSize', 22);
  
  % Save figure eps format
  saveas(gcf, [fig_path, 'nbacc_', data_name, '.eps'], 'epsc');
  saveas(gcf, [fig_path, 'nbacc_', data_name, '.jpg'], 'jpeg');
  % reset figure
  clf;
end







