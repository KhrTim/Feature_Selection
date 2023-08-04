function res = ffei(x, x_origin)
% Calulate the Fuzzy Feature Evalutaion index

% Calculate the distance between patterns in x and x_origin space
dist_x = pdist(x);
d_x_max = max(dist_x);
dist_x = squareform(dist_x);
dist_xo = pdist(x_origin);
d_xo_max = max(dist_xo);
dist_xo = squareform(dist_xo);



n = size(x, 1);
res = 0;
for i = 1:n
    for j = 1:n
        if j == i
            continue;
        end
        ur = 1 - dist_x(i, j)/d_x_max;
        uo = 1 - dist_xo(i, j)/d_xo_max;
        temp = ur * (1 - uo) + uo * (1 - ur);
        temp = temp * 0.5;
        res = res + temp;
    end
end
res = res * 2 / (n * (n - 1));
end
% Calculate the FFEI



  
