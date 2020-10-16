#- TOPIC UI 

topic <- tabItem(
  tabName = "topic",
  
  fluidPage(
    
    h1("Welcome to the Topic Modeling Page!"),
    h4("Here you will be able to visualize the main topics related to your search."),
    
    hr(),
    
    box(
      width = 8,
      prettyRadioButtons(
        inputId = "connections",
        selected = "by_corr",
        label = "Do you want to select the topics' connections by frequency or correlation?",
        thick = TRUE,
        choices = c("Select by Frequency"="by_freq", "Select by Correlation"="by_corr"),
        animation = "pulse",
        status = "info",
        inline = TRUE) %>%
        helper(
          icon = "question",
          colour = "#3c8dbb",
          type = "inline",
          fade = TRUE,
          title = "Do you want to select the topics' connections by frequency or correlation?",
          content = c(
            "This option makes it possible to choose the connectors of the main topics.",
            "",
            "If you choose the <b>'Select by Frequency'</b> option the topics' connections 
            will be presented based on the frequency they appear in the tweets. Otherwise, 
            if you choose the <b>'Select by Correlation'</b> option the connections will be 
            presented considering the words with the strongest (absolute) correlations.",
            "",
            "source: https://www.tidytextmining.com/topicmodeling.html",
            ""
          ),
          buttonLabel = 'Got it!')
      
    ),
    
    
    uiOutput('topic_ui')
    
    
  )   
)