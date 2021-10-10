library(mvtnorm)
library(ggplot2)

rm(list = ls())

x <- rmvnorm(1000, sigma = matrix(c(1,0.9,0.9,1), nrow = 2))
df <- data.frame(x)
colnames(df) <- c("x", "y")

df_pr <- prcomp(df)

p <- ggplot(df, aes(x = x, y = y)) + 
  geom_point() + 
  theme_bw() +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0)

x_lo <- 6*df_pr$rotation[1,1]
y_lo <- 6*df_pr$rotation[2,1]
x_hi <- -6*df_pr$rotation[1,1]
y_hi <- -6*df_pr$rotation[2,1]
pc_1 <- data.frame(x = c(x_lo, x_hi), y = c(y_lo, y_hi))

x_lo <- 6*df_pr$rotation[1,2]
y_lo <- 6*df_pr$rotation[2,2]
x_hi <- -6*df_pr$rotation[1,2]
y_hi <- -6*df_pr$rotation[2,2]
pc_2 <- data.frame(x = c(x_lo, x_hi), y = c(y_lo, y_hi))

p <- p + geom_line(data=pc_1, color = "blue", linetype = "dashed") + 
  geom_line(data=pc_2, color = "blue", linetype = "dashed")
print(p)
