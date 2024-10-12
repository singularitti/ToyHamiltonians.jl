using LinearAlgebra: Hermitian, diagm

export hamiltonian1, diagonalhamil

function hamiltonian1(N, β=0.01, α=10)
    H = diagm(α * rand(N))
    foreach(1:size(H, 1)) do i
        foreach((i + 1):size(H, 2)) do j
            H[i, j] = exp(-β * (i - j)^2)  # Mimic a non-metallic system or a metallic system at ﬁnite temperature
        end
    end
    return Hamiltonian(Hermitian(H))
end

diagonalhamil(N, α=10) = α * diagm(sort(rand(N)))
