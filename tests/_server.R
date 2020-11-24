library(shiny)
library(shinydashboard)
library(shinyauthr)
library(glue)

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
    
    app_user_copy <- app_user
    
    output$user_table <- renderUI({
        req(credentials()$user_auth)
        tagList(
            DT::renderDT({app_user_copy}, editable = TRUE),
            cat(app_user_copy$password)
        )
        
    })
    
    user_info <- reactive({credentials()$info})
    
    user_data <- reactive({
        if(user_info()$permissions == "admin") {
            dplyr::starwars[,1:10]
        } else if (user_info()$permissions == "standard") {
            dplyr::storms[,1:11]
        }
    })
    
    output$user_data <- renderUI({
        req(credentials()$user_auth)
        tagList(
            DT::renderDT({user_data()}, editable = TRUE))
    })
    
    output$dtmtcars <- renderUI({
        req(credentials()$user_auth)
        tagList(
            DT::renderDataTable(dtmtcars,
                                editable = list(target = "row",
                                                disable = list(columns = c(2, 4, 5))),
                                server = TRUE)
            )
    })
    
    observeEvent(input$dtmtcars_cell_edit, {
        dtmtcars <<- editData(dtmtcars, input$dtmtcars_cell_edit, "dtmtcars")
        print(dtmtcars)
    })
    
    output$welcome <- renderText({
        req(credentials()$user_auth)
        
        glue("Welcome {user_info()$name}")
    })
    
    
})