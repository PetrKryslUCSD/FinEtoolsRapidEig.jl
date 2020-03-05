using FinEtools
using FinEtools.AlgoDeforLinearModule: ssit
import CoNCMOR: CoNCData, transfmatrix, LegendreBasis, SineCosineBasis 
using Arpack
using Statistics: mean
using Main.DataUtilities: getcleanname, getjsonname, loadjson, getmdatname, retrieve, store, savejson
using Main.RapidEigUtilities: timingtotalfull, timingtotal
using PGFPlotsX

include("lug_utilities.jl")

fulltimpl(neigvss, ts) = begin
	@pgf Plot({
		mark = "o", mark_size = 3, very_thick,
		dashed, 
		color = "black", very_thick
		},
		Table([neigvss, ts])
		)
end
redtimpl1(neigvss, ts) = begin
	@pgf Plot({
		mark = "star", mark_size = 5, very_thick,
		color = "red", very_thick
		},
		Table([neigvss, ts])
		)
end
redtimpl2(neigvss, ts) = begin
	@pgf Plot({
		mark = "o", mark_size = 5, very_thick,
		color = "red", very_thick
		},
		Table([neigvss, ts])
		)
end
updatets!(ts, f, name) = push!(ts, f(name))

plots = []
tfs = []
trs1 = []
trs2 = []

# neigvss  = [15, 50, 150, 300, 600, ]
# for jsn = [
# 	"Redlug-lug-54776_nas-neigvs=15-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                             
# 	"Redlug-lug-54776_nas-neigvs=50-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                             
# 	"Redlug-lug-54776_nas-neigvs=150-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                            
# 	"Redlug-lug-54776_nas-neigvs=300-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                            
# 	"Redlug-lug-54776_nas-neigvs=600-LegendreBasis-a=1_5-n1=4_7-Nc=[12,_12,_8]-tol=0_02.json",                                                                            
# 	]
# 	updatets!(tfs, timingtotalfull, jsn)
# 	updatets!(trs1, timingtotal, jsn)
# end
# figurename = getcleanname("Redlug-lug-54776_nas-neigvs=$(neigvss)-LegendreBasis-a=1_5-tol=0_02") * ".pdf"

# neigvss  = [15, 50, 150, 300, 600, ]
# for jsn = [
# 	"Redlug-lug-217666_nas-neigvs=15-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                            
# 	"Redlug-lug-217666_nas-neigvs=50-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                            
# 	"Redlug-lug-217666_nas-neigvs=150-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                           
# 	"Redlug-lug-217666_nas-neigvs=300-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                           
# 	"Redlug-lug-217666_nas-neigvs=600-LegendreBasis-a=1_5-n1=6_9-Nc=[12,_12,_8]-tol=0_02.json",                                                                      
# 	]
# 	updatets!(tfs, timingtotalfull, jsn)
# 	updatets!(trs1, timingtotal, jsn)
# end
# figurename = getcleanname("Redlug-lug-217666_nas-neigvs=$(neigvss)-LegendreBasis-a=1_5-tol=0_02") * ".pdf"

neigvss  = [15, 50, 150, 300 ]
for jsn = [
	"Redlug-lug-18540_nas-neigvs=15-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                             
	"Redlug-lug-18540_nas-neigvs=50-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                                                                    
	"Redlug-lug-18540_nas-neigvs=150-LegendreBasis-a=1_5-n1=6_9-Nc=[8,_8,_2]-tol=0_02.json",                            
	"Redlug-lug-18540_nas-neigvs=300-LegendreBasis-a=1_5-n1=3_6-Nc=[8,_8,_2]-tol=0_02.json",                            
	]
	updatets!(tfs, timingtotalfull, jsn)
	updatets!(trs1, timingtotal, jsn)
end
figurename = getcleanname("Redlug-lug-18540_nas-neigvs=$(neigvss)-LegendreBasis-a=1_5-tol=0_02") * ".pdf"

@. trs1 = tfs / trs1
# @. trs2 = tfs / trs2
push!(plots, redtimpl1(neigvss, trs1))

@pgf figure = Axis({
	xmajorgrids,
	ymajorgrids,
	ymin = 0,
	xlabel="Number of frequencies [ND]", ylabel="Speedup [ND]"
	},
	plots...
	)

pgfsave("speedup-" * figurename, figure)


list = [n for n in readdir(".") if match(r"Red.*217666_nas.*_02.*.json", n) != nothing];
for item in list
 	println("\"$item\",")
 end 
# @show timing = runme(15, 60, 1000, SineCosineBasis, 1.2, 3:1:5, 0.05)
