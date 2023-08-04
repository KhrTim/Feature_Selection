function [discretizedData] = discretize_width(data, numBins)
    % Equal-width Binning in MATLAB
    discretizedData = zeros(size(data));
    % Perform equal-width binning for each feature (column)
    for i = 1:size(data, 2)
        if length(unique(data(:, i))) < numBins
            discretizedData(:, i) = data(:, i);
        else
            discretizedData(:, i) = discretize(data(:, i), numBins);
        end
    end
end