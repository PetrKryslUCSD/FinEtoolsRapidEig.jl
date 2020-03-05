using FinEtools
using FinEtools.AlgoDeforLinearModule: ssit
import CoNCMOR: CoNCData, transfmatrix, LegendreBasis, SineCosineBasis 
using Arpack
using Statistics: mean
using Main.DataUtilities: getjsonname, loadjson, getmdatname, retrieve, store, savejson
using Main.RapidEigUtilities: reducedmodelparameters
using Main.LAUtilities: ssitb, ssitc
using Plots
import LinearAlgebra: norm, dot
using SparseArrays: spzeros
using DelimitedFiles

include("lug_utilities.jl")

rms_rel_error(a, t) = sqrt(sum((t - a).^2 ./ t.^2) / length(t))

function runme(meshfile, neigvs, eigstolerance = 0.02)
	
	@info "FULL APPROXIMATE model, mesh $(meshfile), neigvs = $(neigvs)"

	problem, E, nu, rho = lug_parameters()
	features = "$(meshfile)-neigvs=$(neigvs)"
	fulljson = getjsonname(problem, features)
	properties = loadjson(fulljson)
	fullfrequencies = properties["frequencies"]
	fulltiming = properties["timing"]

	# to = TimerOutput()
	timing = Dict{String, Any}()

	timing["Problem setup"] = @elapsed begin
		fens, fesets, integrationrulestiff, integrationrulemass = lug_load_mesh(meshfile)
		u, K, M = lug_setup(E, nu, rho, fens, fesets, integrationrulestiff, integrationrulemass, :consistent)
		smallestdimension = 0.06
	end

	timing["EV problem"] = @elapsed begin
		eval,evec,nev,nconv = eigs(K, M; nev=neigvs, tol = eigstolerance, maxiter = 200, which=:SM)
		@show nev, nconv
		for i = 1:length(eval)
			@show norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i])
		end
		approxfrequencies = real(sqrt.(complex(eval)))/(2*pi)
		approxvectors = evec
	end

	println("Approximate frequencies: $approxfrequencies [Hz]")
	println("Full frequencies: $(properties["frequencies"]) [Hz]")
	
	truefrequencyerror = rms_rel_error(fullfrequencies, approxfrequencies) 
	truefrequencyerrormax = maximum(abs.(fullfrequencies - approxfrequencies) ./ fullfrequencies)
	
	problem = "FullApprox" * problem
	features = "$(meshfile)-neigvs=$(neigvs)-tol=$(eigstolerance)"
	properties = Dict{AbstractString, Any}("problem"=>problem, "meshfile"=>meshfile, "fulljson"=>fulljson, "true_frequency_error"=>truefrequencyerror, "truefrequencyerrormax"=>truefrequencyerrormax)
	timing["Total"] = timing["Problem setup"] + timing["EV problem"]
	timing["TotalFull"] = fulltiming["Total"]
	properties["timing"] = timing
	properties["timingfull"] = fulltiming

	properties["frequencies"] = approxfrequencies
	properties["eigenvectors"] = Dict("dims"=>size(approxvectors), "type"=>"$(eltype(approxvectors))", "file"=>getmdatname(problem, features, "evec"))
	store(approxvectors, properties["eigenvectors"]["file"])

	savejson(getjsonname(problem, features), properties)

	timing
end


eigstolerance = 0.1

# meshes = [   
# "lug-217666.nas",
# "lug-121531.nas",  
# "lug-54776.nas",   
# "lug-18540.nas"
# ]
# for meshfile in meshes
# 	for neigvs in [15, 50, 150, 300, 600]#
# 		@show meshfile, neigvs
# 		@show timing = runme(meshfile, neigvs, eigstolerance)
# 	end
# end

meshes = [   
# "lug-217666.nas",
# "lug-121531.nas",  
# "lug-54776.nas",   
"lug-18540.nas"
]
for meshfile in meshes
	for neigvs in [15]
		@show meshfile, neigvs
		@show timing = runme(meshfile, neigvs, eigstolerance)
	end
end



