using DataFrames, CSV, UnPack

 
"""
    import_data(file)

    Imports the data from the instance specified by file
"""
function import_data(file)

    # Read file
    data = DataFrame(CSV.File(file))
    #println(data) # prints the dataframe

    n = parse(Int64,data[1,1][3:end]) # nr items

    # ---- Create the sets -----
    ITEMS = 1:n # the set of items

    # ---- Create the parameters -----
    max_weight = parse(Int64,data[2,1][3:end]) # max weight (RHS)

    profit = zeros(n) # profit
    weight = zeros(n) # weight
    for i in ITEMS
        profit[i] = data[i+4,2]
        weight[i] = data[i+4,3]
    end

    return (; ITEMS), (; profit,weight,max_weight) # returns the data as two tuples
end


