# Here we play with basic likelihood-free rejection sampling which is how
# the area of ABC got started.

# The assumption is that we have a model that we think can have generated
# the data. We want to calibrate the model parameters (so that the model is as
# good a fit as possible) to the data. We also have a prior over the model
# parameters. The prior gives initial values to model parameters, often
# we have little preference among parameters and can use very general priors.

# Lets try this for a simple coin flipping process. Our model is that there
# is a certain probability of a head, we simulate a coin flip and return 1
# if it was a head, 0 otherwise.
function coin_flip_model(pHeads = 0.5)
  rand() < pHeads ? 1 : 0
end

# Parameter estimation is to estimate the parameters of a model based on 
# observed data.

# Lets say we observe 10 flips of which only 2 are heads:
flips1 = [1 1 0 0 0 0 0 0 0 0]

# Parameter estimation: What is the estimate of pHeads given the model above?

# We need to specify a prior belief in what we consider a likely value for 
# pHeads. We would rather not decide on a prior beforehand so lets define a
# uniform prior.
prior1 = () -> [rand()] # Note that a prior always returns sampled parameters in an Array (since there is typically many).

# The model that we test should create data of the same form as the observed
# data, so that we can compare them. In our case the model needs to run
# as many coin flips as there were coin flips in the actual data.
function repeated_coin_flips_model(params, actualData)
  n = length(actualData)
  observed = Array(typeof(actualData[1]), n)
  for(i in 1:n)
    observed[i] = coin_flip_model(params...)
  end
  observed
end

# To run ABC we need a distance function. Here we simply take the absolute
# difference in the number of heads:
d_absolute_diff_in_heads(d1, d2) = abs(sum(d1) - sum(d2))

# Pritchard's 1999 lf rejection sampler for continuous domains.
function lf_rejection_sampling(data, model, prior, distance; 
  tolerance = 0.01, numSamples = 10000)

  ok_params = Any[]
  params = :dummy

  for(i in 1:numSamples)
    rejected = true
    while rejected
      # Sample parameters from the prior
      params = prior() 

      # Sample data based on the params that has same "shape"/form as actual data.
      observed = model(params, data)

      # If observed data is close to actual data we do not reject the params.
      if distance(data, observed) <= tolerance
        rejected = false
      end
    end
    push!(ok_params, params)
  end

  ok_params
end

# ps = lf_rejection_sampling(flips1, repeated_coin_flips_model, prior1, d_absolute_diff_in_heads; numSamples = 10000)
# ps = [p[1] for p in ps]
# using Gadfly
# using Dataframes
# df = DataFrame(thetas = ps)
# draw(SVG("histogram.svg", 6inch, 3inch), plot(df, x = "thetas", Geom.histogram))