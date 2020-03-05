using FinEtools
using DelimitedFiles
import CoNCMOR: CoNCData, transfmatrix, LegendreBasis, SineCosineBasis 
# using Main.LAUtilities: adjgraph, nodedegrees, revcm

# include("lug_parameters.jl")
include("lug_utilities.jl")

# function revcm1(adjgr::Vector{Vector{Int}}, degrees::Vector{Int})
# 	@assert length(adjgr) == length(degrees)
# 	# Initialization
# 	n = length(adjgr)
# 	alln = collect(1:n)
# 	inR = fill(false, n)
# 	inQ = fill(false, n)
# 	R = Int[]
# 	while true
# 		notinR = broadcast(!, inR)
# 		if !any(notinR)
# 			break
# 		end
# 		candidatedegrees = degrees[notinR]
# 		candidatenodes = alln[notinR]
# 		P = candidatenodes[argmin(candidatedegrees)]
# 		push!(R, P); inR[P] = true
# 		Q = adjgr[P]
# 		while length(Q) >= 1
# 			for C = Q
# 				if !inR[C]
# 					push!(R, C); inR[C] = true
# 				end
# 			end
# 			newQ = Int[]
# 			for C = Q
# 				for i = adjgr[C]
# 					if (!inR[i]) && (!inQ[i])
# 						push!(newQ, i); inQ[i] = true
# 					end
# 				end
# 			end
# 			Q = newQ
# 			@show length(Q)
# 			# @show count(i->i, inR)
# 		end
#     end
#     return reverse(R)
# end
	
function runme(meshfile)
	@info "Mesh $(meshfile)"

	fens, fesets = lug_load_mesh(meshfile)

	Ncs = [4, 4, 2]
	partitioning = nodepartitioning(fens, fesets, Ncs)
	mor = CoNCData(fens, partitioning)

	realNc = maximum(unique(partitioning))
	for cluster = 1:realNc
		pnodes = findall(partitioning .== cluster) 
		@show length(pnodes)
		pPfes = FESetP1(reshape(pnodes, length(pnodes), 1))
		
		File =  meshfile * "-cluster-$(cluster).vtk"
		vtkexportmesh(File,  pPfes.conn,  fens.xyz, FinEtools.MeshExportModule.P1)
	end
	
	@async run(`"paraview.exe" $File`)
end


@show runme("lug-18540")  
# @show runme("lug-54776")  

# @show runme("cylinder-nr=10xnL=40.mesh")  
# @show runme("cylinder-nr=15xnL=60.mesh")
# @show runme("cylinder-nr=20xnL=80.mesh")  
# @show runme("cylinder-nr=5xnL=20.mesh")                     
# @show runme("cylinder-nr=25xnL=100.mesh")