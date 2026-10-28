; ===========================================================================
; ---------------------------------------------------------------------------
; Object D4 - Big block from CNZ that moves back and forth
; ---------------------------------------------------------------------------
; Sprite_2B8EC:
ObjCNZBigBlock:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCNZBigBlock_Index(pc,d0.w),d1
	jmp	ObjCNZBigBlock_Index(pc,d1.w)
; ===========================================================================
; off_2B8FA:
ObjCNZBigBlock_Index:	offsetTable
		offsetTableEntry.w ObjCNZBigBlock_Init	; 0
		offsetTableEntry.w ObjCNZBigBlock_Main	; 2
; ===========================================================================
; loc_2B8FE:
ObjCNZBigBlock_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjCNZBigBlock_MapUnc_2B9CA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BigMovingBlock,2,0),art_tile(a0)
	jsrto	JmpTo52_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.w	#$8000,x_sub(a0)
	move.w	#$8000,y_sub(a0)
	tst.b	subtype(a0)
	bne.s	loc_2B95A
	subi.w	#$60,x_pos(a0)
	btst	#status.npc.x_flip,status(a0)
	beq.s	ObjCNZBigBlock_Main
	addi.w	#$C0,x_pos(a0)
	bra.s	ObjCNZBigBlock_Main
; ===========================================================================

loc_2B95A:
	subi.w	#$60,y_pos(a0)
	btst	#status.npc.y_flip,status(a0)
	beq.s	ObjCNZBigBlock_Main
	addi.w	#$C0,y_pos(a0)
; loc_2B96E:
ObjCNZBigBlock_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.w	ObjCNZBigBlock_Types(pc,d0.w),d1
	jsr	ObjCNZBigBlock_Types(pc,d1.w)
	jsrto	JmpTo17_ObjectMove
	move.w	#$2B,d1
	move.w	#$20,d2
	move.w	#$21,d3
	move.w	(sp)+,d4
	jsrto	JmpTo25_SolidObject
	move.w	objoff_30(a0),d0
	jmpto	JmpTo10_MarkObjGone2
; ===========================================================================
; off_2B99E:
ObjCNZBigBlock_Types:	offsetTable
		offsetTableEntry.w ObjCNZBigBlock_Horizontal	; 0
		offsetTableEntry.w ObjCNZBigBlock_Vertical	; 2
; ===========================================================================
; loc_2B9A2:
ObjCNZBigBlock_Horizontal:
	moveq	#4,d1
	move.w	objoff_30(a0),d0
	cmp.w	x_pos(a0),d0
	bhi.s	+
	neg.w	d1
+
	add.w	d1,x_vel(a0)
	rts
; ===========================================================================
; loc_2B9B6:
ObjCNZBigBlock_Vertical:
	moveq	#4,d1
	move.w	objoff_32(a0),d0
	cmp.w	y_pos(a0),d0
	bhi.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjCNZBigBlock_MapUnc_2B9CA:	include "mappings/sprite/objD4.asm"
; ===========================================================================


