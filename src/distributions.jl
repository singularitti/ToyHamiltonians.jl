using Distributions: Distribution, Uniform, Normal
using Random: AbstractRNG, default_rng

import Random: rand

export EigvalsSampler

struct EigvalsSampler{D<:Distribution,T,R<:AbstractRNG}
    dist::D
    type::T
    rng::R
end
EigvalsSampler(dist, type=Float64, rng=default_rng()) = EigvalsSampler(dist, type, rng)

rand(s::EigvalsSampler, dims::Integer...) = rand(s.rng, s.dist, dims...) .* oneunit(s.type)
