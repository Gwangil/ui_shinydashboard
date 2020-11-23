library(shiny)
library(shinydashboard)
library(shinyauthr)
library(DBI)
library(RSQLite)

conn <- dbConnect(SQLite(),
                  dbname = "./ui_app.db")


app_user <- dbReadTable(conn, "APP_USER")
