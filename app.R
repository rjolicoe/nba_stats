#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# Update to github and deploy onto Shinyapps.Io
# 
# 
#


library(shiny)
library(shinydashboard)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(ballr)
library(DT)
library(lubridate)
library(magrittr)
library(janitor)
library(scales)
source("scripts/script_file.R")

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
      tabPanel("Player Statistics",
          sidebarLayout(
            sidebarPanel(
              sliderInput("players",
                          "Season Played from 1950 to current:",
                          min = 1950,
                          max = year(Sys.Date()),
                          value = 2018),
              radioButtons("plyr_conference", "Conference Choice:", 
                           c("East", "West"))
            ),
          mainPanel(
            h2(textOutput("plyr_season")),
            DT::dataTableOutput("playerstats")
          )
))))

# Define server logic required to draw a histogram
server <- function(input, output) {

    # Team statistics
   output$teamstats <- DT::renderDataTable({
      standings <- NBAStandingsByDate(input$date1) 
      standings <- as.data.frame(standings[input$conference])
      
      standings
   })
   
   # Player Statistics
   output$playerstats <- DT::renderDataTable({
     # Will move the slider inyear for the year with summaries
     player_stats <- player(input$players)
     
     player_stats
   })
   
   output$plyr_season <- renderText({
     paste("Player Statistics in:", input$players)
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

