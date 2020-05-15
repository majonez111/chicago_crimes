# Module server function
chicago_crimes_server <- function(input, output, session) {

  crimes2019 <- readRDS("my_data.rds")

  output$summary2019<-renderPrint({summary(crimes2019)})
  
  #Clear empty Longitude and latitude
  completeFun <- function(data, desiredCols) {
    completeVec <- complete.cases(data[, desiredCols])
    return(data[completeVec, ])
  }
  
  #Delete outlayers
  cleanedcrimes<-completeFun(crimes2019, c("Longitude", "Latitude"))
  cleanedcrimes<-cleanedcrimes[cleanedcrimes$Longitude>-91.68,]
  
  output$cleared2019<-renderPrint({summary(cleanedcrimes)})
  
  #Take only type of crimes with the highest ratio of occurence
  cleanedcrimes1<-cleanedcrimes[(cleanedcrimes$Primary.Type=="THEFT") |(cleanedcrimes$Primary.Type=="BURGLARY")  |(cleanedcrimes$Primary.Type=="CRIMINAL DAMAGE") |(cleanedcrimes$Primary.Type=="DECEPTIVE PRACTICE") |(cleanedcrimes$Primary.Type=="MOTOR VEHICLE THEFT"|(cleanedcrimes$Primary.Type=="ROBBERY")),]
  
  #Calculate cooratinate to the map function
  height <- max(cleanedcrimes$Latitude) - min(cleanedcrimes$Latitude)
  width <- max(cleanedcrimes$Longitude) - min(cleanedcrimes$Longitude)
  borders <- c(bottom  = min(cleanedcrimes$Latitude)  - 0.1 * height, 
               top     = max(cleanedcrimes$Latitude)  + 0.1 * height,
               left    = min(cleanedcrimes$Longitude) - 0.1 * width,
               right   = max(cleanedcrimes$Longitude) + 0.1 * width)
  
  set.seed(20)
  
  data<-reactive({input$decimal})

  output$mapa<-renderPlot({
    
    clusters <- kmeans(cleanedcrimes[,5:6], data())
    # Save the cluster number in the dataset as column 'Labels'
    cleanedcrimes$Labels <- as.factor(clusters$cluster)
    
    map <- get_stamenmap(borders, zoom = 10, maptype = "terrain")
    mapa<-ggmap(map)+geom_point(aes(x = Longitude[], y = Latitude[], colour = as.factor(Labels)),data = cleanedcrimes) +
      ggtitle("Chicago using KMean")
    
    mapas<-data.frame(clusters$centers)
    mapa1<-mapa+geom_point(aes(x = Longitude[], y = Latitude[]),data = mapas)
    
    saveRDS(clusters, file = "clusters.rds")
    
    plot(mapa1)
  })
  
  #import policestation
  ioioio <- read.csv("Police_Stations.csv")
  
  quick<-reactive({input$quick})
  
  output$mapa2<-renderPlot({
      req("clusters.rds")
      clusters <- readRDS("clusters.rds")
      #mapa2<-mapa1+geom_point(aes(x = LONGITUDE[], y = LATITUDE[]), shape=23, fill="blue", color="darkred", size=3,data = ioioio)
    
      #Quick response police station
      clusters1 <- kmeans(cleanedcrimes1[,5:6], input$quick)
      cleanedcrimes1$Labels <- as.factor(clusters1$cluster)
      
      map <- get_stamenmap(borders, zoom = 10, maptype = "terrain")
      
      #Quick response police station
      mapa<-ggmap(map)+geom_point(aes(x = Longitude[], y = Latitude[], colour = as.factor(Labels)),data = cleanedcrimes1) +
        ggtitle("Chicago using KMean")+geom_point(aes(x = Longitude[], y = Latitude[]),data = data.frame(clusters1$centers))
      
      #Main police station
      mapa1<-mapa+geom_point(aes(x = Longitude[], y = Latitude[]),shape=12,fill="green", color="darkred", size=3,data = data.frame(clusters$centers))
      #Current police station
      mapa2<-mapa1+geom_point(aes(x = LONGITUDE[], y = LATITUDE[]), shape=23, fill="blue", color="darkred", size=2,data = ioioio)
      
      plot(mapa2)
  
  })
}
