## CLOUD SERVER ##

#-  FREQUENCIA PALAVRAS
palavras_freq <- reactive({
  db <- pesquisa()
  my_stop <- as_tibble(
    c(
      unlist(strsplit(input$stop, "\\,\\s|\\,|\\s|\\s\\,|\\s\\,\\s")), 
      c(stopwords(input$lang), tolower(input$text))
    )
  )
  
  palavras <- db %>%
    unnest_tokens(word, text_limpo) %>%
    count(word, sort = TRUE) %>%
    anti_join(my_stop, by = c('word' = 'value'))
  
  return(palavras)
})


#- WORD CLOUD
word_cloud <- reactive({
  d <- palavras_freq()
  freq_min <- input$freq_min
  div_words <- input$div_words
  show_words <- input$show_words
  
  if(input$lang == 'pt')
  {
    palavras <- palavras_pt %>%
      select(word, positive, negative)
  }
  
  if(input$lang == 'es')
  {
    palavras <- palavras_es %>%
      select(word, positive, negative)
  }
  
  if(input$lang == 'en')
  {
    palavras <- palavras_en %>%
      select(word, positive, negative)
  }
  
  if(div_words == TRUE)
  {
    d <- left_join(d, palavras, by = c("word" = "word")) %>%
      mutate(
        positive = as.numeric(if_else(is.na(positive), 0L, positive)),
        negative = as.numeric(if_else(is.na(negative), 0L, negative)),
        cores = case_when(
          positive != 0 ~ 'green',
          negative != 0 ~ 'red',
          positive == 0 & negative == 0 ~ 'blue'
        )) %>%
      select(word, n, cores) %>%
      filter(cores %in% show_words)
    
    grafico1 <- wordcloud2(d, minSize = freq_min, color = d$cores)
  }
  
  if(div_words == FALSE)
  {
    grafico1 <- wordcloud2(d, minSize = freq_min)
  }
  
  
  return(grafico1)
  
})


#- OUTPUTS   
output$grafico1 <- renderWordcloud2(word_cloud())


#- DOWNLOADS
output$freq_palavras<-downloadHandler(
  filenam = function()
  {
    paste0('freq_palavras','.csv')
  },
  content = function(arquivo)
  {
    write.table(palavras_freq(), arquivo, sep = ";", row.names = FALSE)
  }
)