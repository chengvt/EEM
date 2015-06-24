#' Unfold EEM list into a matrix 
#' 
#' Unfold EEM list into a matrix with columns as variables (wavelength conditions) and rows as samples.
#' 
#' @param EEM a list containing EEM data as created by \code{readEEM} function.
#' 
#' @return Unfolded EEM matrix where columns are wavelength condition and rows are samples
#' 
#' @examples
#' data(applejuice)
#' applejuice_uf <- unfold(applejuice) # unfold list into matrix
#' dim(applejuice_uf) # dimension of unfolded matrix
#' 
#' @export
#' @importFrom reshape2 melt

unfold <- function(EEM) UseMethod("unfold")

#' @rdname unfold
#' @export
unfold.EEM <-
  function(EEM){
    
    ## check that all EEM has the same dimension
    dimMat <- sapply(EEM, dim)
    if (sum(!apply(dimMat, 2, function (x) identical(dimMat[,1], x))) > 0){
      stop("Dimension do not match. Please check your data.")
    }
    
    ## check that EX and EM wavelength are identical for all samples
    dimension_names <- lapply(EEM, dimnames)
    if (sum(!sapply(dimension_names, function (x) identical(dimension_names[[1]], x))) > 0){
        stop("Dimension names do not match. Please check your data.")
    }

    # get sName
    sName <- names(EEM)
    
    ## begin unfolding EEM data into a matrix with no. of samples x variables  
    N <- length(EEM)
    tmpData <- list()
    
    for (i in 1:N){
      data <- EEM[[i]]
      meltedData <- melt(as.matrix(data))
      colnames(meltedData) <- c("Em", "Ex", "intensity")
      meltedData$var <- paste("EX", meltedData$Ex, "EM", meltedData$Em, sep = "")
      tmpData[[i]] <- t(meltedData[, 3])
    }
    var <- meltedData[, 4]
    
    EEM_uf <- do.call(rbind.data.frame, tmpData)
    EEM_uf <- as.matrix(EEM_uf)
    colnames(EEM_uf) <- var
    rownames(EEM_uf) <- sName
    return(EEM_uf)
  }
