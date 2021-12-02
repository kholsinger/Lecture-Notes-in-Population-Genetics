library(rstan)

rm(list = ls())

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

dat <- read.csv("gypsymoth.csv", header = TRUE)
L <- read.csv("gypsymoth_relatedness.csv", header = TRUE)

analyze_trait <- function(dat, L, trait, n_loci = NA) {
  ## convert dat to data frame for subscripting
  ##
  dat <- as.data.frame(dat)

  if (is.na(n_loci)) {
    n_loci <- ncol(dat) - 5
  }
  n_chains <- 4
  n_iter <- 5000
  n_samples <- (n_iter/2)*n_chains
  p <- matrix(nrow = n_loci, ncol = n_samples)
  mean_p <- numeric(n_loci)
  mu <- array(dim = c(n_loci, n_samples, nrow(dat)))
  for (i in 1:n_loci) {
    cat("Checking locus ", i, "\n", sep = "")
    stan_data <- list(n_indiv = nrow(dat),
                      geno = dat[, i+5],
                      pheno = dat[[trait]],
                      L = L)
    stan_pars <- c("p", "mu")
    fit <- stan("gwas.stan",
                data = stan_data,
                pars = stan_pars,
                iter = n_iter,
                chains = n_chains)#,
#                refresh = 0)
    x <- as.data.frame(fit)
    p[i,] <- x$p
    mean_p[i] <- mean(x$p)
  }
  loci <- data.frame(locus = colnames(dat)[(1:n_loci) + 5],
                     p_mean = mean_p)
  loci <- loci[order(abs(loci$p_mean), decreasing = TRUE), ]
  rownames(p) <- loci$locus
  return(list(loci = loci, p = p))
}

summarize_analysis <- function(results, n_report = 20) {
  if (n_report > nrow(results$loci)) {
    n_report <- nrow(results$loci)
  }
  cat("Mean: (2.5%, 10%, 50%, 90%, 97.5%)\n")
  for (i in 1:n_report) {
    ci <- quantile(results$p[results$loci$locus[i], ],
                   c(0.025, 0.1, 0.5, 0.9, 0.975))
    output <- sprintf("%6s: %8.5f (%8.5f, %8.5f, %8.5f, %8.5f, %8.5f)\n",
                      results$loci$locus[i],
                      results$loci$p_mean[i],
                      ci[1], ci[2], ci[3], ci[4], ci[5])
    cat(output)
  }
}

results <- analyze_trait(dat, L, "Mass")
sink(file = "gypsymoth-Mass.txt")
cat("Mass...\n")
summarize_analysis(results)
sink()
results <- analyze_trait(dat, L, "PD")
sink(file = "gypsymoth-PD.txt")
cat("PD...\n")
summarize_analysis(results)
sink()
results <- analyze_trait(dat, L, "TDT")
sink(file = "gypsymoth-TDT.txt")
cat("TDT...\n")
summarize_analysis(results)
sink()
