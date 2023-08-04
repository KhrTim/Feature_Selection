clear;
max_fea = 300;
clus_iter = 50;
param_arr = [0.001, 0.01, 0.1, 1, 10, 100, 1000];

param_struct = struct('alg', {}, 'param', {}, 'fea', {}, 'time', {});
idx = 1;
param_struct(idx).alg = 'LS';
param_struct(idx).param = 0;
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'MAX_VAR';
param_struct(idx).param = 0;
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

% idx = idx+1;
% param_struct(idx).alg = 'CNAFS';
% param_struct(idx).param = make_param_mat(param_arr, 4);
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

% param_struct(4).alg = 'DUFS';
% param_struct(4).param = make_param_mat(param_arr, 3);
% param_struct(4).fea = zeros(size(param_struct(4).param, 1), max_fea);
% param_struct(4).time = zeros(size(param_struct(4).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'UDFS';
param_struct(idx).param = make_param_mat(param_arr, 2);
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'NDFS';
param_struct(idx).param = make_param_mat(param_arr, 2);
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'MCFS';
param_struct(idx).param = 0;
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'EGCFS';
param_struct(idx).param = make_param_mat(param_arr, 2);
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'RUFS';
param_struct(idx).param = make_param_mat(param_arr, 2);
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

% idx = idx+1;
% param_struct(idx).alg = 'SOCFS';
% param_struct(idx).param = make_param_mat(param_arr, 2);
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'U2FS';
param_struct(idx).param = 0;
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);
% 
% idx = idx+1;
% param_struct(idx).alg = 'RANK';
% param_struct(idx).param = make_param_mat(param_arr, 3);
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);
% idx = idx+1;
% param_struct(idx).alg = 'FMIUFS';
% param_struct(idx).param = [0.4; 0.5; 0.6; 0.7; 0.8; 0.9; 1.0; 1.1;];
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

% param_struct(7).alg = 'FRUAR';
% param_struct(7).param = [0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9; 1.0; 1.1;];
% param_struct(7).fea = zeros(size(param_struct(7).param, 1), max_fea);
% 
% param_struct(8).alg = 'UAR_HKCMI';
% 
% c{1} = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
% c{2} = [0.01, 0.001, 0.0001, 0.00001];
% [a, b] = ndgrid(c{:});
% param_struct(8).param = [a(:), b(:)];
% param_struct(8).fea = zeros(size(param_struct(8).param, 1), max_fea);

% idx = idx+1;
% param_struct(idx).alg = 'IUFS';
% param_struct(idx).param = 0;
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);
idx = idx+1;
param_struct(idx).alg = 'VCSDFS';
param_struct(idx).param = param_arr';
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);
idx = idx+1;
param_struct(idx).alg = 'PROP';
param_struct(idx).param = zeros(5,1);
param_struct(idx).fea = zeros(5, max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

save('exp_setting.mat', 'param_struct');
save('exp_setting.mat', 'max_fea', '-append');
save('exp_setting.mat', 'clus_iter', '-append');
