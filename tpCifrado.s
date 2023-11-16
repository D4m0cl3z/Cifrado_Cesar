
.data

pedidoDeMensaje: .asciz "Ingrese mensaje, valores de las claves y acciÃ³n: "
inputUsuario: .space 128
mensajeExtraido: .space 128
claveExtraida: .word 0
opcionExtraida: .byte 0
mensajeCodificado: .space 128
mensajeDecodificado: .space 128

.text

@entrada: r1(direc Input)
@salida: r0
calcular_longitud:
    .fnstart
    push { lr }
    mov r0 , #0
ciclo:
    ldrb r2, [r1]
    add r1, #1
    cmp r2, #10
    beq finCiclo

    add r0, #1
    bal ciclo
finCiclo:
    pop { lr }
    bx lr
    .fnend

@entrada: r0(long_input), r1(dir Input), r2(dir mensajeExtraido), r5(dir claveExtraida)
@salida:
extraer_mensaje:
    .fnstart
    push { lr }
    mov r4, #0
procesar_mensaje:
    add r4, #1
    ldrb r3, [r1]
    add r1, #1
    cmp r3, #';'
    beq agregar_null

    strb r3,[r2]
    add r2, #1
    bal procesar_mensaje

agregar_null:
    mov r3, #0x00
    strb r3, [r2]

procesar_clave:

    cmp r4, r0
    beq salir

    add r4, #1
    ldrb r3, [r1]
    add r1, #1
    cmp r3, #';'
    beq procesar_clave

    strb r3,[r5]
    add r5, #1
    bal procesar_clave

salir:
    add r5, #1
    mov r3, #0x00
    strb r3, [r5]

    pop { lr }
    bx lr
    .fnend

extraer_opcion:
    .fnstart
    push { lr }
    add r1,r0
    ldrb r3, [r1]
    strb r3, [r2]
    pop { lr }
    bx lr
    .fnend

codificar:
    .fnstart
    push { r6, lr }

    mov r9, #0
    ldrb r2, [r2] @ Traigo corrimiento
    sub r2, r2, #0X30

recorrer_codificador:

    ldrb r6, [r0] @ Cargo letra de memoria

    cmp r6, #0 @ comparo ultimo caracter con null
    beq salir_codificar

    cmp r6, #122 @ comparo con la letra mas grande posible en ascii
    ble Corrimiento_singiro_codificador

    sub r6, #26 @ resto 26 para simular un giro completo

Corrimiento_singiro_codificador:

    add r7, r6, r2 @ agrego letra al mensaje decodificado
    strb r7, [r4]  @ envio a memorio la letra corrida
    add r9, #1
    add r0, #1
    add r4, #1
    bal recorrer_codificador

salir_codificar:
   @ mov r8, #0X0A
   @ strb r8, [r4]
    @add r9, #1
    pop { r6, lr }
    bx lr
    .fnend


decodificar:
    .fnstart
    push { r6, lr }
    mov r9, #0
    ldrb r2, [r2] @ Traigo corrimiento
    sub r2, r2, #0X30

recorrer_decodificador:

    ldrb r6, [r0] @ Cargo letra de memoria

    cmp r6, #0 @ comparo ultimo caracter con null
    beq salir_decodificar

    cmp r6, #97 @ comparo con la letra mas grande posible en ascii
    bgt corrimiento_singiro_decodificador

    add r6, r6, #26 @ sumo 26 para simular un giro completo

corrimiento_singiro_decodificador:

    sub r7, r6, r2 @ agrego letra al mensaje decodificado
    strb r7, [r4]  @ envio a memorio la letra corrida
    add r9, #1
    add r0, #1
    add r4, #1
    bal recorrer_decodificador

salir_decodificar:
    mov r8, #0X0A
    strb r8, [r4]
    add r9, #1
    pop { r6, lr }
    bx lr
    .fnend


esPar:
    .fnstart
    push { lr }
    mov r10, r9
cicloEsPar:
    sub r10, #2
    cmp r10, #1
    bgt cicloEsPar
    beq impar
par:
    mov r3, #0x30
    bal salirEsPar
impar:
    mov r3, #0x31
salirEsPar:
    strb r3, [r4]
    add r9, #1
    pop { lr }
    bx lr
    .fnend

Convertir_ascci_a_entero:


convertir_entero_a_ascii:


.global main

main:
   mov r0, #1  @ Descriptor de archivo (1 para stdout)
   ldr r1, =pedidoDeMensaje
   mov r2, #49
   mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
   swi 0       @ Llama al sistema para escribir la cadena

   mov r0, #0            @ Descriptor de archivo (0 para stdin)
   ldr r1, =inputUsuario
   mov r2, #128           @ TamaÃ±o del bÃºfer
   mov r7, #3            @ CÃ³digo de llamada al sistema para read (3)
   swi 0                @ Llama al sistema para leer la entrada del usuario


    ldr r1,=inputUsuario
    bl calcular_longitud

    ldr r1, =inputUsuario
    ldr r2, =opcionExtraida
    sub r0, #2
    bl extraer_opcion

    ldr r1, =inputUsuario
    ldr r2, =mensajeExtraido
    ldr r5, =claveExtraida
    bl extraer_mensaje

    ldr r0, =mensajeExtraido
    ldr r2, =claveExtraida
    ldr r3, =opcionExtraida
    ldr r4, =mensajeCodificado

    ldrb r3, [r3]

    cmp r3, #'c'
    bleq codificar
    cmp r3, #'C'
    bleq codificar

    cmp r3, #'d'
    bleq decodificar
    cmp r3, #'D'
    bleq decodificar

//    mov r0, #1  @ Descriptor de archivo (1 para stdout)
//    ldr r1, =mensajeExtraido
//    mov r2, #4
//    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
//    swi 0       @ Llama al sistema para escribir la cadena

//    mov r0, #1  @ Descriptor de archivo (1 para stdout)
//    ldr r1, =claveExtraida
//    mov r2, #4
//    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
//    swi 0       @ Llama al sistema para escribir la cadena

//    mov r0, #1  @ Descriptor de archivo (1 para stdout)
//    ldr r1, =opcionExtraida
//    mov r2, #1
//    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
//    swi 0       @ Llama al sistema para escribir la cadena
    
    bl esPar
    strb r3, [r4]

    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    mov r2, r9
    ldr r1, =mensajeCodificado
    swi 0       @ Llama al sistema para escribir la cadena

    @ Salir del programa usando la llamada al sistema de salida
    mov r7, #1            @ Codigo de llamada al sistema para exit (1)
    swi 0  
