using LinearAlgebra
using Plots
using StaticArrays
using TernaryPlots
using Test

@testset "TernaryPlots" begin
    @testset "Example runs" begin
        p = ternary_plot(
            title = "Distribution of A, B, and C in system",
            labels = (A = "Cheaters (%)", B = "Sitters (%)", C = "Idenfitiers (%)"),
        )

        ## Plotting Points
        npoints = 10
        points = [Vector{Float64}() for i in 1:npoints]
        accepted_points = 0

        while accepted_points < npoints
            point = rand(SVector{2, Float64})
            if sum(point) <= 1
                points[accepted_points + 1] = vcat(point, 1 - sum(point))
                accepted_points += 1
            end
        end

        points_to_plot = tern2cart.(points)
        x_to_plot = first.(points_to_plot)
        y_to_plot = last.(points_to_plot)

        Plots.plot!(p, x_to_plot, y_to_plot, seriestype = :scatter)
    end
end
