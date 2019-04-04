"""
init_ap_data!() for Alpine 
""" 
function init_ap_data!(model::MOI.AbstractOptimizer)
    model.inner = AlpineProblem()
    model.inner.num_variables = length(model.variable_info)
    model.inner.num_linear_constraints = length(model.linear_constraints)
    model.inner.num_quadratic_constraints = length(model.quadratic_constraints)
    model.inner.num_soc_constraints = length(model.soc_constraints)
    model.inner.num_rsoc_constraints = length(model.rsoc_constraints) 

    model.inner.constraint_bound_info = Vector{Interval{Float64}}()
    model.inner.objective_bound_info = -Inf..Inf

    for (func, set) in model.linear_constraints 
        if isa(set, MOI.LessThan{Float64}) 
            push!(model.inner.constraint_bound_info, -Inf..set.upper)
        elseif isa(set, MOI.GreaterThan{Float64})
            push!(model.inner.constraint_bound_info, set.lower..Inf)
        else 
            push!(model.inner.constraint_bound_info, set.value..set.value)
        end 
    end 

    for (func, set) in model.quadratic_constraints 
        if isa(set, MOI.LessThan{Float64}) 
            push!(model.inner.constraint_bound_info, -Inf..set.upper)
        elseif isa(set, MOI.GreaterThan{Float64})
            push!(model.inner.constraint_bound_info, set.lower..Inf)
        else 
            push!(model.inner.constraint_bound_info, set.value..set.value)
        end 
    end 

    # handle SOCs and RSOCs later with additional book-keeping in AlpineProblem struct
    for constraint in model.soc_constraints 
        push!(model.inner.constraint_bound_info, -Inf..Inf)
    end 

    for constraint in model.rsoc_constraints 
        push!(model.inner.constraint_bound_info, -Inf..Inf)
    end

    model.inner.quadratic_constraint_convexity = Symbol[]
    model.inner.quadratic_function_convexity = Symbol[]

    model.inner.is_objective_linear = false 
    model.inner.is_objective_nl = false 
    model.inner.is_objective_quadratic = false

    if model.inner.num_quadratic_constraints > 0 
        model.inner.quadratic_constraint_convexity = 
            [:undet for i in 1:model.inner.num_quadratic_constraints]
        model.inner.quadratic_function_convexity = 
            [:undet for i in 1:model.inner.num_quadratic_constraints]
    end 

    model.inner.variable_bound_original = Vector{Interval{Float64}}()
    model.inner.variable_bound_tightened = Vector{Interval{Float64}}()

    for vi in model.variable_info
        lb = -Inf 
        ub = Inf
        (vi.has_lower_bound) && (lb = vi.lower_bound)
        (vi.has_upper_bound) && (ub = vi.upper_bound)

        push!(model.inner.variable_bound_original, lb..ub)
        push!(model.inner.variable_bound_tightened, lb..ub)
    end 

    if ~isa(model.nlp_data.evaluator, EmptyNLPEvaluator)
        evaluator = model.nlp_data.evaluator
        MOI.initialize(evaluator, [:ExprGraph])
        num_nlp_constraints = length(model.nlp_data.constraint_bounds)
        model.inner.num_nlp_constraints = num_nlp_constraints
        if num_nlp_constraints > 0 
            model.inner.nl_constraint_expression = Vector{Expr}()
        end

        for i in 1:num_nlp_constraints 
            lb = model.nlp_data.constraint_bounds[i].lower
            ub = model.nlp_data.constraint_bounds[i].upper
            push!(model.inner.constraint_bound_info, lb..ub)
        end 
        
        if model.nlp_data.has_objective 
            model.inner.is_objective_nl = true 
            model.inner.objective_expression = MOI.objective_expr(evaluator)
            model.inner.is_objective_linear = false 
            model.inner.is_objective_quadratic = false 
            model.inner.objective_convexity = :undet
        elseif isa(model.objective, SQF)
            model.inner.is_objective_nl = false
            model.inner.is_objective_linear = false 
            model.inner.is_objective_quadratic = true
            model.inner.objective_convexity = :undet
        elseif isa(model.objective, Union{SAF, SVF})
            model.inner.is_objective_nl = false
            model.inner.is_objective_linear = true
            model.inner.is_objective_quadratic = false
            model.inner.objective_convexity = :convex
        end

        for i in 1:num_nlp_constraints
            constraint_expr = MOI.constraint_expr(evaluator, i)
            push!(model.inner.nl_constraint_expression, constraint_expr)
        end

    else 
        info(LOGGER, "no explicit NLP constraints or objective provided using @NLconstraint or @NLobjective macros")
        model.inner.num_nlp_constraints = 0
        model.inner.is_objective_nl = false
        if isa(model.objective, SQF) 
            model.inner.is_objective_quadratic = true 
            model.inner.is_objective_linear = false 
        elseif isa(model.objective, Union{SAF, SVF}) 
            model.inner.is_objective_linear = true 
            model.inner.is_objective_quadratic = false 
            model.objective_convexity = true
        end
    end 

    model.inner.num_constraints = 
        model.inner.num_linear_constraints + 
        model.inner.num_quadratic_constraints +
        model.inner.num_soc_constraints +
        model.inner.num_rsoc_constraints + 
        model.inner.num_nlp_constraints
    
    if model.solver_options.log_level != 0
        print_var_con_summary(model.inner)
    end 

    create_quadratic_nl_functions!(model)

    clean_nl_expressions!(model)
    nl_function = NLFunction[]
    
    if ~isa(model.nlp_data.evaluator, EmptyNLPEvaluator)
        for i in 1:model.inner.num_nlp_constraints 
            expr = model.inner.nl_constraint_expression[i]
            disaggregated_expr = expr_disaggregate(expr)
            push!(nl_function, create_nl_function(disaggregated_expr))
        end
        model.inner.nl_function = nl_function

        if model.inner.is_objective_nl 
            disaggregated_expr = expr_disaggregate(model.inner.objective_expression)
            model.inner.objective_nl_function = create_nl_function(disaggregated_expr)
        end 
    end

    create_dag!(model)

    return
end