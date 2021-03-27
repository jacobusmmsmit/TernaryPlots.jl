using TernaryPlots

f(x,y) = ((2 * x) - 1)^4 - ((2 * x) - 1)^2 + y^2

p = ternary_heatmap(f)
p2 = ternary_plot()

ternary_contour!(p, f, title="Title", labels=(bottom = "Bottom", right = "Right", left = "Left"))
ternary_contour!(p2, f, title="Title", labels=(bottom = "Bottom", right = "Right", left = "Left"))

p2