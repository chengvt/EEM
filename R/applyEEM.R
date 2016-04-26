#' Apply function on EEM
#' 
#' Apply function on EEM and return EEM object
#' 
#' @inheritParams unfold
#' @inheritParams base::lapply
#' 
#' @return EEM class object with modified values
#' 
#' @examples 
#' require(EEM)
#' data(applejuice)
#' 
#' # add 30 to all values 
#' applejuice_plus <- applyEEM(applejuice, "+", 30)
#' 
#' # apply log10 to all values
#' applejuice_log <- applyEEM(applejuice_plus, log10)
#' 
#' # find the minimum value of each sample 
#' lapply(applejuice, "min")
#' # use lapply instead of applyEEM when the returned output is not EEM class structure
#' 
#' @export
applyEEM <- function(EEM, FUN, ...){
    output <- lapply(EEM, FUN, ...)
    class(output) <- "EEM"
    return(output)
}