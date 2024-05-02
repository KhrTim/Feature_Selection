function res = proposed_reverse(X, max_feat)

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

first_vec = sum(ff_ent, 2);
first_vec = first_vec - f_ent;
[~, res(1,1)] = min(f_ent);

for k =2:max_feat
    t_rel = zeros(fcol, 1);
    for m=1:fcol
        if ismember(m, res)
            t_rel(m,1) = inf;
            continue;
        end
        t_rel(m,1) = sum(ff_ent(m, res), 2);
    end
    [~, idx] = min(t_rel); 
    res(end+1,1) = idx;
end
end

function [res] = p_entropy( vector )

[uidx,~,single] = unique( vector, 'rows' );
count = zeros(size(uidx,1),1);
for k=1:size(vector,1)
    count( single(k), 1 ) = count( single(k), 1 ) + 1;
end
res = -( (count/size(vector,1))'*log2( (count/size(vector,1)) ) );
end
