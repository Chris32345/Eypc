# Eypc
Programas en ensamblador de la materia eypc
Para ejecutarlos abre un codespace e instala ensamblador con el siguiente comando:
sudo apt-get update
sudo apt-get install -y nasm binutils gdb gcc-multilib

Ensamblar:
as hello.s -o hello.o
ld hello.o -o hello

Ejecutar:
./hello

