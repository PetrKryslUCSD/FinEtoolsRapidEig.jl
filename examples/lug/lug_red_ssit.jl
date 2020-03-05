Don't forget to start the XMing X server                                                                            
pkrysl@Firebolt:~$ cd /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/                                   
pkrysl@Firebolt:/mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig$ ../julia-latest/bin/julia               
               _                                                                                                    
   _       _ _(_)_     |  Documentation: https://docs.julialang.org                                                 
  (_)     | (_) (_)    |                                                                                            
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.                                                     
  | | | | | | |/ _` |  |                                                                                            
  | | |_| | | | (_| |  |  Version 1.2.0-DEV.313 (2019-02-12)                                                        
 _/ |\__'_|_|_|\__'_|  |  Commit cd0da8c48e (53 days old master)                                                    
|__/                   |                                                                                            
                                                                                                                    
julia> include("lug_show_mesh.jl");                                                                                 
ERROR: could not open file /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug_show_mesh.jl              
Stacktrace:                                                                                                         
 [1] include at ./boot.jl:326 [inlined]                                                                             
 [2] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [3] include(::Module, ::String) at ./Base.jl:29                                                                    
 [4] include(::String) at ./client.jl:443                                                                           
 [5] top-level scope at REPL[1]:1                                                                                   
                                                                                                                    
julia> include("go.jl");                                                                                            
  Updating registry at `~/.julia/registries/General`                                                                
^[[200~include("lug_show_mesh.jl");^[[201~                                                                          
  Updating git-repo `https://github.com/JuliaRegistries/General.git`                                                
[ Info: RapidEig ready                                                                                              
                                                                                                                    
julia> include("lug_show_mesh.jl");                                                                                 
[ Info: Mesh lug-18540                                                                                              
count(fens) = 18540                                                                                                 
runme("lug-18540") = Task (queued) @0x00007f03b3bf0c40                                                              
                                                                                                                    
julia> include("lug_utilities.jl");                                                                                 
                                                                                                                    
julia> include("lug_utilities.jl");                                                                                 
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
(meshfile, neigvs) = ("lug-54776.nas", 15)                                                                          
[ Info: FULL model, mesh lug-54776.nas                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_full.jl:54                                                                                                         
caused by [exception 1]                                                                                             
UndefVarError: fes not defined                                                                                      
Stacktrace:                                                                                                         
 [1] macro expansion at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:23 [inlined]     
 [2] macro expansion at ./util.jl:213 [inlined]                                                                     
 [3] runme(::String, ::Int64) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:21      
 [4] macro expansion at ./show.jl:572 [inlined]                                                                     
 [5] top-level scope at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:57               
 [6] include at ./boot.jl:326 [inlined]                                                                             
 [7] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [8] include(::Module, ::String) at ./Base.jl:29                                                                    
 [9] include(::String) at ./client.jl:443                                                                           
 [10] top-level scope at REPL[5]:1                                                                                  
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
(meshfile, neigvs) = ("lug-18540.nas", 15)                                                                          
[ Info: FULL model, mesh lug-18540.nas                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_full.jl:54                                                                                                         
caused by [exception 1]                                                                                             
UndefVarError: femm not defined                                                                                     
Stacktrace:                                                                                                         
 [1] lug_setup(::Float64, ::Float64, ::Float64, ::FENodeSet, ::Array{FESetT10,2}, ::TetRule, ::TetRule) at /mnt/c/Us​‌​
ers/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_utilities.jl:47                                           
 [2] macro expansion at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:23 [inlined]     
 [3] macro expansion at ./util.jl:213 [inlined]                                                                     
 [4] runme(::String, ::Int64) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:21      
 [5] macro expansion at ./show.jl:572 [inlined]                                                                     
 [6] top-level scope at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:57               
 [7] include at ./boot.jl:326 [inlined]                                                                             
 [8] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [9] include(::Module, ::String) at ./Base.jl:29                                                                    
 [10] include(::String) at ./client.jl:443                                                                          
 [11] top-level scope at REPL[5]:1                                                                                  
                                                                                                                    
julia> include("lug_utilities.jl");                                                                                 
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
(meshfile, neigvs) = ("lug-18540.nas", 15)                                                                          
[ Info: FULL model, mesh lug-18540.nas                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_full.jl:54                                                                                                         
caused by [exception 1]                                                                                             
BoundsError: attempt to access 0-element Array{Any,1} at index [1]                                                  
Stacktrace:                                                                                                         
 [1] setindex! at ./essentials.jl:426 [inlined]                                                                     
 [2] lug_setup(::Float64, ::Float64, ::Float64, ::FENodeSet, ::Array{FESetT10,2}, ::TetRule, ::TetRule) at /mnt/c/Us​‌​
ers/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_utilities.jl:48                                           
 [3] macro expansion at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:23 [inlined]     
 [4] macro expansion at ./util.jl:213 [inlined]                                                                     
 [5] runme(::String, ::Int64) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:21      
 [6] macro expansion at ./show.jl:572 [inlined]                                                                     
 [7] top-level scope at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:57               
 [8] include at ./boot.jl:326 [inlined]                                                                             
 [9] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [10] include(::Module, ::String) at ./Base.jl:29                                                                   
 [11] include(::String) at ./client.jl:443                                                                          
 [12] top-level scope at REPL[7]:1                                                                                  
                                                                                                                    
julia> femm = fill(Any(), 3)                                                                                        
ERROR: MethodError: no constructors have been defined for Any                                                       
Stacktrace:                                                                                                         
 [1] top-level scope at REPL[8]:1                                                                                   
                                                                                                                    
julia> femm = fill(nothing, 3)                                                                                      
3-element Array{Nothing,1}:                                                                                         
 nothing                                                                                                            
 nothing                                                                                                            
 nothing                                                                                                            
                                                                                                                    
julia> include("lug_utilities.jl");                                                                                 
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
(meshfile, neigvs) = ("lug-18540.nas", 15)                                                                          
[ Info: FULL model, mesh lug-18540.nas                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_full.jl:54                                                                                                         
caused by [exception 1]                                                                                             
MethodError: Cannot `convert` an object of type FEMMDeforLinear{DeforModelRed3D,FESetT10,typeof(otherdimensionunity)​‌​
,MatDeforElastIso{DeforModelRed3D,typeof(FinEtools.MatDeforElastIsoModule.tangentmoduli3d!),typeof(FinEtools.MatDefo​‌​
rElastIsoModule.update3d!),typeof(FinEtools.MatDeforElastIsoModule.thermalstrain3d!)}} to an object of type Nothing 
Closest candidates are:                                                                                             
  convert(::Type{Nothing}, ::Any) at some.jl:24                                                                     
  convert(::Type{Union{Nothing, T}}, ::Any) where T at some.jl:22                                                   
  convert(::Type{Nothing}, ::Nothing) at some.jl:23                                                                 
  ...                                                                                                               
Stacktrace:                                                                                                         
 [1] convert(::Type{Nothing}, ::FEMMDeforLinear{DeforModelRed3D,FESetT10,typeof(otherdimensionunity),MatDeforElastIs​‌​
o{DeforModelRed3D,typeof(FinEtools.MatDeforElastIsoModule.tangentmoduli3d!),typeof(FinEtools.MatDeforElastIsoModule.​‌​
update3d!),typeof(FinEtools.MatDeforElastIsoModule.thermalstrain3d!)}}) at ./some.jl:24                             
 [2] setindex!(::Array{Nothing,1}, ::FEMMDeforLinear{DeforModelRed3D,FESetT10,typeof(otherdimensionunity),MatDeforEl​‌​
astIso{DeforModelRed3D,typeof(FinEtools.MatDeforElastIsoModule.tangentmoduli3d!),typeof(FinEtools.MatDeforElastIsoMo​‌​
dule.update3d!),typeof(FinEtools.MatDeforElastIsoModule.thermalstrain3d!)}}, ::Int64) at ./array.jl:766             
 [3] lug_setup(::Float64, ::Float64, ::Float64, ::FENodeSet, ::Array{FESetT10,2}, ::TetRule, ::TetRule) at /mnt/c/Us​‌​
ers/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_utilities.jl:48                                           
 [4] macro expansion at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:23 [inlined]     
 [5] macro expansion at ./util.jl:213 [inlined]                                                                     
 [6] runme(::String, ::Int64) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:21      
 [7] macro expansion at ./show.jl:572 [inlined]                                                                     
 [8] top-level scope at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:57               
 [9] include at ./boot.jl:326 [inlined]                                                                             
 [10] include_relative(::Module, ::String) at ./loading.jl:1041                                                     
 [11] include(::Module, ::String) at ./Base.jl:29                                                                   
 [12] include(::String) at ./client.jl:443                                                                          
 [13] top-level scope at REPL[11]:1                                                                                 
                                                                                                                    
julia> Any                                                                                                          
Any                                                                                                                 
                                                                                                                    
julia> fill(Any, 3                                                                                                  
       )                                                                                                            
3-element Array{DataType,1}:                                                                                        
 Any                                                                                                                
 Any                                                                                                                
 Any                                                                                                                
                                                                                                                    
julia> include("lug_utilities.jl");                                                                                 
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
(meshfile, neigvs) = ("lug-18540.nas", 15)                                                                          
[ Info: FULL model, mesh lug-18540.nas                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_full.jl:54                                                                                                         
caused by [exception 1]                                                                                             
MethodError: Cannot `convert` an object of type FEMMDeforLinear{DeforModelRed3D,FESetT10,typeof(otherdimensionunity)​‌​
,MatDeforElastIso{DeforModelRed3D,typeof(FinEtools.MatDeforElastIsoModule.tangentmoduli3d!),typeof(FinEtools.MatDefo​‌​
rElastIsoModule.update3d!),typeof(FinEtools.MatDeforElastIsoModule.thermalstrain3d!)}} to an object of type DataType​‌​
Closest candidates are:                                                                                             
  convert(::Type{T}, ::T) where T at essentials.jl:154                                                              
Stacktrace:                                                                                                         
 [1] setindex!(::Array{DataType,1}, ::FEMMDeforLinear{DeforModelRed3D,FESetT10,typeof(otherdimensionunity),MatDeforE​‌​
lastIso{DeforModelRed3D,typeof(FinEtools.MatDeforElastIsoModule.tangentmoduli3d!),typeof(FinEtools.MatDeforElastIsoM​‌​
odule.update3d!),typeof(FinEtools.MatDeforElastIsoModule.thermalstrain3d!)}}, ::Int64) at ./array.jl:766            
 [2] lug_setup(::Float64, ::Float64, ::Float64, ::FENodeSet, ::Array{FESetT10,2}, ::TetRule, ::TetRule) at /mnt/c/Us​‌​
ers/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_utilities.jl:48                                           
 [3] macro expansion at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:23 [inlined]     
 [4] macro expansion at ./util.jl:213 [inlined]                                                                     
 [5] runme(::String, ::Int64) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:21      
 [6] macro expansion at ./show.jl:572 [inlined]                                                                     
 [7] top-level scope at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:57               
 [8] include at ./boot.jl:326 [inlined]                                                                             
 [9] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [10] include(::Module, ::String) at ./Base.jl:29                                                                   
 [11] include(::String) at ./client.jl:443                                                                          
 [12] top-level scope at REPL[15]:1                                                                                 
                                                                                                                    
julia> sparse(0.0)                                                                                                  
ERROR: UndefVarError: sparse not defined                                                                            
Stacktrace:                                                                                                         
 [1] top-level scope at REPL[16]:1                                                                                  
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
(meshfile, neigvs) = ("lug-18540.nas", 15)                                                                          
[ Info: FULL model, mesh lug-18540.nas                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_full.jl:54                                                                                                         
caused by [exception 1]                                                                                             
type NodalField has no field nfreedofsn                                                                             
Stacktrace:                                                                                                         
 [1] getproperty(::Any, ::Symbol) at ./Base.jl:18                                                                   
 [2] lug_setup(::Float64, ::Float64, ::Float64, ::FENodeSet, ::Array{FESetT10,2}, ::TetRule, ::TetRule) at /mnt/c/Us​‌​
ers/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_utilities.jl:41                                           
 [3] macro expansion at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:23 [inlined]     
 [4] macro expansion at ./util.jl:213 [inlined]                                                                     
 [5] runme(::String, ::Int64) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:21      
 [6] macro expansion at ./show.jl:572 [inlined]                                                                     
 [7] top-level scope at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:57               
 [8] include at ./boot.jl:326 [inlined]                                                                             
 [9] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [10] include(::Module, ::String) at ./Base.jl:29                                                                   
 [11] include(::String) at ./client.jl:443                                                                          
 [12] top-level scope at REPL[17]:1                                                                                 
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
(meshfile, neigvs) = ("lug-18540.nas", 15)                                                                          
[ Info: FULL model, mesh lug-18540.nas                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_full.jl:54                                                                                                         
caused by [exception 1]                                                                                             
UndefVarError: spzeros not defined                                                                                  
Stacktrace:                                                                                                         
 [1] lug_setup(::Float64, ::Float64, ::Float64, ::FENodeSet, ::Array{FESetT10,2}, ::TetRule, ::TetRule) at /mnt/c/Us​‌​
ers/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_utilities.jl:41                                           
 [2] macro expansion at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:23 [inlined]     
 [3] macro expansion at ./util.jl:213 [inlined]                                                                     
 [4] runme(::String, ::Int64) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:21      
 [5] macro expansion at ./show.jl:572 [inlined]                                                                     
 [6] top-level scope at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_full.jl:57               
 [7] include at ./boot.jl:326 [inlined]                                                                             
 [8] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [9] include(::Module, ::String) at ./Base.jl:29                                                                    
 [10] include(::String) at ./client.jl:443                                                                          
 [11] top-level scope at REPL[17]:1                                                                                 
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_full.jl:6                                                                                                          
caused by [exception 1]                                                                                             
syntax: extra token "(" after end of expression                                                                     
Stacktrace:                                                                                                         
 [1] include at ./boot.jl:326 [inlined]                                                                             
 [2] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [3] include(::Module, ::String) at ./Base.jl:29                                                                    
 [4] include(::String) at ./client.jl:443                                                                           
 [5] top-level scope at REPL[17]:1                                                                                  
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
(meshfile, neigvs) = ("lug-18540.nas", 15)                                                                          
[ Info: FULL model, mesh lug-18540.nas                                                                              
nconv = 2                                                                                                           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 3.528000483783674e-10            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 2.501159806322088e-10            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 6.915948327308628e-11            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 3.426221816782427e-11            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 2.0412853369774513e-11           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 1.989897364809308e-11            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 2.918246339931125e-11            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 1.239084641110016e-11            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 5.035400680949805e-12            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 3.8559891792660385e-12           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 8.24177064098397e-12             
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 5.1181988296412796e-12           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 4.583335702443794e-12            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 1.895750828284013e-12            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 1.9422875407723245e-12           
Reference Eigenvalues: [481.339, 587.509, 1140.77, 1740.91, 1920.36, 2007.94, 2023.35, 2973.19, 4384.75, 4407.79, 47​‌​
40.0, 4969.85, 6003.27, 6427.74, 6556.79] [Hz]                                                                      
timing = runme(meshfile, neigvs) = Dict("Problem setup"=>4.78379,"EV problem"=>6.0744,"Total"=>10.8582)             
                                                                                                                    
shell> ls                                                                                                           
'Redalu_cyl-lug-55620-neigvs=150-LegendreBasis-a=1_5-b=3_5-Nc=32.json'                                              
'Redalu_cyl-lug-55620-neigvs=150-LegendreBasis-a=1_5-b=4_6-Nc=16.json'                                              
'Redalu_cyl-lug-55620-neigvs=150-LegendreBasis-a=1_5-b=6_8-Nc=4.json'                                               
'Redlug-lug-18540_nas-neigvs=15-LegendreBasis-a=1_5-n1=4-Nc=32-tol=0_02.json'                                       
'Redlug-lug-18540_nas-neigvs=150-LegendreBasis-a=1_5-b=2_5-Nc=16-tol=0_02.json'                                     
'Redlug-lug-18540_nas-neigvs=150-LegendreBasis-a=1_5-b=2_5-Nc=32-tol=0_02.json'                                     
'Redlug-lug-18540_nas-neigvs=150-LegendreBasis-a=1_5-b=3_6-Nc=128-tol=0_02.json'                                    
'Redlug-lug-18540_nas-neigvs=150-LegendreBasis-a=1_5-b=9_12-Nc=32-tol=0_02.json'                                    
'Redlug-lug-18540_nas-neigvs=150-LegendreBasis-a=1_5-n1=4-Nc=32-tol=0_02.json'                                      
'Redlug-lug-18540_nas-neigvs=300-LegendreBasis-a=1_5-n1=4-Nc=32-tol=0_02.json'                                      
'Redlug-lug-54776_nas-neigvs=15-LegendreBasis-a=1_5-n1=2-Nc=64-tol=0_02.json'                                       
'Redlug-lug-54776_nas-neigvs=15-LegendreBasis-a=1_5-n1=4-Nc=32-tol=0_02.json'                                       
'Redlug-lug-54776_nas-neigvs=15-LegendreBasis-a=1_5-n1=6-Nc=32-tol=0_02.json'                                       
'Redlug-lug-54776_nas-neigvs=300-LegendreBasis-a=1_5-b=1_4-Nc=128-tol=0_02.json'                                    
'Redlug-lug-54776_nas-neigvs=300-LegendreBasis-a=1_5-b=3_6-Nc=128-tol=0_02.json'                                    
'Redlug-lug-54776_nas-neigvs=300-LegendreBasis-a=1_5-b=3_6-Nc=64-tol=0_02.json'                                     
'Redlug-lug-54776_nas-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=16-tol=0_02.json'                                     
'Redlug-lug-54776_nas-neigvs=300-LegendreBasis-a=1_5-b=6_9-Nc=32-tol=0_02.json'                                     
'Redlug-lug-54776_nas-neigvs=300-LegendreBasis-a=1_5-b=9_12-Nc=16-tol=0_02.json'                                    
'Redlug-lug-54776_nas-neigvs=300-SineCosineBasis-a=1_5-b=3_6-Nc=64-tol=0_02.json'                                   
'Redlug-lug-54776_nas-neigvs=300-SineCosineBasis-a=1_5-b=6_9-Nc=32-tol=0_02.json'                                   
 lug-18540-cluster-1.vtk                                                                                            
 lug-18540-cluster-2.vtk                                                                                            
 lug-18540-cluster-3.vtk                                                                                            
 lug-18540-cluster-4.vtk                                                                                            
 lug-18540-cluster-5.vtk                                                                                            
 lug-18540-cluster-6.vtk                                                                                            
 lug-18540-cluster-7.vtk                                                                                            
 lug-18540-cluster-8.vtk                                                                                            
 lug-18540.vtk                                                                                                      
'lug-lug-18540_nas-neigvs=15.json'                                                                                  
'lug-lug-18540_nas-neigvs=150.json'                                                                                 
'lug-lug-18540_nas-neigvs=300.json'                                                                                 
'lug-lug-18540_nas-neigvs=50.json'                                                                                  
'lug-lug-54776_nas-neigvs=15.json'                                                                                  
'lug-lug-54776_nas-neigvs=150.json'                                                                                 
'lug-lug-54776_nas-neigvs=300.json'                                                                                 
'lug-lug-54776_nas-neigvs=50.json'                                                                                  
 lug.mph                                                                                                            
 lug_full.jl                                                                                                        
 lug_full_ssit.jl                                                                                                   
'lug_red - Copy.jl'                                                                                                 
 lug_red.jl                                                                                                         
 lug_red.jl.bak                                                                                                     
 lug_show_mesh.jl                                                                                                   
 lug_show_mode.jl                                                                                                   
 lug_show_partition.jl                                                                                              
 lug_utilities.jl                                                                                                   
 matrices                                                                                                           
 meshes                                                                                                             
                                                                                                                    
julia> include("lug_show_mode.jl");                                                                                 
[ Info: Sim lug-lug-18540_nas-neigvs=15.json                                                                        
(properties["frequencies"])[mode] = 481.33884935358566                                                              
properties["eigenvectors"] = Dict{String,Any}("file"=>"lug-lug-18540_nas-neigvs=15-evec.mdat","dims"=>Any[54807, 15]​‌​
,"type"=>"Float64")                                                                                                 
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_show_mode.jl:30                                                                                                    
caused by [exception 1]                                                                                             
MethodError: no method matching vtkexportmesh(::String, ::FENodeSet, ::Array{FESetT10,2}; vectors=Tuple{String,Array​‌​
{Float64,2}}[("mode1", [-0.0555132 -0.000343696 -0.680625; -0.0752901 -0.000552377 -0.678006; … ; -0.0160792 0.00129​‌​
263 -0.0435924; -0.0149299 0.00200009 -0.0360265])])                                                                
Closest candidates are:                                                                                             
  vtkexportmesh(::String, ::Any, ::Any, ::Any; vectors, scalars) at /home/pkrysl/.julia/packages/FinEtools/Sp8J4/src​‌​
/MeshExportModule.jl:74                                                                                             
  vtkexportmesh(::String, ::FENodeSet, ::T<:FESet; opts...) where T<:FESet at /home/pkrysl/.julia/packages/FinEtools​‌​
/Sp8J4/src/MeshExportModule.jl:55                                                                                   
Stacktrace:                                                                                                         
 [1] runme(::String, ::Int64) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_show_mode.jl:24 
 [2] top-level scope at show.jl:572                                                                                 
 [3] include at ./boot.jl:326 [inlined]                                                                             
 [4] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [5] include(::Module, ::String) at ./Base.jl:29                                                                    
 [6] include(::String) at ./client.jl:443                                                                           
 [7] top-level scope at REPL[19]:1                                                                                  
                                                                                                                    
julia> include("lug_show_mode.jl");                                                                                 
[ Info: Sim lug-lug-18540_nas-neigvs=15.json                                                                        
(properties["frequencies"])[mode] = 481.33884935358566                                                              
properties["eigenvectors"] = Dict{String,Any}("file"=>"lug-lug-18540_nas-neigvs=15-evec.mdat","dims"=>Any[54807, 15]​‌​
,"type"=>"Float64")                                                                                                 
runme("lug-lug-18540_nas-neigvs=15.json", 1) = Task (queued) @0x00007f038a398280                                    
                                                                                                                    
julia> include("lug_show_mode.jl");                                                                                 
[ Info: Sim lug-lug-18540_nas-neigvs=15.json                                                                        
(properties["frequencies"])[mode] = 481.33884935358566                                                              
properties["eigenvectors"] = Dict{String,Any}("file"=>"lug-lug-18540_nas-neigvs=15-evec.mdat","dims"=>Any[54807, 15]​‌​
,"type"=>"Float64")                                                                                                 
runme("lug-lug-18540_nas-neigvs=15.json", 1) = Task (queued) @0x00007f038a398010                                    
                                                                                                                    
julia> include("lug_full.jl");                                                                                      
(meshfile, neigvs) = ("lug-18540.nas", 15)                                                                          
[ Info: FULL model, mesh lug-18540.nas                                                                              
nconv = 2                                                                                                           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 2.8412808024220273e-10           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 2.3370467295084017e-10           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 6.087879465310232e-11            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 2.316784085346617e-11            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 1.7082112805975813e-11           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 3.6305527802116915e-11           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 2.5448960082290713e-11           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 1.7509071267449273e-11           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 7.803246987337418e-12            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 3.0484199005308783e-12           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 4.1903639042563634e-12           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 1.1352976923103306e-11           
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 3.097326970889477e-12            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 9.213948833577031e-12            
norm(K * evec[:, i] - eval[i] * M * evec[:, i]) / norm(eval[i] * M * evec[:, i]) = 8.990913719062095e-12            
Reference Eigenvalues: [536.279, 602.214, 1348.28, 1844.42, 2025.57, 2031.89, 2180.08, 3036.49, 4455.02, 4776.97, 48​‌​
45.23, 5581.36, 6089.43, 6655.97, 6664.59] [Hz]                                                                     
timing = runme(meshfile, neigvs) = Dict("Problem setup"=>2.89645,"EV problem"=>3.83766,"Total"=>6.7341)             
                                                                                                                    
julia> include("lug_show_mode.jl");                                                                                 
[ Info: Sim lug-lug-18540_nas-neigvs=15.json                                                                        
(properties["frequencies"])[mode] = 536.279079814839                                                                
properties["eigenvectors"] = Dict{String,Any}("file"=>"lug-lug-18540_nas-neigvs=15-evec.mdat","dims"=>Any[54807, 15]​‌​
,"type"=>"Float64")                                                                                                 
runme("lug-lug-18540_nas-neigvs=15.json", 1) = Task (queued) @0x00007f038a3984f0                                    
                                                                                                                    
julia> include("lug_show_partition.jl");                                                                            
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_show_partition.jl:4                                                                                                
caused by [exception 1]                                                                                             
UndefVarError: revcm not defined                                                                                    
Stacktrace:                                                                                                         
 [1] include at ./boot.jl:326 [inlined]                                                                             
 [2] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [3] include(::Module, ::String) at ./Base.jl:29                                                                    
 [4] include(::String) at ./client.jl:443                                                                           
 [5] top-level scope at REPL[22]:1                                                                                  
                                                                                                                    
julia> include("lug_show_partition.jl");                                                                            
[ Info: Mesh lug-18540                                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_show_partition.jl:84                                                                                               
caused by [exception 1]                                                                                             
MethodError: no method matching (::Colon)(::Int64, ::Array{Int64,1})                                                
Closest candidates are:                                                                                             
  Colon(::T<:Real, ::Any, ::T<:Real) where T<:Real at range.jl:41                                                   
  Colon(::A<:Real, ::Any, ::C<:Real) where {A<:Real, C<:Real} at range.jl:10                                        
  Colon(::T, ::Any, ::T) where T at range.jl:40                                                                     
  ...                                                                                                               
Stacktrace:                                                                                                         
 [1] runme(::String) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_show_partition.jl:71     
 [2] top-level scope at show.jl:572                                                                                 
 [3] include at ./boot.jl:326 [inlined]                                                                             
 [4] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [5] include(::Module, ::String) at ./Base.jl:29                                                                    
 [6] include(::String) at ./client.jl:443                                                                           
 [7] top-level scope at REPL[22]:1                                                                                  
                                                                                                                    
julia> include("lug_show_partition.jl");                                                                            
[ Info: Mesh lug-18540                                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_show_partition.jl:85                                                                                               
caused by [exception 1]                                                                                             
MethodError: no method matching (::Colon)(::Int64, ::Array{Int64,1})                                                
Closest candidates are:                                                                                             
  Colon(::T<:Real, ::Any, ::T<:Real) where T<:Real at range.jl:41                                                   
  Colon(::A<:Real, ::Any, ::C<:Real) where {A<:Real, C<:Real} at range.jl:10                                        
  Colon(::T, ::Any, ::T) where T at range.jl:40                                                                     
  ...                                                                                                               
Stacktrace:                                                                                                         
 [1] runme(::String) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_show_partition.jl:72     
 [2] top-level scope at show.jl:572                                                                                 
 [3] include at ./boot.jl:326 [inlined]                                                                             
 [4] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [5] include(::Module, ::String) at ./Base.jl:29                                                                    
 [6] include(::String) at ./client.jl:443                                                                           
 [7] top-level scope at REPL[22]:1                                                                                  
                                                                                                                    
julia> include("lug_show_partition.jl");                                                                            
[ Info: Mesh lug-18540                                                                                              
length(pnodes) = 1219                                                                                               
length(pnodes) = 1208                                                                                               
length(pnodes) = 1766                                                                                               
length(pnodes) = 1746                                                                                               
length(pnodes) = 1219                                                                                               
length(pnodes) = 1208                                                                                               
length(pnodes) = 1766                                                                                               
length(pnodes) = 1746                                                                                               
length(pnodes) = 1219                                                                                               
length(pnodes) = 1208                                                                                               
runme("lug-18540") = Task (queued) @0x00007f038a398760                                                              
                                                                                                                    
julia> include("lug_show_partition.jl");                                                                            
[ Info: Mesh lug-18540                                                                                              
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_show_partition.jl:85                                                                                               
caused by [exception 1]                                                                                             
MethodError: no method matching (::Colon)(::Int64, ::Array{Int64,1})                                                
Closest candidates are:                                                                                             
  Colon(::T<:Real, ::Any, ::T<:Real) where T<:Real at range.jl:41                                                   
  Colon(::A<:Real, ::Any, ::C<:Real) where {A<:Real, C<:Real} at range.jl:10                                        
  Colon(::T, ::Any, ::T) where T at range.jl:40                                                                     
  ...                                                                                                               
Stacktrace:                                                                                                         
 [1] runme(::String) at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug_show_partition.jl:72     
 [2] top-level scope at show.jl:572                                                                                 
 [3] include at ./boot.jl:326 [inlined]                                                                             
 [4] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [5] include(::Module, ::String) at ./Base.jl:29                                                                    
 [6] include(::String) at ./client.jl:443                                                                           
 [7] top-level scope at REPL[22]:1                                                                                  
                                                                                                                    
julia> include("lug_show_partition.jl");                                                                            
[ Info: Mesh lug-18540                                                                                              
length(pnodes) = 1219                                                                                               
length(pnodes) = 1208                                                                                               
length(pnodes) = 1766                                                                                               
length(pnodes) = 1746                                                                                               
length(pnodes) = 1223                                                                                               
length(pnodes) = 1247                                                                                               
length(pnodes) = 1790                                                                                               
length(pnodes) = 1773                                                                                               
length(pnodes) = 3220                                                                                               
length(pnodes) = 3348                                                                                               
runme("lug-18540") = Task (queued) @0x00007f038a398eb0                                                              
                                                                                                                    
julia> include("lug_red.jl");                                                                                       
[ Info: REDUCED model, mesh lug-54776.nas, neigvs = 15, basis LegendreBasis                                         
Step 1 size(Phi1) = (162645, 120)                                                                                   
nconv = 0                                                                                                           
nconv = 6                                                                                                           
nconv = 13                                                                                                          
nconv = 15                                                                                                          
(timchf, timchs, timqrs, timmkm, timeig) = (Any[17.1708], Any[6.05175, 6.06762, 6.17119, 5.20201], Any[0.293148, 0.2​‌​
83631, 0.277991, 0.264612], Any[0.695428, 0.715703, 0.668822, 0.606047], Any[0.364752, 0.11624, 0.097846, 0.101599])​‌​
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 6.927735114885688e-10                     
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 5.47730830087482e-10                      
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 1.0984303509462298e-10                    
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 9.440550983276833e-11                     
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 5.2548352954494915e-11                    
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 7.583575837967887e-11                     
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 1.1372271422689272e-10                    
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 1.2660160097900964e-10                    
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 2.2965167802156067e-10                    
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 1.619670616459691e-10                     
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 7.18416219500406e-10                      
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 2.0836785561691614e-10                    
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 2.3981566795333216e-8                     
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 1.3867567076807847e-8                     
norm(K * v[:, i] - lamb[i] * M * v[:, i]) / norm(lamb[i] * M * v[:, i]) = 3.8766831430946227e-7                     
Approximate frequencies: [533.778, 598.996, 1347.32, 1842.14, 2021.07, 2026.87, 2178.42, 3025.96, 4445.56, 4775.62, 
4848.29, 5578.28, 6080.65, 6648.2, 6657.31] [Hz]                                                                    
Full frequencies: Any[533.778, 598.996, 1347.32, 1842.14, 2021.07, 2026.87, 2178.42, 3025.96, 4445.56, 4775.62, 4848​‌​
.29, 5578.28, 6080.65, 6648.2, 6657.31] [Hz]                                                                        
ERROR: Error while loading expression starting at /mnt/c/Users/PetrKrysl/Documents/Work-in-progress/RapidEig/lug/lug​‌​
_red.jl:114                                                                                                         
caused by [exception 1]                                                                                             
UndefVarError: Nc not defined                                                                                       
Stacktrace:                                                                                                         
 [1] runme(::String, ::Int64, ::Int64, ::Type, ::Float64, ::Float64) at /mnt/c/Users/PetrKrysl/Documents/Work-in-pro​‌​
gress/RapidEig/lug/lug_red.jl:91                                                                                    
 [2] top-level scope at show.jl:572                                                                                 
 [3] include at ./boot.jl:326 [inlined]                                                                             
 [4] include_relative(::Module, ::String) at ./loading.jl:1041                                                      
 [5] include(::Module, ::String) at ./Base.jl:29                                                                    
 [6] include(::String) at ./client.jl:443                                                                           
 [7] top-level scope at REPL[23]:1                                                                                  
                                                                                                                    
julia> 