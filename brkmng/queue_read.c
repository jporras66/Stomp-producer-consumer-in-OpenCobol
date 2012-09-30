#include <stdlib.h>
#include "stomp2cob.h"

int queue_read (const char *idheader, const char *queue, char unsigned *message) {
	  int msglength = MAXMSGLENGTH ;
	  
      stomp_frame *frame;
      rc = stomp_read(connection, &frame, pool);
      rc==APR_SUCCESS || die(-2, "Could not read frame", rc);
	  //strcpy(message, frame->body) ;
      #ifdef DEBUG
		fprintf(stdout, "Message dequeued : %s \n", queue );
      #endif 		  
	  int i = 0;
	  for (i = 0; i < msglength; i++){
	      *(message + i) =  *(frame->body + i );
			#ifdef DEBUG
				fprintf(stdout, "%c", *(message + i) );
			#endif  
	  }	  
	  
      #ifdef DEBUG
		fprintf(stdout, "\n");
      #endif 
      
	  if ( rc != 0 ) {
	     return(rc);
	  }
//	  
	  frame->command = "ACK";
	  const char *messageid = apr_hash_get(frame->headers, "message-id", APR_HASH_KEY_STRING);
      apr_hash_set(frame->headers, "subscription", APR_HASH_KEY_STRING, idheader);	  
	  apr_hash_set(frame->headers, "message-id",   APR_HASH_KEY_STRING, messageid);
	  frame->body_length = -1;
      frame->body = NULL;
      rc = stomp_write(connection, frame, pool);
      rc==APR_SUCCESS || die(-2, "Could not ACK frame inside queue_read", rc);
	  
	  #ifdef DEBUG
 	    fprintf(stdout, "Acking message idheader - message : %s, %s \n", idheader, messageid );
      #endif

	  return(rc);	 
//		  
}
