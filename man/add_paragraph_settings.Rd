% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ooxml.R
\name{add_paragraph_settings}
\alias{add_paragraph_settings}
\title{add settings for a paragraph}
\usage{
add_paragraph_settings(
  align = "left",
  paddings = list(),
  border_widths = list(),
  border_colors = list(),
  border_styles = list(),
  shading = "transparent"
)
}
\arguments{
\item{align}{text alignment - a single character value, expected value
is one of 'left', 'right', 'center', 'justify'.}

\item{paddings}{a named list(b for bottom, t for top, l for left and r for right)
containing paragraph paddings - 0 or positive integer value.}

\item{border_widths}{a named list(b for bottom, t for top, l for left and r for right)
containing border widths - 0 or positive integer value.}

\item{border_colors}{a named list(b for bottom, t for top, l for left and r for right)
containing border colors - 0 or positive integer value.}

\item{border_styles}{a named list(b for bottom, t for top, l for left and r for right)
containing border styles. Expected values are "none" or "solid" or "dotted" or "dashed".}

\item{shading}{shading color - a single character value specifying
a valid color (e.g. "#000000" or "black").}
}
\description{
add settings for a paragraph into a Word document.
}
\examples{
add_paragraph_settings(paddings = list(t = 120, b = 20),
  border_widths = list(b = 5) )
}
