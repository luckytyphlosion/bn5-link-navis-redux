
	.gba
	.include "macros.asm"
	.include "defines.asm"

	.open INPUT_ROM, OUTPUT_ROM, 0x8000000

	; === orgs ===
	.include "link-navis-redux/src_orgs.asm"

	; === Free Space ===
	.org fspace
	.include "link-navis-redux/src_farspace.asm"

	.close
; eof
