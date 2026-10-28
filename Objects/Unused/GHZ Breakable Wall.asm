; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3C - Breakable wall (leftover from S1) (mostly unused)
; ----------------------------------------------------------------------------
; Sprite_15D44:
ObjBreakableWall:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBreakableWall_Index(pc,d0.w),d1
	jsr	ObjBreakableWall_Index(pc,d1.w)
	bra.w	MarkObjGone
; ===========================================================================
; off_15D56:
ObjBreakableWall_Index:	offsetTable
		offsetTableEntry.w ObjBreakableWall_Init		; 0
		offsetTableEntry.w ObjBreakableWall_Main		; 2
		offsetTableEntry.w ObjBreakableWall_Fragment	; 4
; ===========================================================================
; loc_15D5C:
ObjBreakableWall_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjBreakableWall_MapUnc_15ECC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BreakWall,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),mapping_frame(a0)
; loc_15D8A:
ObjBreakableWall_Main:
	move.w	(MainCharacter+x_vel).w,objoff_30(a0)
	move.w	#$1B,d1
	move.w	#$20,d2
	move.w	#$20,d3
	move.w	x_pos(a0),d4
	bsr.w	SolidObject
	btst	#status.npc.p1_pushing,status(a0)
	bne.s	+
-	rts
; ===========================================================================
+
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.b	#2,anim(a1)
	bne.s	-	; rts
	mvabs.w	objoff_30(a0),d0
	cmpi.w	#$480,d0
	blo.s	-	; rts
	move.w	objoff_30(a0),x_vel(a1)
	addq.w	#4,x_pos(a1)
	lea	(ObjBreakableWall_FragmentSpeeds_LeftToRight).l,a4
	move.w	x_pos(a0),d0
	cmp.w	x_pos(a1),d0
	blo.s	+
	subi_.w	#8,x_pos(a1)
	lea	(ObjBreakableWall_FragmentSpeeds_RightToLeft).l,a4
+
	move.w	x_vel(a1),inertia(a1)
	bclr	#status.npc.p1_pushing,status(a0)
	bclr	#status.player.pushing,status(a1)
	bsr.s	BreakObjectToPieces
; loc_15E02:
ObjBreakableWall_Fragment:
	bsr.w	ObjectMove
	addi.w	#$70,y_vel(a0)
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	DeleteObject
	bra.w	DisplaySprite


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
	include "Objects/Subroutines/Break Object to Pieces.asm"
; -------------------------------------------------------------------------------

; sub_15E18:
ObjBreakableWall_FragmentSpeeds_LeftToRight:
	;    x_vel,y_vel
	dc.w  $400,-$500	; 0
	dc.w  $600,-$100	; 2
	dc.w  $600, $100	; 4
	dc.w  $400, $500	; 6
	dc.w  $600,-$600	; 8
	dc.w  $800,-$200	; 10
	dc.w  $800, $200	; 12
	dc.w  $600, $600	; 14
; word_15EAC:
ObjBreakableWall_FragmentSpeeds_RightToLeft:
	dc.w -$600,-$600	; 0
	dc.w -$800,-$200	; 2
	dc.w -$800, $200	; 4
	dc.w -$600, $600	; 6
	dc.w -$400,-$500	; 8
	dc.w -$600,-$100	; 10
	dc.w -$600, $100	; 12
	dc.w -$400, $500	; 14
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
ObjBreakableWall_MapUnc_15ECC:	include "mappings/sprite/obj3C.asm"
; ===========================================================================
	bra.w	ObjNull




