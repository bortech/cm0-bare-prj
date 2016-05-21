MEMORY
{
    FLASH (rx): ORIGIN = 0x00000000, LENGTH = 32k
    RAM (rwx): ORIGIN = 0x10000000, LENGTH = 8k
}
  
SECTIONS
{        
	. = ORIGIN(FLASH);
     .text : {
		  KEEP(*(.vectors));
		  *(.text*)
			*(.rodata*)
        } > FLASH

	. = ORIGIN(RAM);
        .data : {
	  INIT_DATA_VALUES = LOADADDR(.data);
	  INIT_DATA_START = .;
	    *(.data*)
	  INIT_DATA_END = .;
        } >RAM AT>FLASH

	.bss : {	 
	 . = ALIGN(4);	
		BSS_START = .;
	   *(.bss*)	  
	 . = ALIGN(4);	
		BSS_END = .;
	} > RAM
}
