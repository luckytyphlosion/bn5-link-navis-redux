
	INPUT_ROM equ vequ("bn5p.gba", "bn5c.gba")
	OUTPUT_ROM equ vequ("bn5p-link-navis-redux.gba", "bn5c-link-navis-redux.gba")
	.vdefinelabel fspace, 0x87FCA20, 0x087FD780

	; version-specific defines
	.vdefinelabel PatchRemoveNaviReset, 0x08135936, 0x08135a1e

	; version-independent defines
	.definelabel PatchLinkNaviOpenPETMenu, 0x0800549a
	