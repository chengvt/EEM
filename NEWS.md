# Current development (master branch)
## New features
* Add support for Aqualog .dat file
* The font size for the group legend box can now be specified using `cex.legend` in `plotScore` function.

## Minor change
* add `showprint` argument in `findLocalMax` to turn on/off the printing.
* For `plotScore`, up to now, 2 group information can be specified in `group` variable (ie. plotScore(PCA, group = c(group1, group2))). Now, if there are two group information, it must be specified separately (plotScore(PCA, group = group1, group2 = group2)).

# EEM 1.0.4
## New features
* The excitation/emission axis can now be flipped using `flipaxis` argument in `drawEEM`.

## Minor changes
* `findLocalMax` returns character vector instead of a data.frame
* deprecated `pointsize` and use `cex` instead in `plotScore`.