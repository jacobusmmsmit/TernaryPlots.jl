using LinearAlgebra
using Plots
using StaticArrays
using TernaryPlots
using DataFrames

p = ternary_plot(
    title=" ",
    labels=(A = "", B = "", C = ""),
    # grid_minor_range=0.1:0.2:0.9,
    ticks=false,
    tick_labels=false,
    axis_labels=false,
    grid_major=false,
    grid_minor=false)

## Heatmap
stepsize = 0.05
x = DataFrame(x=0:stepsize:1)
y = DataFrame(y=0:stepsize:1)
xy = crossjoin(x, y)
xy.z = 1 .- (xy.x .+ xy.y)
filter!(row -> row.z >= 0, xy)

upright_middles = DataFrame(x=[], y=[], z=[])
upsidedown_middles = DataFrame(x=[], y=[], z=[])
for row in eachrow(xy)
    x, y = tern2cart(row)
    if row.z > 0
        push!(upright_middles, row)
    end
    if (row.x > 0 && row.y > 0)
        push!(upsidedown_middles, row)
    end
end
p

# Construct Upsidedown Triangles
upsidedown_middles.zlr = upsidedown_middles.z .+ stepsize
upsidedown_middles.yl = upsidedown_middles.y .- stepsize
upsidedown_middles.xr = upsidedown_middles.x .- stepsize

middles = tern2cart.(eachrow(upsidedown_middles[:, [:x, :y, :z]]))
rights = tern2cart.(eachrow(upsidedown_middles[:, [:xr, :y, :zlr]]))
lefts = tern2cart.(eachrow(upsidedown_middles[:, [:x, :yl, :zlr]]))
all_points = (middles, rights, lefts)

shapes = Shape.([([middles[i], rights[i], lefts[i]]) for i in 1:length(middles)])

z = -sin.(first.(middles)) .+ cos.(last.(middles) .+ √3/40)

plot!(shapes, c = plot_color(transpose(z), ), linewidth=0.5, linecolour=plot_color(transpose(z), ))

# Construct Upright Triangles
upright_middles.zlr = upright_middles.z .- stepsize
upright_middles.xl = upright_middles.x .+ stepsize
upright_middles.yr = upright_middles.y .+ stepsize

middles = tern2cart.(eachrow(upright_middles[:, [:x, :y, :z]]))
rights = tern2cart.(eachrow(upright_middles[:, [:x, :yr, :zlr]]))
lefts = tern2cart.(eachrow(upright_middles[:, [:xl, :y, :zlr]]))
all_points = (middles, rights, lefts)

shapes = Shape.([([middles[i], rights[i], lefts[i]]) for i in 1:length(middles)])

z = -sin.(first.(middles)) .+ cos.(last.(middles) .- √3/40)

plot!(shapes, c = plot_color(transpose(z), ), linewidth=1, linecolour=plot_color(transpose(z), ))

ternary_plot(p,
    title="Distribution of A, B, and C in system",
    labels=(A = "Cheaters (%)", B = "Sitters (%)", C = "Idenfitiers (%)"),
    grid_minor_range=0.05:0.05:0.95,
    )