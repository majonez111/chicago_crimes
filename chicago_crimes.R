chicago_crimes <- function(id, label = "chicago_crimes1") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  XD
  
  mainPanel(width=12,
              fixedRow(
                h1("Chicago crimes"),
                p("The Chicago Police Department has been supplying information on the incidents since 2001. The database holds elements such as crime co-ordinates, type of crime and number of arrests. Based on this dataset, an intention was made to present the data visually."),
                p("The first step was to separate the data. Because the data are from 19 years, the complete last year of 2019 was analysed."),
                withSpinner(verbatimTextOutput(ns("summary2019")),color="#0dc5c1"),
                p("Clear empty Longitude and latitude, and remove outlier"),
                withSpinner(verbatimTextOutput(ns("cleared2019")),color="#0dc5c1"),
                p("Next stage was to implement the K-means algorithm, by the latitude and longitude or occurrence of the crimes."),
                sliderInput(ns("decimal"), "K:",
                            min = 1, max = 10,
                            value = 5, step = 1),
                p("Plot k-means with appropriate number of k"),
                withSpinner(plotOutput(ns("mapa")),color="#0dc5c1"),
                sliderInput(ns("quick"), "Number of quick response police stations",
                            min = 1, max = 20,
                            value = 18, step = 1),
                p("Final map with quick response police stations, normal police stations and current stations"),
                withSpinner(plotOutput(ns("mapa2")),color="#0dc5c1")
                ))
}
