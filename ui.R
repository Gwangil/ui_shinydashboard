library(shiny)
library(shinydashboard)
library(shinyauthr)

dsbdHeader <- dashboardHeader(title = "Dashboard Title",
                              tags$li(class = "dropdown", style = "padding: 8px;",
                                      shinyauthr::logoutUI("logout")))

dsbdSidebar <- dashboardSidebar(collapsed = TRUE,
    sidebarMenu(
        menuItem("Menu A", tabName = "menuA"),
        menuItem("Menu B", tabName = "menuB"),
        menuItem("Menu C", tabName = "menuC")
    )
)

dsbdBody <- dashboardBody(
    shinyjs::useShinyjs(),
    loginUI(id = "login"),
    uiOutput("user_table")
)

shinyUI(dashboardPage(dsbdHeader, dsbdSidebar, dsbdBody, skin = "blue"))