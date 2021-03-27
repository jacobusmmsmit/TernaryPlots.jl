using Plots


function ternary_contour!(plot, f;title="", labels=(bottom = "", right = "", left = ""), stepsize=0.01)
    xs = 0:stepsize:1
    ys = 0:stepsize:1
    zs = zeros(length(xs), length(ys))
    for (j, numj) in enumerate(ys)
        for (i, numi) in enumerate(xs)
            zs[i, j] = f(numj, numi)
        end
    end

    Plots.contour!(plot, xs, ys, zs, lw=1, lc=:black, axes=nothing, border=:none, ticks=false, legend=false, colour=:black)
    Plots.plot!(plot, Shape([(-0.5, 0), (-0.5, 1), (1.5, 1), (1.5, -0.5), (-0.5, -0.5), (-0.5, 0), (1, 0), (0.5, √3 / 2), (0, 0)]), colour=:white, linewidth=0, linealpha=0)
    return ternary_plot(plot,
        title=title,
        labels=labels,
        )
end