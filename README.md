# TernaryPlots.jl
Ternary/simplex plotting recipe/addon for Plots.jl

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
This package provides ways to construct ternary plots via converting ternary co-ordinates to cartesian and plotting them. Currently there is a correct order to call functions as most will overwrite the others' titles and axis labels due to how the package works under the hood. The correct order to

## Work in progress:
* Contour maps (available on `features/contour` branch) using `ternary_contour!` (Note: this is a function that alters a pre-existing plot by adding the contour lines, but again it overwrites the axis labels so its usage should be:
```
using TernaryPlots

f(x,y) = (2 * x - 1)^(4) - (2 * x - 1)^(2) + y^(2)

p = ternary_heatmap(f) # Construct a heatmap, don't specify the title or labels
p2 = ternary_plot() # Construct a blank ternary plot, don't specify the title or labels

ternary_contour!(p, f)
ternary_contour!(p2, f)
```
* Different axis scales (as opposed to just 0 to 1)
* Performance improvements and code cleanup
* Documentation

## Known issues:
* Titles and labels being overwritten, `ternary_plot` having the wrong default arguments for labels.
* Both `ternary_heatmap` and `ternary_contour` include `baseplot.jl` which throws a warning.
