all:fbl.img Makefile

fbl.img:fbl.o floppy.lds $(wildcard ./lib/*.S)
	ld -o fbl.img.elf -T floppy.lds -I "./lib" -d fbl.o
	objcopy -O binary fbl.img.elf fbl.img
	
%.o:%.S
	as -o $@ -a=$(basename $@).lst $<
	#gcc -o $@ -Wa,-a=$(basename $@).lst $<
	
clear:
	rm *.o
	rm *.lst
	rm *.elf
