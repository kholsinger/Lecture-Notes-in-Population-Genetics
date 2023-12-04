options(tidyverse.quiet = TRUE)
library(tidyverse)
library(rstan)
library(brms)
library(popkin)

rm(list = ls())

options(mc.cores = parallel::detectCores())

analyze_trait <- function(dat, A, trait, loci, n_samples = 2000, n_chains = 4) {
  n_loci <- length(loci)
  p_raw <- matrix(nrow = n_loci, ncol = n_chains*n_samples/2)
  mean_p <- numeric(n_loci)
  mu <- array(dim = c(n_loci, n_samples, nrow(dat)))
  for (i in 1:n_loci) {
    locus <- colnames(dat)[loci[i] + 5]
    cat(trait, ": ",  "Checking locus ", loci[i], " (", locus, ")\n", sep = "")
    fit <- brm(paste(trait, locus, sep = " ~ "),
               data = dat,
               data2 = list(A = A),
               family = gaussian(),
               iter = n_samples,
               refresh = 0)
    x <- as.data.frame(fit)
    brm_locus <- paste("b_", locus, sep ="")
    p_raw[i,] <- x[[brm_locus]]
    mean_p[i] <- mean(x[[brm_locus]])
  }
  loci <- data.frame(locus = colnames(dat)[(1:n_loci) + 5],
                     p_mean = mean_p,
                     index = 1:n_loci)
  loci <- loci[order(abs(loci$p_mean), decreasing = TRUE), ]
  p <- matrix(nrow = n_loci, ncol = n_chains*n_samples/2)
  for (i in 1:n_loci) {
    p[i, ] <- p_raw[loci$index[i],]
  }
  rownames(p) <- loci$locus
  return(list(loci = loci, p = p))
}

summarize_analysis <- function(results, trait) {
  n_report <- nrow(results$loci)
  dat <- tibble(Locus = character(n_report),
                Mean = numeric(n_report),
                `2.5%` = numeric(n_report),
                `10%` = numeric(n_report),
                `50%` = numeric(n_report),
                `90%` = numeric(n_report),
                `97.5%` = numeric(n_report))
  for (i in 1:n_report) {
    ci <- quantile(results$p[results$loci$locus[i], ],
                   c(0.025, 0.1, 0.5, 0.9, 0.975))
    dat$Locus[i] <- results$loci$locus[i]
    dat$Mean[i] <- results$loci$p_mean[i]
    dat$`2.5%`[i] <- ci[1]
    dat$`10%`[i] <- ci[2]
    dat$`50%`[i] <- ci[3]
    dat$`90%`[i] <- ci[4]
    dat$`97.5%`[i] <- ci[5]
  }
  write_csv(dat, paste("GWAS-", trait, "-results.csv", sep =""))
}

## read the data
##
dat <- read_csv("gypsymoth.csv",
                show_col_types = FALSE)
## get the relatedness matrix
##
genos <- dat %>% select(starts_with("X"))
A <- popkin(t(as.matrix(genos)),
            subpops = dat$pops)
## identify the rows with the sample names
##
rownames(A) <- dat$sample

## The first five columns are (1) the population label, (2) the sample identifier, (3) Mass, (4) PD, and
## (5) TDT. All of the remaining columns are loci
##
## summarize_analysis doesn't print the results (in this version). It merely saves them in a file named
## GWAS-<trait>-results.csv where <trait> is replaced by Mass, PD, or TDT
##
n_loci <- ncol(dat)-5
## for (trait in c("Mass", "PD", "TDT")) {
##   results <- analyze_trait(dat, A, trait, 1:n_loci)
##   summarize_analysis(results, trait)
## }
results <- analyze_trait(dat, A, "TDT", 1:n_loci)
summarize_analysis(results, "TDT")
