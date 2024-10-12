using Distributions: Distribution, Uniform, Normal
using Random: AbstractRNG, default_rng

import Random: rand

export RandomEigen

struct RandomEigen{D<:Distribution,T,R<:AbstractRNG}
    dist::D
    type::T
    rng::R
end
RandomEigen(dist, type=Float64, rng=default_rng()) = RandomEigen(dist, type, rng)

rand(x::RandomEigen, dims::Integer...) = rand(x.rng, x.dist, dims...) .* oneunit(x.type)
