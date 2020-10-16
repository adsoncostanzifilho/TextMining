#- HOME UI 

home <- tabItem(
  tabName = "home",
  
  fluidPage(
    tags$h1(
      tags$span("Welcome to the"),
      tags$span("Text Mining Tool", class = 'h1_twitter'), 
      icon("twitter")
    ),
    
    br(),
    
    h4(
      'The main goal of this interface is to encourage research in the Text Mining and NLP 
      areas. All the code used to develop this interface is available in my personal',
      tags$a(href="https://github.com/adsoncostanzifilho/TextMining", "GitHub Repository"),
      'and, as always, your feedback and contributions are much appreciated!'),
    
    hr(), 
    br(),
    
    h2('How does this interface work?', class = 'left'),
    
    h4(
      'The interface is divided into 5 tabs presented in the menu on the left:',
      tags$b('Home'),",",tags$b('Search'),",",tags$b('Word Cloud'),",",
      tags$b('Sentiment Analysis'),"and,",tags$b('Topic Modeling'),'.',
      class = 'left',sep=""
    ),
    
    br(),
    
    h4(
      'The first thing you need to do to use the entire page is to collect some data 
      from Twitter. To do that you just need to jump into the',tags$b('Search tab'), 
      'and follow the steps presented there!',
      class = 'left'
    ),
    
    br(),
    
    h4(
      'Once you have finished the "data collection" step on the Search tab, you will be 
      able to use the other tabs available on the left menu.',
      class = 'left'
    ),
    
    br(),
    
    h4(
      tags$b('PS:'), 'You will find over the interface some ',
       icon("question",class = 'quest_icon_home'), ' signs, once you click in one of those
      a pop-up with explanations will open to guide you on how to use that option properly.',
      class = 'left'
    ),
    
    br(),
    
    tags$div(
      class='my_footer',
      tags$b('Follow me on the social media: '), 
      tags$b(' '),
      tags$a(
        href="https://www.linkedin.com/in/adsoncostanzifilho/", 
        icon("linkedin", class = 'my_social')),
      tags$a(
        href="https://github.com/adsoncostanzifilho/", 
        icon("github-square", class = 'my_social')),
      tags$a(
        href="https://twitter.com/AdsonCostanzi", 
        icon("twitter-square", class = 'my_social')),
      tags$a(
        href="mailto:adsoncostanzi32@gmail.com", 
        icon("envelope-square", class = 'my_social'))
      
    )
    
    
  )
  
)