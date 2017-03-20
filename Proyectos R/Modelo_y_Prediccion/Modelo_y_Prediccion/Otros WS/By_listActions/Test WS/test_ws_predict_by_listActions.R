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
    "accion"= list(
      list(
        'accion' = "187",
        'desc_accion' = "Desc_187"
      ),
      list(
        'accion' = "130",
        'desc_accion' = "Desc_130"
      ),
      list(
        'accion' = "101",
        'desc_accion' = "Desc_101"
      )
    )
  ),
  GlobalParameters = setNames(fromJSON('{}'), character(0))
)


body = enc2utf8(toJSON(req))
api_key = "Jh3IWsVTzDzY/T//G2m6Y8jQAAYXZOBZEMOQFDD6Gfj2n4xAGngN6HulnTVIsnn3gbZ1tHMZLzgxs7NMR1VyIQ=="
authz_hdr = paste('Bearer', api_key, sep=' ')


# Hacemos la llamada mediante un curl
h$reset()
curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/7c902930841a4292a9a25c87945f493c/services/73c41628178140b2ba6cd4c54d79a567/execute?api-version=2.0&format=swagger",
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