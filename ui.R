library(shiny); library(shinythemes); library(dplyr); library(markdown)
shinyUI(fluidPage(theme = shinytheme("flatly"),
    titlePanel(h1("StormApp")),
    sidebarLayout(
        sidebarPanel(
            br(),
            selectInput("humans","1. Plot settings: Harm to Humans",
                        choices=c("Total Harm","Deaths Dangers","Injuries Dangers"),
                        selected = "Total Harm"),
            br(),
            radioButtons("econ","2. Plot settings: Damage to Economics",
                         list("Total Damage","Dangers to Property", "Dangers to Crops"),
                         selected = "Total Damage"),
            actionButton("action", "Update Plot"),
            p("Click Update button to refresh Damage to Economics Plot"),
            br()
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("About",includeMarkdown("./README.md")),  
                tabPanel("Plots",column(10,plotOutput("Plot1"),
                                        plotOutput("Plot2"))),
                tabPanel("Tables", column(4, wellPanel(
                    selectInput("HarmtoHumans",
                                "Harm to Humans:",
                                c("Top-10", "Top-20", "All-48"),
                                selected = "Top-10"))),
                    column(4,wellPanel(
                        selectInput("DamagetoEconomics",
                                    "Damage to Economics:",
                                    c("Top-10", "Top-20",
                                      "All-48"),
                                    selected = "Top-10"))),
                    column(7,tableOutput("Table1"),
                           tableOutput("Table2")))
            ))
    )))
