#Asignacion de datos

MensajeCodificado = ""
MensajeDecodificado = ""

#Input

inputUsuario = input ("Ingrese el mensaje que desea codificar, luego ingrese el corrimiento del mensaje y por ultimo si desea codificar o decodificar, todo separado por punto y coma: ")

inputUsuario = inputUsuario.split(";")
inputUsuarioOpc = inputUsuario[-1]
inputUsuarioCor = inputUsuario[-6:-1]
inputUsuarioMen = inputUsuario[-7]
IndiceCor = 0

#Funcion Codificar
if inputUsuarioOpc == "c":
  for letra_Mensaje in inputUsuarioMen:
    
    numAscii = ord(letra_Mensaje)
    #obtengo el nuemro ascii de la letra con el corrimiento  
    nuevoNumAscii = numAscii + int(inputUsuarioCor[IndiceCor])
    #recorro los indices de los corrimientos
    IndiceCor = IndiceCor + 1
    if IndiceCor > 4:
        IndiceCor = 0
    #en caso de que el numero ascii sea mayor a z, lo corro para que vuelva a estar dentro del rango
    if nuevoNumAscii > 122:
        nuevoNumAscii = nuevoNumAscii - 122 + 96
    MensajeCodificado += chr(nuevoNumAscii)
  
  print ("mensaje secreto = " + MensajeCodificado)
  
#Funcion decodificar
elif inputUsuarioOpc == "d" :

  for letra_Mensaje in inputUsuarioMen:
    numAscii = ord(letra_Mensaje) 
    nuevoNumAscii = numAscii + (int(inputUsuarioCor[IndiceCor]) * -1)
    IndiceCor = IndiceCor + 1
    if IndiceCor > 4:
        IndiceCor = 0
    #en caso de que el numero ascii sea mayor a a, lo corro para que vuelva a estar dentro del rango
    if nuevoNumAscii < 97:
       nuevoNumAscii = nuevoNumAscii - 96 + 122
    MensajeDecodificado += chr(nuevoNumAscii)
  print ("mensaje decodificado = " + MensajeDecodificado)
  
#Input incorrecto
else:
  print ("Ingrese una opcion valida")