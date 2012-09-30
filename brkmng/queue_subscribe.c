#include <stdlib.h>
#include "stomp2cob.h"

int queue_subscribe(const char *idheader, const char *queue) {
      
      stomp_frame frame;
      frame.command = "SUB";
      frame.headers = apr_hash_make(pool);
//
      apr_hash_set(frame.headers, "destination", APR_HASH_KEY_STRING, queue);
      apr_hash_set(frame.headers, "id", APR_HASH_KEY_STRING, idheader);	  
      apr_hash_set(frame.headers, "activemq.prefetchSize",APR_HASH_KEY_STRING, "1");
      apr_hash_set(frame.headers, "ack",APR_HASH_KEY_STRING, "client");	  
//	  
	  frame.body_length = -1;
      frame.body = NULL;
      rc = stomp_write(connection, &frame, pool);
      rc==APR_SUCCESS || die(-2, "Could not send frame", rc);
	  
	  #ifdef DEBUG
 	    fprintf(stdout, "Subscribed to idheader - queue : %s, %s \n", idheader, queue);
      #endif	  
	  
	  return(rc);
}  

