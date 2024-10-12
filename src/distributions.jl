using Distributions: Distribution, Uniform, Normal
using Random: AbstractRNG

export RandomEigen, rand_uniform, rand_normal

struct RandomEigen{R<:AbstractRNG,D<:Distribution,T}
    rng::R
    dist::D
    type::T
end

rand_uniform(rng::AbstractRNG, ::Type{X}, dims::Integer...) where {X} =
    rand(rng, X, Uniform(0, 1), dims...) .* oneunit(X)
rand_uniform(::Type{X}, dims::Integer...) where {X} =
    rand(Uniform(0, 1), dims...) .* oneunit(X)
rand_uniform(dims::Integer...) = rand(Uniform(0, 1), dims...)

rand_normal(rng::AbstractRNG, ::Type{X}, μ, σ, dims::Integer...) where {X} =
    rand(rng, X, Normal(μ, σ), dims...) .* oneunit(X)
rand_normal(::Type{X}, μ, σ, dims::Integer...) where {X} =
    rand(Normal(μ, σ), dims...) .* oneunit(X)
rand_normal(μ, σ, dims::Integer...) = rand(Normal(μ, σ), dims...)
