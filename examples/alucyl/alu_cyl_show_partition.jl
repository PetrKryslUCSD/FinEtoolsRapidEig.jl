using FinEtools
using DelimitedFiles
import CoNCMOR: CoNCData, transfmatrix, LegendreBasis, SineCosineBasis 

# include("alu_cyl_parameters.jl")
include("alu_cyl_utilities.jl")
	
function runme(meshfile)
	@info "Mesh $(meshfile)"

	fens, fes = alu_cyl_load_mesh(meshfile)

	Nc = 8
	partitioning = nodepartitioning(fens, Nc)
	mor = CoNCData(fens, partitioning)

	cluster = 7
	partitioning == cluster
	pnodes = findall(partitioning .== cluster) 
	pPfes = FESetP1(reshape(pnodes, length(pnodes), 1))
	
	File =  meshfile * "-cluster-$(cluster).vtk"
	vtkexportmesh(File,  pPfes.conn,  fens.xyz, FinEtools.MeshExportModule.P1)
	@async run(`"paraview.exe" $File`)
end


# @show runme("cylinder-7.5mm-31692el.mesh")      
# @show runme("cylinder-10mm-17980el.mesh")
# @show runme("cylinder-15mm-8204el.mesh")
# @show runme("cylinder-20mm-4436el.mesh")
@show runme("cylinder-30mm-2116el.mesh")  

# @show runme("cylinder-nr=10xnL=40.mesh")  
# @show runme("cylinder-nr=15xnL=60.mesh")
# @show runme("cylinder-nr=20xnL=80.mesh")  
# @show runme("cylinder-nr=5xnL=20.mesh")                     
# @show runme("cylinder-nr=25xnL=100.mesh")