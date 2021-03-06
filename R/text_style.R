#' @importFrom grDevices col2rgb rgb
is.color = function(x) {
  # http://stackoverflow.com/a/13290832/3315962
  out = sapply(x, function( x ) {
    tryCatch( is.matrix( col2rgb( x ) ), error = function( e ) F )
  })

  nout <- names(out)
  if( !is.null(nout) && any( is.na( nout ) ) )
    out[is.na( nout )] = FALSE

  out
}

to_rgb <- function(x){
  str <- do.call(rgb, as.list(col2rgb( x ) / 255) )
  gsub("^#", "", str)
}
to_alpha <- function(x){
  as.numeric( col2rgb( x, alpha = TRUE) [4,1] / 255 )
}

is_visible <- function(x)
  as.logical(col2rgb( x, alpha = TRUE) [4,1] > 0)

valid_pos_num <- function(x) is.null(x) || ( !is.null(x) && is.numeric( x ) && length(x) == 1  && x >= 0 )
valid_bool <- function(x) is.null(x) || ( !is.null(x) && is.logical( x ) && length(x) == 1 )
valid_char <- function(x) is.null(x) || ( !is.null(x) && is.character( x ) && length(x) == 1 )

text_style <- function( color = "black", size = NULL,
                     bold = FALSE, italic = FALSE, underlined = FALSE,
                     font = NULL,
                     valign = "baseline",
                     shading = "transparent" ){

  obj <- list()

  if( !is.null(color) && !is.color( color ) )
    stop("color must be a valid color.", call. = FALSE )
  else obj$color <- color

  if( !valid_pos_num(size) )
    stop("size must be a valid positive integer scalar.", call. = FALSE )
  else obj$size <- as.integer(size)

  if( !valid_bool(bold) )
    stop("bold must be a valid scalar logical.", call. = FALSE )
  else obj$bold <- bold

  if( !valid_bool(italic) )
    stop("italic must be a valid scalar logical.", call. = FALSE )
  else obj$italic <- italic

  if( !valid_bool(underlined) )
    stop("underlined must be a valid logical scalar.", call. = FALSE )
  else obj$underlined <- underlined

  if( !valid_char(font) )
    stop("font must be a valid character scalar.", call. = FALSE )
  else obj$font <- font

  choices_valign <- c("subscript", "superscript", "baseline")
  if( !valid_char(valign) )
    stop("valign must be a valid character scalar.", call. = FALSE )
  else if( ! valign %in% choices_valign )
    stop("valign must be one of ", paste( shQuote(choices_valign), collapse = ", "), call. = FALSE )
  obj$valign <- valign

  if( !is.null(shading) && !is.color( shading ) )
    stop("shading must be a valid color.", call. = FALSE )
  else obj$shading <- shading

  class( obj ) <- "text_style"

  obj
}


format_text_style_docx <- function(x){
  os <- ""
  os <- paste0(os, "<w:rPr xmlns:w14=\"http://schemas.microsoft.com/office/word/2010/wordml\">")

  if( !is.null(x$font) ){
    os <- paste0(os, "<w:rFonts")
    os <- paste0(os, " w:ascii=", shQuote(x$font) )
    os <- paste0(os, " w:hAnsi=", shQuote(x$font) )
    os <- paste0(os, " w:cs=", shQuote(x$font) )
    os <- paste0(os, "/>")
  }


  if( x$italic ) os <- paste0(os, "<w:i/>")
  if( x$bold ) os <- paste0(os, "<w:b/>")
  if( x$underlined ) os <- paste0(os, "<w:u/>")

  if( !"baseline" %in% x$valign ){
    os <- paste0(os, sprintf("<w:vertAlign w:val=\"%s\"/>", x$valign) )
  }

  if( !is.null(x$size) ){
    os <- paste0(os, sprintf("<w:sz w:val=\"%.0f\"/>", x$size*2) )
    os <- paste0(os, sprintf("<w:szCs w:val=\"%.0f\"/>", x$size*2) )
  }
  if( !is.null(x$color) && is_visible(x$color) ){
    os <- paste0(os, sprintf("<w:color w:val=\"%s\"/>", to_rgb(x$color)) )
  }
  if( !is.null(x$shading) && is_visible(x$shading) ){
    os <- paste0(os, sprintf("<w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"%s\"/>", to_rgb(x$shading)) )
  }

  if( !is.null(x$color) && is_visible(x$color) && to_alpha(x$color) < 1 ){
    sf <- sprintf("<w14:solidFill><w14:srgbClr val=\"%s\"><w14:alpha val=\"%.0f\"/></w14:srgbClr></w14:solidFill>",
                  to_rgb(x$color), to_alpha(x$color)* 100000 )
    os <- paste0(os, sprintf("<w14:textFill>%s</w14:textFill>", sf) )
  }
  os <- paste0(os, "</w:rPr>")
  os
}

