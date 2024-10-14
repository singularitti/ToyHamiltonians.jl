using ToyHamiltonians
using Distributions:
    Arcsine,
    Beta,
    Cauchy,
    Exponential,
    Laplace,
    LogitNormal,
    LogUniform,
    Normal,
    Uniform,
    MixtureModel,
    truncated
using LinearAlgebra: Eigen, eigvals, eigvecs
using Plots
using StatsPlots

PLOT_DEFAULTS = Dict(
    :size => (600, 400),
    :dpi => 400,
    :framestyle => :box,
    :linewidth => 1,
    :markersize => 1,
    :markerstrokewidth => 0,
    :minorticks => 5,
    :titlefontsize => 9,
    :plot_titlefontsize => 9,
    :guidefontsize => 9,
    :tickfontsize => 7,
    :legendfontsize => 7,
    :left_margin => (0, :mm),
    :grid => nothing,
    :legend_foreground_color => nothing,
    :legend_background_color => nothing,
    :legend_position => :topleft,
    :background_color_inside => nothing,
    :color_palette => :tab10,
)

set_isapprox_rtol(1e-13)
N = 1000
nbins = 40
distributions = [
    Cauchy(0.35, 0.2),
    Arcsine(0.2, 0.9),
    Beta(2, 2),
    Exponential(1),
    Laplace(0.5, 0.1),
    LogitNormal(0, 1),
    LogUniform(0.1, 0.9),
    Uniform(0, 0.8),
    MixtureModel([Normal(0.2, 0.1), Normal(0.5, 0.1), Normal(0.9, 0.1)], [0.3, 0.4, 0.3]),
    MixtureModel([Cauchy(0.25, 0.2), Laplace(0.5, 0.1)], [0.6, 0.4]),
    MixtureModel(
        [LogUniform(0.05, 0.3), LogUniform(0.3, 0.7), LogUniform(0.7, 1)], [0.2, 0.3, 0.5]
    ),
    MixtureModel(
        [Uniform(0, 0.2), Uniform(0.2, 0.5), Uniform(0.5, 0.7), Uniform(0.7, 1)],
        [0.1, 0.2, 0.2, 0.5],
    ),
]
foreach(distributions) do distribution
    sampler = EigvalsSampler(distribution)
    Λ = rand(sampler, N)
    V = eigvecs(hamiltonian1(N))
    H = Hamiltonian(Eigen(Λ, V))

    plot(; PLOT_DEFAULTS...)
    histogram!(eigvals(H); nbins=nbins, normalize=true, label="solve the Hamiltonian")
    histogram!(Λ; nbins=nbins, normalize=true, label="original random eigvals")
    plot!(truncated(distribution; lower=0, upper=1); label="original distribution")
    xlims!(0, 1)
    title!(
        "Eigenvalues with distribution: " * string(distribution)[1:(end > 40 ? 40 : end)]
    )
    savefig(string(distribution)[1:10] * ".png")
end
