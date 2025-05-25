clear;
max_fea = 300;
clus_iter = 50;
param_arr = [0.001, 0.01, 0.1, 1, 10, 100, 1000];
idx = 0;
param_struct = struct('alg', {}, 'param', {}, 'fea', {}, 'time', {});
% idx = idx+1;
% param_struct(idx).alg = 'LS';
% param_struct(idx).param = 0;
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);
% 
% idx = idx+1;
% param_struct(idx).alg = 'MAX_VAR';
% param_struct(idx).param = 0;
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

% idx = idx+1;
% param_struct(idx).alg = 'CNAFS';
% param_struct(idx).param = make_param_mat(param_arr, 4);
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

% param_struct(4).alg = 'DUFS';
% param_struct(4).param = make_param_mat(param_arr, 3);
% param_struct(4).fea = zeros(size(param_struct(4).param, 1), max_fea);
% param_struct(4).time = zeros(size(param_struct(4).param, 1), 1);

% idx = idx+1;
% param_struct(idx).alg = 'UDFS';
% param_struct(idx).param = make_param_mat(param_arr, 2);
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);
% 
% idx = idx+1;
% param_struct(idx).alg = 'NDFS';
% param_struct(idx).param = make_param_mat(param_arr, 2);
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);
% 
% idx = idx+1;
% param_struct(idx).alg = 'MCFS';
% param_struct(idx).param = 0;
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'EGCFS';
param_struct(idx).param = [0.001, 0.1];
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

% idx = idx+1;
% param_struct(idx).alg = 'RUFS';
% param_struct(idx).param = make_param_mat(param_arr, 2);
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

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
 
% idx = idx+1;
% param_struct(idx).alg = 'RANK';
% param_struct(idx).param = make_param_mat(param_arr, 3);
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'VCSDFS';
param_struct(idx).param = 100;
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'FMIUFS';
param_struct(idx).param = 0.1;
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);
% 
% idx = idx+1;
% param_struct(idx).alg = 'FRUAR';
% param_struct(idx).param = 0.1;
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

% idx = idx+1;
% param_struct(idx).alg = 'UAR_HKCMI';
% param_struct(idx).param = [0.1, 0.001];
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

% idx = idx+1;
% param_struct(idx).alg = 'IUFS';
% param_struct(idx).param = 0;
% param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
% param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);

idx = idx+1;
param_struct(idx).alg = 'PROPQ';
param_struct(idx).param = 0;
param_struct(idx).fea = zeros(size(param_struct(idx).param, 1), max_fea);
param_struct(idx).time = zeros(size(param_struct(idx).param, 1), 1);


save('exp_setting.mat', 'param_struct');
save('exp_setting.mat', 'max_fea', '-append');
save('exp_setting.mat', 'clus_iter', '-append');
