#' Plot score for prcomp result
#' 
#' Plot score for \code{\link[stats]{prcomp}} (PCA) result
#' 
#' @param prcompResult output object from \code{\link[stats]{prcomp}} function
#' @param xPC an integer indicating PC component on x-axis
#' @param yPC an integer indicating PC component on y-axis
#' @param pointsize (optional) size of points on graphs 
#' @param label (optional) a character vector or expression specifying the text to be written.
#' @param pos (optional, applicable when label is given) a position specifier for the text. If specified this overrides 
#' any adj value given. Values of 1, 2, 3 and 4, respectively indicate positions below, 
#' to the left of, above and to the right of the specified coordinates.
#' @param group variable of numeric, character or factor class separating 
#' the samples into groups. 
#' @param legendlocation (optional)location of legend on graph. 
#' Look up \code{\link[graphics]{legend}} for more details.
#' @param legendoutside (optional) set to TRUE if you want to put legend on 
#' the outside of the plot. The legend location is defaulted to topright. 
#' @param rightwhitespace (optional) set width for white space for legend. 
#' Only applicable if legendoutside = TRUE
#' @param legendinset (optional) how much legend box will be pushed to the right.
#' Only applicable if legendoutside = TRUE
#' @param col point color
#' @param pch point type
#' @param title (optional) plot title
#' @param ... additional arguments for \code{\link[graphics]{text}}
#' 
#' @return A figure is returned on the graphic device
#' 
#' @seealso
#' \code{\link{plotScorem}}
#' 
#' @examples
#' data(applejuice)
#' applejuice_uf <- unfold(applejuice) # unfold list into matrix
#' result <- prcomp(applejuice_uf) 
#' plotScore(result, xPC = 1, yPC = 2) # plot PC1 vs PC2 score
#' plotScore(result, xPC = 1, yPC = 2, pch = 3, col = "blue") # change shape and color
#' 
#' # get country of apple production
#' country <- sapply(strsplit(names(applejuice), split = "-"), "[", 1) 
#' plotScore(result, xPC = 1, yPC = 2, label = country) # add label
#' 
#' # or plot by group
#' plotScore(result, xPC = 1, yPC = 3, group = country) 
#' 
#' # custom point types and color
#' plotScore(result, xPC = 1, yPC = 3, group = country, pch = c(1,2), col = c("green", "black"))
#' 
#' # move legend outside
#' plotScore(result, xPC = 1, yPC = 3, group = country, legendoutside = TRUE)
#' 
#' @export
#' 
plotScore <-
function(prcompResult, xPC = 1, yPC = 2, group = NULL,
         pointsize = 1.5, label = NULL, pos = 4, col = NULL, pch = NULL,
         title = NULL,
         legendlocation = "bottomright",
         legendoutside = FALSE,
         rightwhitespace = 0,
         legendinset = 0, ...){
    
    # check if group information is provided
    is.g <- !is.null(group)
    
    # get information from prcompResult
    score <- prcompResult$x
    
    # check validity of group 
    if (is.g) {
        if (length(group) != dim(score)[1]) {
        stop("The dimension of group and sample do not match. 
           Please check your group variable.")
        }
        if (!is.factor(group) & is.null(attributes(group))) {
            group <- unclass(as.factor(group)) 
        }
        numLevels <- nlevels(group)
    } else {
        # if no group is provided, that means there is only one group
        group <- 1
        numLevels <- 1
    }
    
    # color and point type base on group
    col.palette <- generateColor(numLevels, if (!is.null(col))col)
    pch.palette <- generatePoint(numLevels, if (!is.null(pch))pch)
    col <- col.palette[group]
    pch <- pch.palette[group]
    
    # prepare plotting information
    xLabel <- prcompname(prcompResult, xPC)
    yLabel <- prcompname(prcompResult, yPC)
    if (is.null(title)) title <- paste("PC ", xPC, " vs PC ", yPC, sep = "")
    
    # set plotting area when there is legend outside
    if (is.g & isTRUE(legendoutside)) {
        # modify space if legendoutside == TRUE
        par(mar = c(5.1, 4.1, 4.1, 2.1+6+rightwhitespace), xpd = TRUE)
    }
    
    # plot
    plot(score[, xPC], score[, yPC], xlab = xLabel, ylab = yLabel,
         main = title, cex = pointsize, col = col, pch = pch)
    
    abline(v = 0, h = 0, lty = 2, col = "grey39")
    
    # put in label if label is provided
    if (!is.null(label)){
        
        # check input
        if (length(label) != dim(score)[1]) {
            stop("The dimension of label and sample do not match. \n
             Please check your label variable.")
        }
        text(score[, xPC], score[, yPC], labels = label,
             pos = pos, ...)
    }
    
    # legend for is.g
    if (is.g){
        # add legend
        if (!is.null(attributes(group))) {
            group <- levels(group) # turn unclassed factor back
        }
        
        # plot legend inside or outside
        if (isTRUE(legendoutside)){
            # plot legend outside
            # legendlocation will be overwritten if provided
            legend("topright", inset = c(-0.3-legendinset, 0), 
                   legend = as.vector(group), pch = pch.palette,
                   pt.cex = pointsize, col = col.palette, 
                   xpd=TRUE)
            # reset mar 
            par(mar = c(5.1, 4.1, 4.1, 2.1))
        } else {
            # plot legend inside
            legend(legendlocation, legend = as.vector(group), pch = pch.palette,
                   pt.cex = pointsize, col = col.palette, 
                   xpd = TRUE)
        }
    }
}
