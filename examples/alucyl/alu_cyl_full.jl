using FinEtools
using FinEtoolsDeforLinear
using FinEtoolsRapidEig
using Arpack
using Statistics: mean
using FinEtoolsRapidEig.DataUtilities: getjsonname, savejson, getmdatname, store
using LinearAlgebra: issymmetric
using DelimitedFiles


include("alu_cyl_utilities.jl")

function runme(meshfile, neigvs)

	@info "FULL model, mesh $(meshfile)"

	problem, E, nu, rho, radius, leng, omegashift = alu_cyl_parameters()

	properties = Dict("problem"=>problem, "E"=>E, "nu"=>nu, "rho"=>rho, "radius"=>radius, "leng"=>leng, "meshfile"=>meshfile, "omegashift"=>omegashift, "neigvs"=>neigvs)
	features = "$(meshfile)-neigvs=$(neigvs)"

	timing = Dict{String, FFlt}()

	timing["Problem setup"] = @elapsed begin
		fens, fes, integrationrulestiff, integrationrulemass = alu_cyl_load_mesh(meshfile)
		u, K, M = alu_cyl_setup(E, nu, rho, omegashift, fens, fes, integrationrulestiff, integrationrulemass)
		# @show issymmetric(K) && issymmetric(M)
	end

	timing["EV problem"] = @elapsed begin
		eval,evec,nev,nconv = eigs(K + omegashift*M, M; nev=neigvs, which=:SM)
		eval .-=  omegashift;
		fs = real(sqrt.(complex(eval)))/(2*pi)
	end
	println("Reference Eigenvalues: $fs [Hz]")

	properties["frequencies"] = fs
	timing["Total"] = timing["Problem setup"] + timing["EV problem"]
	properties["timing"] = timing

	properties["eigenvectors"] = Dict("dims"=>size(evec), "type"=>"$(eltype(evec))", "file"=>getmdatname(problem, features, "evec"))
	store(evec, properties["eigenvectors"]["file"])

	savejson(getjsonname(problem, features), properties)

	timing
end

# meshes = [   
# "cylinder-30mm-2116el.mesh",  
# "cylinder-15mm-8204el.mesh",
# "cylinder-20mm-4436el.mesh",
# "cylinder-nr=10xnL=40.mesh",  
# "cylinder-nr=15xnL=60.mesh",
# "cylinder-nr=20xnL=80.mesh",  
# "cylinder-nr=5xnL=20.mesh",                     
# "cylinder-nr=25xnL=100.mesh",
# "cylinder-10mm-17980el.mesh",
# "cylinder-7.5mm-31692el.mesh"]


#  ["cylinder-30mm-2116el" "cylinder-20mm-4436el" "cylinder-15mm-8204el" "cylinder-10mm-17980el" "cylinder-7.5mm-31692el"]
meshes = ["cylinder-30mm-2116el"] 
for m in meshes
    for neigvs in [50, 150] #  [50, 150, 300, 600, 1200]
      @show m, neigvs
      timing = runme(m * ".mesh", neigvs)
      FinEtoolsRapidEig.DataUtilities.loadjson("alu_cyl-" * m * "_mesh-neigvs=$(neigvs).json")
  end
end

# meshes = 
# for m in meshes
# 	timing = runme(m * ".mesh", 1200)
# 	Main.DataUtilities.loadjson("alu_cyl-" * m * "_mesh-neigvs=1200.json")
# end
