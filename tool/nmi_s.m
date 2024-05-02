function res = nmi_s(X, Y)
res = h(X) + h(Y) - h([X, Y]);
end