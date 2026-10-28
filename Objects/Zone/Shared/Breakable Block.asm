; ===========================================================================
; ---------------------------------------------------------------------------
; Object 32 - Breakable block/rock from CPZ and HTZ
; ---------------------------------------------------------------------------
; OST Variables:
breakableblock_mainchar_anim =	objoff_32
breakableblock_sidekick_anim =	objoff_33

; Sprite_2351A:
ObjBreakableRock:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBreakableRock_Index(pc,d0.w),d1
	jmp	ObjBreakableRock_Index(pc,d1.w)
; ===========================================================================
; off_23528:
ObjBreakableRock_Index:	offsetTable
		offsetTableEntry.w ObjBreakableRock_Init		; 0
		offsetTableEntry.w ObjBreakableRock_Main		; 2
		offsetTableEntry.w ObjBreakableRock_Fragment	; 4
; ===========================================================================
; loc_2352E:
ObjBreakableRock_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjBreakableRock_MapUnc_23852,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HtzRock,2,0),art_tile(a0)
	move.b	#$18,width_pixels(a0)
	move.l	#ObjBreakableRock_VelArray1,objoff_3C(a0)
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	bne.s	+
	move.l	#ObjBreakableRock_MapUnc_23886,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZMetalBlock,3,0),art_tile(a0)
	move.b	#$10,width_pixels(a0)
	move.l	#ObjBreakableRock_VelArray2,objoff_3C(a0)
+
	jsrto	JmpTo18_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#4,priority(a0)
; loc_23582:
ObjBreakableRock_Main:
	move.w	(Chain_Bonus_counter).w,objoff_38(a0)
	move.b	(MainCharacter+anim).w,breakableblock_mainchar_anim(a0)
	move.b	(Sidekick+anim).w,breakableblock_sidekick_anim(a0)
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo3_SolidObject
	move.b	status(a0),d0
	andi.b	#standing_mask,d0	; is at least one player standing on the object?
	bne.s	ObjBreakableRock_SupportingSomeone

BranchTo2_JmpTo9_MarkObjGone ; BranchTo
	jmpto	JmpTo9_MarkObjGone
; ===========================================================================
; loc_235BC:
ObjBreakableRock_SupportingSomeone:
	cmpi.b	#standing_mask,d0	; are BOTH players standing on the object?
	bne.s	ObjBreakableRock_SupportingOnePlayerOnly	; if not, branch
	cmpi.b	#AniIDSonAni_Roll,breakableblock_mainchar_anim(a0)
	beq.s	+
	cmpi.b	#AniIDSonAni_Roll,breakableblock_sidekick_anim(a0)
	bne.s	BranchTo2_JmpTo9_MarkObjGone
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	breakableblock_mainchar_anim(a0),d0
	bsr.s	ObjBreakableRock_SetCharacterOffBlock
	lea	(Sidekick).w,a1 ; a1=character
	move.b	breakableblock_sidekick_anim(a0),d0
	bsr.s	ObjBreakableRock_SetCharacterOffBlock
	bra.w	ObjBreakableRock_Destroy
; ===========================================================================
; loc_235EA:
ObjBreakableRock_SupportingOnePlayerOnly:
	move.b	d0,d1
	andi.b	#p1_standing,d1			 ; is the main character standing on the object?
	beq.s	ObjBreakableRock_SupportingSidekick ; if not, branch
	cmpi.b	#AniIDSonAni_Roll,breakableblock_mainchar_anim(a0)
	bne.s	BranchTo2_JmpTo9_MarkObjGone
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	ObjBreakableRock_BouncePlayer
	bra.s	ObjBreakableRock_Destroy
; ===========================================================================
; loc_23602:
ObjBreakableRock_SetCharacterOffBlock:
	cmpi.b	#AniIDSonAni_Roll,d0
	bne.s	+
; loc_23608:
ObjBreakableRock_BouncePlayer:
	bset	#status.player.rolling,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.w	#-$300,y_vel(a1)
+
	bset	#status.player.in_air,status(a1)
	bclr	#status.player.on_object,status(a1)
	move.b	#2,routine(a1)
	rts
; ===========================================================================
; loc_2363A:
ObjBreakableRock_SupportingSidekick:
	andi.b	#p2_standing,d0	; is the sidekick standing on the object? (at this point, it should...)
	beq.w	BranchTo2_JmpTo9_MarkObjGone ; if, by miracle, he's not, branch
	cmpi.b	#2,breakableblock_sidekick_anim(a0)
	bne.w	BranchTo2_JmpTo9_MarkObjGone
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	ObjBreakableRock_BouncePlayer
; loc_23652:
ObjBreakableRock_Destroy:
	move.w	objoff_38(a0),(Chain_Bonus_counter).w
	andi.b	#~standing_mask,status(a0)
	movea.l	objoff_3C(a0),a4
	jsrto	JmpTo_BreakObjectToPieces
	bsr.w	SmashableObject_LoadPoints
; loc_2366A:
ObjBreakableRock_Fragment:
	jsrto	JmpTo8_ObjectMove
	addi.w	#$18,y_vel(a0)
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	JmpTo22_DeleteObject
	jmpto	JmpTo12_DisplaySprite

    if removeJmpTos
JmpTo22_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; velocity array for smashed bits, two words for each fragment
; byte_23680:
ObjBreakableRock_VelArray1:
	;    x_vel y_vel
	dc.w -$200,-$200
	dc.w     0,-$280
	dc.w  $200,-$200
	dc.w -$1C0,-$1C0
	dc.w     0,-$200
	dc.w  $1C0,-$1C0
;byte_23698:
ObjBreakableRock_VelArray2:
	;    x_vel y_vel
	dc.w -$100,-$200
	dc.w  $100,-$200
	dc.w  -$C0,-$1C0
	dc.w   $C0,-$1C0

; ===========================================================================
; loc_236A8:
SmashableObject_LoadPoints:
	jsrto	JmpTo3_AllocateObject
	bne.s	+++	; rts
	_move.b	#ObjID_Points,id(a1) ; load obj29
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	(Chain_Bonus_counter).w,d2
	addq.w	#2,(Chain_Bonus_counter).w
	cmpi.w	#6,d2
	blo.s	+
	moveq	#6,d2
+
	moveq	#0,d0
	move.w	SmashableObject_ScoreBonus(pc,d2.w),d0
	cmpi.w	#$20,(Chain_Bonus_counter).w
	blo.s	+
	move.w	#1000,d0
	moveq	#$A,d2
+
	jsr	(AddPoints).l
	lsr.w	#1,d2
	move.b	d2,mapping_frame(a1)
+
	rts
; ===========================================================================
; word_236F2:
SmashableObject_ScoreBonus:
	dc.w	10
	dc.w	20	; 1
	dc.w	50	; 2
	dc.w   100	; 3
