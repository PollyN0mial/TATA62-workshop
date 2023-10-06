import Pkg

# Programming languages
Pkg.add("JuMP") # modeling language for mathematical optimization
#Pkg.add("MiniZinc") 
Pkg.add("PDDL")
Pkg.add("PlanningDomains") # Online repository of PDDL problems

# Solvers
#Pkg.add("Gurobi") # MIP solver (commercial)
Pkg.add("Cbc") # MIP solver (open source)
Pkg.add("ConstraintSolver") # CP solver
Pkg.add("SymbolicPlanners") # library of PDDL solvers

# Other useful packages
Pkg.add("CSV")
Pkg.add("UnPack")
Pkg.add("DataFrames")