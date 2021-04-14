#--- FUNCTIONS ---#
require(dplyr)
require(magrittr)
require(purrr)
require(qdapRegex)

#- Function to clean texts
clean_text <- function(texto)
{
  texto <- texto %>%
    rm_url() %>%
    gsub("[[:punct:][:blank:]]+", " ", .) %>%
    gsub("\n", " ", .) %>%
    iconv(.,from="UTF-8", to="ASCII//TRANSLIT") %>%
    tolower()
  
  return(texto)
}



