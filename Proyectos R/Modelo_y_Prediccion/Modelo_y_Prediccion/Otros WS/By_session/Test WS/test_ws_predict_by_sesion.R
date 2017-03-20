rm(list=ls())

is.installed <- function(paquete) is.element (
  paquete, installed.packages())

if(!is.installed("RCurl"))
  install.packages("RCurl")
if(!is.installed("rjson"))
  install.packages("rjson")

library("RCurl")
library("rjson")



# Accept SSL certificates issued by public Certificate Authorities
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))


h = basicTextGatherer()
hdr = basicHeaderGatherer()


req =  list(
  Inputs = list(
    "session_id"= list(
      list(
        'session_id' = "tEwRr"
      )
    )
  ),
  GlobalParameters = setNames(fromJSON('{}'), character(0))
)


body = enc2utf8(toJSON(req))
api_key = "aP8vVSIvQB6Q2lBk0mJNhRRUDK6UJ5t9d+SQUKJWWs4xmXcnY7JEsxOWk4qNDCkYETx29F9J/FSluSncveBizg=="
authz_hdr = paste('Bearer', api_key, sep=' ')


# Hacemos la llamada mediante un curl
h$reset()
curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/7c902930841a4292a9a25c87945f493c/services/b741e35acbc94232a970ec9b3dd7b700/execute?api-version=2.0&format=swagger",
            httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
            postfields=body,
            writefunction = h$update,
            headerfunction = hdr$update,
            verbose = TRUE
)

headers = hdr$value()
httpStatus = headers["status"]
# En caso de error
if (httpStatus >= 400)
{
  print(paste("The request failed with status code:", httpStatus, sep=" "))
  
  # Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
  print(headers)
}

# Imprimimos resultados
print("Result:")
result = h$value()
print(fromJSON(result))