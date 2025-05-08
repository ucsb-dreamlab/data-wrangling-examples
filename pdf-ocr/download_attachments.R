library(tidyverse)
library(curl)


# Download attachment urls: assumes urls have form like
# https://downloads.regulations.gov/NOAA-NOS-2021-0080-1486/attachment_1.pdf
download_attachments <- function(df) {
  urls <- df %>% select("Attachment Files") %>% 
    filter(!is.na(`Attachment Files`)) %>% 
    separate_rows(`Attachment Files`, sep = ",") %>%
    pull(`Attachment Files`)
  
  destfiles <- urls %>%
    str_replace(paste0("^", "https://downloads.regulations.gov/"),"data/")
  # only download files that don't exist
  urls <- urls[ ! file.exists(destfiles) ]
  destfiles <- destfiles[ ! file.exists(destfiles) ]
  # create parent directories first
  for(n in dirname(destfiles)) {
    if(!dir.exists(n)) {
      dir.create(n)
    }
  }
  if(length(urls)>0) {
    multi_download(urls, destfiles = destfiles)
  }
  print("all files downloaded")
}