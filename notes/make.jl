using Documenter

makedocs(
    sitename = "k theorem prover",
    format = Documenter.HTML(),
    pages = [
        "index.md",
        "termination-check.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
