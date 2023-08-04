function eval_res = kmeans_rng(X, Y, trial, X_origin)
rng(1);
cluster = length(unique(Y));
sil = zeros(trial, 1);
dbi = zeros(trial, 1);
c = zeros(trial, 1);
acc = zeros(trial, 1);
nmi = zeros(trial, 1);
sil_res = zeros(1, 2);
dbi_res = zeros(1, 2);

for k = 1:trial
    pred = kmeans(X, cluster);
    [sil_score, ~] = silhouette(X, pred);
    sil(k, 1) = mean(sil_score);
    dbi(k, 1) = evalclusters(X, pred, 'DaviesBouldin').CriterionValues;
    res = evalClustering(Y, pred);
    acc(k, 1) = res.acc;
    nmi(k, 1) = res.nmi_max;
    c(k, 1) = c_sep(X, pred);
end
sil_res(1, 1) = mean(sil);
sil_res(1, 2) = std(sil);
dbi_res(1, 1) = mean(dbi);
dbi_res(1, 2) = std(dbi);
acc_res(1, 1) = mean(acc);
acc_res(1, 2) = std(acc);
nmi_res(1, 1) = mean(nmi);
nmi_res(1, 2) = std(nmi);
c_res(1, 1) = mean(c);
c_res(1, 2) = std(c);
ffei_res = ffei(X, X_origin);
eval_res = struct('sil', sil_res, 'dbi', dbi_res, ...
    'acc', acc_res, 'nmi', nmi_res, 'c', c_res, 'ffei', ffei_res);
eval_res.sil = sil_res;
eval_res.dbi = dbi_res;
eval_res.acc = acc_res;
eval_res.nmi = nmi_res;
eval_res.c = c_res;
eval_res.ffei = ffei_res;
end
