using Test
using Plots
using TernaryPlots

# @testset "TernaryPlots" begin
#     @testset "Example runs" begin
#         n = 1000
#         x, y, z = rand(n), rand(n), rand(n)
#         x = x ./ (x .+ y .+ z)
#         y = y ./ (x .+ y .+ z)
#         z = z ./ (x .+ y .+ z)
#         ternaryplot(x, y, z)
#     end
# end

n = 1000
x, y, z = rand(n), rand(n), rand(n)
x = x ./ (x .+ y .+ z)
y = y ./ (x .+ y .+ z)
z = z ./ (x .+ y .+ z)
ternaryplot(x, y, z)