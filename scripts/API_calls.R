#remotes::install_github("jeroen/curl@smtp")
#devtools::install_github('mkearney/rtweet')
require(rtweet)
require(lubridate)
require(emayili)
require(curl)
require(dplyr)

# set Twitter API parameters
source('App/credentials/twitter_credentials.R')


# create token to acess the twitter API
mytoken <- create_token(
  app = app_name,
  api_key, 
  api_secret, 
  access_token, 
  access_secret)


# term to search on twitter
termo <- 'rstudio'
dt  <- '202001100000'
dt2 <- '202001100800'
#dt2 <- as.character(dt + 10000)
#dt <- as.character(dt)

# searching data on twitter
 db <- search_tweets(
   q = termo, 
   lang = 'en',
   fromDate = dt, 
   toDate = dt2,
   # env_name = 'searchfullarchive',
   # safedir = 'data/',
   type = "mixed",
   token = mytoken,
   n = 10
 )

 
# searching data on twitter Full Archive
db <- rtweet::search_fullarchive(
  q = termo,
  #lang = 'en',
  fromDate = dt, 
  toDate = dt2,
  env_name = 'searchfull',
  safedir = 'data/',
  token = mytoken,
  #type = "mixed",
  n = 10)


# searching data on twitter 30 days
db <- rtweet::search_30day(
  q = termo,
  fromDate = '202003222116',
  toDate = '202001100000',
  n = 10,
  token = mytoken,
  env_name = 'search30')





