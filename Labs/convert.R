## Convert repens data to Fstat format

library("tidyverse")
library(Hickory)

rm(list = ls())

dat <- read_csv("http://darwin.eeb.uconn.edu/eeb348-resources/repens-outliers.csv",
                col_types = cols(pop = col_character(), .default = col_integer()))

for (i in 1:nrow(dat)) {
  for (j in 2:ncol(dat)) {
    if (!is.na(dat[i, j])) {
      if (dat[i, j] == 0) {
        dat[i, j] <- 11
      } else if (dat[i, j] == 1) {
        dat[i, j] <- 12
      } else if (dat[i, j] == 2) {
        dat[i, j] <- 22
      }
    }   
  }
}
dat$Location <- as.numeric(as.factor(dat$pop))
dat <- relocate(dat, Location) %>%
  select(-pop)

genos <- read_marker_data("http://darwin.eeb.uconn.edu/eeb348-resources/repens-outliers.csv")

sink("repens-outliers.dat")
cat(genos$N_pops, " ", genos$N_loci, " ", 2, 1, "\n")
loci <- names(dat)[-1]
for (i in 1:length(loci)) {
  cat(loci[i], "\n", sep = "")
}
for (i in 1:nrow(dat)) {
  pop_str <- sprintf("%2d  ", dat$Location[i])
  cat(pop_str)
  for (i in 2:ncol(dat)) {
    if (!is.na(dat[i, j])) {
      ## necessary because dat is a tibble
      ##
      output <- as.numeric(dat[i, j])
    } else {
      output <- " 0"
    }
    cat(output, " ", sep = "")
  }
  cat("\n")
}
sink()