# EEM package

`EEM` is an R package for reading and preprocessing fluorescence excitation-emission matrix (EEM). Aside from importing the raw data directly, some preprocessing methods and means to visualize the multivariate analysis results (PCA and PLS) are also provided. 

## Key features 
* **Raw data import**
  - Hitachi Hi-tech, JASCO, Shimadzu and Horiba Aqualog in any of the .txt, .csv, .dat formats are currently supported.
  - For unsupported formats, please refer to [importing raw files](vignettes/file-io.md) or send request. 
* **Visualize EEM in a contour**
  - ([example1](vignettes/figure/drawEEM-1.png), [example2: flipped axis](vignettes/figure/drawEEM-3.png))
* **Preprocessing EEM data**
  - Delete Rayleign scattering rays
  - Cutting unwanted portion of EEM by specifying wavelength range
* **Preparing EEM data for multivariate analysis (PCA, PLS)**
  - Unfolding from 3d to 2d data matrix
  - Normalizing 2d data matrix
* **Viewing multivariate results**
  - Loading plots and score plots of PCA
    - Supported packages: `prcomp` of `stats` package
  - Loading plots and regression plots of PLS
    - Supported packages: `pls` package

## Manuals
The package vignette is available in [English](vignettes/vignette.md) and 
[Japanese](http://rpubs.com/chengvt/EEM_Japanese). The detailed manual on [importing raw files](vignettes/file-io.md) is also available.

The changes during version updates are recorded [here](NEWS.md).

## To install

The stable version:
	
    install.packages("EEM")

The latest development version:

    library(devtools) 
    install_github("chengvt/EEM", dependencies = TRUE)
	
If you don't have `devtools` install yet, you will need to first install it. 

    install.packages("devtools")
	
