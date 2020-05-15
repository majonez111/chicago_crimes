library(rsconnect)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(httr)
library(shinycssloaders)
library(ggmap)
library(grDevices)
library(plyr)
library(dplyr)
library(shinyWidgets)
library(ggplot2)

Sys.setlocale("LC_ALL", "Polish")
options(encoding = 'CP1250')

source("chicago_crimes_server.R")
source("chicago_crimes.R")


fluidPage(theme = shinytheme("darkly"), 
          navbarPage("Kamil Kandzia", 
             id = "navbarID",
             tabPanel("Chicago crimes", chicago_crimes("chicago_crimes1"), icon=icon("user-secret"))
            )
)