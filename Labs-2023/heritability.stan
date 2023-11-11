data {
  int<lower = 0> n_indiv;
  int<lower = 0> n_sires;
  real mu_prior;
  real prior_within;
  real prior_among;
  int sire[n_indiv];
  vector[n_indiv] pheno;
}

parameters {
  vector[n_sires] mu;
  real<lower = 0> sigma_s;
  real<lower = 0> sigma_w;
}

model {
  // likelihood
  //
  for (i in 1:n_indiv) {
    pheno[i] ~ normal(mu[sire[i]], sigma_w);
  }

  // priors
  //
  for (i in 1:n_sires) {
    mu[i] ~ normal(mu_prior, sigma_s);
  }
  sigma_w ~ exponential(prior_within);
  sigma_s ~ exponential(prior_among);
}

generated quantities {
  real h_2;
  real sigma_s_2;
  // to avoid integer division
  //
  real indiv = n_indiv;
  real sires = n_sires;
  real n_off;

  n_off = indiv/sires;
  h_2 = sigma_s^2*n_off/(sigma_s^2*n_off + sigma_w^2);
  sigma_s_2 = sigma_s^2;
}
