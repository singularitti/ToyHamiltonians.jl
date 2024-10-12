using Distributions
using Random: AbstractRNG

export rand_uniform

rand_uniform(rng::AbstractRNG, ::Type{X}, dims::Integer...) where {X} =
    rand(rng, X, Uniform(0, 1), dims...) .* oneunit(X)
rand_uniform(::Type{X}, dims::Integer...) where {X} =
    rand(Uniform(0, 1), dims...) .* oneunit(X)
rand_uniform(dims::Integer...) = rand(Uniform(0, 1), dims...)
