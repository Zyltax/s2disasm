; ===========================================================================
; ---------------------------------------------------------------------------
; Object 4A - Octus (octopus badnik) from OOZ
; ---------------------------------------------------------------------------
; OST Variables:
octus_start_position = objoff_2A

; Sprite_2CA14:
ObjOctus:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjOctus_Index(pc,d0.w),d1
	jmp	ObjOctus_Index(pc,d1.w)
; ===========================================================================
; off_2CA22:
ObjOctus_Index:	offsetTable
		offsetTableEntry.w ObjOctus_Init	; 0
		offsetTableEntry.w ObjOctus_Main	; 2
		offsetTableEntry.w ObjOctus_Angry	; 4 - unused
		offsetTableEntry.w ObjOctus_Bullet	; 6
; ===========================================================================
; loc_2CA2A:
ObjOctus_Bullet:
	subi_.w	#1,objoff_2C(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	jsrto	JmpTo19_ObjectMove
	lea	(Ani_obj4A).l,a1
	jsrto	JmpTo13_AnimateSprite
	jmpto	JmpTo32_MarkObjGone
; ===========================================================================
; loc_2CA46:
ObjOctus_Angry:	; Used by removed sub-object
	subq.w	#1,objoff_2C(a0)
	beq.w	JmpTo47_DeleteObject
	jmpto	JmpTo31_DisplaySprite

    if removeJmpTos
JmpTo47_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; loc_2CA52:
ObjOctus_Init:
	move.l	#ObjOctus_MapUnc_2CBFE,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Octus,1,0),art_tile(a0)
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$A,collision_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#$B,y_radius(a0)
	move.b	#8,x_radius(a0)
	jsrto	JmpTo2_ObjectMoveAndFall
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	#0,y_vel(a0)
	addq.b	#2,routine(a0)
	move.w	x_pos(a0),d0
	sub.w	(MainCharacter+x_pos).w,d0
	bpl.s	+
	bchg	#status.npc.x_flip,status(a0)
+
	move.w	y_pos(a0),octus_start_position(a0)
	rts
; ===========================================================================
; loc_2CAB8:
ObjOctus_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjOctus_Main_Index(pc,d0.w),d1
	jsr	ObjOctus_Main_Index(pc,d1.w)
	lea	(Ani_obj4A).l,a1
	jsrto	JmpTo13_AnimateSprite
	jmpto	JmpTo32_MarkObjGone
; ===========================================================================
; off_2CAD4:
ObjOctus_Main_Index: offsetTable
	offsetTableEntry.w ObjOctus_WaitForCharacter	; 0
	offsetTableEntry.w ObjOctus_DelayBeforeMoveUp	; 2
	offsetTableEntry.w ObjOctus_MoveUp			; 4
	offsetTableEntry.w ObjOctus_Hover			; 6
	offsetTableEntry.w ObjOctus_MoveDown		; 8
; ===========================================================================
; loc_2CADE:
ObjOctus_WaitForCharacter:
	move.w	x_pos(a0),d0
	sub.w	(MainCharacter+x_pos).w,d0
	cmpi.w	#$80,d0
	bgt.s	+	; rts
	cmpi.w	#-$80,d0
	blt.s	+	; rts
	addq.b	#2,routine_secondary(a0)
	move.b	#3,anim(a0)
	move.w	#$20,objoff_2C(a0)
+
	rts
; ===========================================================================
; loc_2CB04:
ObjOctus_DelayBeforeMoveUp:
	subq.w	#1,objoff_2C(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.b	#4,anim(a0)
	move.w	#-$200,y_vel(a0)
	jmpto	JmpTo19_ObjectMove
; ===========================================================================
; loc_2CB20:
ObjOctus_MoveUp:
	addi.w	#$10,y_vel(a0)
	bpl.s	+
	jmpto	JmpTo19_ObjectMove
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#60,objoff_2C(a0)
	bra.w	ObjOctus_FireBullet
; ===========================================================================
; loc_2CB3A:
ObjOctus_Hover:
	subq.w	#1,objoff_2C(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================
; loc_2CB48:
ObjOctus_MoveDown:
	addi.w	#$10,y_vel(a0)
	move.w	y_pos(a0),d0
	cmp.w	octus_start_position(a0),d0
	bhs.s	+
	jmpto	JmpTo19_ObjectMove
; ===========================================================================
+
	clr.b	routine_secondary(a0)
	clr.b	anim(a0)
	clr.w	y_vel(a0)
	move.b	#1,mapping_frame(a0)
	rts
; ===========================================================================
; loc_2CB70:
ObjOctus_FireBullet:
	; In the Simon Wai beta, the object loads another object
	; here, which makes it look angry as it fires.
	; This object would have used ObjOctus_Angry.
	jsr	(AllocateObject).l
	bne.s	+	; rts
	_move.b	#ObjID_Octus,id(a1) ; load obj4A
	move.b	#6,routine(a1)
	move.l	#ObjOctus_MapUnc_2CBFE,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Octus,1,0),art_tile(a1)
	move.b	#4,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#$F,objoff_2C(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	status(a0),status(a1)
	move.b	#2,anim(a1)
	move.b	#$98,collision_flags(a1)
	move.w	#-$200,x_vel(a1)
	btst	#render_flags.x_flip,render_flags(a1)
	beq.s	+	; rts
	neg.w	x_vel(a1)
+
	rts
; ===========================================================================
; animation script
; off_2CBDC:
Ani_obj4A:	offsetTable
		offsetTableEntry.w byte_2CBE6	; 0
		offsetTableEntry.w byte_2CBEA	; 1
		offsetTableEntry.w byte_2CBEF	; 2
		offsetTableEntry.w byte_2CBF4	; 3
		offsetTableEntry.w byte_2CBF8	; 4
byte_2CBE6:	dc.b  $F,  1,  0,$FF
	rev02even
byte_2CBEA:	dc.b   3,  1,  2,  3,$FF
	rev02even
byte_2CBEF:	dc.b   2,  5,  6,$FF
	even
byte_2CBF4:	dc.b  $F,  4,$FF
	even
byte_2CBF8:	dc.b   7,  0,  1,$FD,  1
	even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjOctus_MapUnc_2CBFE:	include "mappings/sprite/obj4A.asm"
; ===========================================================================

