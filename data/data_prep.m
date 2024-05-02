% read csv file and label encoding
data_path = './audiology.standardized.csv';
data = readtable(data_path);
data = table2array(data);
fea = data(:,1:end-1);
gnd = data(:,end);

% label encoding
gnd = labelencode(gnd);


