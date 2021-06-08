library(rsconnect)

rsconnect_data <- readRDS("/home/rstudio/Corona_Vis_Shiny/scripts/rsconnect_data.rds")

setAccountInfo(name=rsconnect_data$name,
                token=rsconnect_data$token, 
                secret=rsconnect_data$secret)

deployApp("/home/rstudio/Corona_Vis_Shiny/", recordDir = "~")

