; NASM, Linux x86 de 32 bits (igual que Helloword.asm).
; Compilar: nasm -f elf32 LeerArchivos.asm -o LeerArchivos.o
; Enlazar: ld -m elf_i386 LeerArchivos.o -o LeerArchivos
; Uso: ./LeerArchivos archivo1.txt archivo2.txt ...
; Imprime una linea por archivo, en el orden de los argumentos:
;   0: lectura completa hasta EOF (incluye archivos vacios).
;  -1: fallo al abrir, leer o cerrar el archivo.
; Sin argumentos imprime -1. Codigo de salida: 1 si hubo errores, 0 si no.

BITS 32

section .data
    exito db '0', 10
    error db '-1', 10

section .bss
    buffer resb 4096
    hubo_error resd 1

section .text
    global _start

_start:
    mov esi, [esp]             ; argc
    dec esi                   ; Cantidad de archivos
    lea edi, [esp + 8]         ; Direccion de argv[1]
    test esi, esi
    jz .sin_argumentos

.abrir:
    mov eax, 5                ; sys_open
    mov ebx, [edi]
    xor ecx, ecx              ; O_RDONLY
    xor edx, edx
    int 0x80
    cmp eax, -4               ; EINTR: reintentar si hubo una senal
    je .abrir
    test eax, eax
    js .fallo
    mov ebp, eax              ; Descriptor del archivo actual

.leer:
    mov eax, 3                ; sys_read
    mov ebx, ebp
    mov ecx, buffer
    mov edx, 4096
    int 0x80
    cmp eax, -4
    je .leer
    test eax, eax
    js .fallo_lectura
    jnz .leer                 ; Continuar incluso tras una lectura parcial

    mov eax, 6                ; EOF alcanzado: sys_close
    mov ebx, ebp
    int 0x80
    test eax, eax
    js .fallo
    mov ecx, exito
    mov edx, 2
    jmp .imprimir

.fallo_lectura:
    mov eax, 6                ; Cerrar tambien cuando falla la lectura
    mov ebx, ebp
    int 0x80

.fallo:
    mov dword [hubo_error], 1
    mov ecx, error
    mov edx, 3

.imprimir:
    mov eax, 4                ; sys_write a stdout
    mov ebx, 1
    int 0x80
    cmp eax, -4
    je .imprimir
    test eax, eax
    jle .fallo_salida
    add ecx, eax
    sub edx, eax
    jnz .imprimir             ; Completar una escritura parcial

    add edi, 4
    dec esi
    jnz .abrir
    jmp .salir

.sin_argumentos:
    mov esi, 1                ; Emitir un unico -1 y terminar
    jmp .fallo

.fallo_salida:
    mov dword [hubo_error], 1

.salir:
    mov eax, 1                ; sys_exit
    mov ebx, [hubo_error]
    int 0x80

section .note.GNU-stack noalloc noexec nowrite progbits
