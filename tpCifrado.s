.data

pedidoDeMensaje: .asciz "Ingrese mensaje, valores de las claves y acciÃ³n: "
mensaje_paridad_no_correcta: .asciz "La paridad es Incorrecta\n"
mensaje_procesar_inic: .asciz "Se procesaron "
mensaje_procesar_fin: .asciz " letras\n"
primer_char: .byte 0
segundo_char: .byte 0
inputUsuario: .space 128
mensajeExtraido: .space 128
claveExtraida: .space 128
pistaExtrida: .space 128
opcionExtraida: .byte 0
mensajeCodificado: .space 128
mensajeDecodificado: .space 128
lenClaveExtraida: .space 128
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
    add r0, #1
    cmp r2, #0
    bne ciclo

    sub r0, #2
    pop { lr }
    bx lr
    .fnend

@entrada: r0(long_input), r1(dir Input), r2(dir mensajeExtraido), r5(dir claveExtraida)
@salida:
extraer_mensaje:
    .fnstart
    push { r3, lr }
    mov r4, #0
procesar_mensaje:
    add r4, #1
    ldrb r3, [r1]
    add r1, #1
    cmp r3, #';'
    beq procesar_clave

    strb r3,[r2]
    add r2, #1
    bal procesar_mensaje



@Salida: r4 (Clavecorrimiento) r5 (lencorrimiento)
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
    add r8, #1
    bal procesar_clave

salir:
    add r5, #1
    mov r3, #0x00
    strb r3, [r5]

    pop { r3, lr }
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

@entrada: r0 (Ubi memoria de mensaje),  r2 (Ubi memoria de corrimiento)
@Salida: r4 (mensajeCodificado)
codificar:
    .fnstart
    push { r6, lr }
    mov r3, #0 @corrimiento numero
    mov r9, #0
    mov r10, r2 @Guardo posiciÃ³n de memoria inicial de corrimiento
    mov r11, #0 @indice lenclave

recorrer_codificador:

    cmp r11, r8 @ Comparo indice de corrimiento con lenclave
    bne noreinicio_ubicaciondeclave_codificador

    mov r2, r10 @ reinicio unicaciÃ³n de clave
    mov r11, #0

noreinicio_ubicaciondeclave_codificador:
    ldrb r3, [r2] @ Traigo corrimiento
    sub r3, r3, #0X30 @Resto 30 para convertir de numero a ascii

    ldrb r6, [r0] @ Cargo letra de memoria

    cmp r6, #0 @ comparo ultimo caracter con null
    beq salir_codificar

    cmp r6, #0x20 @ comparo caracter con un espacio
    beq corrimiento_espacio_codificador

    add r6, r6, r3 @ agrego corrimiento

    cmp r6, #122 @ comparo con la letra mas grande posible en ascii
    ble corrimiento_singiro_codificador

    sub r6, #26 @ resto 26 para simular un giro completo

corrimiento_singiro_codificador:

    add r11, #1 @indice de lenclave
    add r2, #1 @ Recorro clave

corrimiento_espacio_codificador:

    strb r6, [r4]  @ envio a memorio la letra corrida
    add r0, #1
    add r4, #1 @
    add r9, #1 @ Indice de ciclo

    bal recorrer_codificador

salir_codificar:

    pop { r6, lr }
    bx lr
    .fnend


decodificar:
    .fnstart
    push { r6, r7, lr }

    bl descifrar_Corrimiento

    mov r3, #0 @corrimiento numero
    mov r9, #0
    mov r10, r5 @Guardo posiciÃ³n de memoria inicial de corrimiento
    mov r11, #0 @indice lenclave


recorrer_decodificador:

    cmp r11, r8 @ Comparo indice de corrimiento con lenclave
    bne noreinicio_ubicaciondeclave_decodificador

    mov r5, r10 @ reinicio unicaciÃ³n de clave
    mov r11, #0

noreinicio_ubicaciondeclave_decodificador:
    ldrb r3, [r5] @ Traigo corrimiento
    ldrb r6, [r0] @ Cargo letra de memoria

    cmp r6, #'0'
    beq salir_decodificar
    cmp r6, #'1'
    beq salir_decodificar
    cmp r6, #0 @ comparo ultimo caracter con null
    beq salir_decodificar

    cmp r6, #0x20 @ comparo caracter con un espacio
    beq corrimiento_espacio_decodificador

    sub r6, r3 @ resto corrimiento al mensaje codificado

    cmp r6, #97 @ comparo con la letra mas chica posible en ascii
    bge corrimiento_singiro_decodificador

    add r6, r6, #26 @ sumo 26 para simular un giro completo

corrimiento_singiro_decodificador:

    add r11, #1 @indice de lenclave
    add r5, #1 @ Recorro clave

corrimiento_espacio_decodificador:

    strb r6, [r4]  @ envio a memoria la letra corrida
    add r0, #1
    add r4, #1 @
    add r9, #1 @ Indice de ciclo

    bal recorrer_decodificador

salir_decodificar:

    pop { r6, r7, lr }
    bx lr
    .fnend

@ entrada r0 (mensaje extraido) r2 (clave extraida)
@ salida: pistaEstraida (r5)
descifrar_Corrimiento:
    .fnstart

    push {r0, r2, r5, lr}

    mov r3, #0
    mov r6, #0
    mov r8, #0

recorrer_Corrimiento:

    ldrb r3, [r2] @ Traigo pista con corrimiento
    ldrb r6, [r0] @ Cargo letra de memoria

    cmp r3, #0x00
    beq salir_Descifrar_Corrimiento

    cmp r3, #0x20 @ comparo caracter con un espacio
    beq descifrar_corrimiento_espacio


    sub r3, r6, r3
    strb r3, [r5]

    add r8, #1
    add r5, #1

descifrar_corrimiento_espacio:


    add r2, #1
    add r0, #1


    bal recorrer_Corrimiento

salir_Descifrar_Corrimiento:


    pop {r0, r2, r5, lr}
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
    add r4, #1
    mov r3, #0x0A
    strb r3,[r4]
    add r9, #2
    pop { lr }
    bx lr
    .fnend

comprobar_paridad:
    .fnstart
    push { lr }
    mov r2, r9
ciclo_paridad:
    sub r2, #2
    cmp r2, #1
    bgt ciclo_paridad
    beq paridad_impar
paridad_par:
    mov r3, #0x30
    bal comparar_paridad
paridad_impar:
    mov r3, #0x31
comparar_paridad:
    cmp r1,r3
    beq paridad_correcta
paridad_incorrecta:
    mov r4, #0
    bal salir_paridad
paridad_correcta:
    mov r4, #1
salir_paridad:
    pop { lr }
    bx lr
    .fnend

calcular_segundo_caracter:
    .fnstart
    push { lr }
    mov r1, r9
ciclo_char:
    cmp r1, #10
    blt conver_en_char
    sub r1, #10
    bal ciclo_char
conver_en_char:
    mov r2, r1
    add r2, #0x30
    ldr r3 , =segundo_char
    strb r2, [r3]
    pop { lr }
    bx lr
    .fnend

calcular_primer_caracter:
    .fnstart
    push { lr }
    mov r2, r1
    mov r3, r9
    mov r4, #0
    sub r3,r2
    cmp r3, #10
    blt conver_espacio
ciclo_char_1:
    cmp r3, #0
    beq conver_en_char_1

    sub r3, #10
    add r4, #1
    bal ciclo_char_1
conver_espacio:
    ldr r6, =primer_char
    mov r7, #' '
    strb r7, [r6]
    bal salir_primer_char
conver_en_char_1:
    add r4, #0x30
    ldr r3 , =primer_char
    strb r4, [r3]
salir_primer_char:
    pop { lr }
    bx lr
    .fnend

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
    mov r8, #0
    bl extraer_mensaje

    ldr r0, =mensajeExtraido
    ldr r2, =claveExtraida
    ldr r3, =opcionExtraida
    ldr r4, =mensajeCodificado
    ldr r5, =pistaExtrida


    ldrb r3, [r1]

    cmp r3, #'c'
    bleq codificar
    cmp r3, #'C'
    bleq codificar

    ldr r11, =opcionExtraida
    ldrb r12, [r11]
    cmp r12, #'c'
    bleq esPar
    cmp r12, #'C'
    bleq esPar

    cmp r12, #'c'
    beq imprimir
    cmp r12, #'C'
    beq imprimir

    cmp r3, #'d'
    bleq decodificar
    cmp r3, #'D'
    bleq decodificar

    ldrb r1, [r0]
    bl comprobar_paridad


    mov r2 , #'\n'
    ldr r3, =mensajeCodificado
    strb r2, [r3, r9]

    add r9, #1
    cmp r4, #1
    beq imprimir
imprimir_error:
    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    mov r2, #25
    ldr r1, =mensaje_paridad_no_correcta
    swi 0       @ Llama al sistema para escribir la cadena

    b salir_sistema
imprimir:
    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    mov r2, r9
    ldr r1, =mensajeCodificado
    swi 0       @ Llama al sistema para escribir la cadena

imprimir_procesamiento:
    
    cmp r12, #'c'
    beq correc_long_cod
    cmp r12, #'C'
    beq correc_long_cod

    cmp r12, #'d'
    beq correc_long_decod
    cmp r12, #'D'
    beq correc_long_decod

correc_long_cod:
    sub r9, #2
    b calcular_caracteres_long
correc_long_decod:
    sub r9, #1
calcular_caracteres_long:
    bl calcular_segundo_caracter
    bl calcular_primer_caracter

    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    mov r2, #14
    ldr r1, =mensaje_procesar_inic
    swi 0       @ Llama al sistema para escribir la cadena

    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    mov r2, #1
    ldr r1, =primer_char
    swi 0       @ Llama al sistema para escribir la cadena

    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    mov r2, #1
    ldr r1, =segundo_char
    swi 0       @ Llama al sistema para escribir la cadena

    mov r7, #4  @ CÃ³digo de llamada al sistema para write (4)
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    mov r2, #8
    ldr r1, =mensaje_procesar_fin
    swi 0       @ Llama al sistema para escribir la cadena


salir_sistema:
    @ Salir del programa usando la llamada al sistema de salida
    mov r7, #1            @ Codigo de llamada al sistema para exit (1)
    swi 0                @ Llama al sistema
