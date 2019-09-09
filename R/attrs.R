#' Attributes
#' 
#' Attributes to draw horizon plot.
#' 
#' @param x,y,... List of name value pairs giving attributes to map to
#'  variables. The names for x and y aspects are typically omitted because
#'  they are so common; all other aspects must be named.
#' 
#' @section Coordinates:
#' Valid coordinates (depending on layer).
#' \itemize{
#'   \item{\code{x}, \code{y}}
#'   \item{\code{val}}
#' }
#' 
#' @export
attrs <- function(x, y, ...) {
  exprs <- rlang::enquos(x = x, y = y, ..., .ignore_empty = "all")
  aes <- new_aes(exprs, env = parent.frame())
  .construct_aesthetics(aes)
}

# construct aesthetics for re-use
.construct_aesthetics <- function(aes, cl = NULL){
  class <- "attrs"
  if(!is.null(cl))
    class <- append(class, cl)
  structure(aes, class = c(class, class(aes)))
}

# Wrap symbolic objects in quosures but pull out constants out of
# quosures for backward-compatibility
new_aesthetic <- function(x, env = globalenv()) {
  if (rlang::is_quosure(x)) {
    if (!rlang::quo_is_symbolic(x)) {
      x <- rlang::quo_get_expr(x)
    }
    return(x)
  }

  if (rlang::is_symbolic(x)) {
    x <- rlang::new_quosure(x, env = env)
    return(x)
  }

  x
}

new_aes <- function(x, env = globalenv()) {
  stopifnot(is.list(x))
  x <- lapply(x, new_aesthetic, env = env)
  structure(x, class = c("uneval"))
}

#' @export
print.uneval <- function(x, ...) {
  cat("Aesthetics: \n")

  if (length(x) == 0) {
    cat("<empty>\n")
  } else {
    values <- vapply(x, rlang::quo_label, character(1))
    bullets <- paste0("* ", format(paste0("`", names(x), "`")), " -> ", values, "\n")

    cat(bullets, sep = "")
  }

  invisible(x)
}

#' @export
"[.uneval" <- function(x, i, ...) {
  new_aes(NextMethod())
}

# If necessary coerce replacements to quosures for compatibility
#' @export
"[[<-.uneval" <- function(x, i, value) {
  new_aes(NextMethod())
}
#' @export
"$<-.uneval" <- function(x, i, value) {
  # Can't use NextMethod() because of a bug in R 3.1
  x <- unclass(x)
  x[[i]] <- value
  new_aes(x)
}
#' @export
"[<-.uneval" <- function(x, i, value) {
  new_aes(NextMethod())
}

# is aesthetic?
is_attrs <- function(x, cl = "attrs"){
  aes <- FALSE
  if(inherits(x, cl))
    aes <- TRUE
  return(aes)
}

# retrieve aesthetics
get_attrs <- function(...){
  aes <- list(...) %>% 
    keep(is_attrs) 

  if(length(aes))
    aes[[1]]
  else
    list()
}

# mutate aesthetics
mutate_aes <- function(main_aes = NULL, aes = NULL, inherit = TRUE){

  if(is.null(aes) && isTRUE(inherit))
    return(main_aes)

  if(isTRUE(inherit)){
    # aes overrides main_aes
    main_aes <- main_aes[!names(main_aes) %in% names(aes)]
    combined <- append(aes, main_aes)
    return(combined)
  }

  return(aes)
}

# conver to name for selection
attrs_to_columns <- function(attrs){
  keep(attrs, function(x){
    !rlang::is_bare_atomic(x)
  }) %>% 
    map(rlang::as_label) %>% 
    unname() %>% 
    unlist()
}

# coordinate to JSON options
attrs_to_opts <- function(attrs, var){
  if(rlang::is_null(attrs[[var]]))
    return(NULL)
  if(rlang::is_bare_atomic(attrs[[var]]))
    return(attrs[[var]])
  rlang::as_label(attrs[[var]])
}