using Pkg; Pkg.activate("."); Pkg.instantiate()

include("PGFPlotsXUtilities.jl")
include("LAUtilities.jl")
include("DataUtilities.jl")

@info "RapidEig ready"

cd("aluminum_cylinder/")
@show pwd()
include(pwd() * "/alu_cyl_full.jl")
