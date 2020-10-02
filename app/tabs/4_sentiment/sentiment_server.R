## SENTIMENT SERVER ##

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


#- OUTPUTS   
output$grafico2 <- renderChartJSRadar(radar())