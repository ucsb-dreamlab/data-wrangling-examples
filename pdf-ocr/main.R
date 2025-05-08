library(tesseract)
library(pdftools)
library(tidyverse)
library(curl)

source("download_attachments.R")
source("process_pdf.R")

args <- commandArgs(trailingOnly = TRUE)
filename <- "data/m9r-o1ej-xvap.csv"

if(length(args) > 0) {
  filename <- args[1]
}

df <- read_csv(filename)

# download_attachments(df)

data <- fs::dir_walk("data", recurse = TRUE, type = "file", fun = process_pdf)
