## Simple function to plot DAPC results
##
plot_dapc <- function(dat, x_num  = 1, y_num = 2) {
  df_ind <- data.frame(dat$ind.coord)
  df_ind$Location <- dat$grp
  df_names <- colnames(df_ind)
  p <- ggplot(df_ind, aes(x = df_ind[, x_num], 
                          y = df_ind[, y_num], 
                          color = Location)) +
    geom_point() + 
    scale_color_brewer(type = "qualitative", palette = "Set1") +
    xlab(paste("Discriminant axis ", x_num, sep = "")) +
    ylab(paste("Discriminant axis ", y_num, sep = "")) +
    theme_bw()
  p
}