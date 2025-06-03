clear;
% Make line plot
fig_path = './figures_uni/';
if ~exist(fig_path, 'dir')
  mkdir(fig_path);
end

res_path = './result_fs/';
data_path = './data/';

data_list = dir([data_path, '*.mat']);
res_list = dir([res_path, '*.mat']);
max_fs_size = 100;

cer_idx = 2;
load("total_res.mat");
for idx = 1: length(res_list)
  load([res_path res_list{idx}]);

  data_name = res_list{idx}(1:end-7);
  load([data_path, data_name, '.mat']);
%   col = size(fea, 2);
%   if col > max_fs_size
%       fs_size = 10:10:max_fs_size;
%   else
%       r = rem(col, 10);
%       d = (col - r) / 10;
%       fs_size = 1:d:col-r;
%   end
  
  perf_table = [];
  res_cell = struct2cell(res);
  res_cell = res_cell(cer_idx,:,:);
  
  for k = 1:length(res)
    perf_table = [perf_table; cell2mat(res_cell(1, 1, k))];
  end
  fs_max = min(10, min(min_pdp(idx,:)));
  fs_max = min(size(perf_table, 2), fs_max);
  fs_size = 1:fs_max;
  line_style = {'-o', '-s', '-^', '-d', '-v'};
  line_sytle2 = {'--o', '-s', '--^', '--d', '-v'};
  line_color = {'k', 'k', 'k', 'k', 'b'};
  line_color2 = {'c', 'k', 'c', 'c', 'b'};
  plot(fs_size, perf_table(5,1:fs_max), line_style{5}, 'Color', line_color{5}, 'LineWidth', 2, 'MarkerSize', 8);
  hold on;
  for i = 1:4
    plot(fs_size, perf_table(i,1:fs_max), line_style{i}, 'Color', line_color{i}, 'LineWidth', 2, 'MarkerSize', 8);
    hold on;
  end
  % plot(fs_size, perf_table(5,:), line_style{5}, 'Color', line_color{5}, 'LineWidth', 2, 'MarkerSize', 8);
  real_name = data_name;
  if strcmp('CLL_SUB_111', data_name)
      data_name = 'CLL\_SUB\_111';
  end
  if strcmp('Prostate_GE', data_name)
      data_name = 'Prostate\_GE';
  end
  if strcmp('lsvt', data_name)
      data_name = 'LSVT';
  end

  data_name = [upper(data_name(1)) data_name(2:end)];
  
  title(data_name, 'FontSize', 35);
  set(gca, 'LooseInset', get(gca, 'TightInset'));
  set(gca, 'FontName', 'Times New Roman');
  % Set axis
  % Set label
  set(gca, 'XTick', fs_size);
  set(gca, 'XTickLabel', fs_size, 'FontSize', 22);
  % set y tick label font size
  set(gca, 'YTickLabel', get(gca, 'YTick'), 'FontSize', 22);
  xlim([1, fs_size(end)]);
  % Set label name
  xlabel('Number of selected features', 'FontSize', 40);
  ylabel('PDP', 'FontSize', 40);
  legend('Proposed', 'EGC', 'U2', 'VSCD', 'FMI', 'Location', 'northwest', 'FontSize', 22);
  if strcmp('WarpAR10P', data_name)
      legend('Proposed', 'EGC', 'U2', 'VSCD', 'FMI', 'Location', 'southeast', 'FontSize', 22);
  end
  if strcmp('WarpPIE10P', data_name)
      legend('Proposed', 'EGC', 'U2', 'VSCD', 'FMI', 'Location', 'southeast', 'FontSize', 22);
  end
  if strcmp('Yaleb', data_name)
      legend('Proposed', 'EGC', 'U2', 'VSCD', 'FMI', 'Location', 'southeast', 'FontSize', 22);
  end
  if strcmp('Umist', data_name)
      legend('Proposed', 'EGC', 'U2', 'VSCD', 'FMI', 'Location', 'southeast', 'FontSize', 22);   
  end
  
  % Save figure eps format
  saveas(gcf, [fig_path, 'uni_', real_name, '.jpg'], 'jpeg');
  
  % reset figure
  clf;
end







