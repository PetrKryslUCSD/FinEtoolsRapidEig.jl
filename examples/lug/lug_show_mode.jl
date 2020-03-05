using FinEtools
using Main.DataUtilities: getcleanname, getjsonname, loadjson, getmdatname, retrieve
using DelimitedFiles

include("lug_utilities.jl")
	
function runme(jsonfile, mode)
	@info "Sim $(jsonfile)"

	properties = loadjson(jsonfile)

	@show properties["frequencies"][mode]
	@show properties["eigenvectors"]
	evectors = retrieve(properties["eigenvectors"])

	fens, fesets = lug_load_mesh(properties["meshfile"])

	problem, E, nu, rho = lug_parameters()

	u = lug_setup(E, nu, rho, fens, fesets)

	scattersysvec!(u, evectors[:,mode])
	for i = 1:length(fesets)
		File = getcleanname(jsonfile * "mode=$(mode)") * "-r$(i).vtk"
		vtkexportmesh(File, fens, fesets[i]; vectors=[("mode$mode", u.values)])
	end
	
	@async run(`"paraview.exe" $File`)

end


 @show runme("lug-lug-18540_nas-neigvs=15.json", 1)    
