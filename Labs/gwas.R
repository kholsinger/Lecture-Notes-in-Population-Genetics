library(rstan)

rm(list = ls())

options(mc.cores = parallel::detectCores())

dat <- read.csv("gypsymoth.csv", header = TRUE)
L <- read.csv("gypsymoth-relatedness.csv", header = TRUE)

## change the phenotype that you're analyzing here
##
pheno <- dat$Mass

## DO NOT MODIFY BELOW HERE
##
n_loci <- ncol(dat) - 5

h_2 <- function(mu, x) {
  n_rep <- dim(mu)[1]
  h_2 <- numeric(n_rep)
  for (i in 1:n_rep) {
    var_mu <- var(mu[i,])
    var_resid <- var(mu[i,] - x)
    h_2[i] <- var_mu/(var_mu + var_resid)
  }
  return(median(h_2))
}

p <- matrix(nrow = n_loci, ncol = 4000)
mean_p <- numeric(n_loci)
mu <- array(dim = c(n_loci, 4000, nrow(dat)))
for (i in 1:n_loci) {
  cat("Checking locus ", i, "\n", sep = "")
  stan_data <- list(n_indiv = nrow(dat),
                    geno = dat[, i+5],
                    pheno = pheno,
                    L = L)
  stan_pars <- c("p", "mu")
  fit <- stan("gwas-one.stan",
              data = stan_data,
              pars = stan_pars,
              refresh = 0)
  x <- as.data.frame(fit)
  p[i,] <- x$p
  mean_p[i] <- mean(x$p)
  for (n in 1:nrow(dat)) {
    mu[i,,n] <- x[, paste("mu[", n, "]", sep = "")]
  }
}

loci <- data.frame(locus = seq(from = 1, to = n_loci, by = 1),
                   p_mean = mean_p)

loci <- loci[order(abs(loci$p_mean), decreasing = TRUE), ]

for (i in 1:20) {
  ci <- quantile(p[loci$locus[i], ], c(0.025, 0.975))
  cat("Locus ", loci$locus[i], ": ", round(loci$p_mean[i], 5),
      " (", round(ci[1], 5), ", ",
      round(ci[2], 5), ") ",
      " -- h^2: ", round(h_2(mu[loci$locus[i],,], pheno), 3), "\n",
      sep = "")
}

include <- loci$locus[1:20]


