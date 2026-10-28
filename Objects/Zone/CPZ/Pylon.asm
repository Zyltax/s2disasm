; ===========================================================================
; ----------------------------------------------------------------------------
; Object 7C - Big pylon in foreground of CPZ
; ----------------------------------------------------------------------------
; Sprite_20FD2:
ObjCPZPylon:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCPZPylon_Index(pc,d0.w),d1
	jmp	ObjCPZPylon_Index(pc,d1.w)
; ===========================================================================
; off_20FE0: ObjCPZPylon_States:
ObjCPZPylon_Index:	offsetTable
		offsetTableEntry.w ObjCPZPylon_Init	; 0
		offsetTableEntry.w ObjCPZPylon_Main	; 2
; ===========================================================================
; loc_20FE4:
ObjCPZPylon_Init:
	addq.b	#2,routine(a0) ; => ObjCPZPylon_Main
	move.l	#ObjCPZPylon_MapUnc_2103C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZMetalThings,2,1),art_tile(a0)
	jsrto	JmpTo12_Adjust2PArtPointer
	move.b	#$10,width_pixels(a0)
	move.b	#7,priority(a0)

; loc_21006:
ObjCPZPylon_Main:
	move.w	(Camera_X_pos).w,d1
	andi.w	#$3FF,d1
	cmpi.w	#$2E0,d1
	bhs.s	+	; rts
	asr.w	#1,d1
	move.w	d1,d0
	asr.w	#1,d1
	add.w	d1,d0
	neg.w	d0
	move.w	d0,x_pixel(a0)
	move.w	(Camera_Y_pos).w,d1
	asr.w	#1,d1
	andi.w	#$3F,d1
	neg.w	d1
	addi.w	#$100,d1
	move.w	d1,y_pixel(a0)
	jmpto	JmpTo10_DisplaySprite
; ---------------------------------------------------------------------------
+	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjCPZPylon_MapUnc_2103C:	include "mappings/sprite/obj7C.asm"




