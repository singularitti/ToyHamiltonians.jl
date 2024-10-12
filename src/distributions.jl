using Distributions: Distribution, Truncated, Uniform, Normal, truncated
using Random: AbstractRNG, Sampler, default_rng

import Random: rand

export EigvalsSampler

struct EigvalsSampler{R<:AbstractRNG,T,D<:Truncated} <: Sampler{T}
    rng::R
    type::T
    dist::D
    function EigvalsSampler(dist::Distribution, type=Float64, rng=default_rng())
        lower, upper = zero(type), one(type)
        dist = truncated(dist; lower=lower, upper=upper)
        return new{typeof(rng),typeof(type),typeof(dist)}(rng, type, dist)
    end
end

rand(s::EigvalsSampler, dims::Integer...) = rand(s.rng, s.dist, dims...) .* oneunit(s.type)
