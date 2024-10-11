using LinearAlgebra: Diagonal, diag
using StaticArrays: SVector, SHermitianCompact, MArray

export DiagonalHamiltonian

abstract type AbstractHamiltonian{N,T} <: AbstractMatrix{T} end

struct DiagonalHamiltonian{N,T} <: AbstractHamiltonian{N,T}
    data::Diagonal{T,SVector{N,T}}
    function DiagonalHamiltonian(V::AbstractVector)
        @assert all(isreal.(V)) "Hamiltonian matrices reuqire diagoanl elements to be real!"
        N, T = length(V), eltype(V)
        return new{N,T}(Diagonal(SVector{N,T}(V)))
    end
end
function DiagonalHamiltonian(A::AbstractMatrix)
    V = diag(A)
    return DiagonalHamiltonian(V)
end

Base.parent(h::AbstractHamiltonian) = h.data

Base.size(h::AbstractHamiltonian) = size(parent(h))

Base.getindex(h::AbstractHamiltonian, i) = getindex(parent(h), i)

Base.IndexStyle(::Type{<:AbstractHamiltonian}) = IndexLinear()

# See https://github.com/JuliaLang/julia/blob/06e7b9d/base/abstractarray.jl#L833
Base.similar(::AbstractHamiltonian, ::Type{T}, dims::Dims{N}) where {T,N} =
    MArray{Tuple{dims...},T,N}(undef)
