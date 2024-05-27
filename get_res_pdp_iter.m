clear;

load('./total_res_iter.mat');


data_size = size(min_pdp, 1);
alg_size = size(min_pdp, 2);

pdp_res = zeros(data_size, alg_size);
ent_res = zeros(data_size, alg_size);

for k = 1:data_size
    min_idx = min(min_pdp(k, :));
    max_fea_size = size(total_res(k).pdp, 2);
    if min_idx > max_fea_size
        min_idx = max_fea_size;
    end
    for i = 1:alg_size
        pdp_res(k, i) = total_res(k).pdp(i, min_idx);
        ent_res(k, i) = total_res(k).ent(i, min_idx);
    end
end

save('./pdp_res.mat', 'pdp_res', 'ent_res');


