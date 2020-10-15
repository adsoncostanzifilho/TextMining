## TOPIC SERVER ##

#- TOPIC GRAPHIC
topic_graphic <- reactive({
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
    filter(stringr::str_length(word)>4) %>%
    group_by(search_term) %>%
    mutate(order_aux = row_number()) %>%
    ungroup() %>%
    filter(order_aux <= 5)
  
  if(input$connections == 'by_corr')
  {
    db3 <- db %>%
      mutate(
        text_clean = gsub('[[:digit:]]+', '', text_clean)) %>% 
      unnest_tokens(word, text_clean) %>%
      anti_join(my_stopwords, by = c('word' = 'value')) %>%
      pairwise_cor(word, text) %>%
      arrange(desc(correlation)) %>%
      filter(item1 %in% db2$word) %>%
      filter(stringr::str_length(item2)>2) %>%
      group_by(item1) %>%
      mutate(order_aux = row_number()) %>%
      filter(order_aux <= 3) %>%
      ungroup() %>%
      rename('value' = 'correlation') %>%
      as.data.frame()
  }

  else if(input$connections == 'by_freq')
  {
    db3 <- db %>%
      mutate(
        text_clean = gsub('[[:digit:]]+', '', text_clean)) %>% 
      unnest_tokens(word, text_clean) %>%
      anti_join(my_stopwords, by = c('word' = 'value')) %>%
      pairwise_count(word, text) %>%
      arrange(desc(n)) %>%
      filter(item1 %in% db2$word) %>%
      filter(stringr::str_length(item2)>2) %>%
      group_by(item1) %>%
      mutate(order_aux = row_number()) %>%
      filter(order_aux <= 3) %>%
      ungroup() %>%
      rename('value' = 'n') %>%
      as.data.frame() 
      
     
  }
  
  
  levels_source <- data.frame(
    item1 = as.character(unique(db3$item1)),
    IDsource = 0:(length(unique(db3$item1))-1)
  )
  
  levels_target <- data.frame(
    item2 = as.character(unique(db3$item2)),
    IDtarget = 1:length(unique(db3$item2))+4
  )
  
  db_ok <- db3 %>%
    left_join(levels_source, by = c('item1'='item1')) %>%
    left_join(levels_target, by = c('item2'='item2'))
  
  nodes <- data.frame(name = c(unique(db3$item1),unique(db3$item2)))
  
  net_plot <- sankeyNetwork(
    Links = db_ok, 
    Nodes = nodes,
    Source = "IDsource",
    Target = "IDtarget",
    Value = "value",
    NodeID = "name", 
    sinksRight=FALSE, 
    #colourScale=ColourScal, 
    nodeWidth=40, 
    fontSize=13, 
    nodePadding=20,
    fontFamily = 'Montserrat')
  
  return(net_plot)
})


topic_graphic1 <- reactive({
  db <- main_search() %>%
    filter(search_term == input$text1)
  
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
    filter(stringr::str_length(word)>4) %>%
    group_by(search_term) %>%
    mutate(order_aux = row_number()) %>%
    ungroup() %>%
    filter(order_aux <= 5)
  
  if(input$connections == 'by_corr')
  {
    db3 <- db %>%
      mutate(
        text_clean = gsub('[[:digit:]]+', '', text_clean)) %>% 
      unnest_tokens(word, text_clean) %>%
      anti_join(my_stopwords, by = c('word' = 'value')) %>%
      pairwise_cor(word, text) %>%
      arrange(desc(correlation)) %>%
      filter(item1 %in% db2$word) %>%
      filter(stringr::str_length(item2)>2) %>%
      group_by(item1) %>%
      mutate(order_aux = row_number()) %>%
      filter(order_aux <= 3) %>%
      ungroup() %>%
      rename('value' = 'correlation') %>%
      as.data.frame()
  }
  
  else if(input$connections == 'by_freq')
  {
    db3 <- db %>%
      mutate(
        text_clean = gsub('[[:digit:]]+', '', text_clean)) %>% 
      unnest_tokens(word, text_clean) %>%
      anti_join(my_stopwords, by = c('word' = 'value')) %>%
      pairwise_count(word, text) %>%
      arrange(desc(n)) %>%
      filter(item1 %in% db2$word) %>%
      filter(stringr::str_length(item2)>2) %>%
      group_by(item1) %>%
      mutate(order_aux = row_number()) %>%
      filter(order_aux <= 3) %>%
      ungroup() %>%
      rename('value' = 'n') %>%
      as.data.frame() 
    
    
  }
  
  
  levels_source <- data.frame(
    item1 = as.character(unique(db3$item1)),
    IDsource = 0:(length(unique(db3$item1))-1)
  )
  
  levels_target <- data.frame(
    item2 = as.character(unique(db3$item2)),
    IDtarget = 1:length(unique(db3$item2))+4
  )
  
  db_ok <- db3 %>%
    left_join(levels_source, by = c('item1'='item1')) %>%
    left_join(levels_target, by = c('item2'='item2'))
  
  nodes <- data.frame(name = c(unique(db3$item1),unique(db3$item2)))
  
  net_plot <- sankeyNetwork(
    Links = db_ok, 
    Nodes = nodes,
    Source = "IDsource",
    Target = "IDtarget",
    Value = "value",
    NodeID = "name", 
    sinksRight=FALSE, 
    #colourScale=ColourScal, 
    nodeWidth=40, 
    fontSize=13, 
    nodePadding=20,
    fontFamily = 'Montserrat')
  
  return(net_plot)
})


topic_graphic2 <- reactive({
  db <- main_search() %>%
    filter(search_term == input$text2)
  
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
    filter(stringr::str_length(word)>4) %>%
    group_by(search_term) %>%
    mutate(order_aux = row_number()) %>%
    ungroup() %>%
    filter(order_aux <= 5)
  
  if(input$connections == 'by_corr')
  {
    db3 <- db %>%
      mutate(
        text_clean = gsub('[[:digit:]]+', '', text_clean)) %>% 
      unnest_tokens(word, text_clean) %>%
      anti_join(my_stopwords, by = c('word' = 'value')) %>%
      pairwise_cor(word, text) %>%
      arrange(desc(correlation)) %>%
      filter(item1 %in% db2$word) %>%
      filter(stringr::str_length(item2)>2) %>%
      group_by(item1) %>%
      mutate(order_aux = row_number()) %>%
      filter(order_aux <= 3) %>%
      ungroup() %>%
      rename('value' = 'correlation') %>%
      as.data.frame()
  }
  
  else if(input$connections == 'by_freq')
  {
    db3 <- db %>%
      mutate(
        text_clean = gsub('[[:digit:]]+', '', text_clean)) %>% 
      unnest_tokens(word, text_clean) %>%
      anti_join(my_stopwords, by = c('word' = 'value')) %>%
      pairwise_count(word, text) %>%
      arrange(desc(n)) %>%
      filter(item1 %in% db2$word) %>%
      filter(stringr::str_length(item2)>2) %>%
      group_by(item1) %>%
      mutate(order_aux = row_number()) %>%
      filter(order_aux <= 3) %>%
      ungroup() %>%
      rename('value' = 'n') %>%
      as.data.frame() 
    
    
  }
  
  
  levels_source <- data.frame(
    item1 = as.character(unique(db3$item1)),
    IDsource = 0:(length(unique(db3$item1))-1)
  )
  
  levels_target <- data.frame(
    item2 = as.character(unique(db3$item2)),
    IDtarget = 1:length(unique(db3$item2))+4
  )
  
  db_ok <- db3 %>%
    left_join(levels_source, by = c('item1'='item1')) %>%
    left_join(levels_target, by = c('item2'='item2'))
  
  nodes <- data.frame(name = c(unique(db3$item1),unique(db3$item2)))
  
  net_plot <- sankeyNetwork(
    Links = db_ok, 
    Nodes = nodes,
    Source = "IDsource",
    Target = "IDtarget",
    Value = "value",
    NodeID = "name", 
    sinksRight=FALSE, 
    #colourScale=ColourScal, 
    nodeWidth=40, 
    fontSize=13, 
    nodePadding=20,
    fontFamily = 'Montserrat')
  
  return(net_plot)
})


# TOPIC UI
topic_ui <- reactive({
  if(input$single_doble == "single")
  {
    topic_ui <- fluidRow(
      box(
        width = 9,
        h1("Main Topics of", input$text),
        
        hr(),
        
        sankeyNetworkOutput("topic")
        
      )
    )
  }
  
  else if(input$single_doble == "doble")
  {
    topic_ui <- fluidRow(
      box(
        width = 9,
        
        column(
          width = 6,
          class = "preview",
          
          h1("Main Topics of", input$text1),
          
          hr(),
          
          sankeyNetworkOutput("topic1")
          
        ),
        
        column(
          width = 6,
          class = "preview",
          
          h1("Main Topics of", input$text2),
          
          hr(),
          
          sankeyNetworkOutput("topic2")
        )
        
      )
    )
    
    
  }
  
  
  return(topic_ui)
  
})



#- OUTPUTS  
output$topic <- renderSankeyNetwork(topic_graphic())
output$topic1 <- renderSankeyNetwork(topic_graphic1())
output$topic2 <- renderSankeyNetwork(topic_graphic2())

output$topic_ui <- renderUI(topic_ui())



