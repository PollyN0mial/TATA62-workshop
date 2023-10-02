using JuMP, UnPack



"""
    build_variables(m, data, sets)

Build the model variables
"""
function build_variables(m, sets)
    @unpack ITEMS = sets

    # Useful if you have more than one variable type, otherwise you can use @variable directly
    @variables m begin

        x[ITEMS], Bin

    end #variables
    return (;x)
end


"""
    build_objective(m, sets, params, vars)

Build the model objective function
"""
function build_objective(m, sets, params, vars)
    @unpack ITEMS = sets
    @unpack profit = params
    @unpack x = vars

    @objective m Max begin
		sum(profit[i]*x[i] for i in ITEMS)
	end #objective
end



"""
    build_constraints(m,sets,params,vars)

Build the model constraints
"""
function build_constraints(m,sets,params,vars)
    @unpack ITEMS = sets
    @unpack weight,max_weight = params
    @unpack x = vars

    @constraints m begin

        knacksack_constraint,
            sum(weight[i]*x[i] for i in ITEMS) <= max_weight

    end #constraints

end



"""
    build_model(sets,params)

Call the functions abonve to build a MIP model based on the data data given by specific sets and parameters
"""
function build_model(sets,params)
    m = Model()
    vars = build_variables(m, sets)
    build_objective(m, sets, params, vars)
    build_constraints(m,sets,params,vars)

    return m,vars
end