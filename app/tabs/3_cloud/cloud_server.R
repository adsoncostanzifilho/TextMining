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
      c(stopwords(input$lang), tolower(input$text), 's', 't', 'rt')
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
      anti_join(my_stopwords, by = c('word' = 'value')) %>%
      filter(n >= 2)
    
    return(db_word)
  }
  
  else if(input$single_doble == "doble")
  {
    db_word1 <- db %>%
      filter(search_term == input$text1) %>%
      unnest_tokens(word, text_clean) %>%
      count(word, sort = TRUE) %>%
      anti_join(my_stopwords, by = c('word' = 'value')) %>%
      filter(n >= 2)
     
    db_word2 <- db %>%
      filter(search_term == input$text2) %>%
      unnest_tokens(word, text_clean) %>%
      count(word, sort = TRUE) %>%
      anti_join(my_stopwords, by = c('word' = 'value')) %>%
      filter(n >= 2)
  
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
    cust_col <- rep(c('#f94144','#f3722c','#f8961e','#f9c74f', '#90be6d', '#43aa8b', '#577590'),nrow(db))
    cust_col <- cust_col[1:nrow(db)]
    
    par(mar = rep(0, 4))
    set.seed(1992)
    word_cloud_plot <- wordcloud(
      words = db$word, 
      freq = db$n, 
      min.freq = 1,
      max.words = 500,
      random.order = FALSE,
      rot.per = 0.35,
      colors = cust_col,
      ordered.colors = TRUE,
      family = "Montserrat"
    )
    
  }
  
  # Split
  else if(input$div_words == 'split')
  {
    vet_split <- input$show_words_split
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
      filter(
        check_color %in% vet_split,
        n >= 2
      )
    
    par(mar = rep(0, 4))
    set.seed(1992)
    word_cloud_plot <- wordcloud(
      words = word_cloud_db$word, 
      freq = word_cloud_db$n, 
      min.freq = 1,
      max.words = 500,
      random.order = FALSE,
      rot.per = 0.35,
      colors = word_cloud_db$color,
      ordered.colors = TRUE,
      family = "Montserrat"
    )
    
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
    cust_col <- rep(c('#f94144','#f3722c','#f8961e','#f9c74f', '#90be6d', '#43aa8b', '#577590'),nrow(db))
    cust_col <- cust_col[1:nrow(db)]
    
    par(mar = rep(0, 4))
    set.seed(1992)
    word_cloud_plot <- wordcloud(
      words = db$word, 
      freq = db$n, 
      min.freq = 1,
      max.words = 500,
      random.order = FALSE,
      rot.per = 0.35,
      colors = cust_col,
      ordered.colors = TRUE,
      family = "Montserrat"
    )
    
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
      filter(
        check_color %in% vet_split) %>%
      arrange(desc(n))
    
    par(mar = rep(0, 4))
    set.seed(1992)
    word_cloud_plot <- wordcloud(
      words = word_cloud_db$word, 
      freq = word_cloud_db$n, 
      min.freq = 1,
      max.words = 500,
      random.order = FALSE,
      rot.per = 0.35,
      colors = word_cloud_db$color,
      ordered.colors = TRUE,
      family = "Montserrat"
    )
    
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
    cust_col <- rep(c('#f94144','#f3722c','#f8961e','#f9c74f', '#90be6d', '#43aa8b', '#577590'),nrow(db))
    cust_col <- cust_col[1:nrow(db)]
    
    par(mar = rep(0, 4))
    set.seed(1992)
    word_cloud_plot <- wordcloud(
      words = db$word, 
      freq = db$n, 
      min.freq = 1,
      max.words = 500,
      random.order = FALSE,
      rot.per = 0.35,
      colors = cust_col,
      ordered.colors = TRUE,
      family = "Montserrat"
    )
    
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
      filter(
        check_color %in% vet_split) %>%
      arrange(desc(n))
    
    par(mar = rep(0, 4))
    set.seed(1992)
    word_cloud_plot <- wordcloud(
      words = word_cloud_db$word, 
      freq = word_cloud_db$n, 
      min.freq = 1,
      max.words = 500,
      random.order = FALSE,
      rot.per = 0.35,
      colors = word_cloud_db$color,
      ordered.colors = TRUE,
      family = "Montserrat"
    )
    
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
        plotOutput('word_cloud')
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
          
          plotOutput('word_cloud1')
          
        ),
        
        column(
          width = 6,
          class = "preview",
          
          h1("Word Cloud of", input$text2),
          
          hr(),
          
          plotOutput('word_cloud2')
        )
        
      )
    )
    
    
  }

  
  return(word_cloud_ui)
})


#- OUTPUTS   
output$word_cloud <- renderPlot(word_cloud())
output$word_cloud1 <- renderPlot(word_cloud1())
output$word_cloud2 <- renderPlot(word_cloud2())

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

