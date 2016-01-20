# EEM package

`EEM` is an R package for reading and analyzing fluorescence excitation-emission matrix (EEM). Some preprocessing methods and means to visualize multivariate analysis results (PCA and PLS) are provided.

The changes during version updates are recorded [here](NEWS.md).

### To install

The stable version:
	
    install.packages("EEM")

The latest development version:

    library(devtools) 
    install_github("chengvt/EEM", dependencies = TRUE)
	
If you don't have `devtools` install yet, you will need to first install it. 

    install.packages("devtools")
	
The package vignette is available in [English](http://rpubs.com/chengvt/EEM) and 
[Japanese](http://rpubs.com/chengvt/EEM_Japanese).