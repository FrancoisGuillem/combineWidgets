#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
combineWidgets <- function(..., width = NULL, height = NULL) {
  widgets <- list(...)

  data <- lapply(widgets, function(x) x$x)
  widgetType <- sapply(widgets, function(x) class(x)[1])
  elementId <- sapply(widgets, function(x) {
    res <- x$elementId
    if (is.null(res)) res <- paste0("widget", floor(runif(1, max = 1e9)))
    res
  })

  x <- list(data = data, widgetType = widgetType, elementId = elementId);

  # create widget
  combinedWidget <- htmlwidgets::createWidget(
    name = 'combineWidgets',
    x,
    width = width,
    height = height,
    package = 'combineWidgets',
  )

  deps <- lapply(widgets, function(x) {
    append(getDependency(class(x)[1], attr(x, "package")), x$dependencies)
  })
  deps <- do.call(c, deps)

  combinedWidget$dependencies <- deps

  combinedWidget
}

#' Shiny bindings for combineWidgets
#'
#' Output and render functions for using combineWidgets within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a combineWidgets
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name combineWidgets-shiny
#'
#' @export
combineWidgetsOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'combineWidgets', width, height, package = 'combineWidgets')
}

#' @rdname combineWidgets-shiny
#' @export
renderCombineWidgets <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, combineWidgetsOutput, env, quoted = TRUE)
}
