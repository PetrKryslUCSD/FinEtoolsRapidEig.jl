using FinEtools
using FinEtoolsDeforLinear
using FinEtoolsDeforLinear.AlgoDeforLinearModule: ssit
using FinEtoolsRapidEig
import CoNCMOR: CoNCData, transfmatrix, LegendreBasis, SineCosineBasis 
using Arpack
using Statistics: mean
using FinEtoolsRapidEig.DataUtilities: getjsonname, loadjson, getmdatname, retrieve, store, savejson
using FinEtoolsRapidEig.RapidEigUtilities: reducedmodelparameters
import LinearAlgebra: norm, dot
using DelimitedFiles

include("alu_cyl_utilities.jl")

rms_rel_error(a, t) = sqrt(sum((t - a).^2 ./ t.^2) / length(t))


function runme(meshfile, neigvs, fmax, Basis, alpha, frequencytolerance = 0.02)
	
	@info "REDUCED model, mesh $(meshfile), neigvs = $(neigvs), basis $(Basis)"

	ignoreev = 6

	problem, E, nu, rho, radius, leng, omegashift = alu_cyl_parameters()
	features = "$(meshfile)-neigvs=$(neigvs)"
	fulljson = getjsonname(problem, features)
	properties = loadjson(fulljson)

	# to = TimerOutput()
	timing = Dict{String, Any}()

	timing["Problem setup"] = @elapsed begin
		fens, fes, integrationrulestiff, integrationrulemass = alu_cyl_load_mesh(meshfile)
		u, K, M = alu_cyl_setup(E, nu, rho, omegashift, fens, fes, integrationrulestiff, integrationrulemass)
	end

    femm  =  FEMMBase(IntegDomain(fes, integrationrulemass))
	geom  =  NodalField(fens.xyz)
    V = integratefunction(femm, geom, (x) ->  1.0)
	
	N = count(fens)

	@show Nc, nbf1max = reducedmodelparameters(V, N, E, nu, rho, fmax, alpha)
	@show bnumbers = nbf1max-3:nbf1max

	approxfrequencies = fill(0.0, neigvs)
	papproxfrequencies = fill(0.0, neigvs)
	approxvectors = fill(0.0, size(M, 1), neigvs)
	everror = fill(0.0, neigvs)
	timpar = Float64[]; timtra = Float64[]; timrma = Float64[]; timrep = Float64[]; timeve = Float64[]

	push!(timpar, @elapsed begin
		partitioning = nodepartitioning(fens, Nc)
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
		rd,rv,nev,nconv = eigs(rK1 + omegashift*rM1, rM1; nev=neigvs, which=:SM)
		approxfrequencies = @. real(sqrt(complex(rd - omegashift)))/(2*pi);
	end)
	papproxfrequencies = approxfrequencies
	frequencyerrors = Float64[]

		
	for jd = 2:length(bnumbers)
		
		push!(timtra, @elapsed begin
			Phip = transfmatrix(mor, Basis, bnumbers[jd-1]+1:bnumbers[jd], u);
			Phi1 = hcat(Phi0, Phip)
		end)
		
		println("Step $(jd) size(Phi1) = $(size(Phi1))")

		push!(timrma, @elapsed begin
			rKpp = (transpose(Phip)*K*Phip); rKpp .= 0.5 * (rKpp .+ transpose(rKpp))
			rK0p = (transpose(Phi0)*K*Phip);
			rK1 = vcat(hcat(rK0, rK0p), hcat(transpose(rK0p), rKpp))
			rMpp = (transpose(Phip)*M*Phip); rMpp .= 0.5 * (rMpp .+ transpose(rMpp))
			rM0p = (transpose(Phi0)*M*Phip);
			rM1 = vcat(hcat(rM0, rM0p), hcat(transpose(rM0p), rMpp))
		end)

		push!(timrep, @elapsed begin
			rd,rv,nev,nconv = eigs(rK1 + omegashift*rM1, rM1; nev=neigvs, which=:SM)
			approxfrequencies = @. real(sqrt(complex(rd - omegashift)))/(2*pi);
		end)
			
		push!(timeve, @elapsed begin
			# frequencyerror = norm(approxfrequencies - papproxfrequencies) / norm(approxfrequencies)
			nf = min(length(approxfrequencies), length(papproxfrequencies))
			frequencyerror = rms_rel_error(papproxfrequencies[ignoreev+1:nf], approxfrequencies[ignoreev+1:nf])
		end)

		@show frequencyerror
		push!(frequencyerrors, frequencyerror)

		if (frequencyerror < frequencytolerance) || (jd == length(bnumbers))
			approxvectors .= Phi1*real(rv)
			break
		end

		# For next iteration
		papproxfrequencies = approxfrequencies

		Phi0 = Phi1
		rK0 = rK1
		rM0 = rM1

	end

	println("Approximate frequencies: $approxfrequencies [Hz]")
	println("Full frequencies: $(properties["frequencies"]) [Hz]")
	fullfrequencies = properties["frequencies"]
	fulltiming = properties["timing"]

	truefrequencyerror = rms_rel_error(fullfrequencies[ignoreev+1:end], approxfrequencies[ignoreev+1:end]) 
	truefrequencyerrormax = maximum(abs.(fullfrequencies[ignoreev+1:end] - approxfrequencies[ignoreev+1:end]) ./ fullfrequencies[ignoreev+1:end])
	
	problem = "Red" * problem
	features = "$(meshfile)-neigvs=$(neigvs)-$(Basis)-a=$(alpha)-b=$(bnumbers)-Nc=$(Nc)-tol=$(frequencytolerance)"
	properties = Dict{AbstractString, Any}("problem"=>problem, "meshfile"=>meshfile, "fulljson"=>fulljson, "Nc"=>Nc, "nbf1max"=>nbf1max, "bnumbers"=>bnumbers, "frequency_errors"=>frequencyerrors, "true_frequency_error"=>truefrequencyerror, "truefrequencyerrormax"=>truefrequencyerrormax)
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

@show properties
	timing
end

@show timing = runme("cylinder-30mm-2116el.mesh", 150, 18000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-15mm-8204el.mesh", 150, 18000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-15mm-8204el.mesh", 300, 22000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-15mm-8204el.mesh", 600, 30000, LegendreBasis, 1.5, 0.02)

# @show timing = runme("cylinder-15mm-8204el.mesh", 150, 18000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-15mm-8204el.mesh", 300, 22000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-15mm-8204el.mesh", 600, 30000, LegendreBasis, 1.5, 0.005)

# @show timing = runme("cylinder-nr=20xnL=80.mesh", 150, 18000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-nr=20xnL=80.mesh", 300, 22000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-nr=20xnL=80.mesh", 600, 30000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-nr=20xnL=80.mesh", 1200, 40000, LegendreBasis, 1.5, 0.02)

# @show timing = runme("cylinder-nr=20xnL=80.mesh", 150, 18000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-nr=20xnL=80.mesh", 300, 22000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-nr=20xnL=80.mesh", 600, 30000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-nr=20xnL=80.mesh", 1200, 40000, LegendreBasis, 1.5, 0.005)

# @show timing = runme("cylinder-nr=25xnL=100.mesh", 150, 18000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-nr=25xnL=100.mesh", 300, 22000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-nr=25xnL=100.mesh", 600, 30000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-nr=25xnL=100.mesh", 1200, 40000, LegendreBasis, 1.5, 0.02)

# @show timing = runme("cylinder-nr=25xnL=100.mesh", 150, 18000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-nr=25xnL=100.mesh", 300, 22000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-nr=25xnL=100.mesh", 600, 30000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-nr=25xnL=100.mesh", 1200, 40000, LegendreBasis, 1.5, 0.005)

# @show timing = runme("cylinder-7.5mm-31692el.mesh", 150, 18000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-7.5mm-31692el.mesh", 300, 22000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-7.5mm-31692el.mesh", 600, 30000, LegendreBasis, 1.5, 0.02)
# @show timing = runme("cylinder-7.5mm-31692el.mesh", 1200, 40000, LegendreBasis, 1.5, 0.02)

# @show timing = runme("cylinder-7.5mm-31692el.mesh", 150, 18000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-7.5mm-31692el.mesh", 300, 22000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-7.5mm-31692el.mesh", 600, 30000, LegendreBasis, 1.5, 0.005)
# @show timing = runme("cylinder-7.5mm-31692el.mesh", 1200, 40000, LegendreBasis, 1.5, 0.005)

# @show timing = runme("cylinder-7.5mm-31692el.mesh", 1200, 40000, LegendreBasis, 1.5, 0.005)

# @show timing = runme("cylinder-20mm-4436el.mesh", 150, 20000, SineCosineBasis, 1.5, 0.02)
# @show timing = runme(15, 60, 1000, SineCosineBasis, 1.2, 3:1:5, 0.02)

# timing = runme("cylinder-7.5mm-31692el.mesh", 1200, 40000, LegendreBasis, 1.5, 0.02)
# timing = runme("cylinder-7.5mm-31692el.mesh", 1200, 40000, LegendreBasis, 1.5, 0.005)
