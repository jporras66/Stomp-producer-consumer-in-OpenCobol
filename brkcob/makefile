# 
INCLUDE=-I"." -I  /usr/include -I /usr/include/apr-1 -I /usr/include/apr-1.0
LIBS=-lapr-1 -laprutil-1 -L $(APL)/lib -l stomp 
COBC=/opt/opencobol/bin/cobc
COBFLAGS=-std=cobol85 -g -x
OBJSREAD=../brkmng/broker_connect.o ../brkmng/queue_subscribe.o ../brkmng/queue_write.o ../brkmng/queue_read.o ../brkmng/broker_disconnect.o ../asc2ebc/asc2ebc.o 
OBJSWRITE=../brkmng/broker_connect.o ../brkmng/queue_write.o ../brkmng/broker_disconnect.o ../asc2ebc/asc2ebc.o ../asc2ebc/cbl_oc_dump.o
#
all: consumer producer
#
clean:
	rm -f *.o *.lst *.c.h *.c.l.h consumer.c producer.c log.* consumer producer
consumer:  consumer.cob
	$(COBC) $(COBFLAGS) consumer.cob  $(OBJSREAD) -t consumer.cob.lst 	$(LIBS)	
producer:  producer.cob
	$(COBC) $(COBFLAGS) producer.cob $(OBJSWRITE) -t producer.cob.lst 	$(LIBS)	

