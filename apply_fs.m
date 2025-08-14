% Load the binary dataset
load('binary_image_array.mat', 'data');

% Set a variance threshold (features with variance <= threshold are removed)
% For binary data, variance is p*(1-p), where p = mean of feature
%varThreshold = 0.01; % adjust depending on how strict you want to be

% Compute variance of each feature
%featureVar = var(double(data));

% Find features above threshold
selectedFeatures = proposed(data, 50);

% Reduce the dataset
%reducedData = data(:, selectedFeatures);

% Save reduced dataset
save('binary_image_array_reduced.mat', 'reducedData', 'selectedFeatures', '-v7.3');

% Report results
fprintf('Original features: %d\n', size(data, 2));
fprintf('Selected features: %d\n', sum(selectedFeatures));
