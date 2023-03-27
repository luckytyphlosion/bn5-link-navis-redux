
	.org PatchLinkNaviOpenPETMenu
	nop

	.org PatchRemoveNaviReset
	nop
	nop

	.org PatchCheckForForcedCustSize
	nop

	.org PatchCheckFormSpecificABtnPwrAtk
	.area 0x80109A4 - 0x8010928
	mov r1, oNaviStats_NaviIndex
	bl GetBattleNaviStatsByte_AllianceFromBattleObject

	cmp r0, NAVI_PROTOMAN
	bne @@notProtoMan

	cmp r4, CHIP_ELEM_SWORD
	bne @@cantChargeChip
	b @@canChargeChip

@@notProtoMan:
	cmp r0, NAVI_NAPALMMAN
	bne @@notNapalmMan

	cmp r4, CHIP_ELEM_FIRE
	bne @@cantChargeChip
	b @@canChargeChip

@@notNapalmMan:
	cmp r0, NAVI_MAGNETMAN
	bne @@notMagnetMan

	cmp r4, CHIP_ELEM_ELEC
	bne @@cantChargeChip
	b @@canChargeChip

@@notMagnetMan:
	cmp r0, NAVI_SHADOWMAN
	bne @@notShadowMan

	cmp r4, CHIP_ELEM_SWORD
	bne @@cantChargeChip
	b @@canChargeChip

@@notShadowMan:
	cmp r0, NAVI_TOMAHAWKMAN
	bne @@notTomahawkMan

	cmp r4, CHIP_ELEM_WOOD
	bne @@cantChargeChip
	b @@canChargeChip

@@notTomahawkMan:
	cmp r0, NAVI_KNIGHTMAN
	bne @@notKnightMan

	cmp r4, CHIP_ELEM_BREAK
	bne @@cantChargeChip
	b @@canChargeChip

@@notKnightMan:
	cmp r0, NAVI_TOADMAN
	bne @@cantChargeChip

	cmp r4, CHIP_ELEM_AQUA
	bne @@cantChargeChip

	; fallthrough
@@canChargeChip:
	mov r0, TRUE
	pop r4,r6,r7,pc
@@cantChargeChip:
	mov r0, FALSE
	pop r4,r6,r7,pc
	.endarea

	.org PatchCheckFormFor2xABtnPwrAtk
	.area 0x8010440 - 0x80103d4
	tst r4, r4
	beq @@no2xDamage
	mov r1, oNaviStats_NaviIndex
	bl GetBattleNaviStatsByte_AllianceFromBattleObject

	cmp r0, NAVI_PROTOMAN
	beq @@do2xDamage

	cmp r0, NAVI_NAPALMMAN
	beq @@do2xDamage

	cmp r0, NAVI_MAGNETMAN
	beq @@do2xDamage

	cmp r0, NAVI_TOMAHAWKMAN
	beq @@do2xDamage

	cmp r0, NAVI_KNIGHTMAN
	beq @@do2xDamage

	cmp r0, NAVI_TOADMAN
	beq @@do2xDamage
@@no2xDamage:
	mov r0, FALSE
	pop r4,pc

@@do2xDamage:
	mov r0, 0xff
	pop r4,pc
	.endarea

	.org PatchCheckShadowSoulBackstab
	mov r1, oNaviStats_NaviIndex
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, NAVI_SHADOWMAN
