using FinEtools
using FinEtools.AlgoDeforLinearModule: ssit
import CoNCMOR: CoNCData, transfmatrix, LegendreBasis, SineCosineBasis 
using Arpack
using Statistics: mean
using Main.DataUtilities: getjsonname, loadjson, getmdatname, retrieve, store, savejson
using Main.RapidEigUtilities: reducedmodelparameters
using Main.LAUtilities: ssitb, ssitc
using Plots
import LinearAlgebra: norm, dot, mul!, qr, cholesky
using SparseArrays: spzeros
using DelimitedFiles

include("lug_utilities.jl")

rms_rel_error(a, t) = sqrt(sum((t - a).^2 ./ t.^2) / length(t))

function runme(meshfile, neigvs, fmax, Basis, alpha, frequencytolerance = 0.02)
	
	@info "REDUCED model, mesh $(meshfile), neigvs = $(neigvs), basis $(Basis)"

	problem, E, nu, rho = lug_parameters()
	features = "$(meshfile)-neigvs=$(neigvs)"
	fulljson = getjsonname(problem, features)
	properties = loadjson(fulljson)

	# to = TimerOutput()
	timing = Dict{String, Any}()

	timing["Problem setup"] = @elapsed begin
		fens, fesets, integrationrulestiff, integrationrulemass = lug_load_mesh(meshfile)
		u, K, M = lug_setup(E, nu, rho, fens, fesets, integrationrulestiff, integrationrulemass)
		smallestdimension = 0.06
	end

	geom  =  NodalField(fens.xyz)
	V = 0.0
	for i = 1:length(fesets)
		femm  =  FEMMBase(IntegDomain(fesets[i], integrationrulemass))
		V += integratefunction(femm, geom, (x) ->  1.0)
	end
	
	Nc, nbf1max = reducedmodelparameters(V, count(fens), E, nu, rho, fmax, alpha, smallestdimension)
	Nc1 = Int(round(Nc / 10)) < 2 ? 2 : Int(round(Nc / 10))
	Nc3 = Int(round(Nc-8*Nc1)) < 2 ? 2 : Int(round(Nc-8*Nc1))
	@show Ncs = vec([4*Nc1 4*Nc1 Nc3])
	@show bnumbers = nbf1max-3:nbf1max

	approxfrequencies = fill(0.0, neigvs)
	papproxfrequencies = fill(0.0, neigvs)
	approxvectors = fill(0.0, size(M, 1), neigvs)
	everror = fill(0.0, neigvs)
	timpar = Float64[]; timtra = Float64[]; timrma = Float64[]; timrep = Float64[]; timeve = Float64[]

	push!(timpar, @elapsed begin
		partitioning = nodepartitioning(fens, fesets, Ncs)
		mor = CoNCData(fens, partitioning)
	end)

	push!(timtra, @elapsed begin
		Phi0 = transfmatrix(mor, Basis, bnumbers[1], u);
	end)

	push!(timrma, @elapsed begin
		rK0 = (transpose(Phi0)*K*Phi0);
		rK0 .= 0.5 * (rK0 .+ transpose(rK0))
		rM0 = (transpose(Phi0)*M*Phi0);
		rM0 .= 0.5 * (rM0 .+ transpose(rM0))
		rK1 = rK0; rM1 = rM0; Phi1 = Phi0
	end)

	println("Initial step size(Phi1) = $(size(Phi1))")

	push!(timrep, @elapsed begin
		rd,rv,nev,nconv = eigs(rK1, rM1; nev=neigvs, which=:SM)
		evals = deepcopy(rd)
		evecs = deepcopy(Phi0*real(rv))
	end)

	timing["Factorization"] = @elapsed begin
		factor = cholesky(K)
	end
	
	
	timing["Iteration loops"] = @elapsed begin
	for i = 1:9
		println("Eigenvalues: $evals [Hz]")

		for i = 1:length(evals)
			@show norm(K * evecs[:, i] - evals[i] * M * evecs[:, i]) / norm(evals[i] * M * evecs[:, i])
		end

		DeltaPhi = fill(0.0, size(evecs))
		scaledevecs = deepcopy(evecs)
		for i = 1:length(evals)
			scaledevecs[:, i] = evals[i] .* evecs[:, i]
		end
		DeltaPhi .= evecs - (factor \ (M * scaledevecs))
		# for i = 1:length(evals)
		# 	DeltaPhi[:, i] = evecs[:, i] - evals[i] .* (K \ (M * evecs[:, i]))
		# 	# DeltaPhi[:, i] = M \ (K * evecs[:, i] - evals[i] * evecs[:, i])
		# 	# DeltaPhi[:, i] = K * evecs[:, i] - evals[i] * M * evecs[:, i]
		# 	# DeltaPhi[:, i] = 1/evals[i] .* (M \ (K * evecs[:, i] -  evecs[:, i]))
		# 	# DeltaPhi[:, i] = K \ evecs[:, i]
		# end

		QR = qr(DeltaPhi)
		DeltaPhi .= Matrix(QR.Q)
		@time Phi = hcat(evecs, DeltaPhi)
		
		@show size(Phi)
		KPhi = fill(0.0 , size(K, 1), size(Phi, 2))
		mul!(KPhi, K, Phi)
		@time rK0 = transpose(Phi)*KPhi;
		@time rK0 .= 0.5 * (rK0 .+ transpose(rK0))
		MPhi = fill(0.0 , size(K, 1), size(Phi, 2))
		mul!(MPhi, M, Phi)
		@time rM0 = transpose(Phi)*MPhi;
		@time rM0 .= 0.5 * (rM0 .+ transpose(rM0))


		println("Step $(i) size(Phi) = $(size(Phi))")

		rd,rv,nev,nconv = eigs(rK0, rM0; nev=neigvs, which=:SM)
		evals = deepcopy(rd)
		evecs = deepcopy(Phi*real(rv))
	end
	end

	@. approxfrequencies = real(sqrt(complex(evals)))/(2*pi);
	println("Approximate frequencies: $approxfrequencies [Hz]")
	println("Full frequencies: $(properties["frequencies"]) [Hz]")
	fullfrequencies = properties["frequencies"]
	fulltiming = properties["timing"]

	truefrequencyerror = rms_rel_error(fullfrequencies, approxfrequencies) 
	truefrequencyerrormax = maximum(abs.(fullfrequencies - approxfrequencies) ./ fullfrequencies)
	
	problem = "Red" * problem
	features = "$(meshfile)-neigvs=$(neigvs)-$(Basis)-a=$(alpha)-n1=$(bnumbers)-Nc=$(Ncs)-tol=$(frequencytolerance)"
	properties = Dict{AbstractString, Any}("problem"=>problem, "meshfile"=>meshfile, "fulljson"=>fulljson, "Nc"=>Ncs, "bnumbers"=>bnumbers, "true_frequency_error"=>truefrequencyerror, "truefrequencyerrormax"=>truefrequencyerrormax)
	timing["Partitioning"] = timpar
	timing["Transformation matrices"] = timtra
	timing["Reduced matrices"] = timrma
	timing["Reduced EV problem"] = timrep
	timing["Evaluate error"] = timeve
	timing["Total"] = timing["Problem setup"] + sum(timpar) + sum(timtra) + sum(timrma) + sum(timrep) + sum(timeve) + timing["Factorization"] + timing["Iteration loops"]
	timing["TotalFull"] = fulltiming["Total"]
	properties["timing"] = timing
	properties["timingfull"] = fulltiming

	properties["frequencies"] = approxfrequencies
	properties["eigenvectors"] = Dict("dims"=>size(approxvectors), "type"=>"$(eltype(approxvectors))", "file"=>getmdatname(problem, features, "evec"))
	store(approxvectors, properties["eigenvectors"]["file"])

	savejson(getjsonname(problem, features), properties)

	timing
end


Basis = LegendreBasis
alpha = 1.5
frequencytolerance = 0.02
fmax =   [20000, 30000, 50000, 75000, 100000]

neigvs  =  [150,]
meshes = [   
"lug-18540.nas",
]
for meshfile in meshes
	for i =  1:length(neigvs)
		@show meshfile, neigvs[i]
		@show timing = runme(meshfile, neigvs[i], fmax[i], Basis, alpha, frequencytolerance)
	end
end

# neigvs  =  [15,    50,   150,   300,    600]
# meshes = [   
# "lug-54776.nas",   
# "lug-121531.nas",  
# "lug-217666.nas",
# ]
# for meshfile in meshes
# 	for i =  1:length(neigvs)
# 		@show meshfile, neigvs[i]
# 		@show timing = runme(meshfile, neigvs[i], fmax[i], Basis, alpha, frequencytolerance)
# 	end
# end

