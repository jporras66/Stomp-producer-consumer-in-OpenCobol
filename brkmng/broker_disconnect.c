#include <stdlib.h>
#include "stomp2cob.h"

int broker_disconnect() {
   fprintf(stdout, "Disconnecting...");
   rc=stomp_disconnect(&connection); 
   rc==APR_SUCCESS || die(-2, "Could not disconnect", rc);
   
   #ifdef DEBUG
	     fprintf(stdout, "disconnect OK\n");
   #endif      
   
   apr_pool_destroy(pool);	   
   return 0;
}

