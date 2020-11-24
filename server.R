library(shiny)
library(shinydashboard)
library(shinyauthr)
library(shinyjs)
library(tidyverse)
library(DBI)
library(RSQLite)
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
            removeClass(selector = "body", class = "sidebar-collapse")
            show("mtcarsdb")
            show("save")
            show("sync")
            show("download")
        } else {
            addClass(selector = "body", class = "sidebar-collapse")
            hide("mtcarsdb")
            hide("save")
            hide("sync")
            hide("download")
        }
    })
    
###################################################################################################
    
    # 조회
    mtcars_db <- dbReadTable(pool, "MTCARS")
    
    # 출력
    output$mtcarsdb <- renderDT(mtcars_db,
                                server = TRUE,
                                editable = list(target = "row",
                                                disable = list(columns = c(2, 4, 5))),
                                filter = "top",
                                options = list(scrollX = TRUE))    
    
    # 수정
    observeEvent(input$mtcarsdb_cell_edit, {
        mtcars_db <<- editData(mtcars_db, input$mtcarsdb_cell_edit, "mtcarsdb")
    })
    
    # 저장
    observeEvent(input$save, {
        dbRemoveTable(pool, "MTCARS")
        dbWriteTable(pool, "MTCARS", mtcars_db)
    })
    
    # 동기화
    observeEvent(input$sync, {
        mtcars_db <<- dbReadTable(pool, "MTCARS")
        output$mtcarsdb <- renderDT(mtcars_db,
                                    server = TRUE,
                                    editable = list(target = "row",
                                                    disable = list(columns = c(2, 4, 5))),
                                    filter = "top",
                                    options = list(scrollX = TRUE))  
    })
    
    # 다운로드
    output$download <- downloadHandler(filename = "mtcars.csv",
                                       content = function(file) {
                                           write.csv(mtcars_db, file, row.names = FALSE, fileEncoding = "CP949")
                                       })
    
})

onStop(function() {
    poolClose(pool)
    # rm(pool)
})