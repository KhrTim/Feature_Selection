function ret = rankufs(data, c, lambda1, lambda2, lambda3)
% my_socfs에 low-rank 다시 적용
% lambda3 is for rank

[n, d] = size(data);

X = data;

% X를 0-1로 해보자
min_v = min(X, [], 1);
max_v = max(X, [], 1);
X = (X - ones(n, 1) * min(X, [], 1)) ./ (ones(n, 1) * ( max_v - min_v ));
XX = X' * X; % d by d

W = rand(d, c);
D = diag( ones(d, 1) ./ (2 * sum(W.^2, 2).^0.5 + eps) );
[B,~] = qr( rand( c, c ), 'econ' );
[E,~] = qr( rand( n, c ), 'econ' );
F = rand(size(E));

ITER1 = 30;
ITER2 = 10;

% print first obj value
% fprintf('0th obj %f\n', obj(X, W, B, E, lambda1, lambda3));

for iter1=1:ITER1    

    % 1. update E and F
    for iter2=1:ITER2
        temp1 = B' * W' * X' + lambda2 * F';
        [U_E, ~, V_E] = svd(temp1, 'econ');
        E = V_E * U_E';
        F = 0.5 * ( E + abs(E) );
    end

    % 2. update W
    [U_W, ~, V_W] = svd(W, 'econ');
    grad_rank = U_W * V_W';
    W = (XX + lambda1 * D) \ (X' * (E * B') - 0.5 * lambda3 * grad_rank);
    % iteratively
%     nume = X' * E * B' + lambda3 * W;
%     deno = XX * W + lambda1 * D * W + lambda3 * ones(d, d) * W + eps;
%     W = W .* (nume ./ deno);

    % 3. update B
    temp2 = E' * X * W;
    [U_B, ~, V_B] = svd(temp2, 'econ');
    B = V_B * U_B'; 

    % 4. update D
    D = diag( ones(d, 1) ./ (2 * sum(W.^2, 2).^0.5 + eps) );
    
    % print obj value
%     fprintf('%dth obj %f\n', iter1, obj(X, W, B, E, lambda1, lambda3));
end

[~,ret] = sort(sum(W.*W,2), 'descend');

end

function ret = obj(X, W, B, E, lambda1, lambda3)
ret = sum(sum((X * W - E * B').^2)) + lambda1 * l21norm(W);
ret = ret + lambda3 * trace((W' * W)^0.5);
end

function ret = l21norm(X)
ret = sum( sum(X.^2, 2).^0.5 );
end