data {
  int<lower=0> n_indiv;            // number of individuals in data
  vector[n_indiv] geno;            // genotype data
  vector[n_indiv] pheno;           // phenotype data
  cholesky_factor_cov[n_indiv] L;  // covariance of multivariate normal model
}

transformed data {
  real mean_pheno;            // sample mean
  real<lower=0> sd_pheno;     // sample standard deviation
  
  mean_pheno = mean(pheno);
  sd_pheno = sd(pheno);
  
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
  // prior on intercept
  //
  a ~ normal(mean_pheno, 4*sd_pheno);
  
  // prior on random effect
  //
  sigma_ran ~ inv_gamma(2.0, 1.0);
  z ~ normal(0, sigma_ran);
  
  p ~ normal(0.0, 4*sd_pheno);

  // prior on sigma
  //
  sigma ~ inv_gamma(2.0, 1.0);

  // likelihood
  //
  for (n in 1:n_indiv) {
    pheno[n] ~ normal(mu[n] + u[n], sigma);
  }
}
