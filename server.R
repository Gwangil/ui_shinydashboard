library(shiny)
library(shinydashboard)
library(shinyauthr)
library(shinyjs)
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
            shinyjs::show("mtcarsdb")
            shinyjs::show("save")
            shinyjs::show("sync")
            shinyjs::show("download")
        } else {
            shinyjs::addClass(selector = "body", class = "sidebar-collapse")
            shinyjs::hide("mtcarsdb")
            shinyjs::hide("save")
            shinyjs::hide("sync")
            shinyjs::hide("download")
        }
    })
    
###################################################################################################
    
    # 조회
    mtcars_db <- dbReadTable(pool, "MTCARS")
    
    # 출력
    output$mtcarsdb <- renderDT_edit(mtcars_db, c(2, 4, 5))
    
    # 수정
    observeEvent(input$mtcarsdb_cell_edit, {
        edit_list <<- bind_rows(edit_list, input$mtcarsdb_cell_edit)
        mtcars_db <<- editData(mtcars_db, input$mtcarsdb_cell_edit, "mtcarsdb")
    })
    
    # 저장
    observeEvent(input$save, {
        updateEditDT(data = mtcars_db,
                     table_name = "MTCARS",
                     keyIndex = 12,
                     edit_list = edit_list,
                     pool = pool)
    })
    
    # 동기화
    observeEvent(input$sync, {
        mtcars_db <<- dbReadTable(pool, "MTCARS")
        output$mtcarsdb <- renderDT_edit(mtcars_db, c(2, 4, 5))
    })
    
    # 다운로드
    output$download <- downloadHandler(filename = "mtcars.csv",
                                       content = function(file) {
                                           write.csv(mtcars_db, file, row.names = FALSE, fileEncoding = "CP949")
                                       })
    
})

# onStop(function() {
#     poolClose(pool)
#     # rm(pool)
# })