using Simbody
using Documenter

DocMeta.setdocmeta!(Simbody, :DocTestSetup, :(using Simbody); recursive=true)

makedocs(;
    modules=[Simbody],
    authors="Allen Hill <allenofthehills@gmail.com> and contributors",
    sitename="Simbody.jl",
    format=Documenter.HTML(;
        canonical="https://halleysfifthinc.github.io/Simbody.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/halleysfifthinc/Simbody.jl",
    devbranch="main",
)
