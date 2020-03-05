using Pkg; Pkg.activate("."); Pkg.instantiate()

include("PGFPlotsXUtilities.jl")
include("LAUtilities.jl")
include("DataUtilities.jl")
include("RapidEigUtilities.jl")

# cd("lug/")
cd("alucyl")

@info "RapidEig ready"