# 
INCLUDE=-I"." -I  /usr/include -I /usr/include/apr-1 -I /usr/include/apr-1.0
LIBS=-lapr-1 -laprutil-1 -L ../lib -lstomp
#GCCSHAREDFLASG=-O0 -g3 -fPIC -c -D $(DEBUG)
GCCSHAREDFLASG=-O0 -g3 -fPIC -c
#GCCFLASG=-O0 -g3 -c -D $(DEBUG)
GCCFLASG=-O0 -g3 -c
#
all: stomp.o libstomp.so test broker_connect.o queue_subscribe.o queue_write.o queue_read.o broker_disconnect.o 
#
clean:
	rm -f *.o test ../lib/libstomp.* 
stomp.o: stomp.c stomp.h
	gcc $(GCCSHAREDFLASG) stomp.c $(INCLUDE)
libstomp.so: stomp.o
	gcc -shared -Wl,-soname,libstomp.so -o libstomp.so stomp.o -lapr-1 -laprutil-1
	mv libstomp.so ../lib  
test: stomp.c libstomp.so
	gcc -O0 -g3 -o test test.c stomp.o $(INCLUDE) $(LIBS) 
broker_connect.o: broker_connect.c stomp2cob.h
	gcc $(GCCFLASG) broker_connect.c $(INCLUDE)
queue_subscribe.o: queue_subscribe.c stomp2cob.h
	gcc $(GCCFLASG) queue_subscribe.c $(INCLUDE)
queue_write.o: queue_write.c stomp2cob.h
	gcc $(GCCFLASG) queue_write.c $(INCLUDE)		
queue_read.o: queue_read.c stomp2cob.h
	gcc $(GCCFLASG) queue_read.c $(INCLUDE)
broker_disconnect.o: broker_disconnect.c stomp2cob.h
	gcc $(GCCFLASG) broker_disconnect.c $(INCLUDE)	
