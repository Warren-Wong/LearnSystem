.code16
	cli
	mov $0,%ax
	mov %ax,%ds
	mov %ax,%es
	mov %ax,%ss
	mov $0x9fff,%si
	sti
	
	mov $'a',%al
	mov	$0x0e,%ah
	mov	$15,%bx
	int	$0x10
	
lp:
	hlt
	jmp	lp
	
	. = 510

	.word 0xaa55
	
	. = 1440*1024
	

	
	