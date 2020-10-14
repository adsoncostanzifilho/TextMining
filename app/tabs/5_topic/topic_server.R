## TOPIC SERVER ##

#- Radar Data
topic_data <- reactive({
  db <- main_search()
  my_stopwords <- my_stop()
  
  db2 <- db %>%
    mutate(
      text_clean = gsub('[[:digit:]]+', '', text_clean)) %>% 
    group_by(search_term) %>%
    unnest_tokens(word, text_clean) %>%
    ungroup() %>%
    anti_join(my_stopwords, by = c('word' = 'value')) %>%
    group_by(search_term, word) %>%
    summarise(n = n()) %>%
    ungroup() %>%
    bind_tf_idf(word, search_term, n) %>%
    arrange(search_term, desc(tf_idf)) %>%
    group_by(search_term) %>%
    mutate(order_aux = row_number()) %>%
    ungroup() %>%
    filter(order_aux <= 10)
  
  library(widyr)
  db3 <- db %>%
    mutate(
      text_clean = gsub('[[:digit:]]+', '', text_clean)) %>% 
    group_by(search_term) %>%
    unnest_tokens(word, text_clean) %>%
    ungroup() %>%
    anti_join(my_stopwords, by = c('word' = 'value')) %>%
    pairwise_count(word, text, sort = TRUE)
  
  db4 <- db %>%
    mutate(
      text_clean = gsub('[[:digit:]]+', '', text_clean)) %>% 
    group_by(search_term) %>%
    unnest_tokens(word, text_clean) %>%
    ungroup() %>%
    anti_join(my_stopwords, by = c('word' = 'value')) %>%
    pairwise_cor(word, text) %>%
    arrange(desc(correlation))
  
  db5 <- db4 %>%
    filter(item1 == 'split')
  
})


#- OUTPUTS  
output$gauge_ui <- renderUI(gauge_ui())



