function res = proposed_quad(X, max_feat)

fcol = size(X,2);
f_ent = zeros(fcol, 1);
ff_ent = zeros(fcol, fcol);

for k = 1:fcol
    f_ent(k,1) = p_entropy(X(:,k));
end

for k = 1:fcol
    for m = k:fcol
        if k == m
            ff_ent(k,m) = f_ent(k,1) / 2;
            continue;
        end
        ff_ent(k,m) = p_entropy([X(:,k) X(:,m)]);
    end
end

ff_ent = ff_ent + ff_ent'; 

% eigenvector of ff_ent
[V,D] = eig(ff_ent);
eigenvalues = diag(D);
[~, idx] = max(eigenvalues);

% 최대 고유값에 해당하는 고유벡터
max_v = V(:, idx);
max_v = abs(max_v);
[~, idx] = sort(max_v, 'descend');
res = idx(1:max_feat);
res = res';
end

function [res] = p_entropy( vector )

[uidx,~,single] = unique( vector, 'rows' );
count = zeros(size(uidx,1),1);
for k=1:size(vector,1)
    count( single(k), 1 ) = count( single(k), 1 ) + 1;
end
res = -( (count/size(vector,1))'*log2( (count/size(vector,1)) ) );
end
