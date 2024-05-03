function res = nmi_s(X, Y)
res = p_entropy(X) + p_entropy(Y) - p_entropy([X, Y]);
end