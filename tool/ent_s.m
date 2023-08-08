function res = ent_s(X)
res = 0;
for i = 1:size(X, 2)
    res = res + h(X(:,i));
end
end