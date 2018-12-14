
### Dataset Preparation Part ###

genlist <- function(N1, N2,start, seed, grp1name, grp2name){
  
  #  Total number of drug kits to generate
  total_N <- N1 + N2
  begin_N <- start
  end_N <- begin_N + N1 + N2 -1
  
  #  Create (N1 + N2) of kit numbers starting from beginN
  a <- c(begin_N:end_N)
  
  #  Create (N1 + N2) of random values
  set.seed(seed)
  b <- rnorm(N1+N2)
  
  #  Combine the two elements together
  data <- cbind(a,b)
  colnames(data) <- c("Kitnum","rand")
  
  #  Sort the matrix by the second column
  data <- data[order(data[,"rand"]),]
  
  #assign the first N1 to Treatment group, and the rest N2 to placebo group
  
  c <- rep(c(grp1name, grp2name), times = c(N1, N2))
  
  data1 <- cbind(data, c)
  colnames(data1) <- c("Kitnum","Rand","Group")
  
  
  return(data1)
  
}

aa <- genlist(1000,1000,10001, 20181026,"Active","Placebo")



### Shiny Main Part ###

ui <- fluidPage(
  
  # App title ----
  titlePanel("Generate a randomization list for drugs"),
  
  # Sidebar layout with input and output definitions ---
  sidebarLayout(
    
    # Sidebar panel for inputs ---
    sidebarPanel(
      
      # Input: Let the User give the parameters to generate dataset ----
      numericInput('N1', 'How many Active Drug kits do you need?', 680),
      numericInput('N2', 'How many Placebo Drug kits do you need?', 680),
      numericInput('start', 'From which number you want your kit number to start with?', 10001),
      numericInput('seed', 'Now we need a seed to generate the list, please type in the box below', 12345678),
      textInput('grp1name', 'Type in the name you want to call Active drug', "CIBI308"),
      textInput('grp2name', 'Type in the name you want to call the placebo', "placebo"),
      
      #Button
      downloadButton("downloadData","Download"),
      downloadButton("downloadData1","Parameter Save as")
      
    ),
    
    # Main panel for displaying outputs ---
    mainPanel(
      tableOutput("table")
    )
  )
)



server <- function(input,output){
  
  # Reactive value for selected dataset ---
  
    datasetInput <- reactive( {
    
    
    newdata <- genlist(input$N1,input$N2,input$start, input$seed,input$grp1name,input$grp2name)
    
    return(newdata)
  })
  
    
    mydefine <- reactive({
       a <- c("Number of Active Drug", "Number of Placebo Drug", "Number to Start with","Seed ","Name of Active Group","Name of Placebo Group")
       b <- c(input$N1,input$N2,input$start, input$seed,input$grp1name,input$grp2name)
       new <- rbind(a,b)
       return(new)
      })

  
  # Table of selected dataset ---
  output$table <- renderTable({datasetInput()})
  #output$table1 <- renderTable({mydefine()})
  
  # Downloadable csv of selected dataset ---
  
  output$downloadData <- downloadHandler(
    filename = function(){
      paste(input$dataset,".csv", sep = "")
    },
    content = function(file){
      write.csv(datasetInput(),file, row.names = FALSE)
    }
  )
  
  output$downloadData1 <- downloadHandler(
    filename = function(){
      paste("parameter.csv")
    },
    content = function(file){
      write.table(mydefine(),sep = ',',file, row.names = FALSE, col.names = FALSE)
    }
  )
  
  
}

shinyApp(ui,server)
