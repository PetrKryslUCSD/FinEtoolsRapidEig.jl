using FinEtools
using DelimitedFiles

include("alu_cyl_utilities.jl")
	
function runme(meshfile)
	@info "Mesh $(meshfile)"

	fens, fes = alu_cyl_load_mesh(meshfile)
@show count(fens)
	AE = AbaqusExporter(meshfile * ".inp");
	  HEADING(AE, "Aluminum cylinder $(meshfile).");
	  PART(AE, "part1");
	  END_PART(AE);
	  ASSEMBLY(AE, "ASSEM1");
	  INSTANCE(AE, "INSTNC1", "PART1");
	  NODE(AE, fens.xyz);
	  ELEMENT(AE, "c3d4", "AllElements", 1, connasarray(fes))
	  END_INSTANCE(AE);
	  END_ASSEMBLY(AE);
	  close(AE)

	File =  meshfile * ".vtk"
	vtkexportmesh(File, fens, fes)
	@async run(`"paraview.exe" $File`)
end


# @show runme("cylinder-7.5mm-31692el.mesh")      
@show runme("cylinder-10mm-17980el.mesh")
# @show runme("cylinder-15mm-8204el.mesh")
# @show runme("cylinder-20mm-4436el.mesh")
# @show runme("cylinder-30mm-2116el.mesh")  

# @show runme("cylinder-nr=10xnL=40.mesh")  
# @show runme("cylinder-nr=15xnL=60.mesh")
# @show runme("cylinder-nr=20xnL=80.mesh")  
# @show runme("cylinder-nr=5xnL=20.mesh")                     
# @show runme("cylinder-nr=25xnL=100.mesh")