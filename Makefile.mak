all:fbl.img

fbl.img:fbl.o
	objcopy -O binary fbl.o fbl.img
	
fbl.o:fbl.S
	as -o fbl.o -a=fbl.lst fbl.S
