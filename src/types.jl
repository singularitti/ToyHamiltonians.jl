using LinearAlgebra: Diagonal, Eigen, diag
using IsApprox: Approx, ishermitian
using StaticArrays: SMatrix, SVector, SHermitianCompact, MArray

export Hamiltonian, DiagonalHamiltonian, isapprox_rtol, set_isapprox_rtol

abstract type AbstractHamiltonian{N,T} <: AbstractMatrix{T} end

struct Hamiltonian{N,T} <: AbstractHamiltonian{N,T}
    data::SHermitianCompact{N,T}
    function Hamiltonian(V::AbstractVector)
        N, T = length(V), eltype(V)
        return new{N,T}(SHermitianCompact{N,T}(V))
    end
    function Hamiltonian(A::AbstractMatrix)
        @assert ishermitian(A, Approx(; rtol=isapprox_rtol())) "Hamiltonian matrices must be Hermitian!"
        N, T = size(A, 1), eltype(A)
        return new{N,T}(SMatrix{N,N,T}(A))
    end
end
function Hamiltonian(E::Eigen)
    Λ, V = E.values, E.vectors
    return Hamiltonian(V * Diagonal(Λ) * inv(V))  # `Diagonal` is faster than `diagm`
end

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

const ISAPPROX_RTOL = Ref(1e-15)

isapprox_rtol() = ISAPPROX_RTOL[]
# See https://github.com/KristofferC/OhMyREPL.jl/blob/8b0fc53/src/BracketInserter.jl#L44-L45
set_isapprox_rtol(rtol) = ISAPPROX_RTOL[] = rtol

Base.parent(h::AbstractHamiltonian) = h.data

Base.size(h::AbstractHamiltonian) = size(parent(h))

Base.getindex(h::AbstractHamiltonian, i) = getindex(parent(h), i)

Base.IndexStyle(::Type{<:AbstractHamiltonian}) = IndexLinear()

# See https://github.com/JuliaLang/julia/blob/06e7b9d/base/abstractarray.jl#L833
Base.similar(::AbstractHamiltonian, ::Type{T}, dims::Dims{N}) where {T,N} =
    MArray{Tuple{dims...},T,N}(undef)