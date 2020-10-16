#--- SERVER ---#
server <- function(input, output, session) 
{
  
  # Search Server
  source('tabs/2_search/search_server.R', local = TRUE)  
  
  # Word Cloud Server
  source('tabs/3_cloud/cloud_server.R', local = TRUE)
  
  # Sentiment Server
  source('tabs/4_sentiment/sentiment_server.R', local = TRUE)
  
  # Topic Server
  source('tabs/5_topic/topic_server.R', local = TRUE)
}


