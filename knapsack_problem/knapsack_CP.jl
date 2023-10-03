using JuMP, ConstraintSolver, UnPack
const CS = ConstraintSolver

include("import_data.jl")


"""
    solveCP(file)

Solves a knapsack problem using CP based on the data provided in "file"
"""
function solveCP(file="instances/knapPI_11_20_1000_1.csv")
    
    # Import the data
    sets, params = import_data(file)

    # Unpack the tuples
    @unpack ITEMS = sets
    @unpack profit,weight,max_weight = params

    # Create the model
    m = Model(CS.Optimizer) 

    # Add variables
    @variable(m, x[ITEMS], Bin)

    # Add the knapsack constraint
    @constraint(m, sum(weight[i]*x[i] for i in ITEMS) <=  max_weight)

    # Add the objective function
    @objective(m, Max, sum(profit[i]*x[i] for i in ITEMS))

    # Solve
    optimize!(m)
    status = JuMP.termination_status(m)
end

solveCP()