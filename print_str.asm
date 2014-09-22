;***************************************************************
;	Print string Functions Library
;
;	Contain:
;		PRINT  ---  print the letter in AL
;		PRINT_STR  ---  print a string in SI
;		SPACE  ---  print a space
;		NEWLINE  ---  print a newline
;
;***************************************************************
GLOBAL PRINT,PRINT_STR,SPACE,NEWLINE
;PRINT
;function: 
;	print a charactor on the screen
;entey:	
;	al
;exit: 
;	none
;use:
;	AX,BX
;dependent:
;	none
PRINT:
	;MOV AL,'SOME CHARACTOR'
	MOV AH,0EH
	MOV BX,15
	INT 10H
	RET

;PRINT_STR
;function: 
;	print a string on the screen witch end with 0x00.
;entey:
;	SI
;exit: 
;	none
;use:
;	AX,BX,SI
;dependent:
;	none	
PRINT_STR:
	MOV	AL,[SI]
	ADD	SI,1
	CMP	AL,0
	JE	.END	;detect 0，return
	MOV	AH,0EH
	MOV	BX,15
	INT	10H
	JMP	PRINT_STR
.END:
	RET

;SPACE
;function: 
;	print a SPACE on the screen
;entey:	
;	none
;exit: 
;	none
;use:
;	AX,BX
;dependent:
;	PRINT
SPACE:
	MOV AL,' '
	CALL PRINT
	RET

	
;NEWLINE
;function: 
;	print NEW LINE on the screen
;entey:	
;	none
;exit: 
;	none
;use:
;	AX,BX
;dependent:
;	PRINT	
NEWLINE:
	MOV	AL,0DH
	CALL PRINT
	MOV	AL,0AH
	CALL PRINT
	RET
