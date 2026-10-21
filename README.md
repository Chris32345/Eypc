# Eypc
Programas en ensamblador de la materia eypc
Para ejecutarlos abre un codespace e instala ensamblador con el siguiente comando:
sudo apt-get update
sudo apt-get install -y nasm binutils gdb gcc-multilib

Ensamblar:
nasm -f elf64 archivo.asm -o archivo.o
gcc -no-pie archivo.o -o archivo

Ejecutar:
./hello

