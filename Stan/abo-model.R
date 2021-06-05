library(rstan)

options(mc.cores = parallel::detectCores())

stan_data <- list(N_A = 862,
                  N_AB = 131,
                  N_B = 365,
                  N_O = 702)

fit <- stan("abo-model.stan",
            data = stan_data,
            refresh = 0)

old_opts <- options(width = 180)
print(fit, digits = 3)
options(old_opts)
