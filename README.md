# TernaryPlots.jl
Ternary/simplex plotting recipe/addon for Plots.jl

Please note: this package is currently in _very early development stage_, this README is currently up to date as of 07/08/2021, but may not be in the coming days as problems are fixed and features are added. Please feel free to contact me via email with any questions jacobusmmsmit a gmail d com or open an issue on this repository.

## Installation:
In the REPL you can paste this code to install the package:
```
using Pkg; pkg"add https://github.com/jacobusmmsmit/TernaryPlots.jl"
```
and then load it with
```
using TernaryPlots
```


## Current functionality:
* Conversions between cartesian and ternary co-ordinates using the exported function `cart2tern` and `tern2cart`
* Construction of ternary axes using `ternary_axes`. (Currently not possible to reverse arrow/axis directions)

## How to use this package:
This package provides a function (more precisely: a recipe) to construct ternary plots via converting ternary co-ordinates to cartesian and plotting them:
```
push!(LOAD_PATH, "src")
using Plots
using TernaryPlots
using CSV
using DataFrames


#Downloading Global whole-rock geochemical database compilation from https://zenodo.org/record/3359791/files/major.csv?download=1
path = "https://zenodo.org/record/3359791/files/major.csv?download=1"
df = CSV.read(download(path), DataFrame)
df = coalesce.(df,0)
filter!(row -> row[:sio2] >= 0, df)
filter!(row -> row[:al2o3] >= 0, df)
filter!(row -> row[:mgo] >= 0, df)
filter!(row -> (row[:sio2] .+ row[:al2o3] .+ row[:mgo]) >= 0.9, df)
filter!(row -> (row[:sio2] .+ row[:al2o3] .+ row[:mgo]) <= 1.1, df)
compos = [df.sio2 df.al2o3 df.mgo]
a = [zeros(eltype(compos), size(compos, 1)) zeros(eltype(compos), size(compos, 1))]

for i in 1:size(compos,1)
    a[i,:] = collect(tern2cart(compos[i,:]))'
end

ternary_axes(
    title="Rocks",
    xguide="SiO2",
    yguide="Al2O3",
    zguide="MgO",
    gridalpha=0.5,
    xgridlinewidth=1,
    ygridlinewidth=1,
    zgridlinewidth=1,
    xgridstyle=:dash,
    ygridstyle=:dash,
    zgridstyle=:dash,
)

p = scatter!(a[:,1],a[:,2], legend=false)
```
![](https://github.com/jacobusmmsmit/TernaryPlots.jl/blob/master/outputs/example_plot.png?raw=true)


## Work in progress:
* Different axis scales (as opposed to just 0 to 1)
* Performance improvements and code cleanup.
* Documentation.
* Plotting of ternary heatmaps by overloading `heatmap` on `Ternary_Axes`. Users will be able to define a function of cartesian co-ordinates or ternary co-ordinates:
```
 f = ((a, b, c) -> 3a^2 + b - c) # Function of ternary co-ordinates
 g = (x,y) -> f(cart2tern(x, y)...) # Same function, but taking ternary co-ordinates as input
```
* Plotting of ternary histograms possibly simply by converting it into a heatmap and using the previous heatmap functionality.
* Plotting of contour maps.

## Known issues:
* Rotation of labels is not consistent as you resize the graph, as such one needs to fiddle with the size parameter in order to get the angles correct, or specify them yourself.

## Contributions:
* [@jacobusmmsmit](https://github.com/jacobusmmsmit) - Author and maintainer
* [@Hasnep](https://github.com/Hasnep) - Maintainer
* [@daschw](https://github.com/daschw) - Major contributions to recipe implementation
<!-- * [@brenhinkeller](https://github.com/brenhinkeller) - Major contributions for ternary histograms -->

