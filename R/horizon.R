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
#' @param utc Whether to use the local timezone (\code{FALSE})
#' or UTC (\code{TRUE}).
#' @param military Whether to show time in 24h or 12h (am/pm) format.
#' @param bands Number of horizon bands to use.
#' @param mode Mode used to represent negative values. 
#' \code{offset} renders the negative values from the top of the chart 
#' downwards, while /code{mirror} represents them upwards as if they 
#' were positive values, albeit with a different color.
#' @param normalize Whether to normalize all series Y axis to the same extent, 
#' in order to compare series in absolute terms. It defines the behavior of the 
#' dynamic calculation of the max Y, when \code{extent} is not explicitly set. 
#' If \code{TRUE}, the extent is calculated as the global maximum value of all 
#' the data points combined across all series. If \code{FALSE}, each series extent 
#' will be based on their own local maximum.
#' @param scale Set the y-axis scale exponent. Only values > 0 are supported. 
#' An exponent of 1 (default) represents a linear Y scale. A function 
#' (\link[htmlwidgets]{JS}) receives the series ID as input and should return a 
#' numeric value. A number sets the same scale exponent for all the series.
#' @param positive_colors,negative_colors Colors to use for the positive and 
#' negative value bands.
#' @param positive_colors_stops,negative_colors_stops Each stop represents an 
#' interpolation ratio and only values between \code{]0, 1[} (excluding) are permitted. 
#' The stops are used to interpolate the middle colors in \code{*_colors} and are 
#' only applicable if there are more than 2 colors. If the number of stops is less 
#' than number of middle colors, linear interpolation is used to populate the remaining
#' stops. A value of \code{NULL} (default) results in complete linear interpolation.
#' @param aggregation A function (\link[htmlwidgets]{JS}) to reduce multiple values 
#' to a single number, in case there is more than one \code{y} value per unique \code{x}
#' and \code{group} (in \code{\link{attrs}}).
#' @param extent JavaScript function or number to set the y-axis maximum absolute value. 
#' By default (\code{NULL}), the max Y is calculated dynamically from the data. 
#' A function (\link[htmlwidgets]{JS}) receives the series ID as input and should return 
#' a numeric value. A numeric sets the same extent for all the series.
#' @param interpolation_curve Interpolation curve function used to draw lines between points. 
#' Should be a \href{https://github.com/d3/d3-shape#curves}{d3 curve function}. A falsy value
#'  sets linear interpolation (\href{https://github.com/d3/d3-shape#curveLinear}{curveLinear}).
#' @param ruler Whether to show the ruler. 
#' @param zoom Whether to enable pointer-based zoom interactions on the chart, along the time 
#' (x-axis) dimension.
#' @param transition Duration (in milliseconds) of the transitions between data states.
#' 
#' @examples
#' horizon(tsdata, attrs(x = dates, y = value, group = grp))
#' 
#' @import purrr
#' @import htmlwidgets
#' @import assertthat
#'
#' @export
horizon <- function(data, ..., utc = TRUE, military = TRUE, bands = 4L, mode = c("offset", "mirror"), 
  normalize = FALSE, scale = 1L, positive_colors = c("white", "midnightBlue"), negative_colors = c("white", "crimson"), 
  interpolation_curve = NULL, ruler = TRUE, zoom = FALSE, transition = FALSE, positive_colors_stops = NULL, 
  negative_colors_stops = NULL, aggregation = NULL, extent = NULL, width = "100%", height = NULL, elementId = NULL) {
  
    mode <- match.arg(mode)
  
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
    negativeColorsStops = negative_colors_stops,
    interpolationCurve = interpolation_curve,
    showRuler = ruler,
    enableZoom = zoom,
    transitionDuration = transition
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'horizon',
    x,
    width = width,
    height = height,
    package = 'horizon',
    elementId = elementId,
    preRenderHook = render_horizon,
    sizingPolicy = htmlwidgets::sizingPolicy(
      padding = 0,
      browser.fill = TRUE
    )
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
