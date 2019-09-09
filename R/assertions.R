not_missing <- function(x) {
  !missing(x)
}

on_failure(not_missing) <- function(call, env) {
  paste0(
    "Missing `",
    crayon::red(deparse(call$x)),
    "`."
  )
}

has_attrs <- function(x){
  if(is.null(x))
    return(FALSE)
  if(!length(x))
    return(FALSE)
  return(TRUE)
}

on_failure(has_attrs) <- function(call, env) {
  "No attributes found, see `attrs`."
}