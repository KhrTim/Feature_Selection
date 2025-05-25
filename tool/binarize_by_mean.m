function [binarizedData] = binarize_by_mean(data)
    % Binarize each column based on its average value
    binarizedData = zeros(size(data));  % Initialize
    for i = 1:size(data, 2)
        mean_val = mean(data(:, i));
        binarizedData(:, i) = data(:, i) > mean_val;
    end
end
