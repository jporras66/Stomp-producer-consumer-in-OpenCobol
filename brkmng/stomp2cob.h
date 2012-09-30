#ifndef STOMPCOB_H
#define STOMPCOB_H

#include "stomp.h"

apr_status_t rc;
apr_pool_t *pool;
stomp_connection *connection;


#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define MAXMSGLENGTH 2000 ;

int die(int exitCode, const char *message, apr_status_t reason);   
int broker_connect(const char *hostname, unsigned int *port) ;
int queue_write(const char *queue, const unsigned char *message) ;
int queue_subscribe(const char *idheader, const char *queue) ;
int queue_read     (const char *idheader, const char *queue, char unsigned *message) ;
int broker_disconnect() ;

#ifdef __cplusplus
}
#endif

#endif  /* ! STOMPCOB_H */
