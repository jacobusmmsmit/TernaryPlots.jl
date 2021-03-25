using LinearAlgebra
using Plots
using DataFrames
using Statistics
using GR
GR.__init__()

include("baseplot.jl")

stepsize = 0.05
f(x,y) = (2 * x - 1)^(4) - (2 * x - 1)^(2) + y^(2)

p = ternary_plot(
    title=" ",
    labels=(A = "", B = "", C = ""),
    ticks=false,
    tick_labels=false,
    axis_labels=false,
    grid_major=false,
    grid_minor=false)

## Heatmap
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

# Construct Upsidedown Triangles
upsidedown_middles.zlr = upsidedown_middles.z .+ stepsize
upsidedown_middles.yl = upsidedown_middles.y .- stepsize
upsidedown_middles.xr = upsidedown_middles.x .- stepsize

middles = tern2cart.(eachrow(upsidedown_middles[:, [:x, :y, :z]]))
rights = tern2cart.(eachrow(upsidedown_middles[:, [:xr, :y, :zlr]]))
lefts = tern2cart.(eachrow(upsidedown_middles[:, [:x, :yl, :zlr]]))
all_points = (middles, rights, lefts)

shapes = Shape.([([middles[i], rights[i], lefts[i]]) for i in 1:length(middles)])

xs = first.(middles)
ys = last.(middles)
z = f.(xs, ys .+ ((√3 / 2) * stepsize))

Plots.plot!(shapes, c=plot_color(transpose(z), ), linewidth=0.5, linecolour=plot_color(transpose(z), ))

# Construct Upright Triangles
upright_middles.zlr = upright_middles.z .- stepsize
upright_middles.xl = upright_middles.x .+ stepsize
upright_middles.yr = upright_middles.y .+ stepsize

middles = tern2cart.(eachrow(upright_middles[:, [:x, :y, :z]]))
rights = tern2cart.(eachrow(upright_middles[:, [:x, :yr, :zlr]]))
lefts = tern2cart.(eachrow(upright_middles[:, [:xl, :y, :zlr]]))
all_points = (middles, rights, lefts)

shapes = Shape.([([middles[i], rights[i], lefts[i]]) for i in 1:length(middles)])

xs = first.(middles)
ys = last.(middles)
z = f.(xs, ys .- ((√3 / 2) * stepsize))

Plots.plot!(shapes, c=plot_color(transpose(z), ), linewidth=1, linecolour=plot_color(transpose(z), ))

# GR.tricontour(xs, ys, z, quantile(z, 0:0.5:1))

GR.tricont(xs, ys, z)

# xcoords = 0:0.1:10
# ycoords = 0:0.1:10
# zcoords = xcoords' .+ ycoords
# Plots.contour!(xcoords, ycoords, zcoords)

# ternaryoperator(x, y) = y ? -x : x

# contour_shapes = DataFrame(x=xs, y=ys .- ((√3 / 2) * stepsize), z=z, zq=round_to_array(z, quantile(z, 0:0.5:1))) |>
#     df -> sort(df, [:x, :y]) |>
#     df -> groupby(df, :zq) |>
#     df -> transform(df, :y => y -> 0 .< y .- mean(y)) |>
#     df -> transform(df, [:x, :y_function] => (x, y) -> ternaryoperator.(x, y)) |>
#     df -> sort(df, [:x_y_function_function]) |>
#     df -> groupby(df, :zq) |>
#     df -> combine(df, [:x, :y] => ((x, y) -> Shape(x, y)) => :shapes) |>
#     df -> convert(Vector, df.shapes)

# plot!(contour_shapes, linewidth=0.5, linecolour=:black)

function ternary_contour!(plot, f, stepsize=0.01)
    txs = 0:stepsize:1
    tys = 0:stepsize:1
    tz = zeros(length(txs), length(tys))
    for (j, numj) in enumerate(tys)
        for (i, numi) in enumerate(txs)
            tz[i, j] = f(numj, numi)
        end
    end

    Plots.contour!(plot, txs, tys, tz, lw=1, lc=:black, axes=nothing, border=:none, ticks=false, legend=false, colour=:black)
    Plots.plot!(plot, Shape([(0, 0), (0, 1), (1, 1), (1, 0), (0.5, √3 / 2)]), colour=:white, linewidth=0, linealpha=0)
end


ternary_plot(p, title="I can't believe this worked")

f(x,y) = (2 * x - 1)^(4) - (2 * x - 1)^(2) + y^(2)

ternary_heatmap(f, stepsize=0.02, title="Which strategy is best?")

