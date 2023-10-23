#Asignacion de datos

ABC = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

MensajeCodificado = ""

#Input
inputUsuario = input ("ingrese el corrimiento del mensaje y luego Ingrese el mensaje que desea codificar")

inputUsuario_Lista = list(inputUsuario)
Corrimiento = inputUsuario_Lista[0]
Mensaje_a_decodificar = inputUsuario_Lista[1:]

#Funciones
#Recorro el input del usuario en forma de lista y el ABC, busco en indice de las letras que coinciden. creo una cadena con el corrimiento elegido
for Letra_ABC in ABCD:
  for Letra_Mensaje in Mensaje_a_decodificar:
    if Letra_ABC  == Letra_Mensaje:
      MensajeCodificado += ABCD[ABCD.index(Letra_ABC) + int(Corrimiento)]

print ("mensaje secreto =" + MensajeCodificado)
