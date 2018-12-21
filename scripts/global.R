#--- GLOBAL ---#

#- Packages
require(twitteR)
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

#- API Twitter Conection
api_key <- "xxx"
api_secret <- "xxx"
access_token <- "xxx"
access_secret <- "xxx"
setup_twitter_oauth(api_key, api_secret, access_token, access_secret)

#create_token(app = "mytwitterapp",api_key, api_secret, access_token, access_secret)

#- Load functions
source("functions/functions.R")

#- Log_Pesquisa
log_pesquisa <- read.csv("App/log_pesquisa.csv", sep= ";")

#- Inicia DB
db <- data.frame(screenName = c(0,0,0,0),
                 text = c(0,0,0,0),
                 text_limpo = c(0,0,0,0),
                 id = c(0,0,0,0),
                 date = c(0,0,0,0),
                 latitude = c(0,0,0,0),
                 longitude = c(0,0,0,0))

#- Data Sentimental Analysis
palavras_pt <- readRDS("data/Portugues.rds") 
palavras_es <- readRDS("data/Espanhol.rds")
palavras_en <- readRDS("data/Ingles.rds")


#- Run App
runApp("App")

