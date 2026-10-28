; ===========================================================================
; ----------------------------------------------------------------------------
; Object 27 - An explosion, giving off an animal and 100 points
; ----------------------------------------------------------------------------
; Sprite_21088:
ObjExplosion:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjExplosion_Index(pc,d0.w),d1
	jmp	ObjExplosion_Index(pc,d1.w)
; ===========================================================================
; off_21096: ObjExplosion_States:
ObjExplosion_Index:	offsetTable
		offsetTableEntry.w ObjExplosion_InitWithAnimal	; 0
		offsetTableEntry.w ObjExplosion_Init		; 2
		offsetTableEntry.w ObjExplosion_Main		; 4
; ===========================================================================
; loc_2109C: ObjExplosion_Init:
ObjExplosion_InitWithAnimal:
	addq.b	#2,routine(a0) ; => ObjExplosion_Init
	jsrto	JmpTo2_AllocateObject
	bne.s	ObjExplosion_Init
	_move.b	#ObjID_Animal,id(a1) ; load obj28 (Animal and 100 points)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	objoff_3E(a0),objoff_3E(a1)	; Set by Touch_KillEnemy

; loc_210BE: ObjExplosion_Init2:
ObjExplosion_Init:
	addq.b	#2,routine(a0) ; => ObjExplosion_Main
	move.l	#ObjExplosion_MapUnc_21120,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Explosion,0,0),art_tile(a0)
	jsrto	JmpTo12_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#0,collision_flags(a0)
	move.b	#$C,width_pixels(a0)
	move.b	#3,anim_frame_duration(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#SndID_Explosion,d0
	jsr	(PlaySound).l

; loc_21102:
ObjExplosion_Main:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	beq.w	JmpTo18_DeleteObject
+
	jmpto	JmpTo10_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjExplosion_MapUnc_21120:	include "mappings/sprite/obj27.asm"
