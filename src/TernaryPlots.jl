module TernaryPlots

using Plots
using LinearAlgebra

export ternary_plot, tern2cart, cart2tern
export ternary_heatmap
export ternary_contour!

include("baseplot.jl")
include("heatmap.jl")
include("contour.jl")

end # module
