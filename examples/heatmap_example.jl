using LinearAlgebra
using Plots
using StaticArrays
using TernaryPlots
using DataFrames

include("../src/heatmap.jl")

f = ((x, y, z) -> 3x^2 + y - z)
g = (x,y) -> f(TernaryPlots.cart2tern(x, y)...)

ES(pS, pI, pC, h, e) = h - e*(1 + pC/(pS + pI))
EI(h, e, i) = h - e - i
EC(pS, pI, h) = h*(pS/(pS+pI))

best_strat(pS, pI, pC, h=5, e=2, i=1) = argmax([ES(pS, pI, pC, h, e), EI(h, e, i), EC(pS, pI, h)])
g = (x,y) -> best_strat(TernaryPlots.cart2tern(x, y)...)

ternary_heatmap(g, stepsize= 0.02, title="Which strategy is best?")
