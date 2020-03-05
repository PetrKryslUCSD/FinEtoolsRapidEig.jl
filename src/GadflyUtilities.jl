module GadflyUtilities

using Gadfly
import Cairo, Fontconfig
# using DataFrames
import LinearAlgebra: norm
# using Random
# using Distributions
using Statistics
# using StatsBase

function makefilename(filename)
	s = replace(replace(filename, ":"=>"_"), " "=>"_") 
	if (match(r".*\.pdf$", s) == nothing)
		s = s * ".pdf"
	end
	return s
end

function plotconvergence(filename, fst, fs1, fs2; toignore= 0)
	d1 = fs1[toignore+1:end]
	d2 = fs2[toignore+1:end]
	dt = fst[toignore+1:end]
	
	df = abs.(d2 - d1) ./ abs.(d2)
	l1 = layer(x = 1:length(d1), y = df, Geom.line, Theme(default_color=colorant"red"))
	df = abs.(d2 - dt) ./ abs.(dt)
	lt = layer(x = 1:length(dt), y = df, Geom.line(style(line_style=[:dot])), Theme(default_color=colorant"black"))
	p = plot(l1, lt, Scale.y_log10, Guide.xlabel("Frequency"), Guide.ylabel("Difference"),
		Guide.title("Relative difference of the frequencies"));
	File = makefilename(filename)
	draw(PDF(File, 16cm, 9cm), p)
	return p
end

end

# function boxplot(iqr, whiskers, medn, ym)
# 	d = 1.5 * (iqr[2] - iqr[1])
# 	return (
# 		layer(x=[iqr[1], iqr[1]], y=[0.4*ym, 0.6*ym], Geom.line, Theme(default_color="black")), 
# 		layer(x=[iqr[2], iqr[2]], y=[0.4*ym, 0.6*ym], Geom.line, Theme(default_color="black")), 
# 		layer(x=[iqr[1], iqr[2]], y=[0.5*ym, 0.5*ym], Geom.line, Theme(default_color="black")),
# 		layer(x=[iqr[1], iqr[2]], y=[0.6*ym, 0.6*ym], Geom.line, Theme(default_color="black")), 
# 		layer(x=[iqr[1], iqr[2]], y=[0.4*ym, 0.4*ym], Geom.line, Theme(default_color="black")), 
# 		layer(x=[medn, medn], y=[0.4*ym, 0.6*ym], Geom.line, Theme(default_color="black")), 
# 		layer(x=[iqr[1], whiskers[1]], y=[0.5*ym, 0.5*ym], Geom.line, Theme(default_color="black")), 
# 		layer(x=[iqr[2], whiskers[2]], y=[0.5*ym, 0.5*ym], Geom.line, Theme(default_color="black")), 
# 		layer(x=[whiskers[1], whiskers[1]], y=[0.45*ym, 0.55*ym], Geom.line, Theme(default_color="black")), 
# 		layer(x=[whiskers[2], whiskers[2]], y=[0.45*ym, 0.55*ym], Geom.line, Theme(default_color="black"))
# 		)
# end

# function plothrefinement(filename, title, hrefinement)
# 	p = plot(x=hrefinement, Geom.bar, Gadfly.Stat.histogram, Guide.title(title));
# 	File = makefilename(filename)
# 	draw(PDF(File, 16cm, 9cm), p)
# 	return p
# end

# function plotrehistogram(filename, solnestim, solnestims, results, truesoln, nbins=10000, rwidth = 7)
# 	h = fit(Histogram, solnestims, nbins=nbins)
# 	medn = median(solnestims)
# 	ym = maximum(h.weights)
# 	iqr = quantile(solnestims, [0.25, 0.75])
# 	whiskers = quantile(solnestims, [0.025, 0.975])
# 	sol1 = (
# 			layer(x=[results[1], results[1]], y=[0.0*ym, ym/20], Geom.line, Theme(default_color="black")),
# 			layer(x=[results[2], results[2]], y=[0.0*ym, ym/10], Geom.line, Theme(default_color="black")),
# 			layer(x=[results[3], results[3]], y=[0.0*ym, ym/5], Geom.line, Theme(default_color="black")),
# 			)
# 	line4 = layer(x=[truesoln, truesoln], y=[0.0*ym, 0.0*ym], Geom.line, Theme(default_color="black"))
# 	if solnestim != 0.0
# 		line4 = layer(x=[solnestim, solnestim], y=[0.0*ym, 1.0*ym], Geom.line, Theme(default_color="black"))
# 	end
# 	df  = DataFrame(solution = vec(solnestims))
# 	bars = layer(df, x=:solution, Geom.bar, Gadfly.Stat.histogram(bincount = nbins))
# 	xmin = min(truesoln, medn-rwidth*diff(iqr)[1], minimum(results), whiskers[1])
# 	xmax = max(truesoln, medn+rwidth*diff(iqr)[1], maximum(results), whiskers[2])
# 	if solnestim != 0.0
# 		xmin = min(xmin, solnestim)
# 		xmax = max(xmax, solnestim)
# 	end
# 	d = ym/20 * (xmax - xmin) / ym / 2.5
# 	tri4 = (
# 		layer(x=[truesoln, truesoln+d], y=[0.0*ym, ym/20], Geom.line, Theme(default_color="black")),
# 		layer(x=[truesoln-d, truesoln], y=[ym/20, 0.0*ym], Geom.line, Theme(default_color="black")),
# 		layer(x=[truesoln-d, truesoln+d], y=[ym/20, ym/20], Geom.line, Theme(default_color="black"))
# 		)
# 	p = plot(boxplot(iqr, whiskers, medn, ym)..., tri4..., sol1..., line4, bars, Coord.cartesian(xmin=xmin, xmax=xmax), Guide.xlabel("Extrapolated solution"),
# 		Guide.title("Histogram of Richardson extrapolation of the solution"));
# 	File = makefilename(filename)
# 	draw(PDF(File, 16cm, 9cm), p)
# 	return p
# end
 
# function plotreconvergence(filename, results, parameters, solnestim, betaestim, cestim)
# 	ea = diff(results, dims=1) # Approximate errors
# 	et = solnestim .- results # Estimates of true errors
# 	h = parameters # Convenience: element sizes
	
# 	ea21, ea32, ea31 = results[2]-results[1], results[3]-results[2], results[3]-results[1]
# 	a21, a32, a31 = h[2]/h[1], h[3]/h[2], h[3]/h[1]
# 	eac = [ea21/(cestim*(1.0-a21^betaestim)), ea32/(cestim*(1.0-a32^betaestim)), ea31/(cestim*(1.0-a31^betaestim))]
# 	# [ea[idx]/(cestim*(1.0-(h[idx+1]/h[idx])^betaestim)) for idx in 1:length(ea)] 

# 	l1 = layer(x = parameters, y = abs.(et), Geom.line, Geom.point)
# 	l2 = layer(x = parameters[[1, 2, 1]], y =abs.(eac), Theme(default_color=colorant"red"), Geom.point)
# 	p = plot(l1, l2, Scale.x_discrete, Scale.x_log10, Scale.y_log10, Guide.xlabel("Element size"),
# 		Guide.title("Error"));
# 	File = makefilename(filename)
# 	draw(PDF(File, 16cm, 9cm), p)
# 	return p
# end