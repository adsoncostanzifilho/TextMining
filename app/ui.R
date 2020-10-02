#--- UI ---#
require(shiny)
require(shinydashboard)
require(shinydashboardPlus)
require(shinyWidgets)
require(stopwords)
require(wordcloud2)
require(radarchart)
require(shinycssloaders)

ui <- dashboardPagePlus(
  skin = "blue-light",
  
  
  #- Dashboard Title
  dashboardHeader(title = span(tagList(icon("twitter"), "Text Mining Tool"))),

  
  #- Left Menu
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Search", tabName = "search", icon = icon("search")),
      menuItem("Word Cloud", tabName = "cloud", icon = icon("cloud")),
      menuItem("Sentimental Analysis", tabName = "sentimental", icon = icon("eye"))
    )
  ),
  
  dashboardBody(
    
    #- Remove error mensages
    tags$style(
      type="text/css",
      ".shiny-output-error { visibility: hidden; }",
      ".shiny-output-error:before { visibility: hidden; }"
    ),
    setShadow("box"),
    
    tabItems(
      
      #- First TAB
      tabItem(
        tabName = "home",
        
        fluidRow(
          widgetUserBox(
            title = "Adson Costanzi Filho",
            subtitle = "Statistician/Data Scientist",
            width = 7,
            type = 2,
            src = "imagens/profile.png",
            color = "aqua-active",
            align = "center",
            
            socialButton(
              url = "https://www.linkedin.com/in/adson-costanzi-filho-24bb32138/",
              type = "linkedin"
            ),
            
            socialButton(
              url = "https://twitter.com/FGQISIyMPWzuwQ2",
              type = "twitter"
            ),
            
            socialButton(
              url = "adsoncostanzi32@gmail.com",
              type = "google"
            ),
            
            socialButton(
              url = "https://github.com/adsoncostanzifilho",
              type = "github"
            ),
            
            closable = FALSE,
            footer = "This Interface was developed by Adson Costanzi Filho, 
                      in order to estimulate researches in text mining area."
          ),
          
          box(width = 5,
              title = h2("Last 5 terms searched on App",
                         style = "color:#3C8DBC",
                         align = "center"),
              
              tags$hr(),
              
              h3(log_pesquisa$termo[nrow(log_pesquisa)], 
                 style = "color:#00A7D0",
                 align = "center"),
              
              tags$hr(),
              
              h3(log_pesquisa$termo[nrow(log_pesquisa)-1], 
                 style = "color:#00A7D0",
                 align = "center"),
              
              tags$hr(),
              
              h3(log_pesquisa$termo[nrow(log_pesquisa)-2], 
                 style = "color:#00A7D0",
                 align = "center"),
              
              tags$hr(),
              
              h3(log_pesquisa$termo[nrow(log_pesquisa)-3], 
                 style = "color:#00A7D0",
                 align = "center"),
              
              tags$hr(),
              
              h3(log_pesquisa$termo[nrow(log_pesquisa)-4], 
                 style = "color:#00A7D0",
                 align = "center")
              )

        )

      ),
      
      #- Second TAB
      tabItem(
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
        
        
        
        
        
        
        
      ),
      
      #- Third TAB
      tabItem(
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
        
      ),
      
      #- Third TAB
      tabItem(
        tabName = "sentimental",
        
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
            withSpinner(chartJSRadarOutput("grafico2"), 
                        type = getOption("spinner.type", default = 1))
          )
          
        )
      )
      
      
    )
  )
)







