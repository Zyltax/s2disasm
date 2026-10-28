; ===========================================================================
; ---------------------------------------------------------------------------
; Object 2F - Smashable ground in Hill Top Zone
; ---------------------------------------------------------------------------
; Sprite_23300:
ObjSmashableGround:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjSmashableGround_Index(pc,d0.w),d1
	jmp	ObjSmashableGround_Index(pc,d1.w)
; ===========================================================================
; off_2330E:
ObjSmashableGround_Index:	offsetTable
		offsetTableEntry.w ObjSmashableGround_Init		; 0
		offsetTableEntry.w ObjSmashableGround_Main		; 2
		offsetTableEntry.w ObjSmashableGround_Fragment	; 4
; ===========================================================================
; byte_23314:
ObjSmashableGround_Properties:
	;    y_radius
	;	  mapping_frame
	dc.b $24, 0	; 0
	dc.b $20, 2	; 2
	dc.b $18, 4	; 4
	dc.b $10, 6	; 6
	dc.b   8, 8	; 8
; ===========================================================================
; loc_2331E:
ObjSmashableGround_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjSmashableGround_MapUnc_236FA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,1),art_tile(a0)
	jsrto	JmpTo18_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$1E,d0
	lea	ObjSmashableGround_Properties(pc,d0.w),a2
	move.b	(a2)+,y_radius(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.b	#$20,y_radius(a0)
	bset	#render_flags.explicit_height,render_flags(a0)
; loc_23368:
ObjSmashableGround_Main:
	move.w	(Chain_Bonus_counter).w,objoff_38(a0)
	move.b	(MainCharacter+anim).w,objoff_32(a0)
	move.b	(Sidekick+anim).w,objoff_33(a0)
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo3_SolidObject
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+

BranchTo_JmpTo9_MarkObjGone ; BranchTo
	jmpto	JmpTo9_MarkObjGone
; ===========================================================================
+
	cmpi.b	#standing_mask,d0
	bne.s	loc_23408
	cmpi.b	#AniIDSonAni_Roll,objoff_32(a0)
	bne.s	loc_233C0
	tst.b	subtype(a0)
	bmi.s	loc_233F0
	cmpi.b	#$E,(MainCharacter+top_solid_bit).w
	beq.s	loc_233F0

loc_233C0:
	move.b	#$C,(MainCharacter+top_solid_bit).w
	move.b	#$D,(MainCharacter+lrb_solid_bit).w
	cmpi.b	#AniIDSonAni_Roll,objoff_33(a0)
	bne.s	loc_233E2
	tst.b	subtype(a0)
	bmi.s	loc_233F0
	cmpi.b	#$E,(Sidekick+top_solid_bit).w
	beq.s	loc_233F0

loc_233E2:
	move.b	#$C,(Sidekick+top_solid_bit).w
	move.b	#$D,(Sidekick+lrb_solid_bit).w
	bra.s	BranchTo_JmpTo9_MarkObjGone
; ===========================================================================

loc_233F0:
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	objoff_32(a0),d0
	bsr.s	loc_2343E
	lea	(Sidekick).w,a1 ; a1=character
	move.b	objoff_33(a0),d0
	bsr.s	loc_2343E
	bra.w	loc_234A4
; ===========================================================================

loc_23408:
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	loc_23470
	cmpi.b	#AniIDSonAni_Roll,objoff_32(a0)
	bne.s	loc_23426
	tst.b	subtype(a0)
	bmi.s	loc_23436
	cmpi.b	#$E,(MainCharacter+top_solid_bit).w
	beq.s	loc_23436

loc_23426:
	move.b	#$C,(MainCharacter+top_solid_bit).w
	move.b	#$D,(MainCharacter+lrb_solid_bit).w
	bra.w	BranchTo_JmpTo9_MarkObjGone
; ===========================================================================

loc_23436:
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_23444
	bra.s	loc_234A4
; ===========================================================================

loc_2343E:
	cmpi.b	#AniIDSonAni_Roll,d0
	bne.s	loc_2345C

loc_23444:
	bset	#status.player.rolling,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)

loc_2345C:
	bset	#status.player.in_air,status(a1)
	bclr	#status.player.on_object,status(a1)
	move.b	#2,routine(a1)
	rts
; ===========================================================================

loc_23470:
	andi.b	#p2_standing,d0
	beq.w	BranchTo_JmpTo9_MarkObjGone
	cmpi.b	#AniIDSonAni_Roll,objoff_33(a0)
	bne.s	loc_2348E
	tst.b	subtype(a0)
	bmi.s	loc_2349E
	cmpi.b	#$E,(Sidekick+top_solid_bit).w
	beq.s	loc_2349E

loc_2348E:
	move.b	#$C,(Sidekick+top_solid_bit).w
	move.b	#$D,(Sidekick+lrb_solid_bit).w
	bra.w	BranchTo_JmpTo9_MarkObjGone
; ===========================================================================

loc_2349E:
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_23444

loc_234A4:
	move.w	objoff_38(a0),(Chain_Bonus_counter).w
	andi.b	#~standing_mask,status(a0)
	lea	(ObjSmashableGround_FragmentVelocities).l,a4
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	addq.b	#1,mapping_frame(a0)
	move.l	d0,d1
	add.w	d0,d0
	add.w	d0,d0
	lea	(a4,d0.w),a4
	neg.w	d1
	addi.w	#9,d1
	move.w	#$18,d2
	jsrto	JmpTo_BreakObjectToPieces
	bsr.w	SmashableObject_LoadPoints
; loc_234DC:
ObjSmashableGround_Fragment:
	jsrto	JmpTo8_ObjectMove
	addi.w	#$18,y_vel(a0)
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	JmpTo22_DeleteObject
	jmpto	JmpTo12_DisplaySprite
; ===========================================================================
; byte_234F2:
ObjSmashableGround_FragmentVelocities:
	;    x_vel, y_vel
	dc.w -$100,-$800
	dc.w  $100,-$800
	dc.w  -$E0,-$700
	dc.w   $E0,-$700
	dc.w  -$C0,-$600
	dc.w   $C0,-$600
	dc.w  -$A0,-$500
	dc.w   $A0,-$500
	dc.w  -$80,-$400
	dc.w   $80,-$400
