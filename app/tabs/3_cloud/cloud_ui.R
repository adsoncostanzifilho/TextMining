#- CLOUD UI 

cloud <- tabItem(
  tabName = "cloud",
  
  fluidRow(
    box(
      textInput(inputId = "stop",
                label = "Add StopWords",
                placeholder = "ex: rt, one, two"),
      
      numericInput("freq_min", 
                   label = "Minimum frequency to build the Word Cloud:", 
                   value = 2,
                   min = 1, 
                   max = 100, 
                   step = 1,
                   width = NULL),
      
      prettyToggle(
        inputId = "div_words",
        label_on = "Divide Positive/Negative",
        label_off = "Do not Divide Positive/Negative",
        icon_on = icon("check"),
        icon_off = icon("remove"),
        animation = "smooth"
      ),
      
      prettyCheckboxGroup(
        inputId = "show_words",
        selected = c("green", "red", "blue"),
        label = "Show Words",
        thick = TRUE,
        choices = c("Positive"="green", "Negative"="red", "Neutral"="blue"),
        animation = "pulse",
        status = "info"
      ),
      
      submitButton(text = " Refresh ", icon = icon("sync-alt")),
      
      tags$hr(),
      
      downloadButton("freq_palavras", "Download Words")
      
    ),
    
    box(
      wordcloud2Output("grafico1")
    )
    
    
  )
  
)