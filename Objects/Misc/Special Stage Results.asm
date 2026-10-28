; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6F - End of special stage results screen
; ----------------------------------------------------------------------------
; Sprite_143C0:
ObjSSResults: ; (note: screen-space obj)
	moveq	#0,d0
	moveq	#0,d6
	move.b	routine(a0),d0
	move.w	ObjSSResults_Index(pc,d0.w),d1
	jmp	ObjSSResults_Index(pc,d1.w)
; ===========================================================================
; off_143D0:
ObjSSResults_Index:	offsetTable
		offsetTableEntry.w ObjSSResults_Init	;   0
		offsetTableEntry.w ObjSSResults_InitEmeraldText	;   2
		offsetTableEntry.w ObjSSResults_InitResultTitle	;   4
		offsetTableEntry.w ObjSSResults_Emerald0	;   6
		offsetTableEntry.w ObjSSResults_Emerald1	;   8
		offsetTableEntry.w ObjSSResults_Emerald2	;  $A
		offsetTableEntry.w ObjSSResults_Emerald3	;  $C
		offsetTableEntry.w ObjSSResults_Emerald4	;  $E
		offsetTableEntry.w ObjSSResults_Emerald5	; $10
		offsetTableEntry.w ObjSSResults_Emerald6	; $12
		offsetTableEntry.w BranchTo3_ObjTitleCard_MoveTowardsTargetPosition	; $14
		offsetTableEntry.w ObjSSResults_P1Rings	; $16
		offsetTableEntry.w ObjSSResults_P2Rings	; $18
		offsetTableEntry.w ObjSSResults_DeleteIfNotEmerald	; $1A
		offsetTableEntry.w ObjSSResults_TimedDisplay	; $1C
		offsetTableEntry.w ObjSSResults_TallyScore	; $1E
		offsetTableEntry.w ObjSSResults_TimedDisplay	; $20
		offsetTableEntry.w ObjSSResults_DisplayOnly	; $22
		offsetTableEntry.w ObjSSResults_TimedDisplay	; $24
		offsetTableEntry.w ObjSSResults_TimedDisplay	; $26
		offsetTableEntry.w ObjSSResults_TallyPerfect	; $28
		offsetTableEntry.w ObjSSResults_PerfectBonus	; $2A
		offsetTableEntry.w ObjSSResults_TimedDisplay	; $2C
		offsetTableEntry.w ObjSSResults_DisplayOnly	; $2E
		offsetTableEntry.w ObjSSResults_InitAndMoveSuperMsg	; $30
		offsetTableEntry.w ObjSSResults_MoveTowardsSourcePosition	; $32
		offsetTableEntry.w ObjSSResults_MoveAndDisplay	; $34
; ===========================================================================
;loc_14406
ObjSSResults_Init:
	tst.l	(Plc_Buffer).w
	beq.s	+
	rts
; ===========================================================================
+
	movea.l	a0,a1
	lea	ObjSSResults_SubObjectMetaData(pc),a2
	moveq	#bytesToXcnt(ObjSSResults_SubObjectMetaData_End-ObjSSResults_SubObjectMetaData, results_screen_object_size),d1

-	_move.b	id(a0),id(a1) ; load obj6F
	move.w	(a2),x_pixel(a1)
	move.w	(a2)+,titlecard_x_source(a1)
	move.w	(a2)+,titlecard_x_target(a1)
	move.w	(a2)+,y_pixel(a1)
	move.b	(a2)+,routine(a1)
	move.b	(a2)+,mapping_frame(a1)
	move.l	#Map_obj6F,mappings(a1)
	move.b	#$78,width_pixels(a1)
	move.b	#0,render_flags(a1)
	lea	next_object(a1),a1 ; go to next object ; a1=object
	dbf	d1,- ; loop

;loc_14450
ObjSSResults_InitEmeraldText:
	tst.b	(Got_Emerald).w
	beq.s	+
	move.b	#4,mapping_frame(a0)		; "Chaos Emerald"
+
	cmpi.b	#7,(Emerald_count).w
	bne.s	+
	move.b	#$19,mapping_frame(a0)		; "Chaos Emeralds"
+
	move.w	titlecard_x_target(a0),d0
	cmp.w	x_pixel(a0),d0
	bne.s	BranchTo2_ObjTitleCard_MoveTowardsTargetPosition
	move.b	#$1C,routine(a0)	; => ObjSSResults_TimedDisplay
	move.w	#$B4,anim_frame_duration(a0)

BranchTo2_ObjTitleCard_MoveTowardsTargetPosition ; BranchTo
	bra.w	ObjTitleCard_MoveTowardsTargetPosition
; ===========================================================================
;loc_14484
ObjSSResults_InitResultTitle:
	cmpi.b	#7,(Emerald_count).w
	bne.s	+
	moveq	#$16,d0		; "Sonic has all the"
	bra.s	++
; ===========================================================================
+
	tst.b	(Got_Emerald).w
	beq.w	DeleteObject
	moveq	#1,d0		; "Sonic got a"
+
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	addq.w	#1,d0		; "Miles got a" or "Miles has all the"
	btst	#7,(Graphics_Flags).w
	beq.s	+
	addq.w	#1,d0		; "Tails got a" or "Tails has all the"
+
	move.b	d0,mapping_frame(a0)
	bra.w	ObjTitleCard_MoveTowardsTargetPosition
; ===========================================================================
;loc_144B6
ObjSSResults_Emerald6:
	addq.w	#1,d6
;loc_144B8
ObjSSResults_Emerald5:
	addq.w	#1,d6
;loc_144BA
ObjSSResults_Emerald4:
	addq.w	#1,d6
;loc_144BC
ObjSSResults_Emerald3:
	addq.w	#1,d6
;loc_144BE
ObjSSResults_Emerald2:
	addq.w	#1,d6
;loc_144C0
ObjSSResults_Emerald1:
	addq.w	#1,d6
;loc_144C2
ObjSSResults_Emerald0:
	lea	(Got_Emeralds_array).w,a1
	tst.b	(a1,d6.w)
	beq.w	DeleteObject
	btst	#0,(Vint_runcount+3).w
	beq.s	+
	bsr.w	DisplaySprite
+
	rts
; ===========================================================================
;loc_144DC
ObjSSResults_P2Rings:
	tst.w	(Player_mode).w
	bne.w	DeleteObject
	cmpi.b	#$26,(SpecialStageResults+routine).w	; Do we need space for perfect countdown?
	beq.w	DeleteObject							; Branch if yes
	moveq	#$E,d0		; "Miles rings"
	btst	#7,(Graphics_Flags).w
	beq.s	+
	addq.w	#1,d0		; "Tails rings"
+
	lea	(Bonus_Countdown_2).w,a1
	bra.s	loc_1455A
; ===========================================================================
;loc_14500
ObjSSResults_P1Rings:
	cmpi.b	#$26,(SpecialStageResults+routine).w	; Do we need space for perfect countdown?
	bne.s	+										; Branch if not
	move.w	#5000,(Bonus_Countdown_1).w				; Perfect bonus
	move.b	#$2A,routine(a0)	; => ObjSSResults_PerfectBonus
	move.w	#spriteScreenPositionYCentered(48),y_pixel(a0)
	st.b	(Update_Bonus_score).w	; set to -1 (update)
	move.w	#SndID_Signpost,d0
	jsr	(PlaySound).l
	move.w	#$5A,(SpecialStageResults+anim_frame_duration).w
	bra.w	ObjSSResults_PerfectBonus
; ===========================================================================
+
	move.w	(Player_mode).w,d0
	beq.s	++
	move.w	#spriteScreenPositionYCentered(48),y_pixel(a0)
	subq.w	#1,d0
	beq.s	++
	moveq	#$E,d0		; "Miles rings"
	btst	#7,(Graphics_Flags).w
	beq.s	+
	addq.w	#1,d0		; "Tails rings"
+
	lea	(Bonus_Countdown_2).w,a1
	bra.s	loc_1455A
; ===========================================================================
+
	moveq	#$D,d0		; "Sonic rings"
	lea	(Bonus_Countdown_1).w,a1

loc_1455A:
	tst.w	(a1)
	bne.s	+
	addq.w	#5,d0		; Rings text with zero points
+
	move.b	d0,mapping_frame(a0)

BranchTo3_ObjTitleCard_MoveTowardsTargetPosition ; BranchTo
	bra.w	ObjTitleCard_MoveTowardsTargetPosition
; ===========================================================================
;loc_14568
ObjSSResults_DeleteIfNotEmerald:
	tst.b	(Got_Emerald).w
	beq.w	DeleteObject
	bra.s	BranchTo3_ObjTitleCard_MoveTowardsTargetPosition
; ===========================================================================
;loc_14572
ObjSSResults_TimedDisplay:
	subq.w	#1,anim_frame_duration(a0)
	bne.s	BranchTo19_DisplaySprite
	addq.b	#2,routine(a0)

BranchTo19_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
;loc_14580
ObjSSResults_TallyScore:
	bsr.w	DisplaySprite
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	tst.w	(Bonus_Countdown_1).w
	beq.s	+
	addi.w	#10,d0
	subq.w	#1,(Bonus_Countdown_1).w
+
	tst.w	(Bonus_Countdown_2).w
	beq.s	+
	addi.w	#10,d0
	subq.w	#1,(Bonus_Countdown_2).w
+
	tst.w	(Total_Bonus_Countdown).w
	beq.s	+
	addi.w	#10,d0
	subi.w	#10,(Total_Bonus_Countdown).w
+
	tst.w	d0
	bne.s	+++
	move.w	#SndID_TallyEnd,d0
	jsr	(PlaySound).l
	addq.b	#2,routine(a0)		; => ObjSSResults_TimedDisplay
	move.w	#$78,anim_frame_duration(a0)
	tst.w	(Perfect_rings_flag).w
	bne.s	+
	cmpi.w	#2,(Player_mode).w
	beq.s	++		; rts
	tst.b	(Got_Emerald).w
	beq.s	++		; rts
	cmpi.b	#7,(Emerald_count).w
	bne.s	++		; rts
	move.b	#$30,routine(a0)	; => ObjSSResults_InitAndMoveSuperMsg
	rts
; ===========================================================================
+
	move.b	#$24,routine(a0)	; => ObjSSResults_TimedDisplay
	move.w	#$5A,anim_frame_duration(a0)
/
	rts
; ===========================================================================
+
	jsr	(AddPoints).l
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	-		; rts
	move.w	#SndID_Blip,d0
	jmp	(PlaySound).l
; ===========================================================================
;loc_1461C
ObjSSResults_DisplayOnly:
	move.w	#1,(Level_Inactive_flag).w
	bra.w	DisplaySprite
; ===========================================================================
;loc_14626
ObjSSResults_TallyPerfect:
	bsr.w	DisplaySprite
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	tst.w	(Bonus_Countdown_1).w
	beq.s	+
	addi.w	#20,d0
	subi.w	#20,(Bonus_Countdown_1).w
+
	tst.w	d0
	beq.s	+
	jsr	(AddPoints).l
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	++		; rts
	move.w	#SndID_Blip,d0
	jmp	(PlaySound).l
; ===========================================================================
+
	move.w	#SndID_TallyEnd,d0
	jsr	(PlaySound).l
	addq.b	#4,routine(a0)
	move.w	#$78,anim_frame_duration(a0)
	cmpi.w	#2,(Player_mode).w
	beq.s	+		; rts
	tst.b	(Got_Emerald).w
	beq.s	+		; rts
	cmpi.b	#7,(Emerald_count).w
	bne.s	+		; rts
	move.b	#$30,routine(a0)	; => ObjSSResults_InitAndMoveSuperMsg
+
	rts
; ===========================================================================
;loc_14692
ObjSSResults_PerfectBonus:
	moveq	#$11,d0		; "Perfect bonus"
	btst	#3,(Vint_runcount+3).w
	beq.s	+
	moveq	#$15,d0		; null text
+
	move.b	d0,mapping_frame(a0)
	bra.w	DisplaySprite
; ===========================================================================
;loc_146A6
ObjSSResults_InitAndMoveSuperMsg:
	move.b	#$32,next_object+routine(a0)			; => ObjSSResults_MoveTowardsSourcePosition
	move.w	x_pixel(a0),d0
	cmp.w	titlecard_x_source(a0),d0
	bne.s	ObjSSResults_MoveTowardsSourcePosition
	move.b	#$14,next_object+routine(a0)			; => BranchTo3_ObjTitleCard_MoveTowardsTargetPosition
	subq.w	#8,next_object+y_pixel(a0)
	move.b	#$1A,next_object+mapping_frame(a0)		; "Now Sonic can"
	move.b	#$34,routine(a0)						; => ObjSSResults_MoveAndDisplay
	subq.w	#8,y_pixel(a0)
	move.b	#$1B,mapping_frame(a0)					; "Change into"
	lea	(SpecialStageResults2).w,a1
	_move.b	id(a0),id(a1) ; load obj6F; (uses screen-space)
	clr.w	x_pixel(a1)
	move.w	#spriteScreenPositionXCentered(0),titlecard_x_target(a1)
	move.w	#spriteScreenPositionYCentered(-60),y_pixel(a1)
	move.b	#$14,routine(a1)						; => BranchTo3_ObjTitleCard_MoveTowardsTargetPosition
	move.b	#$1C,mapping_frame(a1)					; "Super Sonic"
	move.l	#Map_obj6F,mappings(a1)
	move.b	#$78,width_pixels(a1)
	move.b	#0,render_flags(a1)
	bra.w	DisplaySprite
; ===========================================================================
; Modified copy of `ObjTitleCard_MoveTowardsTargetPosition`. It has a higher speed
; and moves the object toward its source instead of its destination.
;loc_14714 ObjSSResults_MoveToTargetPos
ObjSSResults_MoveTowardsSourcePosition:
	moveq	#$20,d0 ; Movement speed
	move.w	x_pixel(a0),d1
	cmp.w	titlecard_x_source(a0),d1
	beq.s	.display
	bhi.s	+
	neg.w	d0
+
	sub.w	d0,x_pixel(a0)
	; If target lies very far off-screen, then don't bother trying to display it.
	; This is because the sprite coordinates are prone to overflow and underflow.
	cmpi.w	#$200,x_pixel(a0)
	bhi.s	.return
;BranchTo20_DisplaySprite
.display:
	bra.w	DisplaySprite
.return:
	rts
; ===========================================================================
;loc_14736
ObjSSResults_MoveAndDisplay:
	move.w	x_pixel(a0),d0
	cmp.w	titlecard_x_target(a0),d0
	bne.w	ObjTitleCard_MoveTowardsTargetPosition
	move.w	#$B4,anim_frame_duration(a0)
	move.b	#$20,routine(a0)	; => ObjSSResults_TimedDisplay
    if removeJmpTos
	jmp	(DisplaySprite).l
    else
	bra.w	DisplaySprite
    endif
; ===========================================================================
;byte_14752
ObjSSResults_SubObjectMetaData:
	;                                start X,          target X, start Y, routine, map frame
	results_screen_object  spriteScreenPositionX(screen_width+128), spriteScreenPositionXCentered(0),     -70,       2,         0		; "Special Stage"
	results_screen_object                                        0, spriteScreenPositionXCentered(0),     -88,       4,         1		; "Sonic got a"
	results_screen_object  spriteScreenPositionXCentered( -8),                                     0,     -44,       6,         5		; Emerald 0
	results_screen_object  spriteScreenPositionXCentered( 16),                                     0,     -32,       8,         6		; Emerald 1
	results_screen_object  spriteScreenPositionXCentered( 16),                                     0,      -8,      $A,         7		; Emerald 2
	results_screen_object  spriteScreenPositionXCentered( -8),                                     0,       4,      $C,         8		; Emerald 3
	results_screen_object  spriteScreenPositionXCentered(-32),                                     0,      -8,      $E,         9		; Emerald 4
	results_screen_object  spriteScreenPositionXCentered(-32),                                     0,     -32,     $10,        $A		; Emerald 5
	results_screen_object  spriteScreenPositionXCentered( -8),                                     0,     -20,     $12,        $B		; Emerald 6
	results_screen_object  spriteScreenPositionX(screen_width+368), spriteScreenPositionXCentered(0),      24,     $14,        $C		; Score
	results_screen_object  spriteScreenPositionX(screen_width+384), spriteScreenPositionXCentered(0),      40,     $16,        $D		; Sonic Rings
	results_screen_object  spriteScreenPositionX(screen_width+400), spriteScreenPositionXCentered(0),      56,     $18,        $E		; Miles Rings
	results_screen_object  spriteScreenPositionX(screen_width+416), spriteScreenPositionXCentered(0),      72,     $1A,       $10		; Gems Bonus
ObjSSResults_SubObjectMetaData_End:

