library("RCurl")
library("rjson")

# Definimos variables globales
# Aceptar SSL como opcion para el Curl
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))


h = basicTextGatherer()
hdr = basicHeaderGatherer()


# 1. Primero llamamos al WS que carga la tabla streaming_sequencies

req = list(
  GlobalParameters = setNames(fromJSON('{}'), character(0))
)


body = enc2utf8(toJSON(req))
api_key = "T2y8gIJHViHziiPu0ky/rR1i31U/dyAmUHVCY5HKXu73aKCctbXAlDlGzcYwvc5dY0qNZC6lI0b1WJe1iH1chQ=="
authz_hdr = paste('Bearer', api_key, sep = ' ')


h$reset()
curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/7c902930841a4292a9a25c87945f493c/services/360e7f8628f649a4b2dcfabbd18b0a63/execute?api-version=2.0&format=swagger",
            httpheader = c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
            postfields = body,
            writefunction = h$update,
            headerfunction = hdr$update,
            verbose = TRUE
)


headers = hdr$value()
httpStatus = headers["status"]
# Si hay algun tipo de error en el WS
if (httpStatus >= 400) {
    print(paste("The request failed with status code:", httpStatus, sep = " "))
    # Imprimimos las cabeceras con el timestamp, ID, mensage de error, etc.
    print(headers)

    # Vemos tambien el resultado que contrendra entre otros: codigo de error, mensaje y detalles
    print("Result:")
    result = h$value()
    print(fromJSON(result))

# Sino ha habido error en la carga del streaming
} else {
    # Revisamos la salida
    print("Result:")
    result = h$value()
    print(fromJSON(result))


    # 2. Llamada al segundo WS: clusterizamos las secuencias.
    req = list(
      GlobalParameters = setNames(fromJSON('{}'), character(0))
    )

    body = enc2utf8(toJSON(req))
    api_key = "4Khqw/fi8f9U0Mfh1PIZb1MMACZgxML7ZRT97OUEeEggIq+GuwS65mN5MRfkc8SYZOYuCswDrD6yDpZHiy5dBg=="
    authz_hdr = paste('Bearer', api_key, sep = ' ')

    h$reset()
    curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/7c902930841a4292a9a25c87945f493c/services/39245e585e254642a42cb382f853e73f/execute?api-version=2.0&details=true",
                httpheader = c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields = body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )

    headers = hdr$value()
    httpStatus = headers["status"]
    if (httpStatus >= 400) {
        print(paste("The request failed with status code:", httpStatus, sep = " "))

        # Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
        print(headers)
    }

    print("Result:")
    result = h$value()
    print(fromJSON(result))
    finalResult <- fromJSON(result)

    # Encapsulo resultados del web service (solo tendre los resultados de la 
    # clusterizacion de las ultimas sesiones en streaming_sessions)
    resultados <- do.call("rbind", finalResult$Results$salida$value$Values)
    scoredSecuencias <- data.frame(resultados)
    names(scoredSecuencias) <- finalResult$Results$salida$value$ColumnNames
    scoredSecuencias
    list = setdiff(ls(), "scoredSecuencias")
}
