.data

pedidoDeMensaje: .asciz "Ingrese mensaje, valores de las claves y acción: "
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
    add r0, #1
    cmp r2, #0
    bne ciclo

    sub r0,#1
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
    beq procesar_clave
    
    strb r3,[r2]
    add r2, #1
    bal procesar_mensaje

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

Codificar:


Decodificar:


Convertir_ascci_a_entero:


convertir_entero_a_ascii:


.global main

main:
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    ldr r1, =pedidoDeMensaje
    mov r2, #49
    mov r7, #4  @ Código de llamada al sistema para write (4)
    swi 0       @ Llama al sistema para escribir la cadena

    mov r0, #0            @ Descriptor de archivo (0 para stdin)
    ldr r1, =inputUsuario
    mov r2, #128           @ Tamaño del búfer
    mov r7, #3            @ Código de llamada al sistema para read (3)
    swi 0                @ Llama al sistema para leer la entrada del usuario

    bl calcular_longitud
    
    ldr r1, =inputUsuario
    ldr r2, =opcionExtraida
    bl extraer_opcion

    sub r0, #2
	
    ldr r1, =inputUsuario
    ldr r2, =mensajeExtraido
    ldr r5, =claveExtraida
    bl extraer_mensaje
 
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    ldr r1, =mensajeExtraido
    mov r2, #4
    mov r7, #4  @ Código de llamada al sistema para write (4)
    swi 0       @ Llama al sistema para escribir la cadena
    
    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    ldr r1, =claveExtraida
    mov r2, #4
    mov r7, #4  @ Código de llamada al sistema para write (4)
    swi 0       @ Llama al sistema para escribir la cadena

    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    ldr r1, =opcionExtraida
    mov r2, #1
    mov r7, #4  @ Código de llamada al sistema para write (4)
    swi 0       @ Llama al sistema para escribir la cadena


    @ Salir del programa usando la llamada al sistema de salida
    mov r7, #1            @ Código de llamada al sistema para exit (1)
    swi 0                @ Llama al sistema