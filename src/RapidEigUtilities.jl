module RapidEigUtilities

using ..DataUtilities: getjsonname, loadjson, getmdatname, retrieve, store, savejson

function reducedmodelparameters(V, N, E, nu, rho, fmax, alpha)
	@show c = sqrt(E / 2 / (1 + nu) / rho)
	@show lambda = c / fmax
	@show Ncfloat = V / lambda^3
	Nchi = nextpow(2, Ncfloat)
	Nclo = prevpow(2, Ncfloat)
	if Nchi - Ncfloat > Ncfloat - Nclo
		Nc = Nclo
	else
		Nc = Nchi
	end
	nbf1max = Int(floor((N / Nc)^(1.0/3))) 
	# The maximum number of 1d basis functions is reduced to assist with
	# arrangements of nodes that could prevent the columns of the
	# transformation matrix from being linearly independent.
	nbf1max = Int(floor(nbf1max / alpha))
	# We  clamp the number of basis functions $n_1$ to ensure both a
	# sufficient number of such functions to generate a reasonably rich
	# approximation, and to prevent a hugely expensive computation with too
	# many basis functions.
	nbf1max = nbf1max < 4 ? 4 : nbf1max
	nbf1max = nbf1max > 9 ? 9 : nbf1max
	return Nc, nbf1max
end

function reducedmodelparameters(V, N, E, nu, rho, fmax, alpha, smallestdimension)
	@show c = sqrt(E / 2 / (1 + nu) / rho)
	@show lambda = c / fmax
	d = min(lambda, smallestdimension)
	@show Ncfloat = V / d^3
	Nchi = nextpow(2, Ncfloat)
	Nclo = prevpow(2, Ncfloat)
	if Nchi - Ncfloat > Ncfloat - Nclo
		Nc = Nclo
	else
		Nc = Nchi
	end
	nbf1max = Int(floor((N / Nc)^(1.0/3))) 
	# The maximum number of 1d basis functions is reduced to assist with
	# arrangements of nodes that could prevent the columns of the
	# transformation matrix from being linearly independent.
	nbf1max = Int(floor(nbf1max / alpha))
	# We  clamp the number of basis functions $n_1$ to ensure both a
	# sufficient number of such functions to generate a reasonably rich
	# approximation, and to prevent a hugely expensive computation with too
	# many basis functions.
	nbf1max = nbf1max < 4 ? 4 : nbf1max
	nbf1max = nbf1max > 9 ? 9 : nbf1max
	return Nc, nbf1max
end

function timingtotal(jsonfile)
	properties = loadjson(jsonfile)
	return properties["timing"]["Total"]
end

function timingtotalfull(jsonfile)
	return timingtotal(fulljson(jsonfile))
end

function fulljson(jsonfile)
	properties = loadjson(jsonfile)
	return properties["fulljson"]
end

end