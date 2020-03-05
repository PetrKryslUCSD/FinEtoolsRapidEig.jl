module LAUtilities

import LinearAlgebra: eigen, qr, norm, mul!, dot, cholesky
using Statistics

"""
    ssit(K, M; nev::Int=6, evshift::FFlt = 0.0,
        v0::FFltMat = Array{FFlt}(0, 0),
        tol::FFlt = 1.0e-3, maxiter::Int = 300, verbose::Bool=false)
Subspace  Iteration (block inverse power) method.
Block inverse power method for k smallest eigenvalues of the generalized
eigenvalue problem
           `K*v= lambda*M*v`
# Arguments
* `K` =  square symmetric stiffness matrix (if necessary mass-shifted),
* `M` =  square symmetric mass matrix,
# Keyword arguments
* `v0` =  initial guess of the eigenvectors (for instance random),
* `nev` = the number of eigenvalues sought
* `tol` = relative tolerance on the eigenvalue, expressed in terms of norms of the
      change of the eigenvalue estimates from iteration to iteration.
* `maxiter` =  maximum number of allowed iterations
* `withrr` = with Rayleigh-Ritz problem solved to improve the subspace?  (default
    is false)
* `verbose` = verbose? (default is false)
#  Return
* `labm` = computed eigenvalues,
* `v` = computed eigenvectors,
* `nconv` = number of converged eigenvalues
* `niter` = number of iterations taken
* `nmult` = ignore this output
* `lamberr` = eigenvalue errors, defined as  normalized  differences  of
    successive  estimates of the eigenvalues
"""
function ssitc(K, M, v0; nev::Int=6, tol::Float64 = 1.0e-3, maxiter::Int = 300, verbose::Bool=false)
	@assert nev >= 1
	niv = size(v0, 2) # Number of iteration vectors
	@assert nev <= niv
	v = deepcopy(v0)
	u = deepcopy(v0)
	nvecs = size(v, 2)  # How many eigenvalues are iterated?
	plamb = zeros(niv)  # previous eigenvalue
	lamb = zeros(niv)
	timchf = []
	timchs = []
	timqrs = []
	timmkm = []
	timeig = []
 #    lamberr = zeros(nev)
 #    converged = falses(nev)  # not yet
    niter = 0
    nconv = 0
    push!(timchf, @elapsed begin
	    Kfactor = cholesky(K)
	end)
    Kv = zeros(size(K, 1), size(v, 2))
    Mv = zeros(size(M, 1), size(v, 2))
    mul!(Mv, M, v)
    for i = 1:maxiter
    	push!(timchs, @elapsed begin
	    	for c = 1:3
	    		u .= Kfactor\(Mv)
	    			    	mul!(Mv, M, u)
	    	end
	    end)
	    # push!(timchs, @elapsed begin
    	# 	u .= Kfactor\(Mv)
	    # end)
	    push!(timqrs, @elapsed begin
	    	QRfactor = qr(u)  # ; full=falseeconomy factorization
	    	v = Array(QRfactor.Q)
	    end)
	    push!(timmkm, @elapsed begin
	    	mul!(Kv, K, v)
	    	mul!(Mv, M, v)
	    end)
        # for j = 1:nev
        #     lamb[j] = dot(view(v, :, j), view(Kv, :, j)) / dot(view(v, :, j), view(Mv, :, j))
        #     lamberr[j] = abs(lamb[j] - plamb[j])/abs(lamb[j])
        #     converged[j] = lamberr[j] <= tol
        # end
        # @show lamb
        # nconv = length(findall(converged))
        # verbose && println("nconv = $(nconv)")
        # if nconv >= nev # converged on all requested eigenvalues
        #     break
        # end
        # Rayleigh-Ritz
        push!(timeig, @elapsed begin
	        EVdecomp = eigen(transpose(v)*Kv, transpose(v)*Mv)
	        ix = sortperm(abs.(EVdecomp.values))
	        lamb .= EVdecomp.values[ix]
	        rrv = EVdecomp.vectors[:, ix]
	        v .= v*rrv
	    end)
        nconv = 0
        for j = 1:nev
            lamberr = abs(lamb[j] - plamb[j])/abs(lamb[j])
            nconv = lamberr <= tol ? nconv + 1 : nconv
        end
        @show nconv
        if nconv >= nev # converged on all requested eigenvalues
            break
        end
        plamb, lamb = lamb, plamb # swap the eigenvalue arrays
        niter = niter + 1
    end
    # ix = sortperm(abs.(lamb))
    # lamb = lamb[ix]
    # v = v[:, ix]
    # lamberr = lamberr[ix]
    @show timchf, timchs, timqrs, timmkm, timeig
    return lamb[1:nev], v[:, 1:nev], niter
end

"""
    ssit(K, M; nev::Int=6, evshift::FFlt = 0.0,
        v0::FFltMat = Array{FFlt}(0, 0),
        tol::FFlt = 1.0e-3, maxiter::Int = 300, verbose::Bool=false)
Subspace  Iteration (block inverse power) method.
Block inverse power method for k smallest eigenvalues of the generalized
eigenvalue problem
           `K*v= lambda*M*v`
# Arguments
* `K` =  square symmetric stiffness matrix (if necessary mass-shifted),
* `M` =  square symmetric mass matrix,

# Keyword arguments

* `v0` =  initial guess of the eigenvectors (for instance random),
* `nev` = the number of eigenvalues sought
* `tol` = relative tolerance on the eigenvalue, expressed in terms of norms of the
      change of the eigenvalue estimates from iteration to iteration.
* `maxiter` =  maximum number of allowed iterations
* `withrr` = with Rayleigh-Ritz problem solved to improve the subspace?  (default
    is false)
* `verbose` = verbose? (default is false)

# Return

* `labm` = computed eigenvalues,
* `v` = computed eigenvectors,
* `nconv` = number of converged eigenvalues
* `niter` = number of iterations taken
* `nmult` = ignore this output
* `lamberr` = eigenvalue errors, defined as  normalized  differences  of
    successive  estimates of the eigenvalues
"""
function ssitb(K, M, v0; nev::Int=6, tol::Float64 = 1.0e-3, maxiter::Int = 300, verbose::Bool=false)
    @assert nev >= 1
    @assert !isempty(v0) "No initial vectors provided"
    niv = size(v0, 2) # Number of iteration vectors
    @assert nev <= niv
    lamb = zeros(nev)
    niter = 0
    Kfactor = cholesky(K)
    Xb = zeros(size(K, 1), niv)
    Yb = zeros(size(M, 1), niv)
    Y = zeros(size(M, 1), niv)
    mul!(Y, M, v0)
    for i = 1:maxiter
        Xb .= Kfactor \ Y
        Kr = transpose(Xb) * Y
        mul!(Yb, M, Xb)
        Mr = transpose(Xb) * Yb
        decomp = eigen(Kr, Mr)
        ix = sortperm(abs.(decomp.values))
        rrd = decomp.values[ix]
        rrv = decomp.vectors[:, ix]
        Y = Yb*rrv
        @show lamb = rrd[1:nev]
        # verbose && println("nconv = $(nconv)")
        niter = niter + 1
    end
    return lamb, Y
end
# (d,[v,],nconv,niter,nmult,resid)
# eigs returns the nev requested eigenvalues in d, the corresponding Ritz vectors
# v (only if ritzvec=true), the number of converged eigenvalues nconv, the number
# of iterations niter and the number of matrix vector multiplications nmult, as
# well as the final residual vector resid.


"""
    ssitit(K, M; nev::Int=6, evshift::FFlt = 0.0,
        v0::FFltMat = Array{FFlt}(0, 0),
        tol::FFlt = 1.0e-3, maxiter::Int = 300, verbose::Bool=false)

Subspace  Iteration (block inverse power) method.

Block inverse power method for k smallest eigenvalues of the generalized
eigenvalue problem
           `K*v= lambda*M*v`

# Arguments
* `K` =  square symmetric stiffness matrix (if necessary mass-shifted),
* `M` =  square symmetric mass matrix,

# Keyword arguments
* `v0` =  initial guess of the eigenvectors (for instance random),
* `nev` = the number of eigenvalues sought
* `tol` = relative tolerance on the eigenvalue, expressed in terms of norms of the
      change of the eigenvalue estimates from iteration to iteration.
* `maxiter` =  maximum number of allowed iterations
* `withrr` = with Rayleigh-Ritz problem solved to improve the subspace?  (default
    is false)
* `verbose` = verbose? (default is false)

#  Return
* `labm` = computed eigenvalues,
* `v` = computed eigenvectors,
* `nconv` = number of converged eigenvalues
* `niter` = number of iterations taken
* `nmult` = ignore this output
* `lamberr` = eigenvalue errors, defined as  normalized  differences  of
    successive  estimates of the eigenvalues
"""
function ssitit(K, M, v0; maxiter = 300, withrr=false,  maxcgiter = 3, tol=eps, verbose=false)
    v = deepcopy(v0)
    nvecs = size(v, 2)  # How many eigenvalues are iterated?
    plamb = zeros(nvecs)  # previous eigenvalue
    lamb = zeros(nvecs)
    lamberr = zeros(nvecs)
    converged = falses(nvecs)  # not yet
    niter = 0
    nconv = 0
    nmult = 0
    Kv = zeros(size(K, 1), size(v, 2))
    Mv = zeros(size(M, 1), size(v, 2))
    for i = 1:maxiter
    	u = conjgrad(K, M*v, v, maxcgiter)
        factorization = qr(u)  # ; full=false, economy factorization
        v = Array(factorization.Q)
        mul!(Kv, K, v)
        mul!(Mv, M, v)
        for j = 1:nvecs
            lamb[j] = dot(v[:, j], Kv[:, j]) / dot(v[:, j], Mv[:, j])
            lamberr[j] = abs(lamb[j] - plamb[j])/abs(lamb[j])
            converged[j] = lamberr[j] <= tol
        end
        nconv = length(findall(converged))
        verbose && println("nconv = $(nconv)")
        if nconv >= length(converged) # converged on all requested eigenvalues
            break
        end
        if withrr
            decomp = eigen(transpose(v)*Kv, transpose(v)*Mv)
            ix = sortperm(abs.(decomp.values))
            rrd = decomp.values[ix]
            rrv = decomp.vectors[:, ix]
            v = v*rrv
        end
        plamb, lamb = lamb, plamb # swap the eigenvalue arrays
        niter = niter + 1
    end
    return lamb, v, nconv, niter, nmult, lamberr
end

function _columnnorm!(n, M)
	for i = 1:length(n)
		n[i] = norm(view(M, :, i))
	end
	return n
end

function _columndot!(r, M, N)
	for i = 1:length(r)
		r[i] = dot(view(M, :, i), view(N, :, i))
	end
	return r
end

function _columnupdate!(x, alpha, d)
	for i = 1:length(alpha)
		x[:, i] .+= alpha[i] * d[:, i]
	end
	return x
end

"""
    bar(x[, y])

Perform a few iterations of conjugate gradient descent.
"""
function conjgrad(A, b, x0, maxiter)
    x = deepcopy(x0);
    ng = b - A * x
    d = deepcopy(ng)
    Ad = similar(d)
    pd = similar(d)
    rho = fill(zero(eltype(x)), size(x, 2))
    dd = similar(rho)
    dAd = similar(rho)
    for iter = 1:maxiter
        mul!(Ad, A, d);
        _columndot!(rho, d, Ad)
        _columndot!(dd, ng, d)
        alpha = dd ./ rho
        _columnupdate!(x, alpha, d) # update the solution
        ng = b - A * x # new negative gradient
        _columndot!(dAd, ng, Ad)
        beta = - dAd ./ rho
        # Update the search direction
        copyto!(pd, d)
        copyto!(d, ng)
        _columnupdate!(d, beta, pd)
    end
    return x
end


function ConjGradAxb(A,b,x0,maxiter)
    x = x0;
    g = x'*A-b';
    d = -g';
    for iter=1:maxiter
    	Ad = A*d;
        rho = (d'*Ad);
        alpha = (-g*d)/rho; # alpha =(-g*d)/(d'*A*d);
        x = x + alpha* d;
        g = x'*A-b';
        beta = (g*Ad)/rho; # beta =(g*A*d)/(d'*A*d);
        d = beta*d-g';
    end
    return x
end

function pwrm1(K, M, v0; maxiter = 3, tol=eps(), verbose=false)
    v = deepcopy(v0)
    plamb = 0.0 # previous eigenvalue
    lamb = 0.0
    lamberr = 0.0
    nconv = 0
    niter = 0
    Kv = zeros(size(K, 1))
    Mv = zeros(size(M, 1))
    mul!(Kv, K, v)
    for i = 1:maxiter
    	v = M \ Kv
    	v = v ./ norm(v)
        mul!(Kv, K, v)
        mul!(Mv, M, v)
        lamb = dot(v, Kv) / dot(v, Mv)
        lamberr = abs(lamb - plamb)/abs(lamb)
        verbose && println("lamberr = $(lamberr)")
        if lamberr <= tol # converged on all requested eigenvalues
        	nconv = 1
            break
        end
        plamb = lamb # swap the eigenvalues
        niter = niter + 1
    end
    return lamb, v, nconv, niter, lamberr
end

end
