
	INPUT_ROM equ vequ("bn5p.gba", "bn5c.gba")
	OUTPUT_ROM equ vequ("bn5p-link-navis-redux.gba", "bn5c-link-navis-redux.gba")
	.vdefinelabel fspace, 0x87FCA20, 0x087FD780

	; version-specific defines
	.vdefinelabel PatchRemoveNaviReset, 0x08135936, 0x08135a1e
	.vdefinelabel PatchCheckFormSpecificABtnPwrAtk, 0x8010928, 0x8010920
	.vdefinelabel PatchCheckFormFor2xABtnPwrAtk, 0x80103d4, 0x80103cc
	.vdefinelabel PatchCheckShadowSoulBackstab, 0x80ebd2a, 0x80ebe12
	.vdefinelabel PatchCheckForForcedCustSize, 0x8025c2a, 0x8025c2e

	; version-specific defines for game functions
	.vdefinelabel GetBattleNaviStatsByte_AllianceFromBattleObject, 0x8010df6, 0x8010dee

	; version-independent defines
	.definelabel PatchLinkNaviOpenPETMenu, 0x0800549a

	; version-independent game defines
	.definelabel eNaviStats, 0x20052A8
