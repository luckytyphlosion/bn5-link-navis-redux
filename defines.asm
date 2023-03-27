
	INPUT_ROM equ vequ("bn5p.gba", "bn5c.gba")
	OUTPUT_ROM equ vequ("bn5p-link-navis-redux.gba", "bn5c-link-navis-redux.gba")
	.vdefinelabel fspace, 0x87FCA20, 0x087FD780

	; version-specific defines
	.vdefinelabel PatchRemoveNaviReset, 0x08135936, 0x08135a1e
	.vdefinelabel PatchCheckFormSpecificABtnPwrAtk, 0x8010928, 0x8010920
	.vdefinelabel PatchCheckFormFor2xABtnPwrAtk, 0x80103d4, 0x80103cc
	.vdefinelabel PatchCheckShadowSoulBackstab, 0x80ebd2a, 0x80ebe12
	.vdefinelabel PatchCheckForForcedCustSize, 0x8025c2a, 0x8025c2e
	.vdefinelabel PatchCheckFormForCustSlot9to10, 0x8023cf8, 0x8023cf4
	.vdefinelabel PatchLoadShuffleGfx, 0x80240fe, 0x8024102
	.vdefinelabel PatchLoadArmChangeGfx, 0x802415a, 0x802415e
	.vdefinelabel PatchSetArmChange, 0x80124b6, 0x80124ae
	.vdefinelabel PatchSetNaviBPwrAtk, 0x800dd20, 0x800dd18
	.vdefinelabel PatchArmChangeChargeTime, 0x801cb2a, 0x801cb26
	.vdefinelabel PatchBPwrAtkChargeTime, 0x8010694, 0x801068c
	.vdefinelabel PatchTomahawkAirRaidCollisionFlags, 0x80dcc1e, 0x80dcd06
	.vdefinelabel PatchTomahawkAirRaidEndlag, 0x800fade, 0x800fad6
	.vdefinelabel PatchTomahawkAirRaidWindup, 0x80f1798, 0x80f1880
	.vdefinelabel PatchNumberSoulNullChipBonus, 0x800d0b2, 0x800d0aa
	.vdefinelabel PatchNumberSoulNullChipBonus_NotNumberMan, 0x800d108, 0x800d100
	.vdefinelabel ChipInfo, 0x0801e214, 0x0801e210
	.vdefinelabel GoldChipTable, 0x8025ea0, 0x8025ea4
	.vdefinelabel PatchShuffleCount, 0x8023d10, 0x8023d0c

	; version-specific defines for game functions
	.vdefinelabel GetBattleNaviStatsByte_AllianceFromBattleObject, 0x8010df6, 0x8010dee

	; version-independent defines
	.definelabel PatchLinkNaviOpenPETMenu, 0x0800549a

	; version-independent game defines
	.definelabel eNaviStats, 0x20052A8
	.definelabel QueueEightWordAlignedGFXTransfer, 0x80009e8
