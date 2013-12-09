library(ggplot2)

nice_hist <- function(df, name) {
  data <- df[,name]
  bin_width <<- sd(data) / 5
  mean_value <<- mean(data)
  ti <<- paste("Histogram for ", name, " (mean = ", signif(mean_value, 3), 
    ", std = ", signif(sd(data), 3), ")", sep="")

  ggplot(df, aes_string(x = name)) + 
    theme_bw() +
    geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                   binwidth=bin_width,
                   colour="black", fill="white") +
    geom_density(alpha=.1, fill="#FF6666") +
    geom_vline(aes(xintercept=mean_value),
               color="black", linetype="dashed", size=.6) +
    ggtitle(ti)
}