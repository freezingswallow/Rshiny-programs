###########################
#    R Shiny Learning     #
#    Author: Zoe          #
###########################
#https://shiny.rstudio.com/articles/datatables.html


#install.packages("shiny")
#install.packages("DT")
library(shiny)
runExample("01_hello")


Sys.setenv(JAVA_HOME='C:\\Program Files (x86)\\Java\\jre7')

#Create a squence with 100 numbers
a <- c(1:100)

#set a seed and create a column with 100 random numbers
set.seed(20181129)
b <- rnorm(100)

#combine the two elements together
data <- cbind(a,b)
colnames(data) <- c("Kitnum","rand")

#sort the matrix by the second column
newdata <- data[order(data[,"rand"]),]

#assign first 50 rows to treatment Active and the last 50 rows to treatment placebo

c <- rep(c("active","placebo"),each = 50)

newdata1 <- cbind(newdata,c)
colnames(newdata1) <- c("Kitnum","rand","Treatment")

#output to csv file
getwd()
write.csv(newdata1,'C:/Users/yi.zhou/Documents/Learning/Rshiny Buildup/randomization list.csv')

###Start to embark on the journey of R shiny

library(DT)

ui <- basicPage(
  
   h2("The Drugkit List"),
   DT::dataTableOutput("mytable")
)

server <- function(input, output){
  output$mytable = DT::renderDataTable({newdata1})
}

shinyApp(ui,server)

