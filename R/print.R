printMapview = function (x) {

  ## normal htmlwidget printing for notebooks etc.
  ## set options fgb & georaster to FALSE!!
  if (!isTRUE(mapviewGetOption("fgb")) & !isTRUE(mapviewGetOption("georaster"))) {
    print(mapview2leaflet(x))
    # invisible(x)
    return(invisible())
  }

  ## convert to leaflet object
  x = mapview2leaflet(x)
  viewer = getOption("viewer")
  if (mapviewGetOption("viewer.suppress")) {
    viewer = NULL
  }
  if (!is.null(viewer)) {
    viewerFunc = function(url) {
      paneHeight = x$sizingPolicy$viewer$paneHeight
      if (identical(paneHeight, "maximize")) {
        paneHeight = -1
      }
      viewer(url, height = paneHeight)
    }
  } else {
    viewerFunc = function(url) {
      dir = gsub("file://|/index.html", "", url)
      rs = requireNamespace("rstudioapi", quietly = TRUE)
      if (rs) {
        if (mapviewGetOption("viewer.suppress") &
            rstudioapi::isAvailable()) {
          fl = file.path(dir, "index.html")
          utils::browseURL(fl)
        } else {
          servr::httd(
            dir = dir
            , verbose = FALSE
          )
        }
      } else {
        servr::httd(
          dir = dir
          , verbose = FALSE
        )
      }
    }
  }
  htmltools::html_print(
    htmltools::as.tags(x, standalone = TRUE)
    , viewer = if (interactive()) viewerFunc
  )
  invisible(x)
}

#' Method for printing mapview objects
#' @param x a mapview object
#'
setMethod('print', signature(x = "mapview"), printMapview)

#' Method for printing mapview objects (show)
#' @param object a mapview object
setMethod("show", signature(object = "mapview"),
          function(object) {
            print(object)
          }
)


#' Print functions for mapview objects used in knitr
#'
#' @param x A mapview object
#' @param ... further arguments passed on to \code{\link[knitr]{knit_print}}
#'
#' @rawNamespace
#' if(getRversion() >= "3.6.0") {
#'   S3method(knitr::knit_print, mapview)
#' } else {
#'   export(knit_print.mapview)
#' }
#'
knit_print.mapview = function(x, ...) {
  knitr::knit_print(mapview2leaflet(x), ...)
}
