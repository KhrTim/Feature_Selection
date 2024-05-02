% make mat file to csv in matlab code

data_path = './';
data_name = 'lymphoma.mat';
load([data_path data_name]);

% make csv file
data = [fea, gnd];
csvwrite([data_path data_name(1:end-4) '.csv'], data);




