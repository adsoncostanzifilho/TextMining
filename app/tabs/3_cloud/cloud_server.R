## WORD CLOUD SERVER ##

# Sentiment Words
sent_words <- reactive({
  
  if(input$lang == 'en')
  {
   return(palavras_en)
  }
  
  else if(input$lang == 'pt')
  {
    return(palavras_pt)
  }
  
  else if(input$lang == 'es')
  {
    return(palavras_es)
  }
  
})


#- Stopwords
my_stop <- reactive({
  
  stop_db <- as_tibble(
    c(
      tolower(unlist(strsplit(input$stop, "\\,\\s|\\,|\\s|\\s\\,|\\s\\,\\s"))),
      c(stopwords(input$lang), tolower(input$text), 's', 't')
    )
  )
  
  return(stop_db)
})



#- Word frequencies
word_freq <- reactive({
  db <- main_search()
  my_stopwords <- my_stop()
  
  if(input$single_doble == "single")
  {
    db_word <- db %>%
      unnest_tokens(word, text_clean) %>%
      count(word, sort = TRUE) %>%
      anti_join(my_stopwords, by = c('word' = 'value'))
    
    return(db_word)
  }
  
  else if(input$single_doble == "doble")
  {
    db_word1 <- db %>%
      filter(search_term == input$text1) %>%
      unnest_tokens(word, text_clean) %>%
      count(word, sort = TRUE) %>%
      anti_join(my_stopwords, by = c('word' = 'value'))
     
    db_word2 <- db %>%
      filter(search_term == input$text2) %>%
      unnest_tokens(word, text_clean) %>%
      count(word, sort = TRUE) %>%
      anti_join(my_stopwords, by = c('word' = 'value')) 
  
    return(list(db_word1, db_word2))
  }
  
})



#- Word Clouds

# Single word cloud
word_cloud <- reactive({
  db <- word_freq()
  db_sent <- sent_words()
  
  
  # NO Split
  if(input$div_words == 'no_split')
  {
    word_cloud_plot <- wordcloud2(db, minSize = 4)
  }
  
  # Split
  else if(input$div_words == 'split')
  {
    vet_split <<- input$show_words_split
    word_cloud_db <- left_join(db, db_sent, by = c("word" = "word")) %>%
      mutate(
        positive = as.numeric(if_else(is.na(positive), 0L, positive)),
        negative = as.numeric(if_else(is.na(negative), 0L, negative)),
        check_color = case_when(
          positive != 0 ~ 'green',
          negative != 0 ~ 'red',
          positive == 0 & negative == 0 ~ 'blue'
        ),
        color = case_when(
          positive != 0 ~ '#07e37f',
          negative != 0 ~ '#e94756',
          positive == 0 & negative == 0 ~ '#828deb'
        ),
      ) %>%
      select(word, n, check_color, color) %>%
      filter(check_color %in% vet_split)
    
    
    word_cloud_plot <- wordcloud2(word_cloud_db, minSize = 4, color = word_cloud_db$color)
    
  }
  
  
  return(word_cloud_plot)
  
  })

# Doble word cloud
word_cloud1 <- reactive({
  db_complet <- word_freq()
  db_sent <- sent_words()
  
 
  if(input$show_words_diff == "all")  
  {
    db <- db_complet[[1]] %>%
      filter(word != tolower(input$text1))
  }
  else if(input$show_words_diff == "diff")
  {
    db <- db_complet[[1]] %>%
      filter(
        word != tolower(input$text1),
        !word %in% db_complet[[2]]$word
      )
  }
  else if(input$show_words_diff == "equal")
  {
    db <- db_complet[[1]] %>%
      filter(
        word != tolower(input$text1),
        word %in% db_complet[[2]]$word
      )
  }
  
  
  # NO Split
  if(input$div_words == 'no_split')
  {
    word_cloud_plot <- wordcloud2(db, minSize = 4)
  }
  
  # Split
  else if(input$div_words == 'split')
  {
    vet_split <<- input$show_words_split
    
    word_cloud_db <- left_join(db, db_sent, by = c("word" = "word")) %>%
      mutate(
        positive = as.numeric(if_else(is.na(positive), 0L, positive)),
        negative = as.numeric(if_else(is.na(negative), 0L, negative)),
        check_color = case_when(
          positive != 0 ~ 'green',
          negative != 0 ~ 'red',
          positive == 0 & negative == 0 ~ 'blue'
        ),
        color = case_when(
          positive != 0 ~ '#07e37f',
          negative != 0 ~ '#e94756',
          positive == 0 & negative == 0 ~ '#828deb'
        ),
      ) %>%
      select(word, n, check_color, color) %>%
      filter(check_color %in% vet_split) %>%
      arrange(desc(n))
    
    
    word_cloud_plot <- wordcloud2(word_cloud_db, minSize = 4, color = word_cloud_db$color)
    
  }
  
  
  return(word_cloud_plot)
  
})

word_cloud2 <- reactive({
  db_complet <- word_freq()
  db_sent <- sent_words()
  
  if(input$show_words_diff == "all")  
  {
    db <- db_complet[[2]] %>%
      filter(word != tolower(input$text2))
  }
  else if(input$show_words_diff == "diff")
  {
    db <- db_complet[[2]] %>%
      filter(
        word != tolower(input$text2),
        !word %in% db_complet[[1]]$word
      )
  }
  else if(input$show_words_diff == "equal")
  {
    db <- db_complet[[2]] %>%
      filter(
        word != tolower(input$text2),
        word %in% db_complet[[1]]$word
      )
  }
  
  
  
  # NO Split
  if(input$div_words == 'no_split')
  {
    word_cloud_plot <- wordcloud2(db, minSize = 4)
  }
  
  # Split
  else if(input$div_words == 'split')
  {
    vet_split <<- input$show_words_split
    word_cloud_db <- left_join(db, db_sent, by = c("word" = "word")) %>%
      mutate(
        positive = as.numeric(if_else(is.na(positive), 0L, positive)),
        negative = as.numeric(if_else(is.na(negative), 0L, negative)),
        check_color = case_when(
          positive != 0 ~ 'green',
          negative != 0 ~ 'red',
          positive == 0 & negative == 0 ~ 'blue'
        ),
        color = case_when(
          positive != 0 ~ '#07e37f',
          negative != 0 ~ '#e94756',
          positive == 0 & negative == 0 ~ '#828deb'
        ),
      ) %>%
      select(word, n, check_color, color) %>%
      filter(check_color %in% vet_split) %>%
      arrange(desc(n))
    
    
    word_cloud_plot <- wordcloud2(word_cloud_db, minSize = 4, color = word_cloud_db$color)
    
  }
  
  
  return(word_cloud_plot)
  
})


#- Word Cloud UI Return
word_cloud_ui <- reactive({
  if(input$single_doble == "single")
  {
    word_cloud_ui <- fluidRow(
      box(
        width = 10,
        h1("Word Cloud of", input$text),
        
        hr(),
        wordcloud2Output('word_cloud')
      )
    )
  }
  
  else if(input$single_doble == "doble")
  {
    word_cloud_ui <- fluidRow(
      box(
        width = 12,
        
        column(
          width = 6,
          class = "preview",
          
          h1("Word Cloud of", input$text1),
          
          hr(),
          
          wordcloud2Output('word_cloud1')
          
        ),
        
        column(
          width = 6,
          class = "preview",
          
          h1("Word Cloud of", input$text2),
          
          hr(),
          
          wordcloud2Output('word_cloud2')
        )
        
      )
    )
    
    
  }

  
  return(word_cloud_ui)
})


#- OUTPUTS   
output$word_cloud <- renderWordcloud2(word_cloud())
output$word_cloud1 <- renderWordcloud2(word_cloud1())
output$word_cloud2 <- renderWordcloud2(word_cloud2())

output$word_cloud_ui <- renderUI(word_cloud_ui())






# #-  FREQUENCIA PALAVRAS
# palavras_freq <- reactive({
#   db <- pesquisa()
  # my_stop <- as_tibble(
  #   c(
  #     unlist(strsplit(input$stop, "\\,\\s|\\,|\\s|\\s\\,|\\s\\,\\s")),
  #     c(stopwords(input$lang), tolower(input$text))
  #   )
  # )
#   
#   palavras <- db %>%
#     unnest_tokens(word, text_limpo) %>%
#     count(word, sort = TRUE) %>%
#     anti_join(my_stop, by = c('word' = 'value'))
#   
#   return(palavras)
# })
# 
# 
# #- WORD CLOUD
# word_cloud <- reactive({
#   d <- palavras_freq()
#   freq_min <- input$freq_min
#   div_words <- input$div_words
#   show_words <- input$show_words
#   
#   if(input$lang == 'pt')
#   {
#     palavras <- palavras_pt %>%
#       select(word, positive, negative)
#   }
#   
#   if(input$lang == 'es')
#   {
#     palavras <- palavras_es %>%
#       select(word, positive, negative)
#   }
#   
#   if(input$lang == 'en')
#   {
#     palavras <- palavras_en %>%
#       select(word, positive, negative)
#   }
#   
#   if(div_words == TRUE)
#   {
#     d <- left_join(d, palavras, by = c("word" = "word")) %>%
#       mutate(
#         positive = as.numeric(if_else(is.na(positive), 0L, positive)),
#         negative = as.numeric(if_else(is.na(negative), 0L, negative)),
#         cores = case_when(
#           positive != 0 ~ 'green',
#           negative != 0 ~ 'red',
#           positive == 0 & negative == 0 ~ 'blue'
#         )) %>%
#       select(word, n, cores) %>%
#       filter(cores %in% show_words)
#     
#     grafico1 <- wordcloud2(d, minSize = freq_min, color = d$cores)
#   }
#   
#   if(div_words == FALSE)
#   {
#     grafico1 <- wordcloud2(d, minSize = freq_min)
#   }
#   
#   
#   return(grafico1)
#   
# })
# 
# 
# #- OUTPUTS   
# output$grafico1 <- renderWordcloud2(word_cloud())

