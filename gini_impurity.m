function [gini_value] = gini_impurity(X)
    [~, ~, idx] = unique(X, 'rows'); % Find unique rows
    counts = accumarray(idx, 1); % Count occurrences of each row
    gini_value = (1 - sum((counts/length(X)).^2));
end