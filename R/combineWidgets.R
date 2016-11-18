#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
combineWidgets <- function(..., nrow = NULL, ncol = NULL, rowsize = 1, colsize = 1,
                           width = NULL, height = NULL) {
  widgets <- lapply(list(...), function(x) {
    if (is.null(x$preRenderHook)) return(x)
    x$preRenderHook(x)
  })
  nwidgets <- length(widgets)

  # Get number of rows and cols
  if (!is.null(nrow) && !is.null(ncol) && nrow * ncol < nwidgets) {
    stop("There are too much widgets compared to the number of rows and columns")
  } else if (is.null(nrow) && !is.null(ncol)) {
    nrow <- ceiling(nwidgets / ncol)
  } else if (!is.null(nrow) && is.null(ncol)) {
    ncol <- ceiling(nwidgets / nrow)
  } else {
    nrow <- ceiling(sqrt(nwidgets))
    ncol <- ceiling(nwidgets / nrow)
  }

  # Get the html ID of each widget
  elementId <- sapply(widgets, function(x) {
    res <- x$elementId
    if (is.null(res)) res <- paste0("widget", floor(runif(1, max = 1e9)))
    res
  })

  # Constrcut the html of the combined widget
  widgetEL <- sapply(elementId, function(x) {
    sprintf('<div class="cw-col" style="flex:1;-webkit-flex:1"><div id="%s" class="cw-widget"></div></div>', x)
  })

  rowsEl <- lapply(1:nrow, function(i) {
    content <- widgetEL[((i-1) * ncol + 1):(i * ncol)]
    sprintf('<div class="cw-row" style="flex:1;-webkit-flex:1">%s</div>', paste(content, collapse = ""))
  })

  html <- sprintf('<div class="cw-container">%s</div>',
                  paste(rowsEl, collapse = ""))

  data <- lapply(widgets, function(x) x$x)
  widgetType <- sapply(widgets, function(x) class(x)[1])


  x <- list(data = data, widgetType = widgetType, elementId = elementId, html = html);

  # create widget
  combinedWidget <- htmlwidgets::createWidget(
    name = 'combineWidgets',
    x,
    width = width,
    height = height,
    package = 'combineWidgets'
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
