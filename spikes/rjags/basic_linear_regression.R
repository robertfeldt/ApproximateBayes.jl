source("hist.R")
library('rjags')

# Generate data
N <- 1000
x <- 1:N
epsilon <- rnorm(N, 0, 1)
b0 <- -3
b1 <- 3.7
y <- b0 + b1 * x + epsilon

# Create jags model described in external .bug file
jm <- jags.model('basic_linear_regression.bug',
                   data = list('x' = x, 'y' = y, 'N' = N),
                   n.chains = 5, n.adapt = 200)

# Update it to ensure good mixing. 
update(jm, 1000)

# Now we can draw our samples and save them in a data frame.
samples <- jags.samples(jm, c('b0', 'b1', 'tau'), 1000)
df <- data.frame(
  b0 = as.matrix(samples$b0), 
  b1 = as.matrix(samples$b1),
  tau = as.matrix(samples$tau))

nice_hist(df, "b0")
nice_hist(df, "b1")
nice_hist(df, "tau")