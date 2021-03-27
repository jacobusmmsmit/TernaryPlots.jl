# TernaryPlots.jl
Ternary/simplex plotting recipe/addon for Plots.jl

Please note: this package is currently in _very early development stage_, this README is currently up to date as of 26/03/2021, but may not be in the coming days as problems are fixed and features are added. Please feel free to contact me via email with any questions jacobusmmsmit a gmail d com or open an issue on this repository.

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
* Conversions between cartesian and ternary co-ordinates using `cart2tern` and `tern2cart`
* Construction of ternary axes, labels (passed as a `NamedTuple`), and ticks using `ternary_plot`. (Currently not possible to flip arrows) 
* Plotting of ternary heatmaps (using `ternary_heatmap`) a function of cartesian co-ordinates (or ternary co-ordinates via:
```
 f = ((a, b, c) -> 3a^2 + b - c) # Function of ternary co-ordinates
 g = (x,y) -> f(cart2tern(x, y)...) # Same function, but taking ternary co-ordinates as input
```

## How to use this package:
This package provides ways to construct ternary plots via converting ternary co-ordinates to cartesian and plotting them. Currently there is a correct order to call functions as most will overwrite the others' titles and axis labels due to how the package works under the hood. The current correct order to call the functions as such:

```
using TernaryPlots

f(x,y) = (2 * x - 1)^(4) - (2 * x - 1)^(2) + y^(2)

p = ternary_heatmap(f) # Construct a heatmap, don't specify the title or labels
p2 = ternary_plot() # Construct a blank ternary plot, don't specify the title or labels

ternary_contour!(p, f, title="Title", labels=(A="Bottom", B="Right", C="Left")) # Add the contours to the existing heatmap (note the ! in the name of the function)
ternary_contour!(p2, f, title="Title", labels=(A="Bottom", B="Right", C="Left")) # # Add the contours to the blank ternary plot
```
This restriction in order will be removed very soon as it is only in place due to the early nature of the package.

## Work in progress:
* Contour maps (available on `features/contour` branch) using `ternary_contour!` (Note: this is a function that alters a pre-existing plot by adding the contour lines, but again it overwrites the axis labels.
* Different axis scales (as opposed to just 0 to 1)
* Ability to put arrows on axis, above axis, or hidden
* Performance improvements and code cleanup
* Documentation

## Known issues:
* Titles and labels being overwritten, `ternary_plot` having the wrong default arguments for labels.
* Rotation of labels is not consistent as you resize the graph, as such one needs to fiddle with the size parameter in order to get the angles correct, or specify them yourself.
