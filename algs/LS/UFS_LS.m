function idx = UFS_LS(X, max_fea)
options = [];
options.Metric = 'Cosine';
options.NeighborMode = 'KNN';
options.k = 5;
options.WeightMode = 'Cosine';
W = constructW(X,options);
value = LaplacianScore(X,W);
[~, index] = sort(-value);
idx = index(1:max_fea, 1);
end

