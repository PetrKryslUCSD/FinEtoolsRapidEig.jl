module DataUtilities

using JSON
using DelimitedFiles
using FinEtools

const _typedictionary = Dict("Int64"=>Int64, "Float64"=>Float64, "Complex{Float64}"=>Complex{Float64})

const _sep = "-"

function getcleanname(name)
    cleanname = replace(replace(replace(name,'.'=>'_'),':'=>'_'),' '=>'_')    
    return cleanname
end

function getpdfname(problem, features)
    pdffile = getcleanname(problem * _sep * features)
    if match(r".*\.pdf$", pdffile) == nothing
        pdffile = pdffile * ".pdf"
    end
    return pdffile
end

function getjsonname(problem, features)
    jsonfile = getcleanname(problem * _sep * features)
    if match(r".*\.json$", jsonfile) == nothing
        jsonfile = jsonfile * ".json"
    end
    return jsonfile
end

function loadjson(j)
    return open(j, "r") do file
        JSON.parse(file)
    end
end

function savejson(j, d)
	open(j, "w") do file
		JSON.print(file, d)
	end
end

"""
    retrieve(d)

Retrieve a matrix. It is described by the dictionary `d`.
# Example
```
v = retrieve(properties["v"])
```
"""
function retrieve(d)
    T = _typedictionary[d["type"]]
    matrix = fill(zero(T), Tuple(Int.(d["dims"]))...)
    try
        matrix = open("./matrices/" * d["file"], "r") do file
            # readdlm(file, ',', T)
            read!(file, matrix)
        end
        return reshape(matrix, Tuple(Int.(d["dims"]))...)
    catch SystemError
        return nothing
    end
end

"""
    store(matrix, filename)

Store a matrix.
# Example
```
properties["eigenvectors"] = Dict("dims"=>size(v), "type"=>"\$(eltype(v))", "file"=>getmdatname(problem, features, "v"))
store(v, properties["eigenvectors"]["file"])
```
"""
function store(matrix, filename)
    mkpath("./matrices")
    open("./matrices/" * filename, "w") do file
        # writedlm(file, matrix[:])
        write(file, matrix[:])
    end
end

function getmdatname(problem, features, arrayname, additional = "")
	name = problem * _sep * replace(replace(features,'.'=>'_'),':'=>'_')  
    name = name * _sep * arrayname
    (additional != "") && (name = name * _sep * additional)
    return name * ".mdat" 
end

end 
            