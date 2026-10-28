; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1D - Blue balls in CPZ
; ---------------------------------------------------------------------------
; OST Variables:
blueballs_y_pos =	objoff_30	; word
blueballs_y_vel =	objoff_34	; word
blueballs_x_vel	= 	objoff_36	; word
blueballs_x_pos =	objoff_38	; word
blueballs_offset =	objoff_3A	; word ; used to reposition to opposite pipe
					       ; (only used by corridor variants)
; Sprite_22408:
ObjBlueBalls:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBlueBalls_Index(pc,d0.w),d1
	jmp	ObjBlueBalls_Index(pc,d1.w)
; ===========================================================================
; off_22416: ObjBlueBalls_States:
ObjBlueBalls_Index:	offsetTable
		offsetTableEntry.w ObjBlueBalls_Init		; 0
		offsetTableEntry.w ObjBlueBalls_Wait		; 2
		offsetTableEntry.w ObjBlueBalls_MoveArc	; 4
		offsetTableEntry.w ObjBlueBalls_Wait		; 6
		offsetTableEntry.w ObjBlueBalls_MoveStraight	; 8
; ---------------------------------------------------------------------------
; Originally, the balls were meant to move at varying speeds, but the final
; just hardcodes it to use the first value. It also hasn't been used since
; even the Simon Wai build.
; word_22420: ObjBlueBalls_Speeds:
	dc.w -$480
	dc.w -$500
	dc.w -$600
	dc.w -$700
; ===========================================================================
; loc_22428:
ObjBlueBalls_Init:
	addq.b	#2,routine(a0) ; => ObjBlueBalls_Wait
	move.w	#-$480,y_vel(a0)
	moveq	#0,d1
	move.b	subtype(a0),d1
	move.b	d1,d0
	andi.b	#$F,d1	; number of blue balls
	moveq	#2,d5	; routine number
	andi.b	#$F0,d0
	beq.s	+
	moveq	#6,d5	; routine number
+
	move.b	status(a0),d4
	moveq	#0,d2
	movea.l	a0,a1
	bra.s	ObjBlueBalls_InitBall
; ---------------------------------------------------------------------------
; loc_22452:
ObjBlueBalls_LoadBall:
	jsrto	JmpTo5_AllocateObjectAfterCurrent
	bne.s	++
; loc_22458:
ObjBlueBalls_InitBall:
	_move.b	id(a0),id(a1) ; load obj1D
	move.b	d5,routine(a1) ; => ObjBlueBalls_Wait (either one)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	#ObjBlueBalls_MapUnc_22576,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZDroplet,3,0),art_tile(a1)
	jsrto	JmpTo3_Adjust2PArtPointer2
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#%10001011,collision_flags(a1)
	move.w	x_pos(a1),blueballs_x_pos(a1)
	move.w	y_pos(a1),blueballs_y_pos(a1)
	move.w	y_vel(a0),y_vel(a1)
	move.w	y_vel(a1),blueballs_y_vel(a1)
	move.b	#8,width_pixels(a1)
	move.w	#$60,blueballs_offset(a1)
	move.w	#$B,blueballs_x_vel(a1)
	andi.b	#1<<status.player.x_flip,d4
	beq.s	+
	neg.w	blueballs_x_vel(a1)
	neg.w	blueballs_offset(a1)
+
	move.w	d2,objoff_32(a1)
	addq.w	#3,d2
+
	dbf	d1,ObjBlueBalls_LoadBall
	rts
; ===========================================================================
; loc_224D6:
ObjBlueBalls_Wait:
	subq.w	#1,objoff_32(a0)
	bpl.s	BranchTo_JmpTo7_MarkObjGone
	addq.b	#2,routine(a0) ; => ObjBlueBalls_MoveArc or ObjBlueBalls_MoveStraight
	move.w	#$3B,objoff_32(a0)
	move.w	#SndID_Gloop,d0
	jsr	(PlaySoundLocal).l

BranchTo_JmpTo7_MarkObjGone ; BranchTo
	jmpto	JmpTo7_MarkObjGone
; ===========================================================================
; loc_224F4:
ObjBlueBalls_MoveArc:
	jsrto	JmpTo6_ObjectMove
	move.w	blueballs_x_vel(a0),d0
	add.w	d0,x_vel(a0)
	addi.w	#$18,y_vel(a0)
	bne.s	+
	neg.w	blueballs_x_vel(a0)
+
	move.w	blueballs_y_pos(a0),d0
	cmp.w	y_pos(a0),d0
	bhi.s	BranchTo2_JmpTo7_MarkObjGone
	move.w	blueballs_y_vel(a0),y_vel(a0)
	clr.w	x_vel(a0)
	subq.b	#2,routine(a0) ; => ObjBlueBalls_Wait

BranchTo2_JmpTo7_MarkObjGone ; BranchTo
	jmpto	JmpTo7_MarkObjGone
; ===========================================================================
; loc_22528:
ObjBlueBalls_MoveStraight:
	jsrto	JmpTo6_ObjectMove
	addi.w	#$18,y_vel(a0)
	bne.s	+
	move.w	blueballs_offset(a0),d0
	add.w	blueballs_x_pos(a0),d0
	move.w	d0,x_pos(a0)
+
	cmpi.w	#$180,y_vel(a0)
	bne.s	+
	move.w	#SndID_Gloop,d0
	jsr	(PlaySoundLocal).l
+
	move.w	blueballs_y_pos(a0),d0
	cmp.w	y_pos(a0),d0
	bhi.s	BranchTo3_JmpTo7_MarkObjGone
	move.w	blueballs_y_vel(a0),y_vel(a0)
	move.w	blueballs_x_pos(a0),x_pos(a0)
	move.w	#SndID_Gloop,d0
	jsr	(PlaySoundLocal).l

BranchTo3_JmpTo7_MarkObjGone ; BranchTo
	jmpto	JmpTo7_MarkObjGone
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjBlueBalls_MapUnc_22576:	include "mappings/sprite/obj1D.asm"
; ===========================================================================

