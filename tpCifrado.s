.data

pedidoDeMensaje: .asciz "Ingrese mensaje, valores de las claves y acción: "
inputUsuario: .space 128
mensajeExtraido: .space 128
mensajeCodificado: .space 128
mensajeDecodificado: .space 128

.text

@entrada: r1(direc Input), r5 (dir mensajeExtraido)
@salida: r4
extraer_mensaje:
    .fnstart
    push { lr }
procesar:
    ldrb r3, [r1]
	cmp r3, #59
    beq salir
    
    strb r3,[r5]
    add r1, #1
    add r4, #1
    add r5, #1
    bal procesar

salir:
    pop { lr }
    bx lr
    .fnend

extraer_clave:


extraer_opcion:


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

    ldr r5, =mensajeExtraido
    mov r4, #0
    bl extraer_mensaje

    mov r0, #1  @ Descriptor de archivo (1 para stdout)
    ldr r1, =mensajeExtraido
    mov r2, r4
    mov r7, #4  @ Código de llamada al sistema para write (4)
    swi 0       @ Llama al sistema para escribir la cadena

    @ Salir del programa usando la llamada al sistema de salida
    mov r7, #1            @ Código de llamada al sistema para exit (1)
    swi 0                @ Llama al sistema

