using LinearAlgebra: Hermitian, diagm

export hamiltonian1, hamiltonian2, diagonalhamil

function hamiltonian1(N, α=10, β=0.01)
    H = diagm(α * rand(N))
    foreach(1:size(H, 1)) do i
        foreach((i + 1):size(H, 2)) do j
            H[i, j] = exp(-β * (i - j)^2)  # Mimic a non-metallic system or a metallic system at ﬁnite temperature
        end
    end
    return Hamiltonian(Hermitian(H))
end

function hamiltonian2(N, α=1, β=0.01)
    H = diagm(α * rand(N))
    foreach(1:size(H, 1)) do i
        foreach((i + 1):size(H, 2)) do j
            H[i, j] = exp(-β * abs(i - j) / 2) * sin(i + j)
        end
    end
    return Hamiltonian(Hermitian(H))
end

diagonalhamil(N, α=10) = α * diagm(sort(rand(N)))
