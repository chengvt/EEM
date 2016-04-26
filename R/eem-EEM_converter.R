#' Converting between EEM and eemlist objects
#' 
#' Converting between EEM object (EEM package) and eemlist object (eemR package)
#' @aliases EEM2eemlist
#' 
#' @inheritParams unfold
#' @param eemlist object in eemR package
#' 
#' @export
eemlist2EEM <- function(eemlist){
    EEM <- list()
    for (i in 1:length(eemlist)){
        EEM[[i]] <- eemlist[[i]][[2]]
        colnames(EEM[[i]]) <- eemlist[[i]][[3]]
        rownames(EEM[[i]]) <- eemlist[[i]][[4]]
        names(EEM)[i] <- eemlist[[i]][[1]]
    }
    class(EEM) <- "EEM"
    return(EEM)
}

#' @export
EEM2eemlist <- function(EEM){
    eemlist <- list()
    for (i in 1:length(EEM)){
        eemlist[[i]] <- list(sample = names(EEM)[i],
                         x = EEM[[i]],
                         ex = as.numeric(colnames(EEM[[i]])),
                         em = as.numeric(rownames(EEM[[i]]))
                         )
        class(eemlist[[i]]) <- "eemlist"
        attr(eemlist[[i]], "is_blank_corrected") <- FALSE
        attr(eemlist[[i]], "is_scatter_corrected") <- FALSE
        attr(eemlist[[i]], "is_ife_corrected") <- FALSE
        attr(eemlist[[i]], "is_raman_normalized") <- FALSE
    }
    names(eemlist) <- names(EEM)
    class(eemlist) <- "eemlist"
    return(eemlist)
}