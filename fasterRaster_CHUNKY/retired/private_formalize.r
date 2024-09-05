#' Add ... to formals
#'
#' Add ellipse arguments to formals. Use this to help send ... to two or more functions in a wrapper. You need to do:
#' foo.plot <- function(x,y,...) {
#' 	legend <- formalize(legend) # definition is changed locally
#' 	plot(x,y,...)
#' 	legend("bottomleft", "bar", pch = 1, ...)
#' }    
#' 
#' foo.plot(1,1, xaxt = "n", title = "legend")
#'
#' @return A function.
#'
#' @details From moodymudskipper's answer at https://stackoverflow.com/questions/4124900/is-there-a-way-to-use-two-statements-in-a-function-in-r
#'
#' @keywords internal

.formalize <- function(f){
	
	formals(f) <- c(formals(f), alist(...=))
	
	# release the ... in the local environment
	body(f)    <- substitute(
		{x;y},
		list(x = quote(list2env(list(...))),
		y = body(f))
	)
	
	f
}
