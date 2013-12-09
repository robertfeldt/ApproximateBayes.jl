source("hist.R")
library('rjags')

# Generate data
N <- 1000
x <- rnorm(N, 0, 5)

# Create jags model described in external .bug file
jm <- jags.model('inference_normally_distributed.bug',
                   data = list('x' = x,
                               'N' = N),
                   n.chains = 5,
                   n.adapt = 100)

# Update it to ensure good mixing. 
update(jm, 1000)

# Now we can draw our samples and save them in a data frame.
samples <- jags.samples(jm, c('mu', 'tau'), 1000)
df <- data.frame(mu = as.matrix(samples$mu), 
  tau = as.matrix(samples$tau))

nice_hist(df, "mu")
nice_hist(df, "tau")
