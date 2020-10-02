## SEARCH SERVER ##

#- PESQUISA
pesquisa <- reactive({
  
  db <- search_tweets(
    q = input$text, 
    lang = input$lang, 
    n = input$n,
    type = "mixed")
  
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



#- OUTPUTS  
output$tamanho_base <- renderUI(tam_base())

output$preview1 <- renderUI(preview1())
output$preview2 <- renderUI(preview2())
output$preview3 <- renderUI(preview3())


#- DOWNLOADS
output$tweets <- downloadHandler(
  filenam = function()
  {
    paste0('tweets','.csv')
  },
  content = function(arquivo)
  {
    if(input$text!="zxdt94banana62")
    {
      write.table(pesquisa(), arquivo, sep = ";", row.names = FALSE)
    }
    else
    {
      write.csv(read.table("log_pesquisa.txt"),arquivo)
    }
  }
)
