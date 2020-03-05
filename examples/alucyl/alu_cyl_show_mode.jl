using FinEtools
using Main.DataUtilities: getcleanname, getjsonname, loadjson, getmdatname, retrieve
using DelimitedFiles

include("alu_cyl_utilities.jl")
	
function runme(jsonfile, mode)
	@info "Sim $(jsonfile)"

	properties = loadjson(jsonfile)

	@show properties["frequencies"][mode]
	@show properties["eigenvectors"]
	evectors = retrieve(properties["eigenvectors"])

	fens, fes = alu_cyl_load_mesh(properties["meshfile"])

	problem, E, nu, rho, radius, leng, omegashift = alu_cyl_parameters()

	u = alu_cyl_setup(E, nu, rho, omegashift, fens, fes)

	scattersysvec!(u, evectors[:,mode])
	File = getcleanname(jsonfile * "mode=$(mode)") * ".vtk"
	vtkexportmesh(File, fens, fes; vectors=[("mode$mode", u.values)])
	@async run(`"paraview.exe" $File`)

end


 # @show runme("Redalu_cyl-cylinder-30mm-2116el_mesh-neigvs=150-LegendreBasis-a=1_0-b=5_7-Nc=8.json", 150)    
 @show runme("alu_cyl-cylinder-10mm-17980el_mesh-neigvs=150.json", 136)    
