library(tesseract)
library(pdftools)

process_pdf <- function(filename) {
  print(paste("processing", filename))
  new_file <- paste0(filename, ".txt")
  if(file.exists(new_file)){
    return()
  }
  if(str_detect(filename,".*\\.pdf$")){
    text <- paste(pdf_text(filename), collapse = "\n\n")
    if(length(text) > 20 ){
      writeLines(text, new_file)
      return()
    }
    text <- paste(pdf_ocr_text(filename), collapse = "\n\n")
    writeLines(text, new_file)
  }
  # if(length(text) >)
  # pngfile <- pdftools::pdf_convert(filename, dpi = 600) 
  # pages <- tesseract::ocr(pngfile)
  # return(pages)
}

