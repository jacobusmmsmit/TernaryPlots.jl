using LinearAlgebra
using Plots
using StaticArrays
using TernaryPlots
using DataFrames

# f = ((x, y, z) -> 3x^2 + y - z)
# g = (x, y) -> f(cart2tern(x, y)...)

ES(pS, pI, pC, h, e) = h - e * (1 + pC / (pS + pI))
EI(h, e, i) = h - e - i
EC(pS, pI, h) = h * (pS / (pS + pI))

best_strat(pS, pI, pC, h=5, e=2, i=1) = argmax([ES(pS, pI, pC, h, e), EI(h, e, i), EC(pS, pI, h)])
g = (x, y) -> best_strat(cart2tern(x, y)...)

# f(x,y)=(2*x-1)^(4)-(2*x-1)^(2)+y^(2)

ternary_heatmap(f, stepsize=0.02, title="Which strategy is best?")