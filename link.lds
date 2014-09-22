SECTIONS {
	fbl 0x0000:{
		fbl.o
		print_str.o
		print_hex.o
		. = 510;
		BYTE(0x55);
		BYTE(0xaa);
	}=0x90
	
	print_fun :{
		print_debug.o
		. = ALIGN(512);
	}=0x90
	
	sbl :{
		sbl.o
		. = ALIGN(512);
	}=0x90
	
	
}