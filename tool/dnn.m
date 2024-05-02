function pred = dnn(X, Y, X_test)

opt = trainingOptions("adam","MaxEpochs",50, "InitialLearnRate", 1e-4, "Verbose",false);
hidden_size = 32;
% add 1 to Y if Y contains 0
if min(Y) == 0
    Y = Y + 1;
end

% one-hot encoding
%Y = full(ind2vec(Y'))';
Y = categorical(Y);

layers = [featureInputLayer(size(X,2)), fullyConnectedLayer(hidden_size) reluLayer ...
    fullyConnectedLayer(hidden_size * 2) reluLayer fullyConnectedLayer(length(unique(Y))) softmaxLayer, classificationLayer];

net = trainNetwork(X, Y, layers, opt);

pred = classify(net, X_test);
pred = double(pred);

end
