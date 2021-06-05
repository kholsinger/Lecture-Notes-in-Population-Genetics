data {
  int<lower=0> N_A;
  int<lower=0> N_AB;
  int<lower=0> N_B;
  int<lower=0> N_O;
}

transformed data {
  int<lower=0> N[4];

  N[1] = N_A;
  N[2] = N_AB;
  N[3] = N_B;
  N[4] = N_O;
}

parameters {
  // the three allele frequencies add to 1
  //
  simplex[3] p;
}

transformed parameters {
  real<lower=0, upper=1> p_a;
  real<lower=0, upper=1> p_b;
  real<lower=0, upper=1> p_o;
  // the four phenotype frequencies add to 1
  //
  simplex[4] x;

  // allele frequencies
  //
  p_a = p[1];
  p_b = p[2];
  p_o = p[3];
  // phenotype frequencies
  //
  // A
  x[1] = p_a^2 + 2*p_a*p_o;
  // AB
  x[2] = 2*p_a*p_b;
  // B
  x[3] = p_b^2 + 2*p_b*p_o;
  // O
  x[4] = p_o^2;
}

model {
  // likelihood
  //
  N ~ multinomial(x);

  // prior
  //
  p ~ dirichlet(rep_vector(1.0, 3));
}
