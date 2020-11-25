library(DBI)
library(pool)
library(RSQLite)
library(tidyverse)
library(glue)
library(DT)

pool <- dbPool(SQLite(),
               maxSize = 5,
               dbname = "./ui_app.db")

app_user <- dbReadTable(pool, "APP_USER")

renderDT_edit <- function(data, columns) {
    DT::renderDT(data,
                 server = TRUE,
                 editable = list(target = "row",
                                 disable = list(columns = columns)),
                 filter = "top",
                 options = list(scrollX = TRUE))
}

edit_list <- NULL

updateEditDT <- function(data, table_name, keyIndex, edit_list, pool) {
    edited_rows <- unique(edit_list$row)
    
    for (edited_row in edited_rows) {
        setValue <- edit_list %>%
            filter(col != 0) %>% 
            filter(row == glue({edited_row})) %>%
            pull(value) %>%
            paste0(colnames(data), " = '", ., "'")
        
        query <- glue(paste0("UPDATE {table_name} ",
                             "SET {paste(setValue[-keyIndex], collapse = ', ')} ",
                             "WHERE {setValue[keyIndex]}",
                             ";"))
        
        dbExecute(pool, query)
    }
    
    assign("edit_list", NULL, .GlobalEnv)
}