library(rsconnect)

token <- Sys.getenv("SECRETS_RSCONNECT_TOKEN")
secret <- Sys.getenv("SECRETS_RSCONNECT_SECRET")

if(any(c(token,secret) == "")){
    token <- Sys.getenv("INPUT_FIRSTGREETING")
    secret <- Sys.getenv("INPUT_SECONDGREETING")
}

setAccountInfo(name="julian-johannes-umbhau-jensen",
                token=token, # get token through github secrets 
                secret=secret) # get token through github secrets

deployApp(getwd(), forceUpdate = T)

