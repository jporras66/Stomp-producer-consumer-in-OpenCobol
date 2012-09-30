      *---------------------------------------------------------------*
      *          I D E N T I F I C A T I O N   D I V I S I O N        *
      *          =============================================        *
      *---------------------------------------------------------------*
       IDENTIFICATION DIVISION.
      *-----------------------.
       PROGRAM-ID.      CONSUMER.
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
           alphabet ALPHA is native
           alphabet BETA  is ebcdic.
       INPUT-OUTPUT SECTION.
      *--------------------.
       FILE-CONTROL.
      *
        COPY 'select-file-data.cpy'.       
      * 
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
       COPY 'fd-file-data.cpy'.       
      * 
       WORKING-STORAGE SECTION.
      *-----------------------.

       01 FILLER PIC X(050)
                 VALUE  'PGM-CONSUMER-WS-COMIENZO'.
      *
       COPY 'file-status.cpy'. 
      *
       01 PGM-NAME PIC X(15) 
                 VALUE 'CONSUMER'.
      *
       01 W-HOSTNAME    PIC X(15) VALUES '127.0.0.1      '.
       01 W-PORT        USAGE BINARY-SHORT UNSIGNED VALUE 61613. 
       01 W-INPUTQUEUE  PIC X(15) VALUE '/queue/TEST.FOO'.  
       01 W-OUTPUTQUEUE PIC X(15) VALUE '/queue/TEST.OUT'.
       01 W-IDHEADER    PIC X(04) VALUE '0000'.	   
       01 W-RC USAGE    BINARY-SHORT VALUE 0.
      *01 W-BUFFER      PIC X(2000) VALUE SPACES.
       01 COMMIT-COUNTER   PIC 9(4) VALUE 2000.
       01 SECONDS-TO-SLEEP PIC 9(4) VALUE 2.
      *	
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
                  VALUE  'PGM-CONSUMER-WS-FIN'.
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
      *    ACCEPT COMMAND-LINE-VALUES FROM COMMAND-LINE.
      *    MOVE   BROKER-IP     TO W-HOSTNAME
      *    DISPLAY 'COMMAND-LINE-VALUES is : ' 
      *            COMMAND-LINE-VALUES
           DISPLAY 'W-HOSTNAME     is : ' W-HOSTNAME
           DISPLAY 'W-PORT         is : ' W-PORT 
      *	   
           SET NEOF TO TRUE
           OPEN OUTPUT FILE-DATA
           IF FS-FILE-DATA <> '00' THEN
              DISPLAY 'FILE-DATA ACCESS ERROR - STATUS IS : ' 
                      FS-FILE-DATA
              STOP RUN
           END-IF
           PERFORM 2000-INIT
              THRU 2000-INIT-EXIT. 
      *
           PERFORM 3000-END.
      *        
       2000-INIT.
      *
           MOVE FUNCTION CURRENT-DATE TO FULL-CURRENT-DATE.
           DISPLAY 'INICIO : ' PGM-NAME ' - '  FULL-DATETIME.
      *
           DISPLAY "CONSUMER - queue_connect BEFORE     " 	  
           CALL 'broker_connect' USING BY REFERENCE W-HOSTNAME, 
		                               BY REFERENCE W-PORT
                RETURNING W-RC        
           DISPLAY "CONSUMER - queue_connect RC : " W-RC
           IF W-RC NOT EQUAL 0 THEN 
              DISPLAY "CONSUMER - queue_connect ERROR RC IS : " W-RC
           END-IF.		   
      *
           DISPLAY "CONSUMER - queue_subscribe BEFORE     " 	  
           CALL 'queue_subscribe' USING BY REFERENCE W-IDHEADER,
		                          BY REFERENCE W-INPUTQUEUE 
                RETURNING W-RC        
           DISPLAY "CONSUMER - queue_subscribe RC : " W-RC
           IF W-RC NOT EQUAL 0 THEN 
              DISPLAY "CONSUMER - queue_subscribe ERROR RC IS : " W-RC
           END-IF.		   
      *
           SET NEOF TO TRUE	  
           PERFORM 2100-QUEUE-READ 
                   THRU 2100-QUEUE-READ-EXIT 
      			   UNTIL EOF.
      *
           DISPLAY "CONSUMER - queue_disconnect BEFORE     " 	  
           CALL 'broker_disconnect' RETURNING W-RC        
           DISPLAY "CONSUMER - queue_disconnect RC : " W-RC
           IF W-RC NOT EQUAL 0 THEN 
              DISPLAY "CONSUMER - queue_disconnect ERROR RC IS : " W-RC
           END-IF.		   
      * 
       2000-INIT-EXIT.
           EXIT.
      *        
       2100-QUEUE-READ.
      * 
      *    DISPLAY "CONSUMER - queue_read BEFORE     "
           MOVE SPACES TO W-MESSAGE.	  
           CALL 'queue_read' USING BY REFERENCE W-IDHEADER
		                           BY REFERENCE W-INPUTQUEUE, 
		                           BY REFERENCE W-MESSAGE
	   	                           RETURNING W-RC
      * 
           IF W-RC NOT EQUAL 0 THEN 
              DISPLAY "CONSUMER - queue_read ERROR RC IS : " W-RC
              PERFORM 3000-END
           END-IF.
      *
           MOVE W-MESSAGE TO WW02-FILE-DATA
           WRITE WW02-FILE-DATA
           IF FS-FILE-DATA <> '00' THEN
              DISPLAY 'WRITE - FILE-DATA ACCESS ERROR - STATUS IS : ' 
                      FS-FILE-DATA
              PERFORM 3000-END
           END-IF.
      *
           MOVE FUNCTION LENGTH(W-ALFA1) TO W-LENGTH
           CALL 'ebc2asc' USING W-ALFA1, W-LENGTH END-CALL 
      *    CALL 'cbl_oc_dump' using W-ALFA1 END-CALL    
      *
           MOVE FUNCTION LENGTH(W-ALFA2) TO W-LENGTH
           CALL 'ebc2asc' USING W-ALFA2, W-LENGTH END-CALL 
      *    CALL 'cbl_oc_dump' using W-ALFA2 END-CALL
      * 
      *    DISPLAY "============================================="
      *    DISPLAY "CONSUMER - queue_read W-MESSAGE : " W-MESSAGE
      *    DISPLAY "============================================="  
      *  
           MOVE W-MESSAGE TO WW02-FILE-DATA
           WRITE WW02-FILE-DATA
           IF FS-FILE-DATA <> '00' THEN
              DISPLAY 'WRITE - FILE-DATA ACCESS ERROR - STATUS IS : ' 
                      FS-FILE-DATA
              PERFORM 3000-END
           END-IF.
      *
           CALL 'C$SLEEP' USING SECONDS-TO-SLEEP. 
      * 
       2100-QUEUE-READ-EXIT.
           EXIT.
      *
       3000-END.  
      *
           CLOSE FILE-DATA.  
           STOP RUN. 