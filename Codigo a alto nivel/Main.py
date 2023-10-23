#Asignacion de datos

MensajeCodificado = ""

#Input
inputUsuarioCor = int(input ("ingrese el corrimiento del mensaje."))
inputUsuarioMen = input (" Ingrese el mensaje que desea codificar")


#Funciones
for letra_Mensaje in inputUsuarioMen:
    numAscii = ord(letra_Mensaje)
    nuevoNumAscii = numAscii + inputUsuarioCor
    if nuevoNumAscii > 122:
        nuevoNumAscii = nuevoNumAscii - 122 + 96

    MensajeCodificado += chr( nuevoNumAscii)

print ("mensaje secreto = " + MensajeCodificado)