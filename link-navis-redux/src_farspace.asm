
	.align 4
Hook_PatchCheckFormForCustSlot9to10:
	push r4,r6,lr
	mov r0, r10
	ldr r0, [r0, oToolkit_BattleStatePtr]
	ldrb r0, [r0, oBattleState_NetworkSide]
	mov r1, oNaviStats_NaviIndex
	bl GetBattleNaviStatsByte_AllianceFromBattleObject_longcall
	mov r7, r0
	ldr r0, =Hook_PatchCheckFormForCustSlot9to10_Return|1
	bx r0

Hook_PatchLoadShuffleGfx:
	ldr r2, =0x180 ; size of gfx
	ldrb r3, [r4,7] ; chip state
	mul r3, r2
	add r0, r0, r3
	b PatchShuffleArmChangeGfxCommon

	
Hook_PatchLoadArmChangeGfx:
	ldr r2, =0x180 ; size of gfx
	ldrb r3, [r4,7] ; chip state
	cmp r3, 1
	bne @@highlightGfx
	add r0, r0, r2
@@highlightGfx:
	; fallthrough

PatchShuffleArmChangeGfxCommon:
	ldrb r3, [r4,0xc] ; look at the next chip type
	tst r3, r3 ; check if zero (indicates chip)
	; if not, show the full window (size already loaded in r2)
	bne @@showFullWindow
	mov r2, 0xc0
@@showFullWindow:
	bl QueueEightWordAlignedGFXTransfer_longcall
	add r1, r2
	pop pc

Hook_PatchSetNaviBPwrAtk:
	mov r1, oNaviStats_NaviIndex
	bl GetBattleNaviStatsByte_AllianceFromBattleObject_longcall
	cmp r0, NAVI_COLONEL
	bne @@loadRegularBPwrAtk
	ldrb r0, [r4, oAIData_BPwrAtk]
	cmp r0, 0x13 ; armchange
	beq @@keepArmChangeBPwrAtk
@@loadRegularBPwrAtk:
	mov r1, oNaviStats_BPwrAtk
	bl GetBattleNaviStatsByte_AllianceFromBattleObject_longcall
	strb r0, [r4, oAIData_BPwrAtk]
@@keepArmChangeBPwrAtk:
	mov r0, 0xff
	ldr r1, =Hook_PatchSetNaviBPwrAtk_Return|1
	bx r1

Hook_PatchBPwrAtkChargeTime:
	mov r1, oNaviStats_NaviIndex
	bl GetBattleNaviStatsByte_AllianceFromBattleObject_longcall
	cmp r0, NAVI_COLONEL
	bne @@fetchRegularChargeTime
	ldrb r0, [r4, r7]
	cmp r0, 0x13 ; arm change
	bne @@fetchRegularChargeTime

	; tankcan - 80 damage, 80-100i
	; pulsar - 70 damage, 90i
	ldrh r3, [r4, oAIData_ArmChangeChip]
	ldr r2, =ArmChangeChargeTimes
	b @@handleLoop
@@chipNotSame:
	add r2, 4
@@handleLoop:
	ldrh r0, [r2]
	tst r0, r0
	beq @@failsafeChargeTime
	cmp r0, r3
	bne @@chipNotSame
	; read charge time
	ldrh r0, [r2, 2]
	pop r4,r7,pc
@@failsafeChargeTime:
	mov r0, (2000 >> 4)
	lsl r0, r0, 4
@@noChargeTime:
	pop r4,r7,pc

@@fetchRegularChargeTime:
	mov r0, 0xff
	ldrb r1, [r4,r7]
	cmp r1, 0xff
	beq @@noChargeTime
	mov r2, 0xa
	ldr r0, =Hook_PatchBPwrAtkChargeTime_Return|1
	bx r0

GetBattleNaviStatsByte_AllianceFromBattleObject_longcall:
	push r2,lr
	ldr r2, =GetBattleNaviStatsByte_AllianceFromBattleObject|1
	mov lr, pc
	bx r2
	pop r2,pc

QueueEightWordAlignedGFXTransfer_longcall:
	ldr r3, =QueueEightWordAlignedGFXTransfer|1
	bx r3

	.pool

	.align 2
ArmChangeChargeTimes:
	.halfword CHIP_CANNON, 90
	.halfword CHIP_HICANNON, 90
	.halfword CHIP_M_CANNON, 90
	.halfword CHIP_VULCAN1, 90
	.halfword CHIP_VULCAN2, 90
	.halfword CHIP_VULCAN3, 90
	.halfword CHIP_SPREADER, 90
	.halfword CHIP_PULSAR1, 90
	.halfword CHIP_PULSAR2, 90
	.halfword CHIP_PULSAR3, 90
	.halfword CHIP_MINIBOMB, 11
	.halfword CHIP_ENERGBOM, 90
	.halfword CHIP_MEGENBOM, 90
	.halfword CHIP_CRAKBOM, 90
	.halfword CHIP_PARABOM, 90
	.halfword CHIP_RESETBOM, 90
	.halfword CHIP_TANKCAN1, 90
	.halfword CHIP_TANKCAN2, 90
	.halfword CHIP_TANKCAN3, 90
	.halfword CHIP_SKULLY1, 90
	.halfword CHIP_SKULLY2, 90
	.halfword CHIP_SKULLY3, 90
	.halfword CHIP_YOYO, 90
	.halfword CHIP_GUARD1, 90
	.halfword CHIP_GUARD2, 90
	.halfword CHIP_GUARD3, 90
	.halfword CHIP_ELEMRAGE, 90
	.halfword CHIP_CRSSHLD1, 90
	.halfword CHIP_CRSSHLD2, 90
	.halfword CHIP_CRSSHLD3, 90
	.halfword 0
