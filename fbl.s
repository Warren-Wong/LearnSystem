.code16
.text
_start:
	cli
	mov $0,%ax
	mov %ax,%ds
	mov %ax,%es
	mov %ax,%ss
	mov $0x9fff,%si
	sti
	
	/* save the driver number of boot driver */
	movw $driver_number,%bx
	movb %dl,(%bx)
	
	/* mov
	mov $'a',%al
	mov	$0x0e,%ah
	mov	$15,%bx
	int	$0x10

driver_number:	.byte	0
	
.include "print_str.S"
	
lp:
	hlt
	jmp	lp
	
	. = 510

	.word 0xaa55
	

	
	