using JuMP,Cbc
include("../import_data.jl")
include("model_MIP.jl")



"""
    solve_problem(file="../instances/knapPI_11_20_1000_1.csv")

Solves the problem, default file is "../instances/knapPI_11_20_1000_1.csv"
if no argument is specified
"""
function solve_problem(file="../instances/knapPI_11_20_1000_1.csv")

    sets, params = import_data(file)
    m, vars = build_model(sets,params)

    # Choose optimier and solve
    #set_optimizer(m, Gurobi.Optimizer)
    set_optimizer(m, Cbc.Optimizer)
	solvetime = (@timed optimize!(m))[2]

    @show solvetime

    println("The optimal objective value for this problem is z = $(objective_value(m))")
    #println(value.(vars.x))
end


