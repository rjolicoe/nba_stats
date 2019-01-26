#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinydashboard)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(ballr)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme('cerulean'),
   
   # Application title
   br(),
   img(src = 'NBA_logo.png', align = 'left', height = '80', width = '100'),
   br(),
   br(),
   br(),
   titlePanel("NBA Statistics"),
   br(),
   
   # Sidebar with a slider input for number of bins 
     tabsetPanel(
       tabPanel("NBA Team Projections",
        sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of teams:",
                     min = 1,
                     max = 16,
                     value = 5),
         dateInput("date1", "Choose date for Team Standings", value = Sys.Date()),
         radioButtons("conference", "Conference Choice:",
                      c("East", "West"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel( 
        h2("Team Statistics"),
        DT::dataTableOutput("teamstats")
         
      )

   )
),
   # Start of second tab player statistics
      tabPanel("Player Statisticis",
          sidebarLayout(
            sidebarPanel(
              sliderInput("players",
                          "Number of players:",
                          min = 1,
                          max = 50,
                          value = 25),
              radioButtons("plyr_conference", "Conference Choice:", 
                           c("East", "West"))
            ),
          mainPanel(plotOutput("playerPlot")))
)
)
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
   
   output$playerPlot <- renderPlot({
     # generate bins based input$players from ui.R
     x <- faithful[,2]
     bins <- seq(min(x), max(x), length.out = input$bins+1)
     
     hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
   
   output$teamstats <- DT::renderDataTable({
      standings <- NBAStandingsByDate(input$date1) 
      standings <- as.data.frame(standings[input$conference])
      
      standings
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

