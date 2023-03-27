
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

	.org PatchCheckFormForCustSlot9to10
	ldr r0, =Hook_PatchCheckFormForCustSlot9to10|1
	bx r0
	.pool
Hook_PatchCheckFormForCustSlot9to10_Return:
	; navi constants correspond to soul constants
	; so can just reuse the rest of the function here

	.org PatchLoadShuffleGfx+4
	ldr r2, =Hook_PatchLoadShuffleGfx|1
	bx r2
	.pool

	.org PatchLoadArmChangeGfx+4
	ldr r2, =Hook_PatchLoadArmChangeGfx|1
	bx r2
	.pool

	.org PatchSetArmChange
	mov r1, oNaviStats_NaviIndex

	.org PatchSetNaviBPwrAtk
	ldr r0, =Hook_PatchSetNaviBPwrAtk|1
	bx r0
	.pool
Hook_PatchSetNaviBPwrAtk_Return:

	.org PatchBPwrAtkChargeTime
	ldr r0, =Hook_PatchBPwrAtkChargeTime|1
	bx r0
	.pool
Hook_PatchBPwrAtkChargeTime_Return:

	.org PatchTomahawkAirRaidCollisionFlags
	mov r3, 1 ; remove flash flag

	.org PatchTomahawkAirRaidEndlag
	mov r0, 15

	.org PatchNumberDieEndlag
	mov r0, 3

	.org PatchNinjaStarEndlag
	mov r0, 3

	.org PatchFrogSmackEndlag
	mov r0, 3

	; .org PatchTomahawkAirRaidWindup
	; mov r0, 8

	.org PatchNumberSoulNullChipBonus
	mov r1, oNaviStats_NaviIndex
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, NAVI_NUMBERMAN
	; bne PatchNumberSoulNullChipBonus_NotNumberMan

	.org PatchShadowmanMoveFrames
	.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

	.org PatchShuffleCount
	mov r0, 2

	.macro make_asterisk_code, chip_id
	.org ChipInfo + chip_id * 44
	.byte CODE_ASTERISK ; * code
	.endmacro

	make_asterisk_code CHIP_STEPSWRD
	make_asterisk_code CHIP_AIRFORCE
	make_asterisk_code CHIP_SATELITY
	make_asterisk_code CHIP_NAPALM
	make_asterisk_code CHIP_NSTACKLE
	make_asterisk_code CHIP_MEDDYCAP
	make_asterisk_code CHIP_C_CANNON
	make_asterisk_code CHIP_SPLITUP 
	make_asterisk_code CHIP_NUMTRAP 
	make_asterisk_code CHIP_T_SWING 
	make_asterisk_code CHIP_KCRUSHER
	make_asterisk_code CHIP_S_MELODY

	.org GoldChipTable
	chip_and_code CHIP_STEPSWRD, CODE_ASTERISK
	chip_and_code CHIP_STEPSWRD, CODE_ASTERISK
	chip_and_code CHIP_AIRFORCE, CODE_ASTERISK
	chip_and_code CHIP_AIRFORCE, CODE_ASTERISK
	chip_and_code CHIP_SATELITY, CODE_ASTERISK
	chip_and_code CHIP_SATELITY, CODE_ASTERISK
	chip_and_code CHIP_NAPALM, CODE_ASTERISK
	chip_and_code CHIP_NAPALM, CODE_ASTERISK
	chip_and_code CHIP_NSTACKLE, CODE_ASTERISK
	chip_and_code CHIP_NSTACKLE, CODE_ASTERISK
	chip_and_code CHIP_MEDDYCAP, CODE_ASTERISK
	chip_and_code CHIP_MEDDYCAP, CODE_ASTERISK
	chip_and_code CHIP_C_CANNON, CODE_ASTERISK
	chip_and_code CHIP_C_CANNON, CODE_ASTERISK
	chip_and_code CHIP_SPLITUP, CODE_ASTERISK
	chip_and_code CHIP_SPLITUP, CODE_ASTERISK
	chip_and_code CHIP_NUMTRAP, CODE_ASTERISK
	chip_and_code CHIP_NUMTRAP, CODE_ASTERISK
	chip_and_code CHIP_T_SWING, CODE_ASTERISK
	chip_and_code CHIP_T_SWING, CODE_ASTERISK
	chip_and_code CHIP_KCRUSHER, CODE_ASTERISK
	chip_and_code CHIP_KCRUSHER, CODE_ASTERISK
	chip_and_code CHIP_S_MELODY, CODE_ASTERISK
	chip_and_code CHIP_S_MELODY, CODE_ASTERISK
