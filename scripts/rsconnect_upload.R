library(rsconnect)

rsconnect_data <- readRDS("./data/rsconnect_data.rds")

setAccountInfo(name=rsconnect_data$name,
                token=rsconnect_data$token, 
                secret=rsconnect_data$secret)

deployApp("/home/rstudio/Corona_Vis_Shiny/", recordDir = "~")

