<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Importing raw files}
\usepackage[utf8]{inputenc}
-->




# Importing raw files
edited on 2016.01.22

## Table of contents
- [Introduction](#intro)
- [Importing raw data files](#import)
    - [`readEEM` function](#readEEM)
        - [How to use](#howto)
        - [How it works](#howworks)
    - [Company-specific formats](#companyformat)
        - [JASCO](#JASCO)
        - [Hitachi Hi-tech](#hitachi)
        - [Shimadzu](#shimadzu)
        - [Horiba Aqualog](#horiba)
        - [Others](#others)
- [Importing data matrix](#datamatrix)
    - [Importing a data matrix file into R](#datamatrix_import)
        - [\*.txt or \*.csv files](#textfile)
        - [Excel file](#excel)
    - [Folding the data matrix or data frame into `EEM` object](#fold)

## <a name="intro"></a>Introduction
This document explains how raw fluorescence excitation-emission matrix (EEM) data files can be imported into R as `EEM` class object. The raw data files here refer to text-based files (\*.csv, \*.txt) which can be exported from the fluorescence spectrometer. `readEEM` function is available in the package for reading in the raw data files. However, it should be noted that only [specific formats](#companyformat) are supported. Aside from the file format, `readEEM` only requires that the raw data were divided into each files for each samples. 

Newer equipment software does the unfolding of many samples into a data matrix where each row is each sample and each column is each wavelength condition. For this type of data matrix, a procedure is described [here](#datamatrix). 

## <a name="import"></a>Importing raw data files using `readEEM`
### <a name="readEEM"></a>`readEEM` function
#### <a name="howto"></a>How to use
`readEEM` accepts `path` argument specifies the path to files or folders. 


```r
library(EEM)

# importing files
data <-readEEM("sample1.txt") # read in a file
data <-readEEM(c("sample1.txt", "sample2.txt")) # read in two files

# importing folders
data <-readEEM("/data") # read in all files in data folder
data <-readEEM(c("/data", "/data2")) # read in all files in two folders
data <-readEEM("C:\\data") # full path. Note that the slash is doubled.
data <- readEEM("C:/data") # read in all files in data folder. Aside from double slashes,
                           # a reverted slash can also be used. 
```

If the working folder which contains raw data files has already been set, 
`readEEM(".")` or `readEEM(getwd())` can be used to access them directly. 

#### <a name="howworks"></a>How it works
`readEEM` first checks the extensions of a file or all files in the folder. The acceptable extensions are \*.csv, \*.txt, \*.xls, \*.xlsx, and \*.dat. It will not read in the files whose extensions are not in the list. It will then check the formats of each files (see next section on company-specific formats). The files whose format is not supported by `readEEM` will not be read in. 

The method that `readEEM` uses to check the file format is to look out for a certain keyword which is located just above the raw data. The formats of different companies are very similar except for the number of filler lines at the top. `readEEM` will look for a keyword which signals the end of the filler lines and the start of raw data. 

### <a name="companyformat"></a>Company-specific formats

#### <a name="JASCO"></a>JASCO
Reference machine: FP-8500  
The raw files are of "\*.jwb" extension. They have to be converted into text-based files (\*.csv, \*.txt) using the machine software first.
The keyword before the data starts is "XYDATA". Columns are excitation wavelength and rows are emission wavelength.


#### <a name="hitachi"></a>Hitachi Hi-tech
Reference machine: F-7000  
The keyword before the data starts is "Data Points" or "ﾃﾞｰﾀﾘｽﾄ".Columns are excitation wavelength and rows are emission wavelength.

#### <a name="shimadzu"></a>Shimadzu
Reference machine: RF-6000  
The keyword before the data starts is "Rawdata" or "CorrectionData". Columns and rows are exchangable as excitation and emission wavelength. We assume that rows are excitation wavelength and columns are emission wavelength unless the word "励起波長/蛍光波長" is present. The exception has only been added for the Japanese keyword since we only have the sample data in Japanese.

#### <a name="horiba"></a>Horiba Aqualog
Unlike most formats, Aqualog file does not have filler starting lines. The first row states excitation wavelength and the first column states emission wavelength. 

#### <a name="others"></a>Others
For other formats, please send a word so we can work on it. 

## <a name="datamatrix"></a>Importing data matrix
Some recent machines can export unfolded data matrix directly. The unfolded data matrix refer to a matrix whose columns represent the wavelength conditions and rows represent the samples. If the columns and rows are in reverse, it is always possible to transpose it using `t()` after importing into R. Those data matrix can be imported into R as a data frame or matrix first before `fold`ing it into an `EEM` class object. 

### <a name="datamatrix_import"></a>Importing a data matrix file into R

#### <a name="textfile"></a> \*.txt or \*.csv files

```r
datamatrix <- read.csv("datamatrix.csv", row.names = 1) # for csv
datamatrix <- read.csv("datamatrix.txt", row.names = 1) # for txt
datamatrix[1:5,1:5] # check the first 5 rows and columns
```
Note that `row.names` was used to specify that the row names exist and they are in column number 1.

#### <a name="excel"></a> excel file

```r
library(readxl)
datamatrix <- read_excel("datamatrix.xlsx")
datamatrix[1:5,1:5] # check the first 5 rows and columns
```

For `read_excel`, row names cannot be specified so the first column is filled with row names instead. To edit that the following trick can be used.


```r
rownames(datamatrix) <- datamatrix[,1] # assign the first column to the matrix row names
datamatrix <- datamatrix[,-1] # delete the first column
datamatrix[1:5,1:5] # check the first 5 rows and columns
```

### <a name="fold"></a> Folding the data matrix or data frame into `EEM` object

Before the folding operation, there is one condition that the data matrix must meet. The column names must be of `EX???EM???` format. The `???` represent the wavelength value in nm. The usable examples include `EX200EM230` and even with decimal point inside `EX200.5EM400.5`.


```r
library(EEM)
datamatrix_folded <- fold(as.matrix(datamatrix))
class(datamatrix_folded)
# "EEM"
```

