#' Read raw files and return a list
#' 
#' Read raw files from fluorescence spectrometer
#' 
#' @param pathname path to the files or folders which contains raw files (accept a vector). 
#' For windows platform, if left blank will bring up an interactive directory chooser. 
#' 
#' @return \code{readEEM} returns a list containing each raw files
#' 
#' @details The supported format is outputs from FP-8500 (JASCO), F-7000 (Hitachi Hi-tech) and RF-6000 (Shimadzu) fluorescence spectrometer. 
#' It is likely that outputs from different machines of the same companies are supported by this function.
#' Please send a word or pull request to add support for other formats. 
#' 
#' @export
#' 
#' @importFrom utils choose.dir
#' @importFrom tools file_ext file_path_sans_ext
#' @importFrom readxl read_excel
#' @importFrom R.utils isDirectory isFile
readEEM <-
    function(pathname = NULL){
        
        ## if no input is provided, bring up interactive folder chooser (only work for windows now)
        if(.Platform$OS.type == "windows") {
            if (nargs() == 0) {
                pathname <- choose.dir()
                if (is.na(pathname)) stop("No directory has been selected.")
            }
        } else {
            # for other OS
            if (nargs() == 0) stop("No directory has been selected.")
        }
        
        # if file names are provided, use them
        if (all(isFile(pathname))) fileList <- pathname
        
        # if folder paths are provided, use them
        if (all(isDirectory(pathname))) {
            acceptableFileExtension <- "\\.csv$|\\.txt$|\\.xls$|\\.xlsx$"
            fileList <- list.files(path = pathname, pattern = acceptableFileExtension, 
                                   ignore.case = TRUE, full.names = TRUE)
        }
        
        N = length(fileList)
        
        # stop if there is no file in the directory
        if (N == 0) stop("There is no files in the directory. ")
        
        ## initialize output
        EEM <- list() # store each sample data in list format. call each one using EEM[[i]]    
        
        ## get data from each file in loop
        for (i in 1:N){
            file <- fileList[i]
            EEM[[i]] <- readSingleEEM(file)
        }
        
        # delete those that were not meant to be read
        if (sum(grepl("DO NOT READ", EEM)) > 0) {
            idx <- grep("DO NOT READ", EEM)
            EEM <- EEM[-idx]
            fileList <- fileList[-idx]
        }
        
        # add name and class
        names(EEM) <- sapply(fileList, 
                             function(x) basename(file_path_sans_ext(x)), 
                             USE.NAMES = FALSE)
        class(EEM) <- "EEM"
        return(EEM)
    }

## create function to read each file 
readSingleEEM <- function(file){
    
    # check format of file  
    fileExtension <- tolower(file_ext(file))
    
    # initialize conditions
    isEXCEL <- FALSE
    isASCII <- FALSE
    
    # check if the file is .xls or .xlsx format
    if (grepl("xls", fileExtension)) isEXCEL <- TRUE
    
    # read in the lines 
    if (isEXCEL) {
        tmpData <- as.character(read_excel(file)[,1], stringsAsFactors = FALSE)
    } else {
        tmpData = readLines(file, warn = FALSE)
        switch(fileExtension, csv = {SEP <- ","}, txt = {SEP <- ""})
    }
    
    # check if tmpdata contains non ASCII
    if (sum(grepl("UTF-8", sapply(tmpData, Encoding))) > 0) isASCII = TRUE
    if (isASCII) tmpData <- sapply(tmpData, iconv, from = "UTF-8", to = "ASCII", sub = "byte")
    
    # find the line index that contains either of the following word
    # FP-8500 file: "XYData"
    # F-7000 file: "Data Points" or "Data list (in Japanese)"
    # R-7000 file: "RawData"
    pattern <- "Data Points|XYDATA|<ef><be><83><ef><be><9e><ef><bd><b0><ef><be><80><ef><be><98><ef><bd><bd><ef><be><84>|RawData"
    index <- grep(pattern, tmpData, ignore.case = TRUE)
    if (length(index) == 0) {
        warning(paste("'", basename(file), "' does not have the right format. So it will not be read. 
                      (Note: the right format = they contain the words 'Data Points' or 'XYDATA')",
                      sep = ""))
        data <- "DO NOT READ"
        return(data)
    }
    # read data
    if (isEXCEL){
        # for excel files
        data_noRowNames <- read_excel(file, skip = index + 1)
        colnames(data_noRowNames) <- round(as.numeric(colnames(data_noRowNames)))
    } else {
        # for txt or csv files
        data_noRowNames <- read.delim(file, sep = SEP, skip = index, 
                                      check.names = FALSE, row.names = NULL)
    }
    
    # delete NA rows if present
    NA_rows <- which(is.na(data_noRowNames[,1]))
    if (length(NA_rows) > 0) data_noRowNames <- data_noRowNames[-NA_rows,]
    
    # output
    data <- as.matrix(data.frame(c(data_noRowNames[,-1]), 
                                 row.names = data_noRowNames[,1], 
                                 check.names = FALSE))    
    return(data)
}