using FinEtools
using FinEtools.AlgoDeforLinearModule: ssit
import CoNCMOR: CoNCData, transfmatrix, LegendreBasis, SineCosineBasis 
using Arpack
using Statistics: mean
using Main.DataUtilities: getcleanname, getjsonname, loadjson, getmdatname, retrieve, store, savejson
using Main.RapidEigUtilities: timingtotalfull, timingtotal
using PGFPlotsX

include("alu_cyl_utilities.jl")

fulltimpl(neigvss, ts) = begin
	@pgf Plot({
		mark = "o", mark_size = 3, very_thick,
		dashed, 
		color = "black"
		},
		Table([neigvss, ts])
		)
end
redtimpl1(neigvss, ts) = begin
	@pgf Plot({
		mark = "star", mark_size = 5, very_thick,
		color = "red"
		},
		Table([neigvss, ts])
		)
end
redtimpl2(neigvss, ts) = begin
	@pgf Plot({
		mark = "o", mark_size = 5, very_thick,
		color = "red"
		},
		Table([neigvss, ts])
		)
end
updatets!(ts, f, name) = push!(ts, f(name))

plots = []
tfs = []
trs1 = []
trs2 = []


# neigvss  = [150, 300, 600]
# for jsn = [
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_02.json",                                                                               
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=16-tol=0_02.json",                                                                              
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=600-LegendreBasis-a=1_5-b=6_9-Nc=32-tol=0_02.json",                           
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64-tol=0_02.json",                                                                             
# 	]
# 	updatets!(tfs, timingtotalfull, jsn)
# 	updatets!(trs1, timingtotal, jsn)
# end
# for jsn = [                                                               
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_005.json",                                                                              
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=16-tol=0_005.json",                                                                             
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=600-LegendreBasis-a=1_5-b=6_9-Nc=32-tol=0_005.json",  
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64-tol=0_005.json",                                                                            
# 	]
# 	updatets!(trs2, timingtotal, jsn)
# end
# figurename = getcleanname("Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=$(neigvss)-LegendreBasis-a=1_5-tol=0_02-0_005") * ".pdf"


# neigvss  = [150, 300, 600, 1200]
# for jsn = [
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_02.json",                                                                               
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=16-tol=0_02.json",                                                                              
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=600-LegendreBasis-a=1_5-b=6_9-Nc=32-tol=0_02.json",                           
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64-tol=0_02.json",                                                                             
# 	]
# 	updatets!(tfs, timingtotalfull, jsn)
# 	updatets!(trs1, timingtotal, jsn)
# end
# for jsn = [                                                               
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_005.json",                                                                              
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=16-tol=0_005.json",                                                                             
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=600-LegendreBasis-a=1_5-b=6_9-Nc=32-tol=0_005.json",  
# 	"Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64-tol=0_005.json",                                                                            
# 	]
# 	updatets!(trs2, timingtotal, jsn)
# end
# figurename = getcleanname("Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=$(neigvss)-LegendreBasis-a=1_5-tol=0_02-0_005") * ".pdf"

neigvss  = [150, 300, 600, 1200]
for jsn = [
	"Redalu_cyl-cylinder-nr=20xnL=80_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_02.json",                                                                                 
	"Redalu_cyl-cylinder-nr=20xnL=80_mesh-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=16-tol=0_02.json",                                                                                
	"Redalu_cyl-cylinder-nr=20xnL=80_mesh-neigvs=600-LegendreBasis-a=1_5-b=6_9-Nc=32-tol=0_02.json",                                                                             
	"Redalu_cyl-cylinder-nr=20xnL=80_mesh-neigvs=1200-LegendreBasis-a=1_5-b=4_7-Nc=64-tol=0_02.json",                                                                               
	]
	updatets!(tfs, timingtotalfull, jsn)
	updatets!(trs1, timingtotal, jsn)
end
for jsn = [                                                               
	"Redalu_cyl-cylinder-nr=20xnL=80_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_005.json",                                                                                
	"Redalu_cyl-cylinder-nr=20xnL=80_mesh-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=16-tol=0_005.json",                                                                               
	"Redalu_cyl-cylinder-nr=20xnL=80_mesh-neigvs=600-LegendreBasis-a=1_5-b=6_9-Nc=32-tol=0_005.json",                                                       
	"Redalu_cyl-cylinder-nr=20xnL=80_mesh-neigvs=1200-LegendreBasis-a=1_5-b=4_7-Nc=64-tol=0_005.json",                                                                              
	]
	updatets!(trs2, timingtotal, jsn)
end
figurename = getcleanname("Redalu_cyl-cylinder-nr=20xnL=80_mesh-neigvs=$(neigvss)-LegendreBasis-a=1_5-tol=0_02-0_005") * ".pdf"

# neigvss  = [150, 300, 600, 1200]
# for jsn = [
# 	"Redalu_cyl-cylinder-nr=25xnL=100_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_02.json",                                                                                
# 	"Redalu_cyl-cylinder-nr=25xnL=100_mesh-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=16-tol=0_02.json",                                                                               
# 	"Redalu_cyl-cylinder-nr=25xnL=100_mesh-neigvs=600-LegendreBasis-a=1_5-b=6_9-Nc=32-tol=0_02.json", 
# 	"Redalu_cyl-cylinder-nr=25xnL=100_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64-tol=0_02.json",                                                                              
# 	]
# 	updatets!(tfs, timingtotalfull, jsn)
# 	updatets!(trs1, timingtotal, jsn)
# end
# for jsn = [                                                               
# 	"Redalu_cyl-cylinder-nr=25xnL=100_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_005.json",                                                                               
# 	"Redalu_cyl-cylinder-nr=25xnL=100_mesh-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=16-tol=0_005.json",                                                                              
# 	"Redalu_cyl-cylinder-nr=25xnL=100_mesh-neigvs=600-LegendreBasis-a=1_5-b=6_9-Nc=32-tol=0_005.json",                                                            
# 	"Redalu_cyl-cylinder-nr=25xnL=100_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64-tol=0_005.json",                                                                             
# 	]
# 	updatets!(trs2, timingtotal, jsn)
# end
# figurename = getcleanname("Redalu_cyl-cylinder-nr=25xnL=100_mesh-neigvs=$(neigvss)-LegendreBasis-a=1_5-tol=0_02-0_005") * ".pdf"

# neigvss  = [150, 300, 600, ]
# for jsn = [
# 	"Redalu_cyl-cylinder-15mm-8204el_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_02.json",                                                                                 
# 	"Redalu_cyl-cylinder-15mm-8204el_mesh-neigvs=300-LegendreBasis-a=1_5-b=5_8-Nc=16-tol=0_02.json",                                                                                
# 	"Redalu_cyl-cylinder-15mm-8204el_mesh-neigvs=600-LegendreBasis-a=1_5-b=3_6-Nc=32-tol=0_02.json",                                                                                
# 	]
# 	updatets!(tfs, timingtotalfull, jsn)
# 	updatets!(trs1, timingtotal, jsn)
# end
# for jsn = [                                                               
# 	"Redalu_cyl-cylinder-15mm-8204el_mesh-neigvs=150-LegendreBasis-a=1_5-b=6_9-Nc=8-tol=0_005.json",                                                                                
# 	"Redalu_cyl-cylinder-15mm-8204el_mesh-neigvs=300-LegendreBasis-a=1_5-b=5_8-Nc=16-tol=0_005.json",                                                                               
# 	"Redalu_cyl-cylinder-15mm-8204el_mesh-neigvs=600-LegendreBasis-a=1_5-b=3_6-Nc=32-tol=0_005.json",       
# 	]
# 	updatets!(trs2, timingtotal, jsn)
# end
# figurename = getcleanname("Redalu_cyl-cylinder-15mm-8204el_mesh-neigvs=$(neigvss)-LegendreBasis-a=1_5-tol=0_02-0_005") * ".pdf"

push!(plots, fulltimpl(neigvss, tfs), redtimpl1(neigvss, trs1), redtimpl2(neigvss, trs2))

@pgf figure = Axis({
	xmajorgrids,
	ymajorgrids,
	xlabel="Number of frequencies [ND]", ylabel="Timing [sec]"
	},
	plots...
	)

pgfsave("timing-" * figurename, figure)

list = [n for n in readdir(".") if match(r"Red.*15m.*_005.*.json", n) != nothing];
for item in list
 	println("\"$item\",")
 end 
# @show timing = runme(15, 60, 1000, SineCosineBasis, 1.2, 3:1:5, 0.05)
