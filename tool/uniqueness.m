function res = uniqueness(X)
% Calculates the uniqueness of a matrix of row vectors
% X is a matrix of row vectors
% res is a porportion of the vectors that are unique

% Get the number of vectors
n = size(X,1);

% Get the number of unique vectors
uni_vec = unique(X, "rows");
uni = size(uni_vec,1);
res = uni/n;

end
