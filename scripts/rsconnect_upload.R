library(rsconnect)

token <- Sys.getenv("RSCONNECT_TOKEN")
secret <- Sys.getenv("RSCONNECT_SECRET")

if(any(c(token,secret) == "")){
    token <- Sys.getenv("INPUT_FIRSTGREETING")
    secret <- Sys.getenv("INPUT_SECONDGREETING")
}

message("Token: ", token)
message("Secret: ", secret)

setAccountInfo(name="julian-johannes-umbhau-jensen",
                token=token, # get token through github secrets 
                secret=secret) # get token through github secrets

deployApp(getwd(), forceUpdate = T)

