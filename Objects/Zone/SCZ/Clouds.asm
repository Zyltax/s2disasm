; ===========================================================================
; ----------------------------------------------------------------------------
; Object B3 - Clouds (placeable object) from SCZ
; ----------------------------------------------------------------------------
; Sprite_3B2DE:
ObjCloud:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCloud_Index(pc,d0.w),d1
	jmp	ObjCloud_Index(pc,d1.w)
; ===========================================================================
; off_3B2EC:
ObjCloud_Index:	offsetTable
		offsetTableEntry.w ObjCloud_Init	; 0
		offsetTableEntry.w ObjCloud_Main	; 2
; ===========================================================================
; loc_3B2F0:
ObjCloud_Init:
	bsr.w	LoadSubObject
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$5E,d0
	move.w	word_3B30C(pc,d0.w),x_vel(a0)
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a0)
	rts
; ===========================================================================
word_3B30C:
	dc.w  -$80
	dc.w  -$40	; 1
	dc.w  -$20	; 2
; ===========================================================================
; loc_3B312:
ObjCloud_Main:
	jsrto	JmpTo26_ObjectMove
	move.w	(Tornado_Velocity_X).w,d0
	add.w	d0,x_pos(a0)
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
; off_3B322:
ObjCloud_SubObjData:
	subObjData ObjCloud_MapUnc_3B32C,make_art_tile(ArtTile_ArtNem_Clouds,2,0),1<<render_flags.level_fg,6,$30,0

; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjCloud_MapUnc_3B32C:	include "mappings/sprite/objB3.asm"
