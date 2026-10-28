; ===========================================================================
; ---------------------------------------------------------------------------
; Object 7A - Platform that moves back and forth on top of water in CPZ
; ---------------------------------------------------------------------------
; Sprite_293A0:
ObjSidewaysPform:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjSidewaysPform_Index(pc,d0.w),d1
	jmp	ObjSidewaysPform_Index(pc,d1.w)
; ===========================================================================
; off_293AE:
ObjSidewaysPform_Index:	offsetTable
		offsetTableEntry.w ObjSidewaysPform_Init		; 0
		offsetTableEntry.w ObjSidewaysPform_Main		; 2
		offsetTableEntry.w ObjSidewaysPform_SubObject	; 4
; ===========================================================================
obj7A_properties macro totalChildren,originXOffset,parentXOffset,childXOffset
	dc.b	totalChildren-1
	dc.b	originXOffset
	dc.w	parentXOffset
	dc.w	childXOffset
    endm

; byte_293B4:
ObjSidewaysPform_Properties:
	obj7A_properties 1,  $68, -$68,    0 ; $00
	obj7A_properties 2,  $A8, -$B0,  $40 ; $06
	obj7A_properties 2,  $E8, -$80,  $80 ; $0C
	obj7A_properties 1,  $68,  $67,    0 ; $12
; ===========================================================================
; loc_293CC:
ObjSidewaysPform_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjSidewaysPform_MapUnc_29564,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,1),art_tile(a0)
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	bne.s	+
	move.l	#ObjSwingingPlatform_ObjSidewaysPform_MapUnc_10256,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
+
	jsrto	JmpTo41_Adjust2PArtPointer
	moveq	#0,d1
	move.b	subtype(a0),d1
	lea	ObjSidewaysPform_Properties(pc,d1.w),a2
	move.b	(a2)+,d1
	movea.l	a0,a1
	bra.s	ObjSidewaysPform_LoadSubObject
; ===========================================================================
; loc_29408:
ObjSidewaysPform_SubObjectLoop:
	jsrto	JmpTo17_AllocateObjectAfterCurrent
	bne.s	ObjSidewaysPform_SubObjectLoop_End
	_move.b	id(a0),id(a1) ; load obj7A
	move.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
; loc_29426:
ObjSidewaysPform_LoadSubObject:
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#$18,width_pixels(a1)
	move.w	x_pos(a1),objoff_30(a1)
; loc_2944A:
ObjSidewaysPform_SubObjectLoop_End:
	dbf	d1,ObjSidewaysPform_SubObjectLoop

	move.l	a0,objoff_3C(a1)
	move.l	a1,objoff_3C(a0)
	cmpi.b	#$C,subtype(a0)
	bne.s	+
	move.b	#1,objoff_36(a0)
+
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	objoff_30(a0),d0
	sub.w	d1,d0
	move.w	d0,objoff_32(a0)
	move.w	d0,objoff_32(a1)
	add.w	d1,d0
	add.w	d1,d0
	move.w	d0,objoff_34(a0)
	move.w	d0,objoff_34(a1)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a1)
; loc_2948E:
ObjSidewaysPform_Main:
	bsr.s	loc_294F4
	tst.w	(Two_player_mode).w
	beq.s	+	; if 2P VS mode is off, branch
	jmpto	JmpTo24_DisplaySprite
; ===========================================================================
+
	move.w	objoff_32(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bls.s	+
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	loc_294C4
+
	jmp	(DisplaySprite).l
; ===========================================================================

loc_294C4:
	movea.l	objoff_3C(a0),a1 ; a1=object
	cmpa.l	a0,a1
	beq.s	+
	jsr	(DeleteObject2).l
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	JmpTo39_DeleteObject
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)

JmpTo39_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================
; loc_294EA:
ObjSidewaysPform_SubObject:
	bsr.s	loc_294F4
	bsr.s	loc_2953E
	jmp	(DisplaySprite).l
; ===========================================================================

loc_294F4:
	move.w	x_pos(a0),-(sp)
	tst.b	objoff_36(a0)
	beq.s	loc_29516
	move.w	x_pos(a0),d0
	subq.w	#1,d0
	cmp.w	objoff_32(a0),d0
	bne.s	+
	move.b	#0,objoff_36(a0)
+
	move.w	d0,x_pos(a0)
	bra.s	loc_2952C
; ===========================================================================

loc_29516:
	move.w	x_pos(a0),d0
	addq.w	#1,d0
	cmp.w	objoff_34(a0),d0
	bne.s	+
	move.b	#1,objoff_36(a0)
+
	move.w	d0,x_pos(a0)

loc_2952C:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	#8,d3
	move.w	(sp)+,d4
	jsrto	JmpTo6_PlatformObject
	rts
; ===========================================================================

loc_2953E:
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.w	x_pos(a0),d0
	subi.w	#$18,d0
	move.w	x_pos(a1),d2
	addi.w	#$18,d2
	cmp.w	d0,d2
	bne.s	+	; rts
	eori.b	#1,objoff_36(a0)
	eori.b	#1,objoff_36(a1)
+
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjSidewaysPform_MapUnc_29564:	include "mappings/sprite/obj7A.asm"
; ===========================================================================

