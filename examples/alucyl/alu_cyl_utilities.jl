function alu_cyl_parameters()
	# Material parameters of the solid cylinder
	problem = "alu_cyl"
	E = 70000*phun("MPa")::FFlt;
	nu = 0.33::FFlt;
	rho = 2700*phun("KG/M^3")::FFlt;
	radius = 0.5*phun("ft"); 
	leng = 2*phun("ft"); 
	omegashift = (2*pi*100) ^ 2; # to resolve rigid body modes
	return problem, E, nu, rho, radius, leng, omegashift
end

function alu_cyl_load_mesh(meshfile)
	meshfilebase, ext = splitext(meshfile)
	meshfile = meshfilebase * ".mesh"
	datfiles = open("meshes/" * meshfile, "r") do file
		readdlm(file)
	end
	X = open("meshes/" * datfiles[1], "r") do file
		readdlm(file, ' ', Float64)
	end
	C = open("meshes/" * datfiles[2], "r") do file
		readdlm(file, ' ', Int64)
	end

	fens, fes = nothing, nothing
	integrationrulestiff = nothing
	integrationrulemass = nothing
	if size(C, 2) == 8
		fens, fes = FENodeSet(X), FESetH8(C)
		integrationrulestiff = GaussRule(3,2)
		integrationrulemass = GaussRule(3,3)
	else
		fens, fes = FENodeSet(X), FESetT4(C)
		integrationrulestiff = TetRule(1)
		integrationrulemass = TetRule(4)
	end

	return fens, fes, integrationrulestiff, integrationrulemass
end

function alu_cyl_setup(E, nu, rho, omegashift, fens, fes, integrationrulestiff = nothing, integrationrulemass = nothing)
	
	geom = NodalField(fens.xyz)
	u = NodalField(zeros(size(fens.xyz,1),3)) # displacement field
	applyebc!(u)
	numberdofs!(u)
	
	K = nothing; M = nothing
	if (integrationrulestiff != nothing) && (integrationrulemass != nothing)
		MR = DeforModelRed3D
		material = MatDeforElastIso(MR, rho, E, nu, 0.0)
		femm = FEMMDeforLinear(MR, IntegDomain(fes, integrationrulestiff), material)
		femm = associategeometry!(femm, geom)
		K = stiffness(femm, geom, u)
		K .= 0.5 * (K .+ transpose(K))
		femm = FEMMDeforLinear(MR, IntegDomain(fes, integrationrulemass), material)
		M = mass(femm, SysmatAssemblerSparseHRZLumpingSymm(), geom, u)
		M .= 0.5 * (M .+ transpose(M))
		return u, K, M
	else
		return u
	end
end

function generate_h8_mesh()
	nr = 5; nL =  20; 
	# nr = 10; nL =  40; 
	# nr = 15; nL =  60; 
	# nr = 20; nL =  80; 
	# nr = 25; nL =  100; 

	problem, E, nu, rho, radius, leng, tolerance, omegashift = alu_cyl_parameters()

	meshfile = "cylinder-nr=$(nr)xnL=$(nL).mesh"

	fens, fes = H8cylindern(radius, leng, nr, nL)
	fens.xyz[:, 3] = fens.xyz[:, 3] .- 1.0*phun("ft") # Translate the cylinder so that its center coincides with the origin

	meshfilebase, ext = splitext(meshfile)
	datfiles = [meshfilebase * "-xyz.dat", meshfilebase * "-conn.dat"]
	open("./meshes/" * datfiles[1], "w") do file
		writedlm(file, fens.xyz, ' ')
	end
	open("./meshes/" * datfiles[2], "w") do file
		writedlm(file, connasarray(fes), ' ')
	end
	open("./meshes/" * meshfilebase * ".mesh", "w") do file
		writedlm(file, datfiles)
	end
end
