using LinearAlgebra
using Plots
using DataFrames

include("baseplot.jl")

function ternary_heatmap(f=(x, y) -> -sin(x) + cos(y); stepsize=0.05, title="", labels=(A = "", B = "", C = ""))
    if applicable(f, (0.3, 0.3, 0.1))
        f = (x, y) -> f(cart2tern(x, y)...)
    end

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

    xs = first.(middles)
    ys = last.(middles)
    z = f.(xs, ys .+ ((√3 / 2) * stepsize))

    plot!(shapes, c=plot_color(transpose(z), ), linewidth=0.5, linecolour=plot_color(transpose(z), ))

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

    plot!(shapes, c=plot_color(transpose(z), ), linewidth=1, linecolour=plot_color(transpose(z), ))

    return ternary_plot(p,
        title=title,
        labels=labels,
        )
end

