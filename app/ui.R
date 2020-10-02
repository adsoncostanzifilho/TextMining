#- Packages

# require(twitteR)
require(rtweet)
require(tidyr)
require(tidytext)
require(magrittr)
require(purrr)
require(qdapRegex)
require(shiny)
require(shinydashboard)
require(shinydashboardPlus)
require(shinyWidgets)
require(stopwords)
require(wordcloud2)
require(radarchart)
require(shinycssloaders)


#- Set Twitter API parameters
source('credentials/twitter_credentials.R')


#- Create token to acess the twitter API
create_token(
  app = app_name,
  consumer_key = api_key,
  consumer_secret = api_secret,
  access_token = access_token,
  access_secret = access_secret
)


#- Load functions
source("functions/functions.R")


#- Data for Sentimental Analysis
palavras_pt <<- readRDS("data/Portugues.rds") 
palavras_es <<- readRDS("data/Espanhol.rds")
palavras_en <<- readRDS("data/Ingles.rds")


#- Search Log
log_pesquisa <<- readRDS('data/log_pesquisa.rds')


#- Start Search log data
db <<- data.frame(
  screenName = c(0,0,0,0),
  text = c(0,0,0,0),
  text_limpo = c(0,0,0,0),
  id = c(0,0,0,0),
  date = c(0,0,0,0),
  latitude = c(0,0,0,0),
  longitude = c(0,0,0,0)
)


#- Loading UIs

source('tabs/2_search/search_ui.R')
source('tabs/3_cloud/cloud_ui.R')
source('tabs/4_sentiment/sentiment_ui.R')


#- MAIN UI START
ui <- dashboardPagePlus(
  title = "Text Mining Tool",
  skin = "blue-light",
  
  #- Dashboard Title
  dashboardHeader(title = span(tagList(icon("twitter"), "Text Mining Tool"))),
  
  #- Left Menu
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Search", tabName = "search", icon = icon("search")),
      menuItem("Word Cloud", tabName = "cloud", icon = icon("cloud")),
      menuItem("Sentiment Analysis", tabName = "sentiment", icon = icon("eye"))
    )
  ),
  
  #- Dashboard Body
  dashboardBody(
    
    tags$head(
      # css style
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "custom.css"
      ),
      
      # page icon
      tags$link(
        rel = "shortcut icon",
        href = "img/logo.icon"
      ),
      
      # page font
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "http://fonts.googleapis.com/css?family=Open+Sans|Source+Sans+Pro"
      )
    ),
    
    #- Remove error mensages
    tags$style(
      type="text/css",
      ".shiny-output-error { visibility: hidden; }",
      ".shiny-output-error:before { visibility: hidden; }"
    ),
    
    setShadow("box"),
    
    #- TABS
    tabItems(
      home,
      search,
      cloud,
      sentiment
    )
  )
)







