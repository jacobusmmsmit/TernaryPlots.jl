using TernaryPlots

f(x,y) = ((2 * x) - 1)^4 - ((2 * x) - 1)^2 + y^2

p = ternary_heatmap(f, stepsize=0.02)
p2 = ternary_plot(draw_arrow=true, labels=(bottom = "btm", right = "rght", left = "lft"))
p3 = ternary_plot(draw_arrow=true, labels=(bottom = "btm", right = "rght", left = "lft"))

ternary_contour!(p, f)
ternary_contour!(p2, f)

p2

