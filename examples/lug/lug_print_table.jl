using FinEtools
using FinEtools.AlgoDeforLinearModule: ssit
import CoNCMOR: CoNCData, transfmatrix, LegendreBasis, SineCosineBasis 
using Arpack
using Statistics: mean
using Main.DataUtilities: getcleanname, getjsonname, loadjson, getmdatname, retrieve, store, savejson
using Main.RapidEigUtilities: timingtotalfull, timingtotal
using PGFPlotsX

include("lug_utilities.jl")

# list = [n for n in readdir(".") if match(r"Red.*nr=25xnL=100.*_05.*.json", n) != nothing];
list = [n for n in readdir(".") if match(r"Red.*lug-18540_nas.*_02.*.json", n) != nothing];
for item in list
	properties = loadjson(item)
	# @show keys(properties)
	frequencies = properties["frequencies"]
	Nc = properties["Nc"]
	bnumbers = properties["bnumbers"]
	frequency_errors = [Float64(e) for e in properties["frequency_errors"]] 
	true_frequency_error = properties["true_frequency_error"]
	fullproperties = loadjson(properties["fulljson"])
	fullfrequencies = fullproperties["frequencies"]
	frequency_errors = [Int(round(10000*e))/10000 for e in frequency_errors] 
	frequency_errors_p = ""
	for (i, e) = enumerate(frequency_errors)
		frequency_errors_p = frequency_errors_p * "$(e)"
		(i != length(frequency_errors)) && (frequency_errors_p = frequency_errors_p * ", ")
	end
	frequencyerrormax = maximum(abs.(fullfrequencies[7:end] - frequencies[7:end]) ./ fullfrequencies[7:end])
	println("$(length(frequencies)) & $(Nc) & $(bnumbers[end]) & $(frequency_errors_p) & $(Int(round(10000*true_frequency_error))/10000) & $(100 * Int(round(10000*frequencyerrormax))/10000)\\\\")
end 
