using FinEtools
using DelimitedFiles

include("lug_utilities.jl")
	
function runme(meshfile)
	@info "Mesh $(meshfile)"

	fens, fesets = lug_load_mesh(meshfile)
	@show count(fens)

	for i = 1:length(fesets)
		File =  meshfile * "-r$(i)-mesh.vtk"
		vtkexportmesh(File, fens, fesets[i])
	end
	
	@async run(`"paraview.exe" $File`)
end


# @show runme("lug-55620")  
@show runme("lug-18540")  
