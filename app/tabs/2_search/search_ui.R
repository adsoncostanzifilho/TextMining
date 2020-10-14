#- SEARCH UI 

search <- tabItem(
  tabName = "search",
  
  fluidPage(
    
    h1("Welcome to the Search Page!", class = 'h1_twitter'),
    h4("Here you will collect the data to be used in the entire interface."),
    
    hr(),
      
    box(
      width = 8,
      prettyRadioButtons(
        inputId = "single_doble",
        selected = "single",
        label = "What kind of search do you want?",
        thick = TRUE,
        choices = c("Single Search"="single", "Doble Search"="doble"),
        animation = "pulse",
        status = "info",
        inline = TRUE
      ) %>%
        helper(
          icon = "question",
          colour = "#3c8dbb",
          type = "inline",
          fade = TRUE,
          title = "What kind of search do you want?",
          content = c(
            "You must choose between <b>Single Search</b> or <b>Doble Search</b>.",
            "",
            "<b>Single Search</b>:",
            "Single Search means you will be analyzing just one term individually.",
            "",
            "<b>Doble Search</b>:",
            "Doble Search means you will be analyzing two terms at the same time, 
            if you choose this option, you will be able to compare both terms over the interface.",
            ""
          ),
          buttonLabel = 'Got it!')
    ),
    
    box(
      width = 8,
      selectInput(
        inputId = "lang",
        label = "Select language:",
        choices = c("Portuguese"="pt","Spanish"="es","English"="en"),
        selected = "en")
    ),
    
    box(
      width = 8,
      sliderInput(
        inputId = "n",
        label = "Number of tweets to search:",
        min = 50,
        max =  500,
        value =  200,
        step = 10)
    ),
    
    conditionalPanel(
      condition = "input.single_doble == 'single'",
      box(
        width = 8,
        textInput(
          inputId = "text",
          label = "Word to Search on Twitter:",
          placeholder = "ex: twitteR")
      )
    ),
    
    conditionalPanel(
      condition = "input.single_doble == 'doble'",
      box(
        width = 8,
        textInput(
          inputId = "text1",
          label = "First Word to Search on Twitter:",
          placeholder = "ex: twitteR"
        ),
        textInput(
          inputId = "text2",
          label = "Second Word to Search on Twitter:",
          placeholder = "ex: twitteR"
        )
      )
    ),
    
    column(
      width = 8,
      actionButton(
        inputId = 'search',
        label = ' Search ',
        class = 'btn_twitter',
        icon = icon('search')
      )
    ),
    
    br(),
    
    uiOutput("api_return") %>%
      withSpinner(type = 7, color = "#3c8dbb"),
    
    br(),
    
    uiOutput("tweet_preview")
    
  )
  
)