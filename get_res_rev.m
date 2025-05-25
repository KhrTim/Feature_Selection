clear;

fs_res_rev_dir = './result_fs_rev/';

fs_res_rev_list = dir([fs_res_rev_dir '*.mat']);

load('./total_res.mat');
ent_res = zeros(length(fs_res_rev_list), 1);
pdp_res = zeros(length(fs_res_rev_list), 1);
min_res = zeros(length(fs_res_rev_list), 1);
for k = 1:length(fs_res_rev_list)
    load([fs_res_rev_dir fs_res_rev_list(k).name]);
    
    fs_size = size(res(5).pdp, 2);
    flag = 0;
    for j = 1:fs_size
        if res(5).pdp(j) == 1
            flag = 1;
            min_res(k, 1) = j;
            break;
        end 
         
    end

    if min_pdp(k, 1) <= min_res(k, 1)
        pdp_res(k, 1) = res(5).pdp(min_pdp(k, 1));
        ent_res(k, 1) = res(5).ent(min_pdp(k, 1));

    else
        pdp_res(k, 1) = inf;
        ent_res(k, 1) = inf;
        min_res(k, 1) = inf;
    end
end

fs_res_rev_list = fs_res_rev_list';
