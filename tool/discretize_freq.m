function [discretizedData] = discretize_freq(data, numBins)
    % Equal-frequency Binning in MATLAB
    % Initialize discretized data array
    discretizedData = zeros(size(data));
    bin_width = floor(size(data, 1) / numBins);
    bin_arr = ones(size(data, 1), 1) * numBins;
    bin_idx = 1;
    for i = 1:bin_width:size(data, 1)
        if i + bin_width > size(data, 1)
            break;
        end
        bin_arr(i:i+bin_width-1, 1) = bin_idx;
        bin_idx = bin_idx + 1;
    end
    % Perform equal-frequency binning for each feature (column)
    for i = 1:size(data, 2)
        if length(unique(data(:, i))) < numBins
            discretizedData(:, i) = data(:, i);
        else
            [~, si] = sort(data(:, i));
            for j = 1:length(si)
                discretizedData(si(j), i) = bin_arr(j);
            end
        end
    end
end
