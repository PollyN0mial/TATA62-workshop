# TATA62 workshop
Welcome to this workshop!

My name is [Caroline Granfeldt](mailto:caroline.granfeldt@saabgroup.com) and I work as a Research Scientist at Saab Aeronautics in Linköping. I have a PhD in Optimization from Chalmers University of Technology (2016-2023). The purpose of this workshop is to introduce you to some optimization tools and algorithms.

My intention for this workshop is to interact with you all, make sure that everyone understand the basics of these tools and hopefully we will together be able to sort out any question marks!

Since this is a project course performed in a later year of your education. I expect you to be able to accomplish some things with less guidance from me than in the basic courses. Hence I expect everyone to make sure that every participent will have installed the tools that we will use and made sure that they work BEFORE the teaching seminar! However, I am here to help so if you have any questions or run into troubles, do not hesitate to ask me for a meeting or help via my [email](mailto:caroline.granfeldt@saabgroup.com).

The material that we will use in the workshop is available in a [github repository](https://github.com/PollyN0mial/TATA62-workshop/tree/main).
Before the teaching seminar I expect you to:

- Install the software we will use (see below)
- Make sure that the software works

## Software and installation

In this workshop, we will use a variety of software and tools. The intention is that every participant shall have a complete installation of these tools available (and working) on their own computer before the workshop starts.

The software tools that we will use are:
* Julia v1.9.3
* Git v2.42.0
* Gurobi Optimizer version 10.0.3 (commercial solver available for academic use)
    * Alternatively, Cbc (open-source solver) can be used
* Editors and/or IDEs (optional)


### Julia
Julia can be downloaded from their [website](https://julialang.org/downloads/) . The current stable release of Julia is v1.9.3.

Similar to Python, Julia works with packages. To install a package, write the following in a Julia REPL:

```
>>> ]add "packagename"
```

Some useful Julia packages:
* `JuMP` - mathematical programming in Julia
* `CSV` - allows to work with CSV files for data management
* `DataFrames` - set of tools for working with tabular data in Julia

Run the file "init.jl" to install the necessary packages for this tutorial. It also includes some suggestions for other useful packages.


### Git
We will use Git to access the material of the session and manage our source code changes. Git is freely available for download at their [website](https://git-scm.com/downloads). The latest version of Git is 2.42.0. 


### Gurobi Optimizer (or Cbc)
Gurobi Optimizer is a commerical Mixed-Integer Programming (MIP) solver. However, it is possible to access the full version for academic use by creating an account connected to your LiU-mail at this [address](https://www.gurobi.com/downloads/licenses/). The actual software can then downloaded at their [download page](https://www.gurobi.com/downloads/gurobi-software/). The latest version of Gurobi Optimizer is 10.0.3.

Alternatively, you can install the open-source solver Cbc directly in Julia: 
```
>>> ]add Cbc
```


### Editors and IDEs (optional)
Support for editing Julia is available for many [widely used editors](https://github.com/JuliaEditorSupport): [Emacs](https://github.com/JuliaEditorSupport/julia-emacs), [Vim](https://github.com/JuliaEditorSupport/julia-vim), [Sublime Text](https://github.com/JuliaEditorSupport/Julia-sublime), and many others.

If you like using IDEs, I highly recommend using VS Code with the [julia-vscode](https://www.julia-vscode.org/) plugin. For notebook users, [Jupyter](https://jupyter.org/) notebook support is available through the [IJulia](https://github.com/JuliaLang/IJulia.jl) package.



## Methods

Most solvers presented in this workshop can be used in a model-and-run-type of solution approach.
This means:

* Mathematically describe your optimisation problem as a model (model)
* Let the solver solve your model (and run)

A reason behind this type of approach is that all NP-complete problems can be modelled as a MIP, CP (or Boolean satisfiability, SAT), thanks to the nature of NP-hardness. This means that for most practical problems, we can model them using our preferred framework and solve using our preferred solver (that we do not even have to develop!). However, worst-case performance is still exponential, meaning that we might not get an answer given a time limit. From this follows, that the choice of model, modelling framework, and solver can have a significant effect on the computational performance.

*Note*: The generic solvers for MIP, CP, SAT are really really good (think years of engineering/research by experts). If you want to compete (develop your own solver) you need to take serious advantage of your problem structure.


### Mixed integer programming modelling

In a general mixed integer program, there are two main types of variables:

* Continuous
* Binary (or Integer)

A general mixed integer program can be written as:

```math
\min \sum_{i = 1}^{n} c_{i}x_{i} + \sum_{j = 1}^{m} d_{j}y_{j},
```

```math
\text{st. } \sum_{i = 1}^{n} a_{ik}x_{i} + \sum_{j = 1}^{m} b_{jk}y_{j} \leq c_{k}, \quad k=1, \dots, K
```

```math
x_{i} \geq 0, \quad i=1, \dots, n,
```

```math
y_{j} \in \{0, 1\}, \quad j=1, \dots, m.
```

There exists a flora of solvers:

* Gurobi Optimizer
* IBM CPLEX Optimizer
* FICO express
* SCIP
* lpsolve (open source)
* glpsol (open source)

but the difference in computational performance between the open source solvers and commercial solvers is large. The development of the first commerical solver (CPLEX) was for example started in 1988.

When can MIP be suitable to use?

* For problems with an objective function: MIP is good at getting bounds
* If you naturally have *mixed* quantities or inequality (equality) constraints

*Note*: MIP solvers can sometimes struggle with numerical issues. The solver might report issues like this in its logging.


### Constraint programming-based modelling

Constraint programming is a solution framework for solving combinatorial problems with roots in computer science.

Formally, a constraint satisfaction problem on finite domains is defined by a set of variables $`X`$, the domain $`D`$ of variables $`X`$, and set of constraints $`C`$ on these variables. A constraint $`C_{i}(X_{i}, R_{i})`$ is defined by a ordered set of variables $`X_{i}`$ and a relation $`R_{i}\subseteq D_{i_{1}} \times \dots \times D_{i_{k}}`$.

This is a very flexible specification (easily incorporates MIP), but has its stronger points in a variety of *global constraints*. Some famous ones are, *AllDifferent*, *disjunctive* (*no-overlap*) and *Knapsack*.

If a global constraint is used, the solvers typically handles it in a very efficient manner.

There exists a large number of CP solvers and modelling frameworks. A few of them includes:

* Chuffed (solver)
* IBM ILOG CP Optimizer (solver)
* MiniZinc (modelling framework)


### Automated planning

Planning can be defined as using knowledge about the world, including possible actions and their results, to decide what to do (and when) in order to achieve an objective before you actually start doing it.

Some assumptions in classical planning:
1. We assume that the world is always in a given state, which we want to affect.
    * Finite number of states
    * We can always detect the current state
2. A world can only be affected by executing an action
3. Every action results in a discrete state transition
4. Actions are deterministic
5. The objective is always to end up in a goal state
   
A *plan* is a sequence of actions. An *action sequence* is a *solution* if is *executable* and results in a *goal state*. A *cost function* can be added to measure if the solution is good (example: minimize total plan cost).

We therefore need sets of
1. States (finite)
2. Actions (finite)

Useful framework for automatic planning includes
* PDDL (planning domain definition language), [see tutorial here](http://algo2.iti.kit.edu/plan/files/tutorial.pdf)
* STRIPS

See also [slides](https://www.ida.liu.se/~TDDD48/pdf/) from the course `TDDD48: Automated planning` given at LiU.


## Implementation

### Git
The most commonly used version control system for source code is called git. It is used anywhere from small one-person projects to large scale projects. The most stable branch is often called *master* and the common server (or similar) where your project is hosted is often called *origin*.

Some common git-commands are:

* `git init` - initialise a project in current directory
* `git add FILE` - stage changes in FILE
* `git commit -m "MESSAGE"` - Commit your staged changes
* `git fetch` - What has happened in origin?
* `git pull` - Update your current branch with changes from origin, try fast-forward, if not merge
* `git checkout -b BRANCH` - Create a new branch called BRANCH
* `git checkout BRANCH` - Checkout existing branch BRANCH
* `git push` - Send your local updates to origin
* `git diff` - View your changes in terminal
* `git gui` - A graphical client to interact with your current repository
* `git reflog` - Which git-commands have you used (useful if you made a mess :) )


In general, it is good practise to avoid working directly on master (unless you work yourself or it is agreed upon beforehand). A typical workflow when doing an update on branch *master* and you have a *merge workflow*:

```shell
>>> git checkout master
>>> git fetch  # Look for changes
>>> git pull  # Take changes from master
>>> git checkout -b feature/my-change
>>> # CODE CODE CODE
>>> git add FILE1 FILE2 FILE3  # Add the files that you have updated
>>> git commit -m "Describe your update"
>>> # Here it might differ depending on your development process
>>> # Either Create merge request
>>> git push origin feature/my-change
>>> # Or manually merge your changes into master
>>> git checkout master
>>> git merge --no-ff feature/my-change  # Merges your branch feature/my-change into master
>>> git push  # Might yield merge conflict if someone else made an update
```

If you want to work directly on master, it is a bit simpler:

```shell
>>> git checkout master
>>> git fetch  # Look for changes
>>> git pull  # Take changes from master
>>> # CODE CODE CODE
>>> git add FILE1 FILE2 FILE3  # Add the files that you have updated
>>> git commit -m "Describe your update"
>>> git push  # Might yield conflict if someone else made an update
```


### Algorithm development

When developing an algorithm there are a few things that are suggested to keep in mind:

* Reproducibility ([set seeds](https://docs.julialang.org/en/v1/stdlib/Random/index.html#Generators-(creation-and-seeding)-1), log the git version)
* Logging (how long time did it take, optimal solution value, which parameters where used, etc.)
* Good software practices: follow a code style, separation of concerns, avoid duplicate code, etc.


## Julia specific information


### MIP

[JuMP](https://jump.dev/JuMP.jl/stable/) is a domain-specific modeling language for mathematical optimization embedded in Julia. It is very user-friendly and probably the main attraction of doing mathematical optimization in Julia.

### CP

The CP library in Julia is a bit limited, but as a starting point you can look at the following:
* [Minizinc](https://www.minizinc.org/challenge2022/results2022.html) is a modelling framework for CP, and possible to import/export in Julia. See also the documentation on [JuliaHub](https://juliahub.com/ui/Packages/General/MiniZinc/).
* [ConstraintSolver.jl](https://docs.juliahub.com/ConstraintSolver/Wsz6B/0.6.7/) is a pure Julia CP-solver
* [Chuffed.jl](https://github.com/JuliaConstraints/Chuffed.jl) is a Julia wrapper for the Chuffed solver

### AP

* [PDDL in Julia](https://github.com/JuliaPlanners/PDDL.jl)


## Extra material

Here are some additional links that might be useful:
* [International planning competition 2023](https://ipc2023-classical.github.io/), contains some info on how to use planners
* https://github.com/AI-Planning/planutils
* [Google OR Tools](https://developers.google.com/optimization), open source solver from Google
