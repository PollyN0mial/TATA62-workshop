using PDDL, PlanningDomains, SymbolicPlanners

# Load Blocksworld domain and problem
domain = load_domain(:blocksworld)
problem = load_problem(:blocksworld, "problem-4")
state = initstate(domain, problem)
goal = PDDL.get_goal(problem)

# Construct A* planner with h_add heuristic
planner = AStarPlanner(HAdd())

# Solve the problem using the planner
sol = planner(domain, state, goal)