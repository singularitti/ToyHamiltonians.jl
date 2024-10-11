using ToyHamiltonians
using Documenter

DocMeta.setdocmeta!(ToyHamiltonians, :DocTestSetup, :(using ToyHamiltonians); recursive=true)

makedocs(;
    modules=[ToyHamiltonians],
    authors="singularitti <singularitti@outlook.com> and contributors",
    sitename="ToyHamiltonians.jl",
    format=Documenter.HTML(;
        canonical="https://singularitti.github.io/ToyHamiltonians.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/singularitti/ToyHamiltonians.jl",
    devbranch="main",
)
