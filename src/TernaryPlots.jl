module TernaryPlots

using RecipesBase

ternary_to_x(a, b, c) = 1 / 2 * (2b + c) / (a + b + c)
ternary_to_y(a, b, c) = √3 / 2 * (c / (a + b + c))

function cart2tern(x, y)
    c = (2 * y) / √3
    b = x - c / 2
    a = 1 - b - c
    return (a, b, c)
end

@userplot TernaryPlot

@recipe function f(t::TernaryPlot)
    if length(t.args) == 2
        a, b = t.args
        c = 1 .- a .- b
    elseif length(t.args) == 3
        a, b, c = t.args
    else
        error("You need to specify at least the a and b series.")
    end

    x = ternary_to_x.(a, b, c)
    y = ternary_to_y.(a, b, c)

    @series begin
        seriestype := :scatter
        x, y
    end
end

end # module
