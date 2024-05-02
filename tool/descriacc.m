function [m, s] = descriacc(X)
rng(1);

sim_seq = crossvalind('Kfold', size(X, 1), 10);

acc = zeros(10, 1);
for i = 1:10
    test = (sim_seq == i);
    train = ~test;
    X_train = X(train, :);
    X_test = X(test, :);

    %check if a pattern in X_test is in X_train
    for j = 1:size(X_test, 1)
        if sum(ismember(X_train, X_test(j, :), 'rows')) > 0
            acc(i) = acc(i) + 1;
        end
    end
    acc(i) = acc(i) / size(X_test, 1);
end
m = mean(acc);
s = std(acc);
end
