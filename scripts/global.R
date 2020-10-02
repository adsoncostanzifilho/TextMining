#--- GLOBAL ---#

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


#- set Twitter API parameters
source('app/credentials/twitter_credentials.R')


#- Create token to acess the twitter API
mytoken <- create_token(
  app = app_name,
  api_key, 
  api_secret, 
  access_token, 
  access_secret
)

#- Load functions
source("functions/functions.R")


#- Data for Sentimental Analysis
palavras_pt <- readRDS("app/data/Portugues.rds") 
palavras_es <- readRDS("app/data/Espanhol.rds")
palavras_en <- readRDS("app/data/Ingles.rds")


#- Log_Pesquisa
log_pesquisa <- read.csv("app/log_pesquisa.csv", sep= ";")

#- Inicia DB
db <- data.frame(
  screenName = c(0,0,0,0),
  text = c(0,0,0,0),
  text_limpo = c(0,0,0,0),
  id = c(0,0,0,0),
  date = c(0,0,0,0),
  latitude = c(0,0,0,0),
  longitude = c(0,0,0,0)
)


#- Run App
runApp("app")

