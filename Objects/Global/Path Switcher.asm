; ===========================================================================
; ---------------------------------------------------------------------------
; Object 03 - Collision plane/layer switcher
; ---------------------------------------------------------------------------
; OST Variables:
planeswitch_radius =	objoff_32	; word ; half-height of x-switcher or half-width of y-switcher
planeswitch_p1_flag = 	objoff_34	; byte ; 0 if player 1 is above or left of switcher; 1 if below or to right
planeswitch_p2_flag =	objoff_35	; byte ; same as above, but for player 2

; Sprite_1FCDC:
ObjPlaneSwitcher:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjPlaneSwitcher_Index(pc,d0.w),d1
	jsr	ObjPlaneSwitcher_Index(pc,d1.w)
	jmp	(MarkObjGone3).l
; ===========================================================================
; off_1FCF0:
ObjPlaneSwitcher_Index:	offsetTable
		offsetTableEntry.w ObjPlaneSwitcher_Init	; 0
		offsetTableEntry.w ObjPlaneSwitcher_MainX	; 2
		offsetTableEntry.w ObjPlaneSwitcher_MainY	; 4
; ===========================================================================
; loc_1FCF6:
ObjPlaneSwitcher_Init:
	addq.b	#2,routine(a0) ; => ObjPlaneSwitcher_MainX
	move.l	#ObjPlaneSwitcher_MapUnc_1FFB8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a0)
	jsrto	JmpTo7_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#5,priority(a0)
	move.b	subtype(a0),d0
	btst	#2,d0
	beq.s	ObjPlaneSwitcher_Init_CheckX
;ObjPlaneSwitcher_Init_CheckY:
	addq.b	#2,routine(a0) ; => ObjPlaneSwitcher_MainY
	andi.w	#7,d0
	move.b	d0,mapping_frame(a0)
	andi.w	#3,d0
	add.w	d0,d0
	move.w	word_1FD68(pc,d0.w),planeswitch_radius(a0)
	move.w	y_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	y_pos(a1),d1
	bhs.s	+
	move.b	#1,planeswitch_p1_flag(a0)
+
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	y_pos(a1),d1
	bhs.s	+
	move.b	#1,planeswitch_p2_flag(a0)
+
	bra.w	ObjPlaneSwitcher_MainY
; ===========================================================================
word_1FD68:
	dc.w   $20
	dc.w   $40	; 1
	dc.w   $80	; 2
	dc.w  $100	; 3
; ===========================================================================
; loc_1FD70:
ObjPlaneSwitcher_Init_CheckX:
	andi.w	#3,d0
	move.b	d0,mapping_frame(a0)
	add.w	d0,d0
	move.w	word_1FD68(pc,d0.w),planeswitch_radius(a0)
	move.w	x_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	+
	move.b	#1,planeswitch_p1_flag(a0)
+
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	+
	move.b	#1,planeswitch_p2_flag(a0)
+

; loc_1FDA4:
ObjPlaneSwitcher_MainX:
	tst.w	(Debug_placement_mode).w
	bne.w	return_1FEAC
	move.w	x_pos(a0),d1
	lea	planeswitch_p1_flag(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character

+	tst.b	(a2)+
	bne.s	ObjPlaneSwitcher_MainX_Alt
	cmp.w	x_pos(a1),d1
	bhi.w	return_1FEAC
	move.b	#1,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	planeswitch_radius(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blt.w	return_1FEAC
	cmp.w	d3,d4
	bge.w	return_1FEAC
	move.b	subtype(a0),d0
	bpl.s	+
	btst	#status.player.in_air,status(a1)
	bne.w	return_1FEAC
+
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
	btst	#3,d0
	beq.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	andi.w	#drawing_mask,art_tile(a1)
	btst	#5,d0
	beq.s	return_1FEAC
	ori.w	#high_priority,art_tile(a1)
	bra.s	return_1FEAC
; ===========================================================================
; loc_1FE38:
ObjPlaneSwitcher_MainX_Alt:
	cmp.w	x_pos(a1),d1
	bls.w	return_1FEAC
	move.b	#0,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	planeswitch_radius(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blt.w	return_1FEAC
	cmp.w	d3,d4
	bge.w	return_1FEAC
	move.b	subtype(a0),d0
	bpl.s	+
	btst	#status.player.in_air,status(a1)
	bne.w	return_1FEAC
+
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
	btst	#4,d0
	beq.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	andi.w	#drawing_mask,art_tile(a1)
	btst	#6,d0
	beq.s	return_1FEAC
	ori.w	#high_priority,art_tile(a1)

return_1FEAC:
	rts
; ===========================================================================

ObjPlaneSwitcher_MainY:
	tst.w	(Debug_placement_mode).w
	bne.w	return_1FFB6
	move.w	y_pos(a0),d1
	lea	planeswitch_p1_flag(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character

+	tst.b	(a2)+
	bne.s	ObjPlaneSwitcher_MainY_Alt
	cmp.w	y_pos(a1),d1
	bhi.w	return_1FFB6
	move.b	#1,-1(a2)
	move.w	x_pos(a0),d2
	move.w	d2,d3
	move.w	planeswitch_radius(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	x_pos(a1),d4
	cmp.w	d2,d4
	blt.w	return_1FFB6
	cmp.w	d3,d4
	bge.w	return_1FFB6
	move.b	subtype(a0),d0
	bpl.s	+
	btst	#status.player.in_air,status(a1)
	bne.w	return_1FFB6
+
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
	btst	#3,d0
	beq.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	andi.w	#drawing_mask,art_tile(a1)
	btst	#5,d0
	beq.s	return_1FFB6
	ori.w	#high_priority,art_tile(a1)
	bra.s	return_1FFB6
; ===========================================================================
; loc_1FF42:
ObjPlaneSwitcher_MainY_Alt:
	cmp.w	y_pos(a1),d1
	bls.w	return_1FFB6
	move.b	#0,-1(a2)
	move.w	x_pos(a0),d2
	move.w	d2,d3
	move.w	planeswitch_radius(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	x_pos(a1),d4
	cmp.w	d2,d4
	blt.w	return_1FFB6
	cmp.w	d3,d4
	bge.w	return_1FFB6
	move.b	subtype(a0),d0
	bpl.s	+
	btst	#status.player.in_air,status(a1)
	bne.w	return_1FFB6
+
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
	btst	#4,d0
	beq.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	andi.w	#drawing_mask,art_tile(a1)
	btst	#6,d0
	beq.s	return_1FFB6
	ori.w	#high_priority,art_tile(a1)

return_1FFB6:
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjPlaneSwitcher_MapUnc_1FFB8:	include "mappings/sprite/obj03.asm"
; ===========================================================================


