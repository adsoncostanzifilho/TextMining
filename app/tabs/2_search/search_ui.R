#- SEARCH UI 

search <- tabItem(
  tabName = "search",
  
  fluidRow(
    box(
      title = "Follow the steps to search on Twitter:",
      
      timelineBlock(
        
        timelineItem(
          title = "First Step",
          icon = "signature",
          color = "aqua-active",
          selectInput("lang", 
                      "Select language:",
                      c("Portuguese"="pt","Spanish"="es","English"="en"))
        ),
        
        timelineItem(
          title = "Second Step",
          icon = "signature",
          color = "aqua-active",
          sliderInput("n", 
                      "Number of tweets to search:", 
                      50, 1000, 100)
        ),
        
        timelineItem(
          title = "Third Step",
          icon = "signature",
          color = "aqua-active",
          textInput(inputId = "text",
                    label = "Word to Search in Twitter:",
                    placeholder = "ex: twitteR"),
          submitButton(text = " Search ", icon = icon("search"))
        ),
        
        timelineStart(color = "aqua-active"),
        
        tags$hr(),
        
        uiOutput("tamanho_base") 
        
        
        
      )
      
      
    ),
    
    
    uiOutput("preview1"),
    
    uiOutput("preview2"),
    
    uiOutput("preview3")
    
  )
  
)