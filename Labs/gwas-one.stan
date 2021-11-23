data {
  int<lower=0> n_indiv;            // number of individuals in data
  vector[n_indiv] geno;            // genotype data
  vector[n_indiv] pheno;           // phenotype data
  cholesky_factor_cov[n_indiv] L;  // covariance of multivariate normal model
}

parameters {
  vector[n_indiv] z;          // random effect primitive
  real p;                     // variant effect
  real a;                     // intercept
  real<lower=0> sigma;        // residual variance
  real<lower=0> sigma_ran;    // variance of random effect
}

transformed parameters {
  vector[n_indiv] u;          // random effect
  vector[n_indiv] mu;         // individual expectation

  // L is lower triangular Cholesky factor of relatedness matrix
  // z is individual-specific random effect
  // 
  u = L*z; // random effect
  for (n in 1:n_indiv) {
    mu[n] = a + p*geno[n];
  }
}

model {
  // prior on random effect
  //
  sigma_ran ~ inv_gamma(2.0, 1.0);
  z ~ normal(0, sigma_ran);
  
  p ~ normal(0.0, 1.0);

  // prior on sigma
  //
  sigma ~ inv_gamma(2.0, 1.0);

  // likelihood
  //
  for (n in 1:n_indiv) {
    pheno[n] ~ normal(mu[n] + u[n], sigma);
  }
}
