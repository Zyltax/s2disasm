; ===========================================================================
; ----------------------------------------------------------------------------
; Object C3,C4 - Plane's smoke from WFZ
; ----------------------------------------------------------------------------
; Sprite_3C3D6:
ObjTornadoSmoke:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjTornadoSmoke_Index(pc,d0.w),d1
	jmp	ObjTornadoSmoke_Index(pc,d1.w)
; ===========================================================================
; off_3C3E4:
ObjTornadoSmoke_Index:	offsetTable
		offsetTableEntry.w ObjTornadoSmoke_Init
		offsetTableEntry.w ObjTornadoSmoke_Main
; ===========================================================================
; loc_3C3E8:
ObjTornadoSmoke_Init:
	bsr.w	LoadSubObject
	move.b	#7,anim_frame_duration(a0)
	jsrto	JmpTo6_RandomNumber
	move.w	(RNG_seed).w,d0
	andi.w	#$1C,d0
	sub.w	d0,x_pos(a0)
	addi.w	#$10,y_pos(a0)
	move.w	#-$100,y_vel(a0)
	move.w	#-$100,x_vel(a0)
	rts
; ===========================================================================
; loc_3C416:
ObjTornadoSmoke_Main:
	jsrto	JmpTo26_ObjectMove
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	beq.w	JmpTo65_DeleteObject
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; off_3C438:
ObjTornadoSmoke_SubObjData:
	subObjData ObjExplosion_MapUnc_21120,make_art_tile(ArtTile_ArtNem_Explosion,0,0),1<<render_flags.level_fg,5,$C,0
