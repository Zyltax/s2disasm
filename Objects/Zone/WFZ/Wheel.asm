; ===========================================================================
; ----------------------------------------------------------------------------
; Object BA - Wheel from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BB4C:
ObjWFZWheel:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjWFZWheel_Index(pc,d0.w),d1
	jmp	ObjWFZWheel_Index(pc,d1.w)
; ===========================================================================
; off_3BB5A:
ObjWFZWheel_Index:	offsetTable
		offsetTableEntry.w ObjWFZWheel_Init	; 0
		offsetTableEntry.w ObjWFZWheel_Main	; 2
; ===========================================================================
; BranchTo7_LoadSubObject
ObjWFZWheel_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo14_JmpTo39_MarkObjGone
ObjWFZWheel_Main:
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB66:
ObjWFZWheel_SubObjData:
	subObjData ObjWFZWheel_MapUnc_3BB70,make_art_tile(ArtTile_ArtNem_WfzConveyorBeltWheel,2,1),1<<render_flags.level_fg,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjWFZWheel_MapUnc_3BB70:	include "mappings/sprite/objBA.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BB - Removed object (unknown, unused)
; ----------------------------------------------------------------------------
; Sprite_3BB7C:
ObjBB:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBB_Index(pc,d0.w),d1
	jmp	ObjBB_Index(pc,d1.w)
; ===========================================================================
; off_3BB8A:
ObjBB_Index:	offsetTable
		offsetTableEntry.w ObjBB_Init	; 0
		offsetTableEntry.w ObjBB_Main	; 2
; ===========================================================================
; BranchTo8_LoadSubObject
ObjBB_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo15_JmpTo39_MarkObjGone
ObjBB_Main:
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB96:
ObjBB_SubObjData:
	subObjData ObjBB_MapUnc_3BBA0,make_art_tile(ArtTile_ArtNem_Unknown,1,0),1<<render_flags.level_fg,4,$C,9
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBB_MapUnc_3BBA0:	include "mappings/sprite/objBB.asm"
