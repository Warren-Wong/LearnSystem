.code16

.text
print:
	/* mov 'SOME CHARACTOR',al */
	movb $0x0e,%al
	movw $15,%bx
	int	$0x13 
	ret
	 
print_str:
print_str_start:
	movb (%si),%al
	incw %si
	cmpb $0x00,%al /* detect 0，return */
	je print_str_ret
	movb $0x0e,%ah
	movw $15,%bx
	int $0x10
	jmp print_str_start
print_str_ret:
	ret
	
	. = 512