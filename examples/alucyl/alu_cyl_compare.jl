using FinEtools
using FinEtoolsDeforLinear
using FinEtoolsDeforLinear.AlgoDeforLinearModule: ssit
import CoNCMOR: CoNCData, transfmatrix, LegendreBasis, SineCosineBasis 
using Arpack
using Statistics: mean
using Main.DataUtilities: getjsonname, loadjson, getmdatname, retrieve, store, savejson
using Main.RapidEigUtilities: reducedmodelparameters
import LinearAlgebra: norm, dot
using DelimitedFiles
using PGFPlotsX

refd = loadjson("alu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200.json")
f(f, reff) = begin
    f = f[7:end]
    reff = reff[7:end]
    return @. abs(f - reff) / reff
end

plots = []

# d = loadjson("alu_cyl-cylinder-30mm-2116el_mesh-neigvs=1200.json")
# ndiffd = f(d["frequencies"], refd["frequencies"])
# push!(plots, @pgf Plot({
# 	mark = "o", mark_size = 1, 
# 	color = "black"
# 	},
# 	Table([1:length(ndiffd), ndiffd])
# 	)
# )

d = loadjson("alu_cyl-cylinder-20mm-4436el_mesh-neigvs=1200.json")
ndiffd = f(d["frequencies"], refd["frequencies"])
push!(plots, @pgf Plot({
	mark = "triangle", mark_size = 1,  "only marks",
	color = "blue"
	},
	Table([1:length(ndiffd), ndiffd])
	)
)

d = loadjson("alu_cyl-cylinder-15mm-8204el_mesh-neigvs=1200.json")
ndiffd = f(d["frequencies"], refd["frequencies"])
push!(plots, @pgf Plot({
	mark = "o", mark_size = 1, "only marks",
	color = "red"
	},
	Table([1:length(ndiffd), ndiffd])
	)
)

# d = loadjson("alu_cyl-cylinder-10mm-17980el_mesh-neigvs=1200.json")
# ndiffd = f(d["frequencies"], refd["frequencies"])
# push!(plots, @pgf Plot({
# 	mark = "o", mark_size = 1, 
# 	color = "red"
# 	},
# 	Table([1:length(ndiffd), ndiffd])
# 	)
# )

d = loadjson("Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64-tol=0_02.json")
ndiffd = f(d["frequencies"], refd["frequencies"])
push!(plots, @pgf Plot({
	mark = "x", mark_size = 1,  "only marks",
	color = "black"
	},
	Table([1:length(ndiffd), ndiffd])
	)
)

@pgf figure = SemiLogYAxis({
	xmajorgrids,
	ymajorgrids,
	xlabel="Mode number [ND]", ylabel="Normalized frequency error [ND]"
	},
	plots...
	)
pgfsave("compare" * ".pdf", figure)

if false
	sims = ["alu_cyl-cylinder-30mm-2116el_mesh-neigvs=1200.json"
	"alu_cyl-cylinder-20mm-4436el_mesh-neigvs=1200.json"
	"alu_cyl-cylinder-15mm-8204el_mesh-neigvs=1200.json"
	"alu_cyl-cylinder-10mm-17980el_mesh-neigvs=1200.json"
	"alu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200.json"]
	for s in sims
		d = loadjson(s)
		@show d["timing"]["Total"]
	end
	sims = ["Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64-tol=0_02.json"]
	for s in sims
		d = loadjson(s)
		@show d["timing"]["Total"]
	end
end
