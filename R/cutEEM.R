#' Cut portions of EEM
#'
#' Cut portions of EEM
#'
#' @inheritParams drawEEM
#' @param cutEX Numeric or sequential data specifying regions to be cut for excitation wavelength. 
#' Examples, 200 or 200:500 or c(200:300, 600:800)
#' @param cutEM Numeric or sequential data specifying regions to be cut for emission wavelength. 
#' Examples, 200 or 200:500 or c(200:300, 600:800)
#'
#' @return A list similar to input \code{EEM} is returned but with specified portions cut. 
#'
#' @examples
#' data(applejuice)
#' drawEEM(cutEEM(applejuice, cutEX = 200:250), 1)
#'
#' @export

cutEEM <- function(x, cutEX = NULL, cutEM = NULL) UseMethod("cutEEM", x)

#' @rdname cutEEM
#' @export
cutEEM.EEM <- function(x, cutEX = NULL, cutEM = NULL){
    
    # check that all x has the same dimension
    dimMat <- sapply(x, dim)
    if (sum(!apply(dimMat, 2, function (x) identical(dimMat[,1], x))) > 0){
        stop("Dimension do not match. Please check your data.")
    }    
    
    # prepare data 
    N <- length(x)
    rowname <- as.numeric(rownames(x[[1]])) # EM
    colname <- as.numeric(colnames(x[[1]])) # EX
    
    # check that it cannot cut through the middle
    # for EX
    if (!is.null(cutEX)){
        if (suppressWarnings(min(colname) < min(cutEX)&
                                 max(colname) > max(cutEX))){
            stop("Cannot cut through the middle.")
        }
    } 
    # for EM
    if (!is.null(cutEM)){    
        if (suppressWarnings(min(rowname) < min(cutEM)&
                                 max(rowname) > max(cutEM))) {
        stop("Cannot cut through the middle.")
        }
    }
        
    # prepare logical value for rows remain after cutting (EM)
    rowIdx <- !(rowname %in% cutEM)
    
    # prepare columns remain after cutting (EX)
    colIdx <-  !(colname %in% cutEX)
    colSelected <- which(colIdx)
    
    # cut
    x_cut <- list()
    for (i in 1:N){
        x_cut[[i]] <- subset(x[[i]],
                             subset = rowIdx, # subset refer to rows
                             select = colIdx,  # select refer to columns
                             drop = TRUE)
    }
    names(x_cut) <- names(x)
    class(x_cut) <- "EEM"
    return(x_cut)
}

#' @rdname cutEEM
#' @export
cutEEM.EEMweight <- function(x, cutEX = NULL, cutEM = NULL){
    
    # get value 
    title <- x$title
    EEM <- x$value
    
    # check that the format is correct, as in the variable name is there
    varnames <- rownames(x)
    if (!isTRUE(grepl("EX...EM...", varnames[1]))) {
        stop("The column name did not contain EX...EM... format.")
    }
    
    # prepare data
    EX <- as.numeric(gsub("(^.*EX)(.*)(EM.*$)", "\\2", varnames))
    EM <- as.numeric(gsub("(^.*EX.*EM)(.*$)", "\\2", varnames))
    
    # check that it cannot cut through the middle
    # for EX
    if (!is.null(cutEX)){
        if (suppressWarnings(min(EX) < min(cutEX)&
                                 max(EX) > max(cutEX))){
            stop("Cannot cut through the middle.")
        }
    } 
    # for EM
    if (!is.null(cutEM)){    
        if (suppressWarnings(min(EM) < min(cutEM)&
                                 max(EM) > max(cutEM))) {
            stop("Cannot cut through the middle.")
        }
    }
    
    # prepare logical index for columns remaining after cutting 
    EXIdx <-  !(EX %in% cutEX)
    EMIdx <- !(EM %in% cutEM)
    index <- EXIdx & EMIdx
    
    # cut
    x_cut <- x[index,]
    
    # return output
    output <- list()
    output$title <- title
    output$value <- x_cut
    class(output) <- "EEMweight"
    
    return(output)
}
