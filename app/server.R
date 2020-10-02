#--- SERVER ---#

server <- function(input, output) 
{
  
  #- PESQUISA
  pesquisa <- reactive({
    
    db <- search_tweets(
      q = input$text, 
      lang = input$lang, 
      n = input$n,
      type = "mixed",
      token = mytoken)
    
    db <- db %>%
      mutate(text_limpo = clean_text(text))
    
    dt_informacoes_novas <- data.frame(
      termo = input$text,
      idioma = input$lang,
      num = input$n)
    
    dt_informacoes_velhas <- readRDS("data/log_pesquisa.rds")
    
    dt_informacoes <- bind_rows(dt_informacoes_novas, dt_informacoes_velhas)
    
    saveRDS(
      dt_informacoes,
      file = "data/log_pesquisa.rds")
    
    return(db)
  })
  
  
  #- TAMANHO BASE
  tam_base <- reactive({
    p <- pesquisa()
    
    if(is_empty(p))
    {
      texto <- paste0("No tweet was found.")

      retorno_ui <- box(width = 12,
                        h4(texto,
                           style = "color:#00A7D0",
                           align = "center")
                        ) 

    }

    if(!is_empty(p))
    {
      texto <- paste0("It was found ",nrow(p)," distinct tweets about ",input$text,".")
      retorno_ui <- box(width = 12,
                        h4(texto, 
                           style = "color:#00A7D0",
                           align = "center"),
                        tags$hr(),
                        downloadButton("tweets", "Download Tweets")
                        ) 
    }
    
    return(retorno_ui)
    
  })
  
  
  #-  FREQUENCIA PALAVRAS
  palavras_freq <- reactive({
    db <- pesquisa()
    my_stop <- as_tibble(c(unlist(strsplit(input$stop, "\\,\\s|\\,|\\s|\\s\\,|\\s\\,\\s")), 
                            stopwords(input$lang)))
    
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
  
  
  #- RADAR CHART
  radar <- reactive({
    d <- palavras_freq()
    
    if(input$lang == 'pt')
    {
      palavras <- palavras_pt
    }
    
    if(input$lang == 'es')
    {
      palavras <- palavras_es
    }
    
    if(input$lang == 'en')
    {
      palavras <- palavras_en 
    }
    
    if(input$pal_positive != "")
    {
      palavras <- palavras %>%
        add_row(word = unlist(strsplit(input$pal_positive, "\\,\\s|\\,|\\s|\\s\\,|\\s\\,\\s")),
                positive = 1,
                negative = 0,
                anger = 0,
                anticipation = 0,
                disgust = 0,
                fear = 0,
                joy = 0,
                sadness = 0,
                surprise = 0,
                trust = 0)
    }
    
    if(input$pal_negative != "")
    {
      palavras <- palavras %>%
        add_row(word = unlist(strsplit(input$pal_negative, "\\,\\s|\\,|\\s|\\s\\,|\\s\\,\\s")),
                positive = 0,
                negative = 1,
                anger = 0,
                anticipation = 0,
                disgust = 0,
                fear = 0,
                joy = 0,
                sadness = 0,
                surprise = 0,
                trust = 0)
    }




    
    
    # Ponderado pelo n 
    if(input$ponderar == TRUE)
    {
      d2 <- left_join(d, palavras, by = c("word" = "word")) %>%
        replace_na(
          list(
            positive = 0,
            negative = 0,
            anger = 0,
            anticipation = 0,
            disgust = 0,
            fear = 0,
            joy = 0,
            sadness = 0,
            surprise = 0,
            trust = 0)) %>%
        mutate(
          positive = positive * n,
          negative = negative *n,
          anger = anger * n,
          anticipation = anticipation * n,
          disgust = disgust * n,
          fear = fear * n,
          joy = joy * n,
          sadness = sadness * n,
          surprise = surprise * n,
          trust = trust * n
        )
    }
    
    
    # Nao ponderado por n
    if(input$ponderar == FALSE)
    {
      d2 <- left_join(d, palavras, by = c("word" = "word")) %>%
        replace_na(
          list(
            positive = 0,
            negative = 0,
            anger = 0,
            anticipation = 0,
            disgust = 0,
            fear = 0,
            joy = 0,
            sadness = 0,
            surprise = 0,
            trust = 0))
    }
    
    
    # Grafico Radar
    labs <- c("positive",
              "negative",
              "anger",
              "anticipation",
              "disgust",
              "fear",
              "joy",
              "sadness",
              "surprise",
              "trust")
    
    score <- list(
      "Score" = c(sum(d2$positive),
                  sum(d2$negative),
                  sum(d2$anger),
                  sum(d2$anticipation),
                  sum(d2$disgust),
                  sum(d2$fear),
                  sum(d2$joy),
                  sum(d2$sadness),
                  sum(d2$surprise),
                  sum(d2$trust)))
    
    grafico2 <- chartJSRadar(scores = score, labs = labs, width = 12, height = 12)
    
    return(grafico2)
    
    
  })
  
  
  #- PREVIEW
  preview1 <- reactive({
    db <- pesquisa()
    
    box1 <- widgetUserBox(
      title =  db$name[1],
      subtitle = db$description[1],
      socialButton(
        url = db$status_url[1],
        type = "twitter"
      ),
      type = 2,
      src = db$profile_image_url[1],
      background = TRUE,
      backgroundUrl = db$profile_background_url[1],
      footer = db$text[1]
    )

    return(box1)
  })
  
  preview2 <- reactive({
    db <- pesquisa()
    
    box1 <- widgetUserBox(
      title =  db$name[2],
      subtitle = db$description[2],
      socialButton(
        url = db$status_url[2],
        type = "twitter"
      ),
      type = 2,
      src = db$profile_image_url[2],
      background = TRUE,
      backgroundUrl = db$profile_background_url[2],
      footer = db$text[2]
    )
    
    return(box1)
  })
  
  preview3 <- reactive({
    db <- pesquisa()
    
    box1 <- widgetUserBox(
      title =  db$name[3],
      subtitle = db$description[3],
      socialButton(
        url = db$status_url[3],
        type = "twitter"
      ),
      type = 2,
      src = db$profile_image_url[3],
      background = TRUE,
      backgroundUrl = db$profile_background_url[3],
      footer = db$text[3]
    )
    
    return(box1)
  })
  
  
  
  
  
  
  
  #- LISTA DE OUTPUTS   
  output$tamanho_base <- renderUI(tam_base())
  
  output$grafico1 <- renderWordcloud2(word_cloud())
  
  output$grafico2 <- renderChartJSRadar(radar())
  
  output$preview1 <- renderUI(preview1())
  
  output$preview2 <- renderUI(preview2())
  
  output$preview3 <- renderUI(preview3())
  
  
  #- DOWNLOADS
  output$tweets<-downloadHandler(
    filenam=function()
    {
      paste0('tweets','.csv')
    },
    content=function(arquivo)
    {
      if(input$text!="zxdt94banana62")
      {
        write.table(pesquisa(),arquivo, sep = ";", row.names = FALSE)
      }
      else
      {
        write.csv(read.table("log_pesquisa.txt"),arquivo)
      }
    })
  
  output$freq_palavras<-downloadHandler(
    filenam = function()
    {
      paste0('freq_palavras','.csv')
    },
    content = function(arquivo)
    {
      write.table(palavras_freq(), arquivo, sep = ";", row.names = FALSE)
    })

  
  
}


