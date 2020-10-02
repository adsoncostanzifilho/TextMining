#- SENTIMENT UI 

sentiment <- tabItem(
  tabName = "sentiment",
  
  fluidRow(
    box(
      width = 4,
      textInput(inputId = "pal_positive",
                label = "Add Positive Words",
                #value = " ",
                placeholder = "ex: one, two"),
      
      textInput(inputId = "pal_negative",
                label = "Add Negative Words",
                #value = " ",
                placeholder = "ex: one, two"),
      
      prettyToggle(
        inputId = "ponderar",
        label_on = "Weighting by n",
        label_off = "No Weighting by n",
        icon_on = icon("check"),
        icon_off = icon("remove")
      ),
      
      submitButton(text = " Refresh ", icon = icon("sync-alt"))
      
    ),
    
    
    box(
      width = 8,
      chartJSRadarOutput("grafico2")
    )
    
  )
)