# EEM v1.1.0
## New features
* Add support for Aqualog .dat file
* Add `delScattering2` function
* Add `drawEEMgg` function
* Add S3 method for `c.EEM`
* Introduce `commonnizeEEM`: the function which smooths out the difference dimensions of EEM data

## Minor new features
* `findLocalMax` now supports unfolded matrix
* `drawEEM ` now supports VIP plotting (for the VIP function available at pls package's main site). 
* The font size for the group legend box can now be specified using `cex.legend` in `plotScore` function.
* Add methods for `tbl` object in `fold`
* Automatically replace NA with 0 in `unfold`

## Major change
* No longer support excel file import internally in `readEEM`

## Minor change
* Add `showprint` argument in `findLocalMax` to turn on/off the printing.
* For `plotScore`, up to now, 2 group information can be specified in `group` variable (ie. plotScore(PCA, group = c(group1, group2))). Now, if there are two group information, it must be specified separately (plotScore(PCA, group = group1, group2 = group2)).
* Change the default value for forth from 0 to 40 for delScattering. 
* `unfold` became faster by not using `melt`
* `forth` argument in `delScattering` had 0 as default value. The value was reset to be 40. 

## Debug
* `cutEEM` so that it can deal with values with decimal points.

# EEM v1.0.4
## New features
* The excitation/emission axis can now be flipped using `flipaxis` argument in `drawEEM`.

## Minor changes
* `findLocalMax` returns character vector instead of a data.frame
* deprecated `pointsize` and use `cex` instead in `plotScore`.
