[BITS 16]
;BIOS MEMORY LAYOUT:
;Low Memory (the first MiB)
;start		|	end	size	|	type			|	description
;0x00000000	|	0x000003FF	|	1 KiB			|	RAM - partially unusable (see above)	Real Mode IVT (Interrupt Vector Table)
;0x00000400	|	0x000004FF	|	256 bytes		|	RAM - partially unusable (see above)	BDA (BIOS data area)
;0x00000500	|	0x00007BFF	|	almost 30 KiB	|	RAM (guaranteed free for use)	Conventional memory
;0x00007C00 |	0x00007DFF	|	512 bytes		|	(typical location)	RAM - partially unusable (see above)	Your OS BootSector
;0x00007E00	|	0x0007FFFF	|	480.5 KiB		|	RAM (guaranteed free for use)	Conventional memory
;0x00080000	|	0x0009FBFF	|	120KiB 			|	(typical location) depending on EBDA size	RAM (free for use, if it exists)	Conventional memory
;0x0009FC00 |	0x0009FFFF	|	1 KiB			|	RAM (unusable)	EBDA (Extended BIOS Data Area)
;0x000A0000	|	0x000FFFFF	|	384 KiB			|	various (unusable)	Video memory, ROM Area

;So we load our system code here:	
;0x00007E00	|	0x0007FFFF	|	480.5 KiB		|	RAM (guaranteed free for use)
GLOBAL _START
EXTERN SBL
EXTERN PRINT,PRINT_STR,SPACE,NEWLINE,PRINT_HEX,PRINT_AX,PRINT_MT,PRINT_BIN,PRINT_AX_BIN,PRINT_AX_DEBUG
	CLI
	XOR AX,AX
	MOV DS,AX
	MOV ES,AX
	MOV SS,AX
	MOV SP,0A000H
	STI
	
_START:
RESET_DISK:
	MOV SI,HELLO_MSG
	CALL PRINT_STR
	CALL NEWLINE
	
	MOV AH,00H
	MOV DL,00H
	INT 13H
	NOP
	NOP
	JC	.DISKERR
	CALL POK
	JMP LOAD_FUN
.DISKERR:
	CALL PERR
	JMP FIN

LOAD_FUN:
	MOV AX,0000H	;ES:BX ->data buff
	MOV ES,AX		;here set to [0000:7e00]
	MOV BX,7E00H	;
	MOV AH,02H		;BIOS int 13h #2 function
	MOV AL,01H		;number of sector to read
	MOV CH,00H		;cylinder number
	MOV CL,02H		;start sector
	MOV DH,00H		;head number
	MOV DL,00H		;driber number
	INT 13H
	NOP
	NOP
	JC	.LOADERR
	CALL POK
	JMP LOAD_SBL
.LOADERR:
	CALL PRINT_AX
	CALL PERR
	JMP FIN
	
LOAD_SBL:
	;MOV SI,8000H
	;MOV CX,0FFH
	;CALL PRINT_MT
	;------------------------ LOAD SBL------------
	XOR AX,AX
	MOV ES,AX		;ES:BX ->data buff
	MOV BX,8000H	;here set to [0000:8000]
	MOV CL,03H		;start sector
.NEXT:
	MOV CH,00H		;cylinder number
	MOV AH,02H		;BIOS int 13h #2 function
	MOV AL,01H		;number of sector to read
	MOV DH,00H		;head number
	MOV DL,00H		;driber number
	INT 13H
	NOP
	NOP
	JC	.LOADERR
	MOV AL,CL
	CALL PRINT_HEX
	CALL SPACE
	ADD	BX,200H
	INC CL
	CMP CL,18
	JBE .NEXT
	CALL NEWLINE
	MOV SI:TO_SBL
	CALL PRINT_STR
	CALL NEWLINE
	JMP SBL
.LOADERR:
	CALL PRINT_AX
	CALL PERR
	JMP FIN


FIN:
	CALL NEWLINE
	MOV SI,LOADEND
	CALL PRINT_STR
	CALL NEWLINE
FIN2:
	HLT
	JMP FIN2

;%include "lib/print_str.asm"
;%include "lib/print_hex.asm"	
	
POK:
	MOV SI,OK_MSG
	CALL PRINT_STR
	CALL NEWLINE
	RET
	
PERR:
	MOV SI,ERR_MSG
	CALL PRINT_STR
	CALL NEWLINE
	RET
	
LOADEND:	DB	' END ',0
TO_SBL:		DB	' SBL ',0
HELLO_MSG:	DB ' HELLO ',0
ERR_MSG:	DB ' ERR ',0
OK_MSG:	DB	' OK ',0
DRIVER_NUMBER:	DB 0
	TIMES 10 DB '@'

	;RESB 510-($-$$)
	;DW 0AA55H
