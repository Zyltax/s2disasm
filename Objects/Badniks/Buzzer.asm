; ===========================================================================
; ----------------------------------------------------------------------------
; Object 4B - Buzzer (Buzz bomber) from EHZ
; ----------------------------------------------------------------------------
; OST Variables:
ObjBuzzer_parent		= objoff_2A	; long
ObjBuzzer_move_timer	= objoff_2E	; word
ObjBuzzer_turn_delay	= objoff_30	; word
ObjBuzzer_shooting_flag	= objoff_32	; byte
ObjBuzzer_shot_timer	= objoff_34	; word

; Sprite_2D068: ; Obj_Buzzer:
ObjBuzzer:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBuzzer_Index(pc,d0.w),d1
	jmp	ObjBuzzer_Index(pc,d1.w)
; ===========================================================================
; off_2D076:
ObjBuzzer_Index:	offsetTable
		offsetTableEntry.w ObjBuzzer_Init	; 0
		offsetTableEntry.w ObjBuzzer_Main	; 2
		offsetTableEntry.w ObjBuzzer_Flame	; 4
		offsetTableEntry.w ObjBuzzer_Projectile	; 6
; ===========================================================================
; loc_2D07E:
ObjBuzzer_Projectile:
	jsrto	JmpTo21_ObjectMove
	lea	(Ani_obj4B).l,a1
	jsrto	JmpTo15_AnimateSprite
	jmpto	JmpTo_MarkObjGone_P1
; ===========================================================================
; loc_2D090:
ObjBuzzer_Flame:
	movea.l	ObjBuzzer_parent(a0),a1 ; a1=object
    if fixBugs
	cmpi.b	#ObjID_Buzzer,id(a1)
	bne.w	JmpTo49_DeleteObject
    else
	; This check doesn't really work: it's possible for an object to be
	; loaded into the parent's slot before this object can check if the
	; slot is empty. In fact, it will always be immediately occupied by
	; the explosion object. This defect causes the flame to linger for a
	; while after the Buzzer is destroyed. A better way to do this check
	; would be to check if the ID is equal to 'ObjID_Buzzer'.
	tst.b	id(a1)
	beq.w	JmpTo49_DeleteObject	; branch, if object slot is empty. This check is incomplete and very unreliable; check ObjAquis_Wing to see how it should be done
    endif
	tst.w	ObjBuzzer_turn_delay(a1)
	bmi.s	+		; branch, if parent isn't currently turning around
	rts
; ---------------------------------------------------------------------------
+	; follow parent object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	lea	(Ani_obj4B).l,a1
	jsrto	JmpTo15_AnimateSprite
	jmpto	JmpTo_MarkObjGone_P1

    if removeJmpTos
JmpTo49_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; loc_2D0C8:
ObjBuzzer_Init:
	move.l	#ObjBuzzer_MapUnc_2D2EA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Buzzer,0,0),art_tile(a0)
	jsrto	JmpTo57_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$A,collision_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#$10,y_radius(a0)
	move.b	#$18,x_radius(a0)
	move.b	#3,priority(a0)
	addq.b	#2,routine(a0)	; => ObjBuzzer_Main

	; load exhaust flame object
	jsrto	JmpTo20_AllocateObjectAfterCurrent
	bne.s	+	; rts

	_move.b	#ObjID_Buzzer,id(a1) ; load obj4B
	move.b	#4,routine(a1)	; => ObjBuzzer_Flame
	move.l	#ObjBuzzer_MapUnc_2D2EA,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Buzzer,0,0),art_tile(a1)
	jsrto	JmpTo7_Adjust2PArtPointer2
	move.b	#4,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.b	status(a0),status(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	#1,anim(a1)
	move.l	a0,ObjBuzzer_parent(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#$100,ObjBuzzer_move_timer(a0)
	move.w	#-$100,x_vel(a0)
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+	; rts
	neg.w	x_vel(a0)
+
	rts
; ===========================================================================
; loc_2D174:
ObjBuzzer_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjBuzzer_Buzzer_States(pc,d0.w),d1
	jsr	ObjBuzzer_Buzzer_States(pc,d1.w)
	lea	(Ani_obj4B).l,a1
	jsrto	JmpTo15_AnimateSprite
	jmpto	JmpTo_MarkObjGone_P1
; ===========================================================================
; off_2D190:
ObjBuzzer_Buzzer_States:	offsetTable
		offsetTableEntry.w ObjBuzzer_Roaming	; 0
		offsetTableEntry.w ObjBuzzer_Shooting	; 2
; ===========================================================================
; loc_2D194:
ObjBuzzer_Roaming:
	bsr.w	ObjBuzzer_ChkPlayers
	subq.w	#1,ObjBuzzer_turn_delay(a0)
	move.w	ObjBuzzer_turn_delay(a0),d0
	cmpi.w	#$F,d0
	beq.s	ObjBuzzer_TurnAround
	tst.w	d0
	bpl.s	return_2D1B8
	subq.w	#1,ObjBuzzer_move_timer(a0)
	bgt.w	JmpTo21_ObjectMove
	move.w	#$1E,ObjBuzzer_turn_delay(a0)

return_2D1B8:
	rts
; ---------------------------------------------------------------------------
; loc_2D1BA:
ObjBuzzer_TurnAround:
	sf	ObjBuzzer_shooting_flag(a0)	; reenable shooting
	neg.w	x_vel(a0)		; reverse movement direction
	bchg	#render_flags.x_flip,render_flags(a0)
	bchg	#status.npc.x_flip,status(a0)
	move.w	#$100,ObjBuzzer_move_timer(a0)
	rts

    if removeJmpTos
; loc_2D38C:
JmpTo21_ObjectMove ; JmpTo
	jmp	(ObjectMove).l
    endif
; ===========================================================================
; Start of subroutine ObjBuzzer_ChkPlayers
; sub_2D1D6:
ObjBuzzer_ChkPlayers:
	tst.b	ObjBuzzer_shooting_flag(a0)
	bne.w	return_2D232	; branch, if shooting is disabled
	move.w	x_pos(a0),d0
	lea	(MainCharacter).w,a1 ; a1=character
	btst	#0,(Vint_runcount+3).w
	beq.s	+		; target Sidekick on uneven frames
	lea	(Sidekick).w,a1 ; a1=character
+
	sub.w	x_pos(a1),d0	; get object's distance to player
	move.w	d0,d1		; save value for later
	bpl.s	+		; branch, if it was positive
	neg.w	d0		; get absolute value
+
	; test if player is inside an 8 pixel wide strip
	cmpi.w	#$28,d0
	blt.s	return_2D232
	cmpi.w	#$30,d0
	bgt.s	return_2D232

	tst.w	d1			; test sign of distance
	bpl.s	ObjBuzzer_PlayerIsLeft	; branch, if player is left from object
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	return_2D232		; branch, if object is facing right
	bra.s	ObjBuzzer_ReadyToShoot
; ---------------------------------------------------------------------------
; loc_2D216:
ObjBuzzer_PlayerIsLeft:
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	return_2D232	; branch, if object is facing left

; loc_2D21E:
ObjBuzzer_ReadyToShoot:
	st.b	ObjBuzzer_shooting_flag(a0)		; disable shooting
	addq.b	#2,routine_secondary(a0)	; => ObjBuzzer_Shooting
	move.b	#3,anim(a0)		; play shooting animation
	move.w	#$32,ObjBuzzer_shot_timer(a0)

return_2D232:
	rts
; End of subroutine ObjBuzzer_ChkPlayers
; ===========================================================================
; loc_2D234:
ObjBuzzer_Shooting:
	move.w	ObjBuzzer_shot_timer(a0),d0	; get timer value
	subq.w	#1,d0			; decrement
	blt.s	ObjBuzzer_DoneShooting	; branch, if timer has expired
	move.w	d0,ObjBuzzer_shot_timer(a0)	; update timer value
	cmpi.w	#$14,d0			; has timer reached a certain value?
	beq.s	ObjBuzzer_ShootProjectile	; if yes, branch
	rts
; ---------------------------------------------------------------------------
; loc_2D248:
ObjBuzzer_DoneShooting:
	subq.b	#2,routine_secondary(a0)	; => ObjBuzzer_Roaming
	rts
; ---------------------------------------------------------------------------
; loc_2D24E
ObjBuzzer_ShootProjectile:
	jsr	(AllocateObjectAfterCurrent).l	; Find next open object space
	bne.s	+

	_move.b	#ObjID_Buzzer,id(a1) ; load obj4B
	move.b	#6,routine(a1)	; => ObjBuzzer_Projectile
	move.l	#ObjBuzzer_MapUnc_2D2EA,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Buzzer,0,0),art_tile(a1)
	jsrto	JmpTo7_Adjust2PArtPointer2
	move.b	#4,priority(a1)
	move.b	#$98,collision_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	status(a0),status(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	#2,anim(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$18,y_pos(a1)	; align vertically with stinger
	move.w	#$D,d0		; absolute horizontal offset for stinger
	move.w	#$180,y_vel(a1)
	move.w	#-$180,x_vel(a1)
	btst	#render_flags.x_flip,render_flags(a1)	; is object facing left?
	beq.s	+			; if not, branch
	neg.w	x_vel(a1)	; move in other direction
	neg.w	d0		; make offset negative
+
	add.w	d0,x_pos(a1)	; align horizontally with stinger
	rts
; ===========================================================================
; animation script
; off_2D2CE:
Ani_obj4B:	offsetTable
		offsetTableEntry.w byte_2D2D6	; 0
		offsetTableEntry.w byte_2D2D9	; 1
		offsetTableEntry.w byte_2D2DD	; 2
		offsetTableEntry.w byte_2D2E1	; 3
byte_2D2D6:	dc.b	$0F, $00, $FF
	rev02even
byte_2D2D9:	dc.b	$02, $03, $04, $FF
	rev02even
byte_2D2DD:	dc.b	$03, $05, $06, $FF
	rev02even
byte_2D2E1:	dc.b	$09, $01, $01, $01, $01, $01, $FD, $00
	even
; ----------------------------------------------------------------------------
; sprite mappings -- Buzz Bomber Sprite Table
; ----------------------------------------------------------------------------
; MapUnc_2D2EA: SprTbl_Buzzer:
ObjBuzzer_MapUnc_2D2EA:	include "mappings/sprite/obj4B.asm"
; ===========================================================================

