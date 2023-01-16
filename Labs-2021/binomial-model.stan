data {
  int<lower=0> N;     // the sample size
  int<lower=0> k;     // the number of A_1 alleles observed
}

parameters {
  real<lower=0, upper=1> p;  // the allele frequency
}

model {
  // likelihood
  //
  k ~ binomial(N, p);

  // prior
  p ~ uniform(0.0, 1.0);
}
