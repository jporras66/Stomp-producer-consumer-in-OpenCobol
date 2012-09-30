#include <stdlib.h>
#include "stomp2cob.h"

int queue_write(const char *queue, const unsigned char *message) {
	  //int msglength = strlen(message) ;
	  int msglength = MAXMSGLENGTH ;
	  
      stomp_frame frame;
      frame.command = "SEND";
      frame.headers = apr_hash_make(pool);
      apr_hash_set(frame.headers, "destination", APR_HASH_KEY_STRING, queue);
	  //apr_hash_set(frame.headers, "content-type", APR_HASH_KEY_STRING, "test/plain");
	  apr_hash_set(frame.headers, "content-type", APR_HASH_KEY_STRING, "application/octet-stream");
	  
      //frame.body_length = -1;
	  frame.body_length = msglength;
	  frame.body = malloc ( sizeof(unsigned char)* msglength ) ;
	  memset(frame.body,'\000',msglength);
	  
	  //strcpy(frame.body,message) ; 
      #ifdef DEBUG
		fprintf(stdout, "About to enqueue : %s \n", queue );
      #endif 	  
	  int i = 0;
	  for (i = 0; i < msglength; i++){
	      *(frame.body + i) =  *(message + i );
			#ifdef DEBUG
				fprintf(stdout, "%c", *(message + i) );
			#endif  		  
	  }
	  
      #ifdef DEBUG
		fprintf(stdout, "\n");
      #endif 
	  
      rc = stomp_write(connection, &frame, pool);
      rc==APR_SUCCESS || die(-2, "Could not send frame", rc);
	  
	  free(frame.body);
	  
	  return(rc);
}  
