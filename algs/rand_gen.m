while 1
    data = zeros(8, 4);
    for i = 1:8
        for j = 1:4
            r = rand();
            if rand > 0.5
                data(i,j) = 1;
            end
        end
    end
    
    prop_idx = proposed(data, 4);
    prop_rev = proposed_reverse(data, 4);
    
    data_prop = data(:, prop_idx(1:2));
    data_rev = data(:, prop_rev(1:2));
    % check the number of each row (0, 0), (0, 1), (1, 0), (1, 1) on the data_prop
    count_00 = 0;
    count_01 = 0;
    count_10 = 0;
    count_11 = 0;
    count_rev_00 = 0;
    count_rev_01 = 0;
    count_rev_10 = 0;
    count_rev_11 = 0;
    for i = 1:8
        if data_prop(i, 1) == 0 && data_prop(i, 2) == 0
            count_00 = count_00 + 1;
        elseif data_prop(i, 1) == 0 && data_prop(i, 2) == 1
            count_01 = count_01 + 1;
        elseif data_prop(i, 1) == 1 && data_prop(i, 2) == 0
            count_10 = count_10 + 1;
        elseif data_prop(i, 1) == 1 && data_prop(i, 2) == 1
            count_11 = count_11 + 1;
        end
    end

    for i = 1:8
        if data_rev(i, 1) == 0 && data_rev(i, 2) == 0
            count_rev_00 = count_rev_00 + 1;
        elseif data_rev(i, 1) == 0 && data_rev(i, 2) == 1
            count_rev_01 = count_rev_01 + 1;
        elseif data_rev(i, 1) == 1 && data_rev(i, 2) == 0
            count_rev_10 = count_rev_10 + 1;
        elseif data_rev(i, 1) == 1 && data_rev(i, 2) == 1
            count_rev_11 = count_rev_11 + 1;
        end
    end

    % count the value of count_** and count_rev_** is 1
    count_prop = 0;
    count_rev = 0;
    if count_00 == 1
        count_prop = count_prop + 1;
    end
    if count_01 == 1
        count_prop = count_prop + 1;
    end
    if count_10 == 1
        count_prop = count_prop + 1;
    end
    if count_11 == 1
        count_prop = count_prop + 1;
    end

    if count_rev_00 == 1
        count_rev = count_rev + 1;
    end
    if count_rev_01 == 1
        count_rev = count_rev + 1;
    end
    if count_rev_10 == 1
        count_rev = count_rev + 1;
    end
    if count_rev_11 == 1
        count_rev = count_rev + 1;
    end

    if count_prop > count_rev
        disp('proposed is better');
    end
end
