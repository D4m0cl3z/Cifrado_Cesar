#Asignacion de datos

MensajeCodificado = ""
MensajeDecodificado = ""

#Input

inputUsuario = input ("Ingrese el mensaje que desea codificar, luego ingrese el corrimiento del mensaje y por ultimo si desea codificar o decodificar, todo separado por punto y coma: ")

inputUsuario = inputUsuario.split(";")
inputUsuarioOpc = inputUsuario[-1]
inputUsuarioCor = int(inputUsuario[-2])
inputUsuarioMen = inputUsuario[-3]

#Funcion Codificar
if inputUsuarioOpc == "c":
  for letra_Mensaje in inputUsuarioMen:
    numAscii = ord(letra_Mensaje)
    nuevoNumAscii = numAscii + inputUsuarioCor
    if nuevoNumAscii > 122:
        nuevoNumAscii = nuevoNumAscii - 122 + 96

    MensajeCodificado += chr(nuevoNumAscii)
  print ("mensaje secreto = " + MensajeCodificado)
  
#Funcion decodificar
elif inputUsuarioOpc == "d" :

  for letra_Mensaje in inputUsuarioMen:
    numAscii = ord(letra_Mensaje) 
    nuevoNumAscii = numAscii + (inputUsuarioCor * -1)
    if nuevoNumAscii < 97:
       nuevoNumAscii = nuevoNumAscii - 96 + 122
    MensajeDecodificado += chr(nuevoNumAscii)
  print ("mensaje decodificado = " + MensajeDecodificado)
#Input incorrecto
else:
  print ("Ingrese una opcion valida")