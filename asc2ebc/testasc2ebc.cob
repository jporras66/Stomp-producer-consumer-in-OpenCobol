      *---------------------------------------------------------------*
      *          I D E N T I F I C A T I O N   D I V I S I O N        *
      *          =============================================        *
      *---------------------------------------------------------------*       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTASC2EBC. 
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      *SPECIAL-NAMES.
      *ALPHABET ALPHA IS NATIVE
      *ALPHABET BETA  IS EBCDIC.
       INPUT-OUTPUT SECTION.
      *--------------------.
       FILE-CONTROL.  
       DATA DIVISION.
      *-------------.
       FILE SECTION.
      *-------------.  
       WORKING-STORAGE SECTION.
       01 I      PIC 9(04) VALUE 0.
       01 C      PIC X(01) VALUE SPACES.
       01 VLENGTH USAGE BINARY-SHORT VALUE 0.
       01 VAR    PIC X(62) VALUE IS
       '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ'. 
       01 VAR2   PIC X(256) VALUE SPACES.
       PROCEDURE DIVISION.
      *
       MOVE FUNCTION LENGTH(VAR2) TO VLENGTH  
       CALL 'inithexa' USING VAR2, VLENGTH END-CALL
       CALL 'cbl_oc_dump' using VAR2 END-CALL
      *
       CALL 'asc2ebc' USING VAR2, VLENGTH END-CALL 
       CALL 'cbl_oc_dump' using VAR2 END-CALL 
      *   
       CALL 'ebc2asc' USING VAR2, VLENGTH END-CALL
      *
       CALL 'cbl_oc_dump' using VAR2 END-CALL 
       GOBACK.
       