clear;

data_dir = './data/';
% list of data which name has '.mat'
data_list = dir([data_dir, '*.mat']);
data_list = {data_list.name};

% list of data description table # patterns, # features, # classes

desc_table = zeros(length(data_list), 4);

for i = 1:length(data_list)


  data_name = data_list{i};
  load([data_dir, data_name]);
  desc_table(i, 1) = size(fea, 1);
  desc_table(i, 3) = size(fea, 2);
  desc_table(i, 4) = length(unique(gnd));
  data_list{i} = data_name(1:end-4);
  % read csv file
  csv_name = [data_dir, data_list{i}, '.csv'];
  csv_data = readtable(csv_name);
  desc_table(i, 2) = size(csv_data, 2);
end
