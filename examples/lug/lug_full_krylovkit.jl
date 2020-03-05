using FinEtools
using Arpack
using Statistics: mean
using Main.DataUtilities: getjsonname, savejson, getmdatname, store
using LinearAlgebra: issymmetric
using DelimitedFiles
using SparseArrays: spzeros
using KrylovKit

include("lug_utilities.jl")

function runme(meshfile, neigvs)

	@info "FULL model, mesh $(meshfile)"

	problem, E, nu, rho = lug_parameters()

	properties = Dict("problem"=>problem, "E"=>E, "nu"=>nu, "rho"=>rho, "meshfile"=>meshfile, "neigvs"=>neigvs)
	features = "$(meshfile)-neigvs=$(neigvs)"

	timing = Dict{String, FFlt}()

	timing["Problem setup"] = @elapsed begin
		fens, fes, integrationrulestiff, integrationrulemass = lug_load_mesh(meshfile)
		u, K, M = lug_setup(E, nu, rho, fens, fes, integrationrulestiff, integrationrulemass)
		# @show issymmetric(K) && issymmetric(M)
	end

	timing["EV problem"] = @elapsed begin
		# eval,evec,nev,nconv = eigs(K, M; nev=neigvs, which=:SM)
		eval, evec1, info = geneigsolve((K, M), neigvs, :SR; krylovdim = neigvs, issymmetric = true, verbosity = 1)
		@show info
		fs = real(sqrt.(complex(eval)))/(2*pi)
		@show typeof(evec1)
		evec = fill(0.0, size(K, 1), length(evec1))
		for i = 1:length(evec1)
			evec[:, i] .= evec1[i]
		end
	end
	println("Reference frequencies: $fs [Hz]")

	properties["frequencies"] = fs
	timing["Total"] = timing["Problem setup"] + timing["EV problem"]
	properties["timing"] = timing

	properties["eigenvectors"] = Dict("dims"=>size(evec), "type"=>"$(eltype(evec))", "file"=>getmdatname(problem, features, "evec"))
	store(evec, properties["eigenvectors"]["file"])

	savejson(getjsonname(problem, features), properties)

	timing
end

meshes = [   
# "lug-217666.nas",
# "lug-121531.nas",  
# "lug-54776.nas",   
"lug-18540.nas"
]
for meshfile in meshes
	for neigvs in [150]
		@show meshfile, neigvs
		@show timing = runme(meshfile, neigvs)
	end
end 
