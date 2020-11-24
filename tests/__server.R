library(shiny)
library(shinydashboard)
library(shinyauthr)
library(tidyverse)
library(DT)

shinyServer(function(input, output, session) {
    credentials <- callModule(shinyauthr::login,
                              id = "login",
                              data = app_user,
                              user_col = user,
                              pwd_col = password,
                              # sodium_hashed = TRUE,
                              log_out = reactive(logout_init()))
    
    logout_init <- callModule(shinyauthr::logout,
                              id = "logout",
                              active = reactive(credentials()$user_auth))
    
    observe({
        if(credentials()$user_auth) {
            shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
        } else {
            shinyjs::addClass(selector = "body", class = "sidebar-collapse")
        }
    })
})

onStop(function() {
    poolClose(pool)
    rm(pool)
})