; ===========================================================================
; ----------------------------------------------------------------------------
; Object C6 - Eggman
; ----------------------------------------------------------------------------
; Sprite_3CED0:
ObjEggman:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjEggman_Index(pc,d0.w),d1
	jmp	ObjEggman_Index(pc,d1.w)
; ===========================================================================
; off_3CEDE: ObjEggman_States:
ObjEggman_Index:	offsetTable
		offsetTableEntry.w ObjEggman_Init	; 0
		offsetTableEntry.w ObjEggman_State2	; 2
		offsetTableEntry.w ObjEggman_State3	; 4
		offsetTableEntry.w ObjEggman_State4	; 6
; ===========================================================================
; loc_3CEE6:
ObjEggman_Init:
	bsr.w	LoadSubObject
	move.b	subtype(a0),d0
	subi.b	#$A4,d0
	move.b	d0,routine(a0) ; => ObjEggman_State2, ObjEggman_State3, or ObjEggman_State4??
	rts
; ===========================================================================
; loc_3CEF8:
ObjEggman_State2:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjEggman_State2_States(pc,d0.w),d1
	jmp	ObjEggman_State2_States(pc,d1.w)
; ===========================================================================
; off_3CF06:
ObjEggman_State2_States: offsetTable
	offsetTableEntry.w ObjEggman_State2_State1	; 0
	offsetTableEntry.w ObjEggman_State2_State2	; 2
	offsetTableEntry.w ObjEggman_State2_State3	; 4
	offsetTableEntry.w ObjEggman_State2_State4	; 6
	offsetTableEntry.w ObjEggman_State2_State5	; 8
; ===========================================================================
; loc_3CF10:
ObjEggman_State2_State1: ; a1=object (set in loc_3D94C)
	addq.b	#2,routine_secondary(a0) ; => ObjEggman_State2_State2
	lea	(ChildObject_3D0D0).l,a2
	bsr.w	LoadChildObject
	move.w	#$3F8,x_pos(a1)
	move.w	#$160,y_pos(a1)
	move.w	a0,(DEZ_Eggman).w
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF32:
ObjEggman_State2_State2:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$5C,d2
	cmpi.w	#$B8,d2
	blo.s	loc_3CF44
	jmpto	JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3CF44:
	addq.b	#2,routine_secondary(a0) ; => ObjEggman_State2_State3
	move.w	#$18,objoff_2A(a0)
	move.b	#1,mapping_frame(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF58:
ObjEggman_State2_State3:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3CF62
	jmpto	JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3CF62:
	addq.b	#2,routine_secondary(a0) ; => ObjEggman_State2_State4
	bset	#status.npc.misc,status(a0)
	move.w	#$200,x_vel(a0)
	move.w	#$10,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF7C:
ObjEggman_State2_State4:
	cmpi.w	#$810,x_pos(a0)
	bhs.s	loc_3CFC0
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$50,d2
	cmpi.w	#$A0,d2
	bhs.s	+
	move.w	x_pos(a1),d0
	addi.w	#$50,d0
	move.w	d0,x_pos(a0)
+
	subq.w	#1,objoff_2A(a0)
	bpl.s	+
	move.w	#$20,objoff_2A(a0)
	bsr.w	loc_3D00C
+
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_objC5_objC6).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3CFC0:
	move.b	#2,mapping_frame(a0)
	clr.w	x_vel(a0)
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	+
	addq.b	#2,routine_secondary(a0) ; => ObjEggman_State2_State5
	move.w	#$80,x_vel(a0)
	move.w	#-$200,y_vel(a0)
	move.b	#2,mapping_frame(a0)
	move.w	#$50,objoff_2A(a0)
	bset	#status.npc.p1_standing,status(a0)
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CFF6:
ObjEggman_State2_State5:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	addi.w	#$10,y_vel(a0)
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3D00C:
	lea	(ChildObject_3D0D4).l,a2
	bsr.w	LoadChildObject
	move.b	#$AA,subtype(a1) ; <== ObjEggman_SubObjData
	move.b	#5,mapping_frame(a1)
	move.w	#-$100,x_vel(a1)
	subi.w	#$18,y_pos(a1)
	move.w	#8,objoff_2A(a1)
	rts
; ===========================================================================
; loc_3D036:
ObjEggman_State3:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjEggman_State3_States(pc,d0.w),d1
	jmp	ObjEggman_State3_States(pc,d1.w)
; ===========================================================================
; off_3D044:
ObjEggman_State3_States: offsetTable
	offsetTableEntry.w ObjEggman_State3_State1	; 0
	offsetTableEntry.w ObjEggman_State3_State2	; 2
	offsetTableEntry.w ObjEggman_State3_State3	; 4
; ===========================================================================
; loc_3D04A:
ObjEggman_State3_State1:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.misc,status(a1)
	bne.s	loc_3D05E
	bsr.w	loc_3D086
	jmpto	JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3D05E:
	addq.b	#2,routine_secondary(a0) ; => ObjEggman_State3_State2
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3D066:
ObjEggman_State3_State2:
	bsr.w	loc_3D086
	lea	(Ani_objC6).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3D078:
ObjEggman_State3_State3:
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#status.npc.p1_pushing,status(a1)
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

loc_3D086:
	move.w	x_pos(a0),-(sp)
	move.w	#$13,d1
	move.w	#$20,d2
	move.w	#$20,d3
	move.w	(sp)+,d4
	jmpto	JmpTo27_SolidObject
; ===========================================================================
; loc_3D09C:
ObjEggman_State4:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	addi.w	#$10,y_vel(a0)
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3D0B2:
ObjEggman_SubObjData3:
	subObjData ObjEggman_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),1<<render_flags.level_fg,5,$18,0
; off_3D0BC:
ObjEggman_SubObjData4:
	subObjData ObjEggman_MapUnc_3D1DE,make_art_tile(ArtTile_ArtNem_ConstructionStripes_1,1,0),1<<render_flags.level_fg,1,8,0
; off_3D0C6:
ObjEggman_SubObjData:
	subObjData ObjEggman_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),1<<render_flags.level_fg,5,4,0
ChildObject_3D0D0:	childObjectData objoff_3E, ObjID_Eggman, $A8
ChildObject_3D0D4:	childObjectData objoff_3C, ObjID_Eggman, $AA
; animation script
; off_3D0D8:
Ani_objC5_objC6:offsetTable
		offsetTableEntry.w byte_3D0DC	; 0
		offsetTableEntry.w byte_3D0E2	; 1
byte_3D0DC:	dc.b   5,  2,  3,  4,$FF,  0
byte_3D0E2:	dc.b   5,  6,  7,$FF
		even
; animation script
; off_3D0E6:
Ani_objC6:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,  3,$FA
		even
; ----------------------------------------------------------------------------
; sprite mappings ; Robotnik running
; ----------------------------------------------------------------------------
ObjEggman_MapUnc_3D0EE:	include "mappings/sprite/objC6_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjEggman_MapUnc_3D1DE:	include "mappings/sprite/objC6_b.asm"
