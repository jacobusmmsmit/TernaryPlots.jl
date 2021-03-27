using TernaryPlots

f(x,y) = ((2 * x) - 1)^4 - ((2 * x) - 1)^2 + y^2

p2 = ternary_heatmap(f, 0.02,
    title="Example Ternary Plot",
    labels=(bottom = "Bottom Axis", left = "Left Axis", right = "Right Axis"))

p = ternary_plot()
ternary_heatmap!(p, f, 0.02; draw_arrows=false, tick_labels=false)
ternary_contour!(p, f, 0.01)