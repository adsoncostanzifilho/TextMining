#- CLOUD UI 

cloud <- tabItem(
  tabName = "cloud",
  
  fluidPage(
    
    h1("Welcome to the Word Cloud Page!"),
    h4("Here you will be able to visualize different kinds of word clouds 
       and have a better understanding of the topics related to your search."),
    
    hr(),
    
    box(
      width = 8,
      h3("Word Cloud Options"),
      hr(),
      
      # OPTIONS
      box(
        width = 12,
        textInput(
          inputId = "stop",
          label = "Add Stop Words",
          placeholder = "ex: rt, one, two") %>%
          helper(
            icon = "question",
            colour = "#3c8dbb",
            type = "inline",
            fade = TRUE,
            title = "Add Stop Words",
            content = c(
              "Stop Words are all those words commonly used in any language that has very little meaning, 
              such as 'and', 'the', 'a', 'an', etc.",
              "",
              "This option makes it possible for you to <b>include more Stop Words </b>in your analysis.",
              "",
              "<b>PS</b>:",
              "- All words you includ here will be disregarded in further analysis!",
              "- The tool considers as default the Stop Words from the <b>R package stopwords</b>.",
              ""
            ),
            buttonLabel = 'Got it!')
      ),
      
      box(
        width = 12,
        prettyRadioButtons(
          inputId = "div_words",
          selected = "no_split",
          label = "Do you want to split the Word Cloud by Positive, Negative, and Neutral words?",
          thick = TRUE,
          choices = c("Split it!"="split", "Do not split it!"="no_split"),
          animation = "pulse",
          status = "info",
          inline = TRUE) %>%
          helper(
            icon = "question",
            colour = "#3c8dbb",
            type = "inline",
            fade = TRUE,
            title = "Do you want to split the Word Cloud by Positive, Negative, and Neutral words?",
            content = c(
              "If you press the <b>'Split it!'</b> option you will <b>split the words in the Word Cloud</b> 
              in Positive (green), Negative (red) and, Neutral (blue) words.",
              "",
              "You must be able to select what words you want to show in the Word Cloud 
              by combining the checkbox options: Positive, Negative, and Neutral.",
              ""
            ),
            buttonLabel = 'Got it!'),
        
        conditionalPanel(
          condition = "input.div_words == 'split'",
          prettyCheckboxGroup(
            inputId = "show_words_split",
            selected = c("green", "red", "blue"),
            label = "Split words by:",
            thick = TRUE,
            inline = TRUE, 
            choices = c("Positive"="green", "Negative"="red", "Neutral"="blue"),
            animation = "pulse",
            status = "info"
          ) 
        )
      ),
      
      conditionalPanel(
        condition = "input.single_doble == 'doble'",
        box(
          width = 12,
          prettyRadioButtons(
            inputId = "show_words_diff",
            selected = "all",
            label = "What kind of words do you want to show?",
            thick = TRUE,
            choices = c("All"="all", "Just Different"="diff", "Just Equal"="equal"),
            animation = "pulse",
            status = "info",
            inline = TRUE) %>%
            helper(
              icon = "question",
              colour = "#3c8dbb",
              type = "inline",
              fade = TRUE,
              title = "What kind of words do you want to show?",
              content = c(
                "This option makes it possible to compare more deeply the words being used for each searched term.",
                "",
                "<b>All</b>: This option will show all words from both Word Clouds.",
                "",
                "<b>Just Different</b>: This option will compare the words of each searched term and show just the ones that are unique.",
                "",
                "<b>Just Equal</b>: This option will compare the words of each searched term and show just the ones that are common for both.",
                ""
              ),
              buttonLabel = 'Got it!')
        )
      )
    ),
    
    # WORD CLOUD
    uiOutput('word_cloud_ui')
    
    
  )
  
)