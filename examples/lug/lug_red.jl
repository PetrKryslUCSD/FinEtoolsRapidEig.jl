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

	println("Step 1 size(Phi1) = $(size(Phi1))")

	push!(timrep, @elapsed begin
		rd,rv,nev,nconv = eigs(rK1, rM1; nev=neigvs, which=:SM)
		@. approxfrequencies = real(sqrt(complex(rd)))/(2*pi);
	end)
	papproxfrequencies .= approxfrequencies
	frequencyerrors = Float64[]


	for jd = 2:length(bnumbers)

		push!(timtra, @elapsed begin
			Phip = transfmatrix(mor, Basis, bnumbers[jd-1]+1:bnumbers[jd], u);
			Phi1 = hcat(Phi0, Phip)
		end)

		println("Step $(jd) size(Phi1) = $(size(Phi1))")

		push!(timrma, @elapsed begin
			KPhip = K*Phip
			rKpp = (transpose(Phip)*KPhip); rKpp .= 0.5 * (rKpp .+ transpose(rKpp))
			rK0p = (transpose(Phi0)*KPhip);
			rK1 = vcat(hcat(rK0, rK0p), hcat(transpose(rK0p), rKpp))
			MPhip = M*Phip
			rMpp = (transpose(Phip)*MPhip); rMpp .= 0.5 * (rMpp .+ transpose(rMpp))
			rM0p = (transpose(Phi0)*MPhip);
			rM1 = vcat(hcat(rM0, rM0p), hcat(transpose(rM0p), rMpp))
		end)

		push!(timrep, @elapsed begin
			rd,rv,nev,nconv = eigs(rK1, rM1; nev=neigvs, which=:SM)
			@. approxfrequencies = real(sqrt(complex(rd)))/(2*pi);
		end)

		push!(timeve, @elapsed begin
			# frequencyerror = norm(approxfrequencies - papproxfrequencies) / norm(approxfrequencies)
			frequencyerror = rms_rel_error(papproxfrequencies, approxfrequencies)
		end)

		@show frequencyerror
		push!(frequencyerrors, frequencyerror)

		if (frequencyerror < frequencytolerance) || (jd == length(bnumbers))
			approxvectors .= Phi1*real(rv)
			break
		end

		# For next iteration
		papproxfrequencies .= approxfrequencies

		Phi0 = Phi1
		rK0 = rK1
		rM0 = rM1

	end

	println("Approximate frequencies: $approxfrequencies [Hz]")
	println("Full frequencies: $(properties["frequencies"]) [Hz]")
	fullfrequencies = properties["frequencies"]
	fulltiming = properties["timing"]

	truefrequencyerror = rms_rel_error(fullfrequencies, approxfrequencies) 
	truefrequencyerrormax = maximum(abs.(fullfrequencies - approxfrequencies) ./ fullfrequencies)
	
	problem = "Red" * problem
	features = "$(meshfile)-neigvs=$(neigvs)-$(Basis)-a=$(alpha)-n1=$(bnumbers)-Nc=$(Ncs)-tol=$(frequencytolerance)"
	properties = Dict{AbstractString, Any}("problem"=>problem, "meshfile"=>meshfile, "fulljson"=>fulljson, "Nc"=>Ncs, "bnumbers"=>bnumbers, "frequency_errors"=>frequencyerrors, "true_frequency_error"=>truefrequencyerror, "truefrequencyerrormax"=>truefrequencyerrormax)
	timing["Partitioning"] = timpar
	timing["Transformation matrices"] = timtra
	timing["Reduced matrices"] = timrma
	timing["Reduced EV problem"] = timrep
	timing["Evaluate error"] = timeve
	timing["Total"] = timing["Problem setup"] + sum(timpar) + sum(timtra) + sum(timrma) + sum(timrep) + sum(timeve)
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

neigvs  =  [15,    50,   150,   300]
meshes = [   
"lug-18540.nas",
]
for meshfile in meshes
	for i =  1:length(neigvs)
		@show meshfile, neigvs[i]
		@show timing = runme(meshfile, neigvs[i], fmax[i], Basis, alpha, frequencytolerance)
	end
end

neigvs  =  [15,    50,   150,   300,    600]
meshes = [   
"lug-54776.nas",   
"lug-121531.nas",  
"lug-217666.nas",
]
for meshfile in meshes
	for i =  1:length(neigvs)
		@show meshfile, neigvs[i]
		@show timing = runme(meshfile, neigvs[i], fmax[i], Basis, alpha, frequencytolerance)
	end
end

