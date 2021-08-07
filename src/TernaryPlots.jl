module TernaryPlots

export ternary_axes, ternary_axes!
export tern2cart, cart2tern

using RecipesBase
using Plots: text
using LinearAlgebra: normalize

include("user_helpers.jl")
include("recipe_helpers.jl")
include("ternary_axes.jl")

end # module
