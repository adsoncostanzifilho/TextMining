#- SENTIMENT UI 

sentiment <- tabItem(
  tabName = "sentiment",
  
  fluidPage(
    
    h1("Welcome to the Sentiment Analysis Page!", class = 'h1_twitter'),
    h4("Here you will be able to visualize the sentiments related to your search."),
    
    hr(),
    
    box(
      width = 8,
      prettyRadioButtons(
        inputId = "weight_n",
        selected = "no_weight",
        label = "Do you want the weight the sentiments by n?",
        thick = TRUE,
        choices = c("Yes, weigh it by n!"="yes_weight", "No, do not weigh it by n!"="no_weight"),
        animation = "pulse",
        status = "info",
        inline = TRUE) %>%
        helper(
          icon = "question",
          colour = "#3c8dbb",
          type = "inline",
          fade = TRUE,
          title = "Do you want the weight the sentiments by n?",
          content = c(
            "This option makes it possible to weight (or not) the words used to determine the sentiment.",
            "",
            "If you choose the 'Yes, weigh it by n!' option you will potentialize the sentiment
            based on the number of times the words which carry that feeling appears (n).",
            "",
            "<b>Example</b>: If the word 'good' which has a positive connotation appears 10 times,
            and you choose the 'Yes, weigh it by n!' option, the positive sentiment will be boosted 10 times.
            Otherwise, if you choose the 'No, do not weigh it by n!' option,
            the word 'good' will be considered just one time. ",
            ""
          ),
          buttonLabel = 'Got it!')
      
    ),
    
    # GAUGE - SPEEDOMETER
    uiOutput('gauge_ui'),
    
    
    # RADAR CHART
    box(
      width = 9,
      h1("More Sentiments"),
      hr(),
      plotlyOutput('radar_plot')
    )
  )   
)