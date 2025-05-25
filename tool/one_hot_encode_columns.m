function [encodedData] = one_hot_encode_columns(data)
    % One-hot encode columns with more than 2 unique values
    encodedData = [];

    for i = 1:size(data, 2)
        col = data(:, i);
        unique_vals = unique(col);
        
        if length(unique_vals) > 2
            % One-hot encoding
            one_hot = zeros(length(col), length(unique_vals));
            for j = 1:length(unique_vals)
                one_hot(:, j) = (col == unique_vals(j));
            end
            encodedData = [encodedData one_hot]; % Concatenate the new one-hot columns
        else
            % Keep original column
            encodedData = [encodedData col];
        end
    end
end