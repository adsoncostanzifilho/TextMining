#- HOME UI 

home <- tabItem(
  tabName = "home",
  
  fluidRow(
    widgetUserBox(
      title = "Adson Costanzi Filho",
      subtitle = "Statistician/Data Scientist",
      width = 7,
      type = 2,
      src = "img/profile.png",
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
        
        h3(log_pesquisa$termo[1], 
           style = "color:#00A7D0",
           align = "center"),
        
        tags$hr(),
        
        h3(log_pesquisa$termo[2], 
           style = "color:#00A7D0",
           align = "center"),
        
        tags$hr(),
        
        h3(log_pesquisa$termo[3], 
           style = "color:#00A7D0",
           align = "center"),
        
        tags$hr(),
        
        h3(log_pesquisa$termo[4], 
           style = "color:#00A7D0",
           align = "center"),
        
        tags$hr(),
        
        h3(log_pesquisa$termo[5], 
           style = "color:#00A7D0",
           align = "center")
    )
    
  )
  
)