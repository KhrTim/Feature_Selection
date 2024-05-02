function [m_dnn, s_dnn] = acc_dnn(X, Y)
% NBACC: MVMN Naive Bayes accuracy
% 10 Fold cross validation
rng(1);
sim_seq = crossvalind('Kfold', size(X, 1), 10);

acc_dnn = zeros(10, 1);

for i = 1:10
    test = (sim_seq == i);
    train = ~test;
    pred = dnn(X(train,:), Y(train), X(test, :));
    acc_dnn(i) = sum(pred == Y(test)) / length(Y(test));
end
m_dnn = mean(acc_dnn);
s_dnn = std(acc_dnn);
end
