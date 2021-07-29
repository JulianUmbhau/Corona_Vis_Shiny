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

# setAccountInfo(name='julian-johannes-umbhau-jensen', 
#                token='2C37B4019E3B949BE5D490DDAC59A196', 
#                secret='xst+aZ/6zTvuuNnOcbkVq9NAju+0uPyrqf4yfPoB')

deployApp(getwd(), forceUpdate = T)

