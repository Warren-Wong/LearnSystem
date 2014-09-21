all:fbl.img Makefile.mak

fbl.img:fbl.o print_str.o floppy.lds
	ld -o fbl.img.elf -T floppy.lds -I "./lib" fbl.o
	objcopy -O binary fbl.img.elf fbl.img
	
%.o:%.S
	as -o $@ -a=$(basename $@).lst $<
	
clear:
	rm *.o *.lst *.elf
