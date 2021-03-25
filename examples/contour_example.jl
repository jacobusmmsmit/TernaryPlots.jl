using TernaryPlots

f(x,y) = (2 * x - 1)^(4) - (2 * x - 1)^(2) + y^(2)

p = ternary_heatmap(f)
p2 = ternary_plot()

ternary_contour!(p, f)
ternary_contour!(p2, f)

p