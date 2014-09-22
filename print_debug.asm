;***************************************************************
;	Print debug Functions Library
;
;	Contain:
;		PRINT_MT  ---  print a memory data table (begin on SI, print CX bytes)
;		PRINT_BIN  ---  print a AL on the screen in binary format
;		PRINT_AX_BIN  ---  print a AX on the screen in binary format
;		PRINT_AX_DEBUG  ---  print a AX on the screen in hex and binary format
;	Dependent:
;		print_str.asm
;		print_hex.asm
;
;***************************************************************
GLOBAL PRINT_MT,PRINT_BIN,PRINT_AX_BIN,PRINT_AX_DEBUG
EXTERN PRINT,PRINT_STR,SPACE,NEWLINE,PRINT_HEX,PRINT_AX
;PRINT_MT
;function:
;	print memory datas by a table
;entry:
;	ES:SI - the start address of memory want to show contents
;	CX - how many byte would be show
;exit: 
;	none
;use:
;	AX,BX,CX,DX,SI,ES
;dependent:
;	PRINT_HEX
;	SPACE
;	NEWLINE
;	PRINT
;	PRINT_AX
PRINT_MT:
	INC CX	;FOR BELOW CMP CX,0 JBE...
	; show [ES:SI]
	MOV AL,'>'
	CALL PRINT
	MOV AL,'>'
	CALL PRINT
	MOV AL,'>'
	CALL PRINT
	CALL SPACE
	MOV AL,'['
	CALL PRINT
	MOV AX,ES
	CALL PRINT_AX
	MOV AL,':'
	CALL PRINT
	MOV AX,SI
	CALL PRINT_AX
	MOV AL,']'
	CALL PRINT
	CALL NEWLINE
	
	PUSH CX
	CALL SHOWHEAD
	POP CX
	MOV AX,SI
	AND AX,000FH
	ADD AX,CX
	MOV CX,AX
	MOV AX,SI
	AND AX,0FFF0H
	MOV SI,AX
	;initial counter
	MOV AX,0
	MOV [.CNT],AX
	
	; show [ES:SI]
	MOV AL,'['
	CALL PRINT
	MOV AX,ES
	CALL PRINT_AX
	MOV AL,':'
	CALL PRINT
	MOV AX,SI
	CALL PRINT_AX
	MOV AL,']'
	CALL PRINT
	; print space
	CALL SPACE
	
.NEXT:
	CMP CX,0
	JBE .END
	MOV AL,[ES:SI]
	CALL PRINT_HEX
	CALL SPACE
	INC	SI
	DEC	CX
	
	MOV AX,[.CNT]
	INC AX
	MOV [.CNT],AX
	
	CMP AX,8
	JNE .NOLINE
	MOV AL,'-'
	CALL PRINT
	CALL SPACE
	MOV AX,[.CNT]
.NOLINE:
	CMP AX,16
	JB .NEXT
	MOV AX,0
	MOV [.CNT],AX
	CALL NEWLINE
	; show [ES:SI]
	MOV AL,'['
	CALL PRINT
	MOV AX,ES
	CALL PRINT_AX
	MOV AL,':'
	CALL PRINT
	MOV AX,SI
	CALL PRINT_AX
	MOV AL,']'
	
	CALL PRINT
	CALL SPACE
	JMP	.NEXT
.END:
	RET
.CNT:
	DW 0
	
SHOWHEAD:
	MOV CX,12
.LOOP:
	CALL SPACE
	DEC CX
	CMP CX,0
	JA .LOOP
	MOV CX,0
.PRINT_NUM:
	MOV AX,CX
	CALL PRINT_HEX
	CALL SPACE
	INC CX
	CMP CX,16
	JAE	.END
	CMP CX,8
	JNE	.PRINT_NUM
	CALL SPACE
	CALL SPACE
	JMP .PRINT_NUM
.END:
	CALL NEWLINE
	RET
	
;PRINT_BIN
;function: 
;	print a AL on the screen in binary format
;entey:	
;	al
;exit: 
;	none
;use:
;	AX,BX,DX,CX
;dependent:
;	PRINT
PRINT_BIN:
	MOV DL,AL
	MOV CX,8	
.NEXT:
	AND AL,80H
	JZ	.ISZERO
	MOV AL,'1'
	CALL PRINT
	JMP .CHECK_CX
.ISZERO:
	MOV	AL,'0'
	CALL PRINT
.CHECK_CX:
	DEC CX
	CMP CX,4
	JNE .NODUSH
	MOV AL,'_'
	CALL PRINT
.NODUSH:
	SHL	DL,1
	MOV AL,DL
	CMP	CX,0
	JA	.NEXT
	RET

;PRINT_AX_BIN
;function: 
;	print a AX on the screen in binary format
;entey:	
;	AX
;exit: 
;	none
;use:
;	AX,BX,DX,CX
;dependent:
;	PRINT
;	PRINT_BIN	
PRINT_AX_BIN:
	PUSH AX
	MOV AL,AH
	CALL PRINT_BIN
	MOV AL,'_'
	CALL PRINT
	POP AX
	CALL PRINT_BIN
	RET
	
;PRINT_AX_DEBUG
;function: 
;	print a AX on the screen in hex and binary format
;entey:	
;	AX -- data
;	SI -- string to print befor
;exit: 
;	none
;use:
;	AX,BX,DX,CX,SI
;dependent:
;	PRINT_STR
;	SPACE
;	PRINT
;	PRINT_AX
;	PRINT_AX_BIN
PRINT_AX_DEBUG:
	;MOV SI,REG NAME LIKE => REGNAME: 'AX=',0
	MOV	DX,AX
	CALL PRINT_STR
	CALL SPACE
	MOV AX,DX
	CALL PRINT_AX
	CALL SPACE
	MOV AL,'['
	CALL PRINT
	MOV AX,DX
	CALL PRINT_AX_BIN
	MOV	AL,']'
	CALL PRINT
	RET
