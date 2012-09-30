      *---------------------------------------------------------------*
      *          I D E N T I F I C A T I O N   D I V I S I O N        *
      *          =============================================        *
      *---------------------------------------------------------------*
       IDENTIFICATION DIVISION.
      *-----------------------.
       PROGRAM-ID.      PRODUCER.
       AUTHOR.          POWER.           
       DATE-WRITTEN.    20/09/2012.
      *---------------------------------------------------------------*
      *             E N V I R O N M E N T   D I V I S I O N           *
      *             =======================================           *
      *---------------------------------------------------------------*
       ENVIRONMENT DIVISION.
      *--------------------.
       CONFIGURATION SECTION.
      *---------------------.
       SPECIAL-NAMES.
      *    DECIMAL-POINT IS COMMA.
           alphabet alpha is native
           alphabet beta  is ebcdic.
       INPUT-OUTPUT SECTION.
      *--------------------.
       FILE-CONTROL.
      *---------------------------------------------------------------*
      *                    DECLARACION DE FICHEROS                    *
      *---------------------------------------------------------------*      
      * 
      *---------------------------------------------------------------*
      *                    D A T A   D I V I S I O N                  *
      *---------------------------------------------------------------*
       DATA DIVISION.
      *-------------.
       FILE SECTION.
      *------------.
      * 
       WORKING-STORAGE SECTION.
      *-----------------------.

       01 FILLER PIC X(050)
                 VALUE  'PGM-PRODUCER-WS-COMIENZO'.
      *
       01 PGM-NAME PIC X(15) 
                 VALUE 'PRODUCER'.
      *
       01 W-HOSTNAME     PIC X(15) VALUES '127.0.0.1      '.
       01 W-PORT         USAGE BINARY-SHORT UNSIGNED VALUE 61613. 
       01 W-OUTPUTQUEUE  PIC X(15) VALUE '/queue/TEST.FOO'.	   
      *01 W-OUTPUTQUEUE  PIC X(15) VALUE '/queue/TEST.OUT'.
       01 W-IDHEADER     PIC X(04) VALUE '0000'.	   
       01 W-RC USAGE     BINARY-SHORT VALUE 0.
       01 COUNTER        PIC 9(4) VALUE 10.
       01 SECONDS-TO-SLEEP PIC 9(4) VALUE 1.
       01 W-MESSAGE.
          05 FILLER1    PIC X(15)   VALUE 'DATE :    '.
          05 W-DATE     PIC X(25)   .
          05 W-ALFA1    PIC X(37)
             VALUE      'abcdefghijklmnñopqrstuvwxyz0123456789'.
          05 W-ALFA2    PIC X(37)
             VALUE      'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789'.
          05 FILLER2    PIC X(01) VALUE '-'.
          05 W-ID1      PIC 9(04) USAGE  COMP    VALUE 0.
          05 FILLER3    PIC X(01) VALUE '-'.
          05 W-ID2      PIC 9(04) USAGE  COMP-3  VALUE 0.
          05 FILLER4    PIC X(01) VALUE '-'.
          05 W-ID3      PIC 9(04) USAGE  COMP-5  VALUE 0.
          05 FILLER5    PIC X(01) VALUE '-'.
          05 W-ID4      PIC 9(04) USAGE  DISPLAY VALUE 0.	
          05 FILLER6    PIC X(01) VALUE '-'.
          05 W-BUFFER   PIC X(1868) VALUE SPACES.
          05 FILLER7    PIC X(01) VALUE '-'.
          05 FILLER     PIC X(01) VALUE X'00'.
       01 W-LENGTH      BINARY-SHORT VALUE 0.
       01 W-ALFA        PIC X(37) VALUE SPACES.
      *	   
       01 W-DATA.
          05 FILE-EOF           PIC 9.                
             88 EOF             VALUE 1.              
             88 NEOF            VALUE 0.              
          05 REPOSITION         PIC 9.                
             88 REP-FOUND       VALUE 1.              
             88 REP-NFOUND      VALUE 0.              
          05 FULL-CURRENT-DATE.
             10 FULL-DATETIME.
                15 F-DATE.
                   25 F-YEAR       PIC 9(4) VALUE ZEROS.
                   25 F-MONTH      PIC 99   VALUE ZEROS.
                   25 F-DAY        PIC 99   VALUE ZEROS.
                15  F-TIME.
                   25 C-HOUR       PIC 99   VALUE ZEROS.
                   25 C-MINUTES    PIC 99   VALUE ZEROS.
                   25 C-SECONDS    PIC 99   VALUE ZEROS.
                   25 C-SEC-HUND   PIC 99   VALUE ZEROS.
             10 C-TIME-DIFF.
                15 C-GMT-DIR    PIC X    VALUE SPACES.
                15 C-HOUR       PIC 99   VALUE ZEROS.
                15 C-MINUTES    PIC 99   VALUE ZEROS.
      *
       01 COMMAND-LINE-VALUES.
          05 MSGCOUNTER     PIC 9(04) VALUE 2000.
          05 FILLER PIC X.
          05 BROKER-IP      PIC X(15) VALUE '127.0.0.1      '.  
      *
       01 I  PIC 9(04) VALUE ZEROS.
       01 J  PIC 9(04) VALUE ZEROS.
       01 K  PIC 9(04) VALUE ZEROS.
       01 LONG PIC 9(04) VALUE ZEROS.                                                                                     
      *	  
       01  FILLER PIC X(050)
                  VALUE  'PGM-PRODUCER-WS-FIN'.
      *
       LINKAGE SECTION.
      *
      *---------------------------------------------------------------*
      *               P R O C E D U R E   D I V I S I O N             *
      *---------------------------------------------------------------*
      *
       PROCEDURE DIVISION.
      *
       1000-MAIN.
      *
           ACCEPT COMMAND-LINE-VALUES FROM COMMAND-LINE.
           DISPLAY 'COMMAND-LINE-VALUES is : ' 
                    COMMAND-LINE-VALUES
           DISPLAY 'W-HOSTNAME     is : ' W-HOSTNAME
           DISPLAY 'W-PORT         is : ' W-PORT 
      *
           IF COMMAND-LINE-VALUES = SPACES THEN
              DISPLAY 'GENERATING 10 MESSAGES  ... '
              MOVE 10 TO MSGCOUNTER
           END-IF
           MOVE     MSGCOUNTER    TO COUNTER
           DISPLAY 'COUNTER        is : ' COUNTER
      *
           SET NEOF TO TRUE  
      *
      *    DISPLAY "W-MESSAGE LENGTH : " FUNCTION LENGTH(W-MESSAGE)
      *    STOP RUN.
      *
           PERFORM 2000-INIT
              THRU 2000-INIT-EXIT. 
      *        
           STOP RUN. 
      *        
       2000-INIT.
      *
           MOVE FUNCTION CURRENT-DATE TO FULL-CURRENT-DATE.
           DISPLAY 'INICIO : ' PGM-NAME ' - '  FULL-DATETIME.
      *
           DISPLAY "PRODUCER - queue_connect BEFORE     " 	  
           CALL 'broker_connect' USING BY REFERENCE W-HOSTNAME, 
		                               BY REFERENCE W-PORT
                RETURNING W-RC        
           DISPLAY "PRODUCER - queue_connect RC : " W-RC
           IF W-RC NOT EQUAL 0 THEN 
              DISPLAY "PRODUCER - queue_connect ERROR RC IS : " W-RC
           END-IF.		   
      *
           PERFORM 2100-QUEUE-WRITE 
                   THRU 2100-QUEUE-WRITE-EXIT 
                   VARYING I FROM 1 BY 1 UNTIL I > COUNTER
      *	   
           DISPLAY "PRODUCER - queue_disconnect BEFORE     " 
           CALL 'broker_disconnect' RETURNING W-RC        
           DISPLAY "PRODUCER - queue_disconnect RC : " W-RC
           IF W-RC NOT EQUAL 0 THEN 
              DISPLAY "PRODUCER - queue_disconnect ERROR RC IS : " W-RC
           END-IF.		   
      *
       2000-INIT-EXIT.
           EXIT.
      *        
       2100-QUEUE-WRITE.
      * 
      *    DISPLAY "PRODUCER - queue_write BEFORE     " 
           MOVE SPACES TO W-DATE, W-BUFFER
           MOVE FUNCTION CURRENT-DATE TO W-DATE
           MOVE I TO W-ID1, W-ID2, W-ID3, W-ID4
           STRING 'MESSAGE NUMBER : ',      
                  X'00', X'01', X'02', X'03',I,'BYE!!', 
                  X'00', X'03', X'02', X'01' INTO W-BUFFER
      *
      *    INSPECT FILLER1  CONVERTING ALPHA TO BETA
      *    INSPECT FILLER2  CONVERTING ALPHA TO BETA
      *    INSPECT FILLER3  CONVERTING ALPHA TO BETA
      *    INSPECT FILLER4  CONVERTING ALPHA TO BETA
      *    INSPECT FILLER5  CONVERTING ALPHA TO BETA
      *    INSPECT FILLER6  CONVERTING ALPHA TO BETA
      *    INSPECT FILLER7  CONVERTING ALPHA TO BETA
      *    INSPECT W-DATE   CONVERTING ALPHA TO BETA
      *    INSPECT W-ALFA1  CONVERTING ALPHA TO BETA
      *    INSPECT W-ALFA2  CONVERTING ALPHA TO BETA
      *    INSPECT W-BUFFER CONVERTING ALPHA TO BETA
      *
           MOVE 'abcdefghijklmnñopqrstuvwxyz0123456789'
                TO W-ALFA1
           MOVE FUNCTION LENGTH(W-ALFA1) TO W-LENGTH
           CALL 'asc2ebc' USING W-ALFA1, W-LENGTH END-CALL  
           CALL 'cbl_oc_dump' using W-ALFA1 END-CALL    
      *
           MOVE 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789'
                TO W-ALFA2
           MOVE FUNCTION LENGTH(W-ALFA2) TO W-LENGTH
           CALL 'asc2ebc' USING W-ALFA2, W-LENGTH END-CALL 
           CALL 'cbl_oc_dump' using W-ALFA2 END-CALL
      *
      *    MOVE FUNCTION LENGTH(W-MESSAGE) TO W-LENGTH
      *    CALL 'asc2ebc' USING W-MESSAGE, W-LENGTH END-CALL 
      *    CALL 'cbl_oc_dump' using W-MESSAGE END-CALL    
      *
      *    DISPLAY "PRODUCER - queue_write W-MESSAGE : " W-MESSAGE  
           CALL 'queue_write' USING BY REFERENCE W-OUTPUTQUEUE,
		                            BY REFERENCE W-MESSAGE
	   	                            RETURNING W-RC        
           IF W-RC NOT EQUAL 0 THEN 
              DISPLAY "PRODUCER - queue_write ERROR RC IS : " W-RC
           END-IF.
      *  
       2100-QUEUE-WRITE-EXIT.
           EXIT.
      *  
