fbl.img:fbl.o sbl.o print_str.o print_hex.o print_debug.o Makefile link.lds
	echo new : $?
	ld -o fbl.temp -T link.lds -dc fbl.o  sbl.o print_str.o print_hex.o print_debug.o
	objcopy -O binary -I pei-i386 fbl.temp fbl.img

%.o:%.asm
	nasm -o $@ -l $(basename $<).lst -f elf $<
	
clear:
	rm *.o
	rm *.temp
	rm *.lst