;***************************************************************
;	Print AL/AX HEX Functions Library
;
;	Contain:
;		PRINT_HEX  ---  print a data in AL in hex format
;		PRINT_AX  ---  print a data in AX in hex format
;	Depenednt:
;		print_str.asm
;
;***************************************************************
GLOBAL PRINT_HEX,PRINT_AX
EXTERN PRINT,PRINT_STR,SPACE,NEWLINE
;BCD_FORMAT
;function: 
;	change al lower 4 bits contents to BCD code
;entey:	
;	AL
;exit: 
;	AL
;use:
;	AL
;dependent:
;	none	
BCD_FORMAT:
	AND AL,0FH
	CMP	AL,09H
	JA	.ISALPHA
	ADD AL,30H
	JMP	.BCDOK
.ISALPHA:
	SUB AL,0AH
	ADD	AL,41H
.BCDOK:
	RET
	

;PRINT_HEX
;function: 
;	print the value in AL on the screen by hex number
;entey:	
;	AL
;exit: 
;	none
;use:
;	AX,BX,DL
;dependent:
;	BCD_FORMAT
;	PRINT
PRINT_HEX:
	MOV	DL,AL
	SHR AL,4
	CALL BCD_FORMAT
	CALL PRINT
	MOV AL,DL
	CALL BCD_FORMAT
	CALL PRINT
	RET
	
	
;PRINT_AX
;function: 
;	print the value in AX on the screen by hex number
;entey:	
;	AX
;exit: 
;	none
;use:
;	AX,BX,DX
;dependent:
;	PRINT_HEX	
PRINT_AX:
	MOV DX,AX
	MOV AL,DH
	PUSH DX
	CALL PRINT_HEX
	POP DX
	MOV AL,DL
	CALL PRINT_HEX
	RET