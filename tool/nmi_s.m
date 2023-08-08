function res = nmi_s(X, Y)
res = 0;
for i = 1:size(X, 2)
    res = res + mi(X(:,i), Y);
end
end