function res = rep_ent(data)
  cov_mat = cov(data);
  eig_val = eig(cov_mat);
  eig_prob = eig_val / sum(eig_val);

  res = 0;
  for i = 1:length(eig_prob)
    res = res - eig_prob(i) * log(eig_prob(i));
  end
end
