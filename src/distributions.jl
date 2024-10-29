using Distributions: Distribution
using LinearAlgebra: qr
using Random: AbstractRNG, default_rng

import Random: rand

export EigvalsSampler, EigvecsSampler

abstract type Sampler{R<:AbstractRNG,D<:Distribution} end

struct EigvalsSampler{R,D} <: Sampler{R,D}
    rng::R
    dist::D
    function EigvalsSampler(dist, rng=default_rng())
        return new{typeof(rng),typeof(dist)}(rng, dist)
    end
end

struct EigvecsSampler{R,D} <: Sampler{R,D}
    rng::R
    dist::D
    EigvecsSampler(dist, rng=default_rng()) = new{typeof(rng),typeof(dist)}(rng, dist)
end

function Hamiltonian(s₁::EigvalsSampler, s₂::EigvecsSampler, m::Integer)
    evals, evecs = sort(rand(s₁, m)), collect(rand(s₂, m, m))
    return Hamiltonian(Eigen(evals, evecs))
end

rand(s::EigvalsSampler, dims::Integer...) = rand(s.rng, s.dist, dims...)
function rand(s::EigvecsSampler, m::Integer, n::Integer)
    matrix = rand(s.rng, s.dist, m, n)
    q, _ = qr(matrix)
    return collect(q)
end
