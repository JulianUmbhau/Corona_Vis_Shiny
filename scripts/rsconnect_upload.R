library(rsconnect)

token <- Sys.getenv("RSCONNECT_TOKEN")
secret <- Sys.getenv("RSCONNECT_SECRET")

if(any(c(token,secret) == "")){
    token <- Sys.getenv("INPUT_FIRSTGREETING")
    secret <- Sys.getenv("INPUT_SECONDGREETING")
}

message("Token: ", token)
message("Secret: ", secret)

token <- '2C37B4019E3B949BE5D490DDAC59A196'
secret <- 'xst+aZ/6zTvuuNnOcbkVq9NAju+0uPyrqf4yfPoB'

setAccountInfo(name="julian-johannes-umbhau-jensen",
                token=token, # get token through github secrets 
                secret=secret) # get token through github secrets

deployApp(getwd(), forceUpdate = T)

