using Distributions: Distribution, Truncated, Uniform, Normal, truncated
using LinearAlgebra: qr
using Random: AbstractRNG, Sampler, default_rng

import Random: rand

export EigvalsSampler, EigvecsSampler

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

struct EigvecsSampler{R<:AbstractRNG,T,D<:Distribution} <: Sampler{T}
    rng::R
    type::T
    dist::D
    EigvecsSampler(dist, type=Float64, rng=default_rng()) =
        new{typeof(rng),typeof(type),typeof(dist)}(rng, type, dist)
end

function Hamiltonian(s₁::EigvalsSampler, s₂::EigvecsSampler, m::Integer)
    evals, evecs = sort(rand(s₁, m)), collect(rand(s₂, m, m))
    return Hamiltonian(Eigen(evals, evecs))
end

rand(s::EigvalsSampler, dims::Integer...) = rand(s.rng, s.dist, dims...) .* oneunit(s.type)
function rand(s::EigvecsSampler, m::Integer, n::Integer)
    matrix = rand(s.rng, s.dist, m, n) .* oneunit(s.type)
    q, _ = qr(matrix)
    return q
end
