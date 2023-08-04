function res = ent(data)
  max_val = zeros(1, size(data,2));
  min_val = zeros(1, size(data,2));
  for i = 1:size(data,2)
    max_val(i) = max(data(:,i));
    min_val(i) = min(data(:,i));
  end
  avg_distance = 0;
  dist_map = zeros(size(data,1), size(data,1));
  for i = 1:size(data,1)
    for j = 1:size(data,1)
      if i ~= j
        temp = dpq(i,j, data, max_val, min_val);
        dist_map(i,j) = temp;
        avg_distance = avg_distance + temp;
      end
    end
  end
  avg_distance = avg_distance / (size(data,1) * (size(data,1) - 1));

  alpha = -log(0.5) / avg_distance;
  for i = 1:size(data,1)
    for j = 1:size(data,1)
      if i ~= j
        dist_map(i,j) = exp(-alpha * dist_map(i,j));
      end
    end
  end

  res = 0;
  for i = 1:size(data,1)
    for j = 1:size(data,1)
      temp = dist_map(i,j) * log(dist_map(i,j)) + (1 - dist_map(i,j)) * log(1 - dist_map(i,j));
      if isnan(temp)
        temp = 0;
      end
      res = res + temp;
    end
  end
  res = -res;
end

function d = dpq(p,q, data, max_val, min_val)
  d = 0;
  for i = 1:size(data,2)
    local_d = (data(p, i) - data(q, i)) / (max_val(i) - min_val(i));
    d = d + local_d^2;
  end
  d = sqrt(d);
end
