#' Smooth out the different dimensions of EEM data
#' 
#' Smooth out the difference dimensions of EEM data by finding the common variables of all data and subset
#' those data.
#' 
#' @param EEM a list containing EEM data as created by \code{readEEM} function.
#' 
#' @return EEM class object with only common variables
#' 
#' @export
commonizeEEM <- function(EEM){
    
    # get var names
    getVar <- function(EEM){
        var.full <- expand.grid(em = as.numeric(rownames(EEM)), ex = as.numeric(colnames(EEM)))
        var <- paste0("EX", var.full$ex, "EM", var.full$em) 
        return(var)
    }
    var_list <- sapply(EEM, getVar)
    
    # find common variables
    common_var <- Reduce(intersect, var_list)
    common_index <- t(sapply(var_list, function(x) match(common_var, x)))
    
    # subset data
    data_uf <- matrix(NA, length(EEM), length(common_var))
    for (i in 1:length(EEM)){
        tmpdata <- as.vector(EEM[[i]])
        data_uf[i,] <- tmpdata[common_index[i,]]
    }
    colnames(data_uf) <- common_var
    data <- fold(data_uf)
    return(data)
}