function ret = normalize(X)
% data is n x d

n = size(X, 1);
min_v = min(X, [], 1);
max_v = max(X, [], 1);
ret = (X - ones(n, 1) * min(X, [], 1)) ./ (ones(n, 1) * ( max_v - min_v ));
end