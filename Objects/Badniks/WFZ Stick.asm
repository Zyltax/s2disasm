; ===========================================================================
; ----------------------------------------------------------------------------
; Object BF - Rotaty-stick badnik from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BEAA:
ObjWFZStick:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjWFZStick_Index(pc,d0.w),d1
	jmp	ObjWFZStick_Index(pc,d1.w)
; ===========================================================================
; off_3BEB8:
ObjWFZStick_Index:	offsetTable
		offsetTableEntry.w ObjWFZStick_Init		; 0
		offsetTableEntry.w ObjWFZStick_Animate	; 2
; ===========================================================================
; BranchTo9_LoadSubObject
ObjWFZStick_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_3BEC0:
ObjWFZStick_Animate:
	lea	(Ani_objBF).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3BECE:
ObjLateralCannon_SubObjData2:
	subObjData ObjWFZStick_MapUnc_3BEE0,make_art_tile(ArtTile_ArtNem_WfzUnusedBadnik,3,1),1<<render_flags.level_fg,4,4,4
; animation script
; off_3BED8:
Ani_objBF:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjWFZStick_MapUnc_3BEE0:	include "mappings/sprite/objBF.asm"
