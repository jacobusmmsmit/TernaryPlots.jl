module TernaryPlots

using Plots
using LinearAlgebra

export ternary_plot, tern2cart, cart2tern
export ternary_heatmap

# include("baseplot.jl")
include("heatmap.jl")
include("ternary_contour.jl")

end # module
