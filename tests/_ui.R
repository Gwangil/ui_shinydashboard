library(shiny)
library(shinydashboard)
library(shinyauthr)

dsbdHeader <- dashboardHeader(title = "Dashboard Title",
                              tags$li(class = "dropdown", style = "padding: 8px;",
                                      shinyauthr::logoutUI("logout")))

dsbdSidebar <- dashboardSidebar(collapsed = TRUE,
                                div(textOutput("welcome"),uiOutput("buttons")),
    sidebarMenu(
        menuItem("Menu A", tabName = "menuA"),
        menuItem("Menu B", tabName = "menuB"),
        menuItem("Menu C", tabName = "menuC")
    )
)

dsbdBody <- dashboardBody(
    shinyjs::useShinyjs(),
    shinyauthr::loginUI(id = "login"),
    tabItems(
        tabItem(tabName = "menuA",
                fluidRow(
                    box(DT::DTOutput("dtmtcars"))
                )),
        
        tabItem(tabName = "munuB",
                fluidRow(
                    # box()
                ))
    )
    
    
    
)

shinyUI(dashboardPage(dsbdHeader, dsbdSidebar, dsbdBody, skin = "blue"))