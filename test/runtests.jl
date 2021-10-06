using Plots
using TernaryPlots

# Generate test data
test_data = rand(100, 3) |> eachrow .|> r -> r ./ sum(r) |> tern2cart

# Plot the data
p = ternary_axes(title = "Rocks", xguide = "SiO2", yguide = "Al2O3", zguide = "MgO")
scatter!(p, getindex.(test_data, 1), getindex.(test_data, 2), legend = false)
