library(shiny)
library(shinydashboard)
library(shinyauthr)
library(shinyjs)
library(DT)

dsbdHeader <- dashboardHeader(title = "Dashboard Title",
                              tags$li(class = "dropdown", style = "padding: 8px;",
                                      shinyauthr::logoutUI("logout")))

dsbdSidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Menu A", tabName = "menuA", icon = icon("moon"))
    )
)

dsbdBody <- dashboardBody(
    shinyjs::useShinyjs(),
    shinyauthr::loginUI(id = "login", title = "Login to Dashboard"),
###################################################################################################
    tabItems(
        tabItem(tabName = "menuA",
            div(DTOutput("mtcarsdb"),
                actionButton(inputId = "save", "Save", icon = icon("save")),
                actionButton(inputId = "sync", "Sync", icon = icon("sync")),
                downloadButton(outputId = "download", "Download")
                )
        )
        
    )
)

shinyUI(dashboardPage(dsbdHeader, dsbdSidebar, dsbdBody, skin = "blue"))