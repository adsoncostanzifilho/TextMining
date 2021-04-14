## SEARCH SERVER ##

#- Help buttons
observe_helpers(withMathJax = TRUE)


# SEARCH ON TWITTER
main_search <- eventReactive(input$search,{
  
  # search if SINGLE
  if(input$single_doble == "single")
  {
    
    # text input not empty
    if(input$text != "")
    {
      db <- search_tweets(
        q = input$text,
        lang = input$lang,
        n = input$n,
        type = "recent")
      
      if(!is_empty(db))
      {
        db <- db %>%
          mutate(
            text_clean = clean_text(text),
            search_term = input$text
          )
      }
      
      return(db)
    }
    
    # text input empty
    else
    {
      return("The term to search is empty, please fill it an try again!")
    }
    
  }
  
  # search if DOBLE
  if(input$single_doble == "doble")
  {
    # text inputs not empty
    if(input$text1 != "" & input$text2 != "")
    {
      # first word to search
      db1 <- search_tweets(
        q = input$text1,
        lang = input$lang,
        n = input$n,
        type = "recent")
      
      # db1 is empty
      if(is_empty(db1))
      {
        return(paste0("No tweets about ", input$text1, " were found, try a different term."))
      }
      
      db1 <- db1 %>%
        mutate(
          text_clean = clean_text(text),
          search_term = input$text1
        )
      
      # second word to search
      db2 <- search_tweets(
        q = input$text2,
        lang = input$lang,
        n = input$n,
        type = "recent")
      
      # db2 is empty
      if(is_empty(db2))
      {
        return(paste0("No tweets about ", input$text2, " were found, try a different term."))
      }
      
      db2 <- db2 %>%
        mutate(
          text_clean = clean_text(text),
          search_term = input$text2
        )
      
      db <- bind_rows(db1, db2)
      
      return(db) 
      
    }
    
    # text inputs empty
    else
    {
      if(input$text1 == "" & input$text2 == "")
      {
        return('Both terms are empty, please fill it an try again!')
      }
      else if(input$text1 == "")
      {
        return('The firts terms is empty, please fill it an try again!')
      }
      else if(input$text2 == "")
      {
        return('The second terms is empty, please fill it an try again!')
      }
    }
  }
 
})


# INTERFACE - Return from Twitter API
twitter_api_return <- eventReactive(input$search,{
  db <- main_search()
  

  # EMPTY TEXT INPUTs
  if(is.character(db))
  {
    text <- h4(db, class = 'search_return')
  }
  
  # EMPTY DATA
  else if(is_empty(db))
  {
    text <-  h4("No tweet was found. Please try other term!", class = 'search_return')
  }
  
  # NO EMPTY AND SINGLE
  else if(!is_empty(db) & input$single_doble == "single")
  {
    
    text <-  h4(
      p(paste0("It was found ", nrow(db)," tweets about ", input$text,".")),
      p("Now you are able to use the entire page! Take a look at the menu on the left."),
      class = 'search_return'
    )
  }
  
  # NO EMPTY AND DOBLE
  else if(!is_empty(db) & input$single_doble == "doble")
  {
    
    text <- h4(
      p(paste0(
        "It was found ", 
        nrow(db %>% filter(search_term == input$text1)),
        " tweets about ", 
        input$text1,", and ",
        nrow(db %>% filter(search_term == input$text2)),
        " tweets about ", 
        input$text2,".")
      ),
      p("Now you are able to use the entire page! Take a look at the menu on the left."),
      class = 'search_return'
    )
  }

  # UI TO RETURN
  return_ui <- box(
    width = 10,
    text
  )
  
  return(return_ui)

})


# TWEET PREVIEWs
preview_ui <- eventReactive(input$search,{
  
  # preview for empty text inputs
  if(is.character(main_search()) | is_empty(main_search()))
  {
    preview_ui <- br()
  }
  
  # preview if SINGLE
  else if(input$single_doble == "single")
  {
    db <- main_search() %>%
      arrange(desc(created_at))
    
    preview_ui <- fluidRow(
      box(
        width = 11,
        h1("Top 3 most recent tweets about ", input$text),
        
        hr(),
        
        userBox(
          width = 10,
          title = userDescription(
            title = db$name[1],
            subtitle = HTML(
              paste0(
                '<p>',db$description[1],'<p>',
                '<a href="',
                db$status_url[1], 
                '" target="_blank" class="btn btn-twitter"><i class="fab fa-twitter left"></i></a>')
            ),
            type = 2,
            image = db$profile_image_url[1],
            backgroundImage = db$profile_background_url[1],
          ),
          collapsible = FALSE,
          footer = db$text[1]
        ),
        
        
        userBox(
          width = 10,
          title = userDescription(
            title = db$name[2],
            subtitle = HTML(
              paste0(
                '<p>',db$description[2],'<p>',
                '<a href="',
                db$status_url[2], 
                '" target="_blank" class="btn btn-twitter"><i class="fab fa-twitter left"></i></a>')
            ),
            type = 2,
            image = db$profile_image_url[2],
            backgroundImage = db$profile_background_url[2],
          ),
          collapsible = FALSE,
          footer = db$text[2]
        ),
        
        
        userBox(
          width = 10,
          title = userDescription(
            title = db$name[3],
            subtitle = HTML(
              paste0(
                '<p>',db$description[3],'<p>',
                '<a href="',
                db$status_url[3], 
                '" target="_blank" class="btn btn-twitter"><i class="fab fa-twitter left"></i></a>')
            ),
            type = 2,
            image = db$profile_image_url[3],
            backgroundImage = db$profile_background_url[3],
          ),
          collapsible = FALSE,
          footer = db$text[3]
        )
      
        
      )
    )
  }
  
  # preview if DOBLE
  else if(input$single_doble == "doble")
  {
    db <- main_search() 
    db2<-db
    db1 <- db %>% 
      filter(search_term == input$text1) %>%
      arrange(desc(created_at))
    
    db2 <- db %>% 
      filter(search_term == input$text2) %>%
      arrange(desc(created_at))
    
    preview_ui <- fluidRow(
      box(
        width = 12,
        
        column(
          width = 6,
          class = "preview",
          
          h1("Top 3 most recent tweets about ", input$text1),
          
          hr(),
          
          userBox(
            width = 11,
            title = userDescription(
              title = db1$name[1],
              subtitle = HTML(
                paste0(
                  '<p>',db1$description[1],'<p>',
                  '<a href="',
                  db1$status_url[1], 
                  '" target="_blank" class="btn btn-twitter"><i class="fab fa-twitter left"></i></a>')
              ),
              type = 2,
              image = db1$profile_image_url[1],
              backgroundImage = db1$profile_background_url[1],
            ),
            collapsible = FALSE,
            footer = db1$text[1]
          ),
          
          
          userBox(
            width = 11,
            title = userDescription(
              title = db1$name[2],
              subtitle = HTML(
                paste0(
                  '<p>',db1$description[2],'<p>',
                  '<a href="',
                  db1$status_url[2], 
                  '" target="_blank" class="btn btn-twitter"><i class="fab fa-twitter left"></i></a>')
              ),
              type = 2,
              image = db1$profile_image_url[2],
              backgroundImage = db1$profile_background_url[2],
            ),
            collapsible = FALSE,
            footer = db1$text[2]
          ),
          
          
          userBox(
            width = 11,
            title = userDescription(
              title = db1$name[3],
              subtitle = HTML(
                paste0(
                  '<p>',db1$description[3],'<p>',
                  '<a href="',
                  db1$status_url[3], 
                  '" target="_blank" class="btn btn-twitter"><i class="fab fa-twitter left"></i></a>')
              ),
              type = 2,
              image = db1$profile_image_url[3],
              backgroundImage = db1$profile_background_url[3],
            ),
            collapsible = FALSE,
            footer = db1$text[3]
          )
          
        ),
        
        column(
          width = 6,
          class = "preview",
          
          h1("Top 3 most recent tweets about ", input$text2),
          
          hr(),
          
          userBox(
            width = 11,
            title = userDescription(
              title = db2$name[1],
              subtitle = HTML(
                paste0(
                  '<p>',db2$description[1],'<p>',
                  '<a href="',
                  db2$status_url[1], 
                  '" target="_blank" class="btn btn-twitter"><i class="fab fa-twitter left"></i></a>')
              ),
              type = 2,
              image = db2$profile_image_url[1],
              backgroundImage = db2$profile_background_url[1],
            ),
            collapsible = FALSE,
            footer = db2$text[1]
          ),
          
          
          userBox(
            width = 11,
            title = userDescription(
              title = db2$name[2],
              subtitle = HTML(
                paste0(
                  '<p>',db2$description[2],'<p>',
                  '<a href="',
                  db2$status_url[2], 
                  '" target="_blank" class="btn btn-twitter"><i class="fab fa-twitter left"></i></a>')
              ),
              type = 2,
              image = db2$profile_image_url[2],
              backgroundImage = db2$profile_background_url[2],
            ),
            collapsible = FALSE,
            footer = db2$text[2]
          ),
          
          
          userBox(
            width = 11,
            title = userDescription(
              title = db2$name[3],
              subtitle = HTML(
                paste0(
                  '<p>',db2$description[3],'<p>',
                  '<a href="',
                  db2$status_url[3], 
                  '" target="_blank" class="btn btn-twitter"><i class="fab fa-twitter left"></i></a>')
              ),
              type = 2,
              image = db2$profile_image_url[3],
              backgroundImage = db2$profile_background_url[3],
            ),
            collapsible = FALSE,
            footer = db2$text[3]
          )
        
          
        )
      )
    )
    
  }
   
  return(preview_ui)
})


#- OUTPUTS  

output$api_return <- renderUI(twitter_api_return())

output$tweet_preview <- renderUI(preview_ui())

