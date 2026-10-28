; ===========================================================================
; ---------------------------------------------------------------------------
; Object D9 - Invisible sprite that you can hang on to, like the blocks in WFZ
; ---------------------------------------------------------------------------
; Sprite_2C92C:
ObjGrab:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjGrab_Index(pc,d0.w),d1
	jmp	ObjGrab_Index(pc,d1.w)
; ===========================================================================
; off_2C93A:
ObjGrab_Index:	offsetTable
		offsetTableEntry.w ObjGrab_Init	; 0
		offsetTableEntry.w ObjGrab_Main	; 2
; ===========================================================================
; loc_2C93E:
ObjGrab_Init:
	addq.b	#2,routine(a0)
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$18,width_pixels(a0)
	move.b	#4,priority(a0)
; loc_2C954:
ObjGrab_Main:
	lea	objoff_30(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ctrl_1).w,d0
	bsr.s	ObjGrab_CheckCharacter
	lea	(Sidekick).w,a1 ; a1=character
	addq.w	#1,a2
	move.w	(Ctrl_2).w,d0
	bsr.s	ObjGrab_CheckCharacter
	jmpto	JmpTo7_MarkObjGone3
; ===========================================================================
; loc_2C972:
ObjGrab_CheckCharacter:
	tst.b	(a2)
	beq.s	loc_2C9A0
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	ObjGrab_CheckCharacter_End
	clr.b	obj_control(a1)
	clr.b	(a2)
	move.b	#18,2(a2)
	andi.w	#(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
	beq.s	+
	move.b	#60,2(a2)
+
	move.w	#-$300,y_vel(a1)
	bra.w	ObjGrab_CheckCharacter_End
; ===========================================================================

loc_2C9A0:
	tst.b	2(a2)
	beq.s	+
	subq.b	#1,2(a2)
	bne.w	ObjGrab_CheckCharacter_End
+
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$18,d0
	cmpi.w	#$30,d0
	bhs.w	ObjGrab_CheckCharacter_End
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	cmpi.w	#$10,d1
	bhs.w	ObjGrab_CheckCharacter_End
	tst.b	obj_control(a1)
	bmi.s	ObjGrab_CheckCharacter_End
	cmpi.b	#6,routine(a1)
	bhs.s	ObjGrab_CheckCharacter_End
	tst.w	(Debug_placement_mode).w
	bne.s	ObjGrab_CheckCharacter_End
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#AniIDSonAni_Hang2,anim(a1)
	move.b	#1,obj_control(a1)
	move.b	#1,(a2)
; return_2CA08:
ObjGrab_CheckCharacter_End:
	rts
; ===========================================================================

