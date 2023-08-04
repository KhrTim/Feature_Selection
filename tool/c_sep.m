% Clustering Evaluation: Class Separability
function res = c_sep(data, y_pred)
  c = unique(y_pred);
  c_num = length(c);
  c_prior = zeros(c_num, 1);
  for i = 1:c_num
    c_prior(i) = sum(y_pred == c(i)) / length(y_pred);
  end
  c_mean = zeros(c_num, size(data, 2));
  for i = 1:c_num
    idx = find(y_pred == c(i));
    c_mean(i, :) = mean(data(idx, :));
  end
  Sw = 0;
  for i = 1:c_num
    idx = find(y_pred == c(i));
    Sw = Sw + c_prior(i) * cov(data(idx, :));
  end
  Mo = mean(data); 
  Sb = 0;
  for i = 1:c_num
    Sb = Sb + (c_mean(i, :) - Mo) * (c_mean(i, :) - Mo)';
  end
  res = trace(inv(Sb) * Sw);
end
