using FinEtools
using FinEtoolsRapidEig
using Arpack
using Statistics: mean
using FinEtoolsRapidEig.DataUtilities: getjsonname, savejson, loadjson
using PGFPlotsX

neigvs  =  300
plots = [];

properties = loadjson("alu_cyl-cylinder-30mm-2116el_mesh-neigvs=$(neigvs).json")
f = convert.(Float64, properties["frequencies"])
p = @pgf Plot(    {
        mark  = "x", mark_size = 0.2, 
        color = "black",
        only_marks
    },
    Table([1:length(f), f])
)
push!(plots, p);
# properties = loadjson("alu_cyl-cylinder-20mm-4436el_mesh-neigvs=150.json")
# f = convert.(Float64, properties["frequencies"])
# p = @pgf Plot(    {
#         mark  = "+", mark_size = 0.2, 
#         color = "black",
#         only_marks
#     },
#     Table([1:length(f), f])
# )
# push!(plots, p);
# properties = loadjson("alu_cyl-cylinder-15mm-8204el_mesh-neigvs=150.json")
# f = convert.(Float64, properties["frequencies"])
# p = @pgf Plot(    {
#         mark  = "o", mark_size = 0.2, 
#         color = "black",
#         only_marks
#     },
#     Table([1:length(f), f])
# )
# push!(plots, p);
# properties = loadjson("alu_cyl-cylinder-10mm-17980el_mesh-neigvs=150.json")
# f = convert.(Float64, properties["frequencies"])
# p = @pgf Plot(    {
#         mark  = "o", mark_size = 0.2, 
#         color = "black",
#         only_marks
#     },
#     Table([1:length(f), f])
# )
# push!(plots, p);
# properties = loadjson("alu_cyl-cylinder-7_5mm-31692el_mesh-neigvs=150.json")
# f = convert.(Float64, properties["frequencies"])
# p = @pgf Plot(    {
#         mark  = "o", mark_size = 0.2, 
#         color = "black",
#         only_marks
#     },
#     Table([1:length(f), f])
# )
# push!(plots, p);

@pgf figure = SemiLogYAxis(
    {
        xmajorgrids,
        ymajorgrids,
        xlabel="Serial number [ND]", ylabel="Frequency [Hz]"
    },
    plots...
)

pgfsave("full_alu_cyl-neigvs=$(neigvs)-frequencies.pdf", figure)


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