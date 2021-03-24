using LinearAlgebra
using Plots
using StaticArrays
using TernaryPlots
using DataFrames

p = ternary_plot(
    title="Distribution of A, B, and C in system",
    labels=(A = "Cheaters (%)", B = "Sitters (%)", C = "Idenfitiers (%)"),
    grid_minor_range=0.05:0.05:0.95,)

## Plotting Points
npoints = 10
points = [Vector{Float64}() for i in 1:npoints]
accepted_points = 0

while accepted_points < npoints
    point = rand(SVector{2,Float64})
    if sum(point) <= 1
        points[accepted_points + 1] = vcat(point, 1 - sum(point))
        accepted_points += 1
    end
end

points_to_plot = tern2cart.(points)
x_to_plot = first.(points_to_plot)
y_to_plot = last.(points_to_plot)

# Plots.plot!(p, x_to_plot, y_to_plot, seriestype=:scatter)

x = DataFrame(x=0:0.05:1)
y = DataFrame(y=0:0.05:1)
xy = crossjoin(x, y)
xy.z = 1 .- (xy.x .+ xy.y)
filter!(row -> row.z >= 0, xy)

upright_xs = []
upright_ys = []
upsidedown_xs = []
upsidedown_ys = []
for row in eachrow(xy)
    x, y = tern2cart(row)
    if row.z > 0
        push!(upright_xs, x)
        push!(upright_ys, y)
    end
    if (row.x > 0 && row.y > 0)
        push!(upsidedown_xs, x)
        push!(upsidedown_ys, y)
    end
end
Plots.plot!(p, upright_xs, upright_ys .- 0.025, seriestype=:scatter, colour=:red, alpha=0.5)
Plots.plot!(p, upsidedown_xs, upsidedown_ys .+ 0.025, seriestype=:scatter, colour=:blue, alpha=0.5)
p