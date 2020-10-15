## SENTIMENT SERVER ##

#- Radar Data
radar_data <- reactive({
  db <- word_freq()
  db_sent <- sent_words()
  
  # IF SINGLE/DOBLE
  if(input$single_doble == "single")
  {
    db2 <- db %>%
      left_join(db_sent, by = c('word'='word')) %>%
      replace_na(
        list(
          positive = 0,
          negative = 0,
          anger = 0,
          anticipation = 0,
          disgust = 0,
          fear = 0,
          joy = 0,
          sadness = 0,
          surprise = 0,
          trust = 0)
      )
    
    db3 <- pivot_longer(
      data = db2,
      cols = c(3:12),
      names_to = 'sentiment') 
    
    db4 <- db3 %>%
      mutate(
        values_by_n = n*value
      ) %>%
      group_by(sentiment) %>%
      summarise(
        score = round(sum(value)/n()*100, 2),
        score_by_n = round(sum(values_by_n)/sum(n)*100, 2)
      )
    
    db5 <- db3 %>%
      filter(value > 0) %>%
      group_by(sentiment) %>%
      top_n(n = 3,n) %>%
      mutate(
        aux = 1:n()
      ) %>%
      filter(aux <= 3) %>%
      summarise(
        top3_words = paste(word , collapse = ', ')
      ) %>%
      ungroup()
    
    db_final <- db4 %>%
      left_join(db5, by = c('sentiment'='sentiment'))
    
    # IF WEIGHT 
    if(input$weight_n == 'yes_weight')
    {
      db_final <- db_final %>%
        mutate(
          score_ok = score_by_n
        )
    }
    
    else if(input$weight_n == 'no_weight')
    {
      db_final <- db_final %>%
        mutate(
          score_ok = score
        )
    }
    
  }
  
  else if(input$single_doble == "doble")
  {
    db1 <- db[[1]] %>%
      left_join(db_sent, by = c('word'='word')) %>%
      replace_na(
        list(
          positive = 0,
          negative = 0,
          anger = 0,
          anticipation = 0,
          disgust = 0,
          fear = 0,
          joy = 0,
          sadness = 0,
          surprise = 0,
          trust = 0)
      )
    
    db3 <- pivot_longer(
      data = db1,
      cols = c(3:12),
      names_to = 'sentiment') 
    
    db4 <- db3 %>%
      mutate(
        values_by_n = n*value
      ) %>%
      group_by(sentiment) %>%
      summarise(
        score = round(sum(value)/n()*100, 2),
        score_by_n = round(sum(values_by_n)/sum(n)*100, 2)
      )
    
    db5 <- db3 %>%
      filter(value > 0) %>%
      group_by(sentiment) %>%
      top_n(n = 3,n) %>%
      mutate(
        aux = 1:n()
      ) %>%
      filter(aux <= 3) %>%
      summarise(
        top3_words = paste(word , collapse = ', ')
      ) %>%
      ungroup()
    
    db_final_1 <- db4 %>%
      left_join(db5, by = c('sentiment'='sentiment'))
    
    # IF WEIGHT 
    if(input$weight_n == 'yes_weight')
    {
      db_final_1 <- db_final_1 %>%
        mutate(
          score_ok = score_by_n
        )
    }
    
    else if(input$weight_n == 'no_weight')
    {
      db_final_1 <- db_final_1 %>%
        mutate(
          score_ok = score
        )
    }
    
    db1 <- db[[2]] %>%
      left_join(db_sent, by = c('word'='word')) %>%
      replace_na(
        list(
          positive = 0,
          negative = 0,
          anger = 0,
          anticipation = 0,
          disgust = 0,
          fear = 0,
          joy = 0,
          sadness = 0,
          surprise = 0,
          trust = 0)
      )
    
    db3 <- pivot_longer(
      data = db1,
      cols = c(3:12),
      names_to = 'sentiment') 
    
    db4 <- db3 %>%
      mutate(
        values_by_n = n*value
      ) %>%
      group_by(sentiment) %>%
      summarise(
        score = round(sum(value)/n()*100, 2),
        score_by_n = round(sum(values_by_n)/sum(n)*100, 2)
      )
    
    db5 <- db3 %>%
      filter(value > 0) %>%
      group_by(sentiment) %>%
      top_n(n = 3,n) %>%
      mutate(
        aux = 1:n()
      ) %>%
      filter(aux <= 3) %>%
      summarise(
        top3_words = paste(word , collapse = ', ')
      ) %>%
      ungroup()
    
    db_final_2 <- db4 %>%
      left_join(db5, by = c('sentiment'='sentiment'))
    
    # IF WEIGHT 
    if(input$weight_n == 'yes_weight')
    {
      db_final_2 <- db_final_2 %>%
        mutate(
          score_ok = score_by_n
        )
    }
    
    else if(input$weight_n == 'no_weight')
    {
      db_final_2 <- db_final_2 %>%
        mutate(
          score_ok = score
        )
    }
    
    db_final <- list(db_final_1, db_final_2)
  }
  
  
  return(db_final)
  
})



#- RADAR CHART
radar_ui <- reactive({
  db_final <- radar_data() 
  
  if(input$single_doble == "single")
  {
    radar_plot <- db_final %>%
      filter(!sentiment %in% c('positive','negative')) %>%
      plot_ly(
      type = 'scatterpolar',
      mode = 'lines') %>%
      add_trace(
        r = ~score_ok,
        theta = ~sentiment,
        name = input$text,
        text = ~paste('<b>Sentiment</b>:', sentiment, '<br><b>Score</b>:', score_ok, '<br><b>Top 3 Words</b>:', top3_words),
        fill = 'toself',
        mode = 'markers',
        hoverinfo = "text",
        fillcolor = 'rgba(60, 141, 188, 0.4)',
        marker = list(color = '#3c8dbc')) %>% layout(
          polar = list(
            radialaxis = list(
              visible = FALSE
            )
          ),
          showlegend = TRUE) %>% 
      config(displayModeBar = FALSE)
    
  }
  
  else if(input$single_doble == "doble")
  {
    radar_plot <- plot_ly(
      type = 'scatterpolar',
      mode = 'lines') %>%
      add_trace(
        data = db_final[[1]] %>% filter(!sentiment %in% c('positive','negative')),
        r = ~score_ok,
        theta = ~sentiment,
        name = input$text1,
        text = ~paste('<b>Sentiment</b>:', sentiment, '<br><b>Score</b>:', score_ok, '<br><b>Top 3 Words</b>:', top3_words),
        fill = 'toself',
        mode = 'markers',
        hoverinfo = "text",
        fillcolor = 'rgba(60, 141, 188, 0.4)',
        marker = list(color = '#3c8dbc')) %>%
      add_trace(
        data = db_final[[2]] %>% filter(!sentiment %in% c('positive','negative')),
        r = ~score_ok,
        theta = ~sentiment,
        name = input$text2,
        text = ~paste('<b>Sentiment</b>:', sentiment, '<br><b>Score</b>:', score_ok, '<br><b>Top 3 Words</b>:', top3_words),
        fill = 'toself',
        mode = 'markers',
        hoverinfo = "text",
        fillcolor = 'rgba(37, 177, 79, 0.4)',
        marker = list(color = '#25b14f')) %>% layout(
          polar = list(
            radialaxis = list(
              visible = FALSE
            )
          ),
          showlegend = TRUE) %>% 
      config(displayModeBar = FALSE)
  }
  
  return(radar_plot)
  
})



#- GAUGE
gauge <- reactive({
  db_final <- radar_data() 
  
  db_gauge <- db_final %>%
    select(sentiment, score_ok) %>%
    filter(sentiment %in% c('positive','negative')) %>% 
    pivot_wider(id_cols = sentiment,names_from = sentiment,values_from = score_ok) %>%
    mutate(
      gauge_score = round(negative/positive*50, 1)
    )
  
  gauge <- e_charts() %>% 
    e_gauge(
      db_gauge$gauge_score, 
      "", 
      min=0, 
      max=100,
      axisLine = list(
        lineStyle = list(
          color=list(
            c(0.4, "#008450"),
            c(.6, "#EFB700"),
            c(1, "#B81D13"))
        )
      )
    )
  
  return(gauge)
  
})

gauge1 <- reactive({
  db_final <- radar_data() 
  
  db_gauge <- db_final[[1]] %>%
    select(sentiment, score_ok) %>%
    filter(sentiment %in% c('positive','negative')) %>% 
    pivot_wider(id_cols = sentiment,names_from = sentiment,values_from = score_ok) %>%
    mutate(
      gauge_score = round(negative/positive*50, 1)
    )
  
  gauge <- e_charts() %>% 
    e_gauge(
      db_gauge$gauge_score, 
      "", 
      min=0, 
      max=100,
      axisLine = list(
        lineStyle = list(
          color=list(
            c(0.4, "#008450"),
            c(.6, "#EFB700"),
            c(1, "#B81D13"))
        )
      )
    )
  
  return(gauge)
  
})

gauge2 <- reactive({
  db_final <- radar_data() 
  
  db_gauge <- db_final[[2]] %>%
    select(sentiment, score_ok) %>%
    filter(sentiment %in% c('positive','negative')) %>% 
    pivot_wider(id_cols = sentiment,names_from = sentiment,values_from = score_ok) %>%
    mutate(
      gauge_score = round(negative/positive*50, 1)
    )
  
  gauge <- e_charts() %>% 
    e_gauge(
      db_gauge$gauge_score, 
      "", 
      min=0, 
      max=100,
      axisLine = list(
        lineStyle = list(
          color=list(
            c(0.4, "#008450"),
            c(.6, "#EFB700"),
            c(1, "#B81D13"))
        )
      )
    )
  
  return(gauge)
  
})

gauge_ui <- reactive({
  
  if(input$single_doble == "single")
  {
    gauge_ui <- fluidRow(
      box(
        width = 9,
        h1("Sentiment Score of", input$text),
        
        hr(),
        echarts4rOutput('gauge'),
        
        HTML(
          '<div class="center">
            <ul class="legend">
              <li><span class="pos"></span> Positive</li>
              <li><span class="neu"></span> Neutral</li>
              <li><span class="neg"></span> Negative</li>
            </ul>
          </div>'
        )
        
      )
    )
  }
  
  else if(input$single_doble == "doble")
  {
    gauge_ui <- fluidRow(
      box(
        width = 9,
        
        column(
          width = 6,
          class = "preview",
          
          h1("Sentiment Score of", input$text1),
          
          hr(),
          
          echarts4rOutput('gauge1')
          
        ),
        
        column(
          width = 6,
          class = "preview",
          
          h1("Sentiment Score of", input$text2),
          
          hr(),
          
          echarts4rOutput('gauge2')
        ),
        
        HTML(
          '<div class="center">
            <ul class="legend">
              <li><span class="pos"></span> Positive</li>
              <li><span class="neu"></span> Neutral</li>
              <li><span class="neg"></span> Negative</li>
            </ul>
          </div>'
        )
        
      )
    )
    
    
  }
  
  
  return(gauge_ui)
 
})



#- OUTPUTS  
output$gauge <- renderEcharts4r(gauge())
output$gauge1 <- renderEcharts4r(gauge1())
output$gauge2 <- renderEcharts4r(gauge2())

output$gauge_ui <- renderUI(gauge_ui())

output$radar_plot <- renderPlotly(radar_ui())

