"""
    init_tight_bound(m::PODNonlinearModel)

Initial tight bound vectors for later operations
"""
function init_tight_bound(m::PODNonlinearModel)

    m.l_var_tight = [m.l_var_orig,fill(-Inf, m.num_var_linear_mip+m.num_var_nonlinear_mip);]
    m.u_var_tight = [m.u_var_orig,fill(Inf, m.num_var_linear_mip+m.num_var_nonlinear_mip);]
    for i in 1:m.num_var_orig
        if m.var_type_orig[i] == :Bin
            m.l_var_tight[i] = 0.0
            m.u_var_tight[i] = 1.0
        end
    end

    return
end


"""
    detect_bound_from_aff(m::PODNonlinearModel)

Detect bounds from parse affine constraint. This function examines the one variable constraints such as
x >= 5, x <= 5 or x == 5 and fetch the information to m.l_var_tight and m.u_var_tight.
This function can potential grow to be smarter.
"""
function bounds_propagation(m::PODNonlinearModel)

    exhausted = false
    while !exhausted
        exhausted = true
        for aff in m.bounding_constr_mip
            for i in 1:length(aff[:vars])
                var_idx = aff[:vars][i].args[2]
                var_coef = aff[:coefs][i]
                @assert (isa(var_idx, Float64) || isa(var_idx, Int))
                if aff[:sense] == :(==) && var_coef > 0.0
                    eval_l_bound = aff[:rhs] / var_coef
                    eval_u_bound = aff[:rhs] / var_coef
                    for j in 1:length(aff[:vars])
                        if j != i && aff[:coefs][j]*var_coef > 0.0     # same sign
                            (eval_l_bound != -Inf) && (eval_l_bound -= abs(aff[:coefs][j]/var_coef)*m.u_var_tight[aff[:vars][j].args[2]])
                            (eval_u_bound != Inf) && (eval_u_bound -= abs(aff[:coefs][j]/var_coef)*m.l_var_tight[aff[:vars][j].args[2]])
                        elseif j!= i && aff[:coefs][j]*var_coef < 0.0  # different sign
                            (eval_l_bound != -Inf) && (eval_l_bound += abs(aff[:coefs][j]/var_coef)*m.l_var_tight[aff[:vars][j].args[2]])
                            (eval_u_bound != Inf) && (eval_u_bound += abs(aff[:coefs][j]/var_coef)*m.u_var_tight[aff[:vars][j].args[2]])
                        end
                    end
                    if eval_l_bound > m.l_var_tight[var_idx] + m.tol
                        exhausted = false
                        m.l_var_tight[var_idx] = eval_l_bound
                        (m.loglevel > 99) && println("[VAR$(var_idx)] Lower bound $(m.l_var_tight[var_idx]) evaluated from constraints")
                    end
                    if eval_u_bound < m.u_var_tight[var_idx] - m.tol
                        exhausted = false
                        m.u_var_tight[var_idx] = eval_u_bound
                        (m.loglevel > 99) && println("[VAR$(var_idx)] Upper bound $(m.u_var_tight[var_idx]) evaluated from constraints")
                    end
                elseif aff[:sense] == :(>=) && var_coef > 0.0  # a($) - by + cz >= 100, y∈[1,10], z∈[2,50], a,b,c > 0
                    eval_bound = aff[:rhs] / var_coef
                    for j in 1:length(aff[:vars])
                        if j != i && aff[:coefs][j] > 0.0
                            eval_bound -= abs(aff[:coefs][j]/var_coef) * m.u_var_tight[aff[:vars][j].args[2]]
                        elseif j !=i aff[:coefs][j] < 0.0
                            eval_bound += abs(aff[:coefs][j]/var_coef) * m.l_var_tight[aff[:vars][j].args[2]]
                        end
                        (eval_bound == -Inf) && break
                    end
                    if eval_bound > m.l_var_tight[var_idx] + m.tol
                        exhausted = false
                        m.l_var_tight[var_idx] = eval_bound
                        (m.loglevel > 99) && println("[VAR$(var_idx)] Lower bound $(m.l_var_tight[var_idx]) evaluated from constraints")
                    end
                elseif var_coef < 0.0 && aff[:sense] == :(>=) # -a($) - by + cz >= 100, y∈[1,10], z∈[2,50], a,b,c > 0
                    eval_bound = aff[:rhs] / var_coef
                    for j in 1:length(aff[:vars])
                        if j != i && aff[:coefs][j] > 0.0
                            eval_bound += abs(aff[:coefs][j]/var_coef) * m.u_var_tight[aff[:vars][j].args[2]]
                        elseif j != i && aff[:coefs][j] < 0.0
                            eval_bound -= abs(aff[:coefs][j]/var_coef) * m.l_var_tight[aff[:vars][j].args[2]]
                        end
                        (eval_bound == Inf) && break
                    end
                    if eval_bound < m.u_var_tight[var_idx] - m.tol
                        exhausted = false
                        m.u_var_tight[var_idx] = eval_bound
                        (m.loglevel > 99) && println("[VAR$(var_idx)] Upper bound $(m.u_var_tight[var_idx]) evaluated from constraints")
                    end
                elseif (aff[:sense] == :(<=) && aff[:coefs][i] > 0.0) # a($) - by + cz <= 100, y∈[1,10], z∈[2,50], a,b,c > 0
                    eval_bound = aff[:rhs] / var_coef
                    for j in 1:length(aff[:vars])
                        if j != i && aff[:coefs][j] > 0.0
                            eval_bound -= abs(aff[:coefs][j]/var_coef) * m.l_var_tight[aff[:vars][j].args[2]]
                        elseif j != i && aff[:coefs][j] < 0.0
                            eval_bound += abs(aff[:coefs][j]/var_coef) * m.u_var_tight[aff[:vars][j].args[2]]
                        end
                        (eval_bound == Inf) && break
                    end
                    if eval_bound < m.u_var_tight[var_idx] - m.tol
                        exhausted = false
                        m.u_var_tight[var_idx] = eval_bound
                        (m.loglevel > 99) && println("[VAR$(var_idx)] Upper bound $(m.u_var_tight[var_idx]) evaluated from constraints")
                    end
                elseif (aff[:sense] == :(<=) && aff[:coefs][i] < 0.0) # -a($) - by + cz <= 100, y∈[1,10], z∈[2,50], a,b,c > 0
                    eval_bound = aff[:rhs] / var_coef
                    for j in 1:length(aff[:vars])
                        if j != i && aff[:coefs][j] > 0.0
                            eval_bound += abs(aff[:coefs][j]/var_coef) * m.l_var_tight[aff[:vars][j].args[2]]
                        elseif j != i && aff[:coefs][j] < 0.0
                            eval_bound -= abs(aff[:coefs][j]/var_coef) * m.u_var_tight[aff[:vars][j].args[2]]
                        end
                        (eval_bound == -Inf) && break
                    end
                    if eval_bound > m.l_var_tight[var_idx] + m.tol
                        exhausted = false
                        m.l_var_tight[var_idx] = eval_bound
                        (m.loglevel > 99) && println("[VAR$(var_idx)] Lower bound $(m.l_var_tight[var_idx]) evaluated from constraints")
                    end
                end
            end
        end
        (exhausted == true && m.loglevel > 99) && println("Initial constraint-based bound evaluation exhausted...")
    end

    return
end

"""
    resolve_var_bounds(m::PODNonlinearModel)

Resolve the bounds of the lifted variable using the information in l_var_tight and u_var_tight. This method only takes
in known or trivial bounds information to reason lifted variable bound to avoid the cases of infinity bounds.
"""
function resolve_var_bounds(m::PODNonlinearModel)

    # Basic Bound propagation
    m.presolve_bp && bounds_propagation(m) # Fetch bounds from constraints

    # Added sequential bound resolving process base on DFS process, which ensures all bounds are secured.
    # Increased complexity from linear to square but a reasonable amount
    # Potentially, additional mapping can be applied to reduce the complexity
    for i in 1:length(m.term_seq)
        k = m.term_seq[i]
        if haskey(m.nonlinear_terms, k)
            m.nonlinear_terms[k][:bound_resolver](m, k)
        elseif haskey(m.linear_terms, k)
            basic_linear_bounds(m, k)
        else
            error("[RARE] Found homeless term key $(k) during bound resolution.")
        end
    end

    # Resolve still infinite bound
    resolve_inf_bounds(m)

    return
end

function resolve_inf_bounds(m::PODNonlinearModel)

    return
end

"""
    resolve_var_bounds(nonlinear_terms::Dict, discretization::Dict)

For discretization to be performed, we do not allow for a variable being discretized to have infinite bounds.
The lifted variables will have infinite bounds and the function infers bounds on these variables. This process
can help speed up the subsequent solve in subsequent iterations.
"""
function resolve_var_bounds(nonlinear_terms::Dict, linear_terms::Dict, term_seq::Dict, discretization::Dict; kwargs...)

    # TODO this sequence need to be changed

    # Added sequential bound resolving process base on DFS process, which ensures all bounds are secured.
    # Increased complexity from linear to square but a reasonable amount
    # Potentially, additional mapping can be applied to reduce the complexity
    for i in 1:length(term_seq)
        k = term_seq[i]
        if haskey(nonlinear_terms, k)
            nlk = k
            if nonlinear_terms[nlk][:nonlinear_type] in POD_C_MONOMIAL
                lifted_idx = nonlinear_terms[nlk][:lifted_var_ref].args[2]
                cnt = 0
                bound = []
                for var in nlk
                    cnt += 1
                    var_idx = var.args[2]
                    var_bounds = [discretization[var_idx][1], discretization[var_idx][end]]
                    if cnt == 1
                        bound = copy(var_bounds)
                    elseif cnt == 2
                        bound = bound * var_bounds'
                    else
                        bound = diag(bound) * var_bounds'
                    end
                end
                if minimum(bound) > discretization[lifted_idx][1]
                    discretization[lifted_idx][1] = minimum(bound)
                end
                if maximum(bound) < discretization[lifted_idx][end]
                    discretization[lifted_idx][end] = maximum(bound)
                end
            elseif nonlinear_terms[nlk][:nonlinear_type] in [:BINPROD]
                basic_binprod_bounds(m, k)
            elseif nonlinear_terms[nlk][:nonlinear_type] in POD_C_TRIGONOMETRIC
                basic_sincos_bounds(m, k)
            elseif nonlinear_terms[nlk][:nonlinear_type] in [:BINLIN]
                basic_binlin_bounds(m, k)
            end
        elseif haskey(slinear_terms, k)
            basic_linear_bounds(m, k, linear_terms)
        else
            error("[RARE] Found homeless term key $(k) during bound resolution.")
        end
    end

    return discretization
end

"""
    resolve_closed_var_bounds(m::PODNonlinearModel)

This function seeks variable with tight bounds (by presolve_bt_width_tol) by checking .l_var_tight and .u_var_tight.
If a variable is found to be within a sufficiently small interval then no discretization will be performed on this variable
and the .discretization will be cleared with the tight bounds for basic McCormick operation if necessary.

"""
function resolve_closed_var_bounds(m::PODNonlinearModel; kwargs...)

    for var in m.candidate_disc_vars
        if abs(m.l_var_tight[var] - m.u_var_tight[var]) < m.presolve_bt_width_tol         # Closed Bound Criteria
            deleteat!(m.disc_vars, findfirst(m.disc_vars, var)) # Clean nonlinear_terms by deleting the info
            m.discretization[var] = [m.l_var_tight[var], m.u_var_tight[var]]              # Clean up the discretization for basic McCormick if necessary
        end
    end

    return
end

"""
    update_var_bounds(m::PODNonlinearModel, discretization::Dict; len::Float64=length(keys(discretization)))

This function take in a dictionary-based discretization information and convert them into two bounds vectors (l_var, u_var) by picking the smallest and largest numbers. User can specify a certain length that may contains variables that is out of the scope of discretization.

Output::

    l_var::Vector{Float64}, u_var::Vector{Float64}
"""
function update_var_bounds(discretization; kwargs...)

    options = Dict(kwargs)

    haskey(options, :len) ? len = options[:len] : len = length(keys(discretization))

    l_var = fill(-Inf, len)
    u_var = fill(Inf, len)

    for var_idx in keys(discretization)
        l_var[var_idx] = discretization[var_idx][1]
        u_var[var_idx] = discretization[var_idx][end]
    end

    return l_var, u_var
end
