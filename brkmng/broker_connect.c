#include <stdlib.h>
#include "stomp2cob.h"

apr_status_t rc;
apr_pool_t *pool;
stomp_connection *connection;

int die(int exitCode, const char *message, apr_status_t reason) {
    char msgbuf[80];
	apr_strerror(reason, msgbuf, sizeof(msgbuf));
	fprintf(stderr, "%s: %s (%d)\n", message, msgbuf, reason);
	exit(exitCode);
	return reason;
}

static void terminate()
{
   apr_terminate();
}

int broker_connect(const char *hostname, unsigned int *port) {
   int vport = *port ;
   
   #ifdef DEBUG
	  printf( "Connecting port : %d \n", vport );
   #endif
   
   setbuf(stdout, NULL);
   rc = apr_initialize();
   rc==APR_SUCCESS || die(-2, "Could not initialize", rc);
   atexit(terminate);	
   
   rc = apr_pool_create(&pool, NULL);
	rc==APR_SUCCESS || die(-2, "Could not allocate pool", rc);

   #ifdef DEBUG
	  fprintf(stdout, "Connecting......");
   #endif	
   
   rc=stomp_connect( &connection, hostname, vport, pool);
   rc==APR_SUCCESS || die(-2, "Could not connect", rc);
   
   #ifdef DEBUG
	  fprintf(stdout, "Sending connect message .. \n");
   #endif 
   
   {
      stomp_frame frame;
      frame.command = "CONNECT";
      frame.headers = apr_hash_make(pool);         
      frame.body = NULL;
	  frame.body_length = -1;
      rc = stomp_write(connection, &frame, pool);
      rc==APR_SUCCESS || die(-2, "Could not send frame", rc);
   }  
   
   #ifdef DEBUG
      fprintf(stdout, "OK. Reading Response. \n");   
   #endif 
   
   {
      stomp_frame *frame;
      rc = stomp_read(connection, &frame, pool);
      rc==APR_SUCCESS || die(-2, "Could not read frame", rc);

      #ifdef DEBUG
        fprintf(stdout, "Response: %s, %s \n", frame->command, frame->body);
      #endif	  
      
   }
   
   return(rc);
}