#' @importFrom stats aggregate
NULL
#' Calculating paleo diversity curves using the Range Through method
#'
#' \code{plotRawFossilOccs} calculates and plots the early and late boundaries 
#' associated with each taxa in A dataset.
#'
#' @param data A \code{data.frame} containing fossil data on the age (early and 
#' late bounds of rock layer, respectively labeled as \code{max_ma} and 
#' \code{min_ma}) and the taxonomic level asked in \code{tax_lv}.
#' @param tax_lvl A \code{character} giving the taxonomic in which 
#' calculations will be based on, which must refer to the column names in 
#' \code{data}. If \code{NULL} (default value), the function plots every 
#' individual occurrences in \code{data}.
#' @param sort \code{logical} indicating if taxa should be sorted by their 
#' \code{max_ma} values (default value is \code{TRUE}). Otherwise (i.e., if 
#' \code{FALSE}), function will follow the order of taxa (or occurrences) 
#' inputted in \code{data}.
#' @param use_midpoint \code{logical} indicating if function should use 
#' occurrence midpoints (between \code{max_ma} and \code{min_ma}) as "true" 
#' occurrence temporal boundaries, a method commonly employed in paleobiology 
#' to remove noise related to extremely coarse temporla resolution due to 
#' stratification.
#' @param return_ranges \code{logical} indicating if ranges calculated by 
#' function should be return as a \code{data.frame}. If \code{tax_lvl} is 
#' \code{NULL}, the function don't calculate ranges and so it has nothing 
#' to return.
#' @return A \code{data.frame} containing the diversity (column \code{div}) of 
#' the chosen taxonomic level, through time - with time moments being a 
#' sequence of arbitrary numbers based on \code{bin_reso}
#' 
#' @export plotRawFossilOccs
#' 
#' @references 
#' 
#' ADD REFERENCE
#' 
#' @author Matheus Januario, Jennifer Auler
#' 
#' @examples
#' 
#' data("ammonoidea_fossil")
#' par(mfrow=c(1,2))
#' plotRawFossilOccs(ammonoidea_fossil, tax_lvl = "species")
#' plotRawFossilOccs(ammonoidea_fossil, tax_lvl = "genus")
#' 
plotRawFossilOccs <- function(data, tax_lvl=NULL, sort=TRUE, use_midpoint=TRUE, return_ranges=FALSE){
  
  title="Occurrence"
  
  if(is.null(tax_lvl) & use_midpoint){
    message(" if tax_lvl is not supplied, argument use_midpoint will be set to FALSE")
    use_midpoint=FALSE
  }
  
  if(!is.null(tax_lvl)){
    if(tax_lvl %in% colnames(data)){
      
      title = tax_lvl
      
      if(use_midpoint){
        
        data$midpoint = (data$max_ma-data$min_ma)/2 + data$min_ma
        
        aux1=aggregate(data$midpoint, by=list(data[,tax_lvl]), max, na.rm=T)
        colnames(aux1)=c("taxon", "max_ma")
        
        aux2=aggregate(data$midpoint, by=list(data[,tax_lvl]), min, na.rm=T)
        colnames(aux2)=c("taxon", "min_ma") 
      }else{
        aux1=aggregate(data$max_ma, by=list(data[,tax_lvl]), max, na.rm=T)
        colnames(aux1)=c("taxon", "max_ma")
        
        aux2=aggregate(data$min_ma, by=list(data[,tax_lvl]), min, na.rm=T)
        colnames(aux2)=c("taxon", "min_ma") 
      }
      
      data= merge(aux1, aux2)
    }else{
      stop("data do not have a column with this taxonomic level")
    }
  }
  
  if(sort){
    data <- data[order(data$max_ma, decreasing = T),]
  }
  
  
  if(is.null(tax_lvl)){
    ylab_text="Fossil occurrences"  
  }else{
    ylab_text=paste0(tax_lvl, " temporal ranges")
  }
  
  plot(NA, 
       ylim=c(0, nrow(data)),
       xlim=rev(range(c(data$max_ma, data$min_ma))), frame.plot = F, yaxt="n",
       ylab=ylab_text, xlab="Absolute time (Mya)", main=paste0(title, " level; N = ", nrow(data)," taxa")
  )
  
  segments(x0 = data$max_ma, y0 = 1:nrow(data),
           x1 = data$min_ma, y1 = 1:nrow(data))
  
  if(return_ranges){
    if(is.null(tax_lvl)){
      stop("no range is calculated if \"tax_lvl\" is NULL")
    }
    return(data)
  }
}