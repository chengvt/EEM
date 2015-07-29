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
#' the samples into groups. Able to accept up to two groups which can be stated by
#' group = c(group1, group2)
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
    # assign false to twogroup if is.g == FALSE
    if (!is.g) twogroup <- FALSE 
    
    # get information from prcompResult
    score <- prcompResult$x
    numSample <- dim(score)[1]
    
    # check validity of group 
    if (is.g) {
        
        # check length
        if (length(group) %% numSample != 0) {
        stop("The dimension of group and sample do not match. 
           Please check your group variable.")
        }
        
        # check if two different groups were provided
        if (length(group) / numSample == 2) {
            group2 <- group[(numSample+1):(numSample*2)]
            group <- group[1:numSample]
            twogroup <- TRUE
        } else { 
            twogroup <- FALSE 
        }
                
        # turn into factor if it isn't already
        if (!is.factor(group) & is.null(attributes(group))) {
            group <- unclass(as.factor(group))
            if (twogroup) group2 <- unclass(as.factor(group2))             
        }
        numLevels <- nlevels(group)
        if (twogroup) numLevels2 <- nlevels(group2)
    } else {
        # if no group is provided, that means there is only one group
        group <- 1
        numLevels <- 1
    }
    
    # color and point type base on group
    col.palette <- generateColor(numLevels, if (!is.null(col))col)
    col <- col.palette[group]
    
    # if twogroups are present assign pch to group2 instead
    if (twogroup){    
        pch.palette <- generatePoint(numLevels2, if (!is.null(pch))pch)
        pch <- pch.palette[group2]
    } else {
        pch.palette <- generatePoint(numLevels, if (!is.null(pch))pch)
        pch <- pch.palette[group]
    }
    
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
        # turn unclassed factor back 
        if (!is.null(attributes(group))) {
            group <- levels(group) 
            if (twogroup) group2 <- levels(group2)
        }
        
        # plot legend inside or outside
        if (legendoutside){
            # plot legend outside
            # legendlocation will be overwritten if provided
            if (!twogroup) {
                legend("topright", inset = c(-0.3-legendinset, 0), 
                       legend = as.vector(group), pch = pch.palette,
                       pt.cex = pointsize, col = col.palette, 
                       xpd=TRUE)
            } else {
                group <- c(group, NA, group2)
                col.palette <- c(col.palette, NA, rep("black", numLevels2))
                pch.palette <- c(rep(15, numLevels), NA, pch.palette)
                legend("topright", inset = c(-0.3-legendinset, 0), 
                       legend = as.vector(group), pch = pch.palette,
                       pt.cex = pointsize, col = col.palette, 
                       xpd=TRUE)
            }
 
            # reset mar 
            par(mar = c(5.1, 4.1, 4.1, 2.1))
            
        } else {
            # plot legend inside
            if (twogroup){ 
                group <- c(group, NA, group2)
                col.palette <- c(col.palette, NA, rep("black", numLevels2))
                pch.palette <- c(rep(15, numLevels), NA, pch.palette)
            }
            
            legend(legendlocation, legend = as.vector(group), pch = pch.palette,
                   pt.cex = pointsize, col = col.palette, 
                   xpd = TRUE)
        }
    }
}
