function [res, s_res] = kmeans_rng(X, Y, trial, X_origin)
rng(1);
cluster = length(unique(Y));
c_res = zeros(trial, 1);
res = zeros(1, 4);
res(1, 2) = ent(X);
res(1, 3) = rep_ent(X);
res(1, 4) = ffei(X, X_origin);
for k = 1:trial
    pred = kmeans(X, cluster);
    c_res(k, 1) = c_sep(X, pred);
end
res(1, 1) = mean(c_res);
s_res = std(c_res);
end
