library(DBI)
library(pool)
library(RSQLite)

pool <- dbPool(SQLite(),
               maxSize = 5,
               dbname = "./ui_app.db")

app_user <- dbReadTable(pool, "APP_USER")