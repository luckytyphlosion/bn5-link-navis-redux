
	.include "version_macros.asm"

	.macro chip_and_code, chip_id, code
	.halfword (chip_id & 0x1ff) | code << 9
	.endmacro
