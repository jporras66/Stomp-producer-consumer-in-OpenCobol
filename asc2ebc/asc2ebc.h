/*
**  ASCII <=> EBCDIC conversion functions
	http://publib.boulder.ibm.com/infocenter/zos/v1r11/index.jsp?topic=/com.ibm.zos.r11.csfb400/e2aASC3EBC.htm
	EBCDIC and ASCII Default Conversion Tables
*/

#ifndef ASC3EBC__H
#define ASC3EBC__H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

 
int asc2ebc (char * pstr, const unsigned int *plength);  
int ebc2asc (char * pstr, const unsigned int *plength);  
int inithexa(char * pstr, const unsigned int *plength);  

unsigned char ASCIItoEBCDIC(const unsigned char c);  
unsigned char EBCDICtoASCII(const unsigned char c);

#ifdef __cplusplus
}
#endif

#endif /* ASC3EBC__H */

