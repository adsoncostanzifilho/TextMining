#--- FUNCTIONS ---#
require(twitteR)
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

#- Function to search terms on twitter
search_twitter <- function(termo, idioma, num)
{

  busca <- searchTwitteR(searchString = termo, lang = idioma, n = num)
  
  if(is_empty(busca))
  {
    db <- as_tibble()
  }
  
  if(!is_empty(busca))
  {
    db <- do.call("rbind", lapply(busca, as.data.frame)) %>%
      as_tibble() %>%
      mutate(text_limpo = clean_text(text),
             date = as.Date(created, fomat = "Y/%m/%d")) %>%
      select(screenName, text, text_limpo, id, date, latitude, longitude)
    
    
  }
  return(db)
}




