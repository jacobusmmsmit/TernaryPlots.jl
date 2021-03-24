using LinearAlgebra
using Plots
using StaticArrays
using TernaryPlots
using Test

@testset "TernaryPlots" begin
    @testset "Example runs" begin
    ternaryplot(rand(10),rand(10))
    end
end
