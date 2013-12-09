source("hist.R")
library('rjags')

# Generate data
N <- 1000
x <- 1:N
a <- -5
b <- 0.03
z <- a + b * x
y <- sapply(1 / (1 + exp(-z)), function(p) {rbinom(1, 1, p)})

# Create jags model described in external .bug file
jm <- jags.model('one_dimensional_linear_regression.bug',
                   data = list('x' = x, 'y' = y, 'N' = N),
                   n.chains = 5, n.adapt = 200)

# Update it to ensure good mixing. 
update(jm, 1000)

# Now we can draw our samples and save them in a data frame.
samples <- jags.samples(jm, c('a', 'b'), 1000)
df <- data.frame(
  a = as.matrix(samples$a), 
  b = as.matrix(samples$b))

nice_hist(df, "a")
nice_hist(df, "b")