clear;

load("toy.mat");

[r num_fea] = size(idx);

result = zeros(r, 1);

for i = 1:r
    result(i) = p_entropy(dat(:, idx(i, :)));
end

