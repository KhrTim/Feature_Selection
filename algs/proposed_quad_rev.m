function res = proposed_quad_rev(X, max_feat)

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

% quadratic prog
x = quadprog(ff_ent, zeros(fcol,1), [], [], ones(1, fcol) , 1, zeros(fcol,1), ones(fcol,1), [], optimset('Display','off'));
[~,idx] = sort(x, 'descend');
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
