library(shiny)
library(bslib)
library(duckdb)
library(DBI)
library(tidyverse)
library(plotly)

# Connect to DuckDB
con <- dbConnect(
  duckdb(),
  dbdir = here::here("cta_transforms/dev.duckdb"),
  read_only = TRUE
)

# Load mart tables into memory
monthly <- dbGetQuery(con, "SELECT * FROM mart_monthly_ridership ORDER BY month")
dow     <- dbGetQuery(con, "SELECT * FROM mart_dow_ridership ORDER BY day_of_week_num")

# Disconnect after loading
dbDisconnect(con)

# Convert month to date
monthly$month <- as.Date(monthly$month)