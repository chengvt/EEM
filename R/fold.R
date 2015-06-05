#' Fold EEM matrix into a list
#' 
#' Fold EEM matrix into a list 
#' 
#' @param EEM_uf Unfolded EEM matrix where columns are wavelength condition and rows are samples.
#' It should have corresponding column names (formatted as EX###EM###) and row names. 
#' 
#' @return EEM a list containing EEM/EEM data
#' 
#' @examples
#' data(applejuice)
#' applejuice_uf <- unfold(applejuice) # unfold list into matrix
#' applejuice_uf_norm <- normalize(applejuice_uf) # normalize matrix
#' drawEEM(fold(applejuice_uf_norm), 1) # visualize normalized EEM
#' 
#' @export
#' 
#' @importFrom reshape2 acast
fold <- function(EEM_uf) UseMethod("fold")

#' @rdname fold
#' @export
fold.matrix <- function(EEM_uf){
    
  # information from EEM_uf
  sName <- rownames(EEM_uf)
  N <- length(sName)
  var <- colnames(EEM_uf)
  ex <- as.numeric(substring(var, 3, 5))
  em <- as.numeric(substring(var, 8, 10))
  
  # add data into list
  EEM <- list()
  for (i in 1:N){
    data <- EEM_uf[i,]
    dataFrame <- data.frame(x = ex, y = em, z = as.numeric(data))
    EEM[[i]] <- as.data.frame(acast(dataFrame, y ~ x, value.var = "z"))
  }
    
  # return 
  names(EEM) <- sName
  class(EEM) <- "EEM"
  return(EEM)
  }
