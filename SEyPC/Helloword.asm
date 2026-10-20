section .data
    msg db 'Hello, World!', 0xA    ; Cadena con salto de línea (\n)
    len equ $ - msg                 ; Cálculo de la longitud de la cadena

section .text
    global _start

_start:
    ; --- Prólogo de la función ---
    push ebp
    mov ebp, esp

    ; --- Llamada al sistema: sys_write (eax = 4) ---
    mov eax, 4          ; ID de sys_write
    mov ebx, 1          ; File descriptor 1 (stdout)
    mov ecx, msg        ; Puntero al mensaje
    mov edx, len        ; Longitud del mensaje
    int 0x80            ; Interrupción para ejecutar la llamada al sistema

    ; --- Epílogo de la función ---
    mov esp, ebp
    pop ebp

    ; --- Llamada al sistema: sys_exit (eax = 1) ---
    mov eax, 1          ; ID de sys_exit
    xor ebx, ebx        ; Código de salida 0
    int 0x80            ; Interrupción para salir del programa

