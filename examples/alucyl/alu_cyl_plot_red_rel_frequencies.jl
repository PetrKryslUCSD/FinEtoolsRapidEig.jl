using FinEtools
using Arpack
using Statistics: mean
using Main.DataUtilities: getjsonname, savejson, loadjson
using PGFPlotsX

properties = loadjson("alu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200.json")
fref = convert.(Float64, properties["frequencies"])

plots = [];

properties = loadjson("Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64.json")
f = convert.(Float64, properties["frequencies"]) ./ fref .- 1.0
p = @pgf Plot(    {
        mark  = "pentagon", mark_size = 1.0 , 
        color = "black",
        only_marks
    },
    Table([7:length(f), f[7:end]])
)
push!(plots, p);


@pgf figure = Axis(
    {
        xmajorgrids,
        ymajorgrids,
        xlabel="Serial number [ND]", ylabel="Relative frequency error [ND]"
    },
    plots...
)

pgfsave("Redalu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=1200-LegendreBasis-a=1_5-b=6_9-Nc=64.json-normalized-frequencies.pdf", figure)


# plots = [];

# # Mesh markers
# p = @pgf Plot(
#     {
#         mark  = "x",
#         color = "black",
#         only_marks,
#         very_thick
#     },
#     Table([7:length(f)-1, diff(f[7:end], dims=1) ./ f[7:end-1]])
# )
# push!(plots, p);

# @pgf figure = SemiLogYAxis(
#     {
#         xmajorgrids,
#         ymajorgrids,
#         xlabel="Serial number [ND]", ylabel="Relative frequency difference [ND]"
#     },
#     plots...
# )

# pgfsave("full_alu_cyl-nr=15xnL=60-neigvs=1000-frequency-diff.pdf", figure)