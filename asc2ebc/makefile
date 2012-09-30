# 
INCLUDE=-I"."
GCCFLASG=-O0 -g3 -c -D $(DEBUG)
COBC=/opt/opencobol/bin/cobc
COBFLAGS=-std=cobol85 -g -x
COBOBJFLAGS=-std=cobol85 -g -c
OBJS=asc2ebc.o cbl_oc_dump.o
#
all: cbl_oc_dump.o asc2ebc.o testasc2ebc.exe 
#
clean:
	rm -f testasc2ebc *.o *.c.h *.c.l.h *.lst cbl_oc_dump.c testasc2ebc.c
asc2ebc.o: asc2ebc.c asc2ebc.h
	gcc $(GCCFLASG) asc2ebc.c $(INCLUDE)
cbl_oc_dump.o:  cbl_oc_dump.cob
	$(COBC) $(COBOBJFLAGS) cbl_oc_dump.cob  -t cbl_oc_dump.cob.lst
testasc2ebc.exe:  testasc2ebc.cob asc2ebc.o
	$(COBC) $(COBFLAGS) testasc2ebc.cob  $(OBJS) -t testasc2ebc.cob.lst
