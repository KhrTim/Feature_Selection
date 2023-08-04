function param_mat = make_param_mat(param_arr, num)

for k = 1:num
    d{k} = param_arr;
end

if num == 2
    [a1, a2] = ndgrid(d{k});
    param_mat = [a1(:), a2(:)];
elseif num == 3
    [a1, a2, a3] = ndgrid(d{k});
    param_mat = [a1(:), a2(:), a3(:)];
elseif num == 4
    [a1, a2, a3, a4] = ndgrid(d{k});
    param_mat = [a1(:), a2(:), a3(:), a4(:)];
else
    error('num must be 2, 3, or 4');
end
    
end

