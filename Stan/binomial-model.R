## Load the rstan library
##
library(rstan)

## set the number of chains to the number of cores in the computer
##
options(mc.cores = parallel::detectCores())

## set up the data
##   N: sample size
##   k: number of A1 alleles
stan_data <- list(N = 20,
                  k = 7)

## Invoke stan
##
fit <- stan("binomial-model.stan",
            data = stan_data,
            refresh = 0)

## print the results on the console with 3 digits after the decimal
##
print(fit, digits = 3)

