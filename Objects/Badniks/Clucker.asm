; ===========================================================================
; ----------------------------------------------------------------------------
; Object AD - Clucker's base from WFZ
; ----------------------------------------------------------------------------
; Sprite_3941C:
ObjCluckerBase:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCluckerBase_Index(pc,d0.w),d1
	jmp	ObjCluckerBase_Index(pc,d1.w)
; ===========================================================================
; off_3942A:
ObjCluckerBase_Index:	offsetTable
		offsetTableEntry.w ObjCluckerBase_Init	; 0
		offsetTableEntry.w ObjCluckerBase_Main	; 2
; ===========================================================================
; loc_3942E:
ObjCluckerBase_Init:
	bsr.w	LoadSubObject
	move.b	#$C,mapping_frame(a0)
	rts
; ===========================================================================
; loc_3943A:
ObjCluckerBase_Main:
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo27_SolidObject
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object AE - Clucker (chicken badnik) from WFZ
; ----------------------------------------------------------------------------
; Sprite_39452:
ObjClucker:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjClucker_Index(pc,d0.w),d1
	jmp	ObjClucker_Index(pc,d1.w)
; ===========================================================================
; off_39460:
ObjClucker_Index:	offsetTable
		offsetTableEntry.w ObjClucker_Init	;  0
		offsetTableEntry.w loc_39488	;  2
		offsetTableEntry.w loc_394A2	;  4
		offsetTableEntry.w loc_394D2	;  6
		offsetTableEntry.w loc_394E0	;  8
		offsetTableEntry.w loc_39508	; $A
		offsetTableEntry.w loc_39516	; $C
; ===========================================================================
; loc_3946E:
ObjClucker_Init:
	bsr.w	LoadSubObject
	move.b	#$15,mapping_frame(a0)
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	bset	#status.npc.x_flip,status(a0)
+
	rts
; ===========================================================================

loc_39488:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$80,d2
	cmpi.w	#$100,d2
	blo.s	+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_394A2:
	move.b	routine(a0),d2
	lea	(Ani_objAE_a).l,a1
	jsrto	JmpTo25_AnimateSprite
	cmp.b	routine(a0),d2
	bne.s	+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	lea	mapping_frame(a0),a1
	clr.l	(a1) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration-mapping_frame(a1)
	move.b	#8,(a1)
	move.b	#6,collision_flags(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_394D2:
	lea	(Ani_objAE_b).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_394E0:
	tst.b	objoff_2A(a0)
	beq.s	+
	subq.b	#1,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	lea	mapping_frame(a0),a1
	clr.l	(a1) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration-mapping_frame(a1)
	move.b	#$B,(a1)
	bsr.w	loc_39526
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_39508:
	lea	(Ani_objAE_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_39516:
	move.b	#8,routine(a0)
	move.b	#$40,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_39526:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	++	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#$D,mapping_frame(a1)
	move.b	#$46,subtype(a1) ; <==  ObjCluckerBase_SubObjData3
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$B,y_pos(a1)
	move.w	#-$200,d0
	move.w	#-8,d1
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	neg.w	d0
	neg.w	d1
+
	move.w	d0,x_vel(a1)
	add.w	d1,x_pos(a1)
	lea_	ObjProjectile_CluckerShotMove,a2
	move.l	a2,objoff_2A(a1)
+
	rts
; ===========================================================================
ObjCluckerBase_SubObjData:
	subObjData ObjCluckerBase_ObjProjectile_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),1<<render_flags.level_fg,4,$18,0
ObjCluckerBase_SubObjData2:
	subObjData ObjCluckerBase_ObjProjectile_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),1<<render_flags.level_fg,5,$10,0

; animation script
; off_3958A
Ani_objAE_a:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,  3,  4,  5,  6,  7,$FC
		even

; animation script
; off_39596
Ani_objAE_b:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  8,  9, $A, $B, $B, $B, $B,$FC
		even

; animation script
; off_395A2
Ani_objAE_c:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3, $A, $B,$FC
		even

; animation script
; off_395A8
Ani_CluckerShot:offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3, $D, $E, $F,$10,$11,$12,$13,$14,$FF
		even

; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjCluckerBase_ObjProjectile_MapUnc_395B4:	include "mappings/sprite/objAE.asm"
