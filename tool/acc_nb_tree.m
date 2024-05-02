function [m_nb, s_nb, m_tree, s_tree] = acc_nb_tree(X, Y)
% NBACC: MVMN Naive Bayes accuracy
% 10 Fold cross validation
rng(1);

sim_seq = crossvalind('Kfold', size(X, 1), 10);

acc_nb = zeros(10, 1);
acc_tree = zeros(10, 1);

for i = 1:10
    test = (sim_seq == i);
    train = ~test;
    nb = fitcnb(X(train, :), Y(train), 'DistributionNames', 'mvmn');
    tree = fitctree(X(train, :), Y(train));
    pred = predict(nb, X(test, :));
    acc_nb(i) = sum(pred == Y(test)) / length(Y(test));
    pred = predict(tree, X(test, :));
    acc_tree(i) = sum(pred == Y(test)) / length(Y(test));

end

m_nb = mean(acc_nb);
s_nb = std(acc_nb);
m_tree = mean(acc_tree);
s_tree = std(acc_tree);

end
