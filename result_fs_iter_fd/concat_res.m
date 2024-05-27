clear;

res_list = dir('./*.mat');

for k = 1:length(res_list)
    res = load(['./' res_list(k).name], 'res');
    res_comp = load(['../result_fs/' res_list(k).name], 'res');
    res = res.res;
    res_comp = res_comp.res;
    res(5).alg = 'PROP';
    res(1) = res_comp(1);
    res(2) = res_comp(2);
    res(3) = res_comp(3);
    res(4) = res_comp(4);
    save_dir = ['./' res_list(k).name];

    save(save_dir, 'res');
end
