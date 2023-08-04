clear;
n_fc = 50;
file_list = dir('./result_fs/*.mat');
res = load(['./result_fs/' file_list(1).name]);
res = res.res;
alg_len = length(res);
s_res = zeros(length(file_list), alg_len);
e_res = zeros(length(file_list), alg_len);
r_res = zeros(length(file_list), alg_len);
f_res = zeros(length(file_list), alg_len);
act_fc = n_fc / 50;
for i = 1:length(file_list)
  res = load(['./result_fs/' file_list(i).name]);
  res = res.res;
  for j = 1:alg_len
    s_res(i, j) = min(res(j).S(:, act_fc));
    r_res(i, j) = min(res(j).R(:, act_fc));
    e_res(i, j) = min(res(j).E(:, act_fc));
    f_res(i, j) = min(res(j).F(:, act_fc));
  end
end

