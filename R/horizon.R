#' Initialise
#'
#' Initialise an horizon plot.
#'
#' @param data A \code{data.frame} or \link[tibble]{tibble}.
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param elementId Id of element.
#' @param ... Attributes, specified using \code{\link{attrs}}.
#' 
#' @import purrr
#' @import htmlwidgets
#' @import assertthat
#'
#' @export
horizon <- function(data, ..., utc = TRUE, military = TRUE, bands = 4L, mode = c("offset", "mirror"), 
  normalize = FALSE, scale = 1L, positive_colors = c("white", "midnightBlue"), negative_colors = c("white", "crimson"), 
  positive_colors_stops = NULL, negative_colors_stops = NULL, aggregation = NULL, extent = NULL, width = NULL, height = NULL, elementId = NULL) {
  
    mode <- match.args(mode)
  
  # must pass data
  assert_that(not_missing(data))

  # extract & process coordinates
  attrs <- get_attrs(...)
  assert_that(has_attrs(attrs))
  columns <- attrs_to_columns(attrs)

  x = list(
    data = data,
    series = attrs_to_opts(attrs, "group"),
    ts = attrs_to_opts(attrs, "x"),
    val = attrs_to_opts(attrs, "y"),
    useUtc = utc,
    use24h = military,
    horizonBands = bands,
    horizonMode = mode,
    yNormalize = normalize,
    yScaleExp = scale,
    yExtent = extent,
    yAggregation = aggregation,
    positiveColors = positive_colors,
    positiveColorStops = positive_colors_stops,
    negativeColors = negative_colors,
    negativeColorsStops = negative_colors_stops
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'horizon',
    x,
    width = width,
    height = height,
    package = 'horizon',
    elementId = elementId,
    preRenderHook = render_horizon
  )
}

render_horizon <- function(h){
  h$x$data <- apply(h$x$data, 1, as.list)
  return(h)
}

#' Shiny bindings for horizon
#'
#' Output and render functions for using horizon within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a horizon
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name horizon-shiny
#'
#' @export
horizonOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'horizon', width, height, package = 'horizon')
}

#' @rdname horizon-shiny
#' @export
renderHorizon <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, horizonOutput, env, quoted = TRUE)
}
