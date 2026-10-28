; ===========================================================================
; ---------------------------------------------------------------------------
; Object 72 - Conveyor belt from CNZ
; ---------------------------------------------------------------------------
; Sprite_2893C:
ObjCNZConveyorBelt:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCNZConveyorBelt_Index(pc,d0.w),d1
	jmp	ObjCNZConveyorBelt_Index(pc,d1.w)
; ===========================================================================
; off_2894A:
ObjCNZConveyorBelt_Index:	offsetTable
		offsetTableEntry.w ObjCNZConveyorBelt_Init	; 0
		offsetTableEntry.w ObjCNZConveyorBelt_Main	; 2
; ===========================================================================
; loc_2894E:
ObjCNZConveyorBelt_Init:
	addq.b	#2,routine(a0)
	move.w	#$30,objoff_3C(a0)
	move.b	subtype(a0),d0
	bpl.s	+
	move.w	#$70,objoff_3C(a0)
+
	andi.b	#$7F,d0
	lsl.b	#4,d0
	move.b	d0,objoff_38(a0)
	move.w	#2,objoff_36(a0)
	btst	#status.npc.x_flip,status(a0)
	beq.s	ObjCNZConveyorBelt_Main
	neg.w	objoff_36(a0)
; loc_28980:
ObjCNZConveyorBelt_Main:
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	ObjCNZConveyorBelt_Action
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	ObjCNZConveyorBelt_Action
	jmpto	JmpTo5_MarkObjGone3
; ===========================================================================
; loc_28990:
ObjCNZConveyorBelt_Action:
	moveq	#0,d2
	move.b	objoff_38(a0),d2
	move.w	d2,d3
	add.w	d3,d3
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d2,d0
	cmp.w	d3,d0
	bhs.s	+	; rts
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	move.w	objoff_3C(a0),d0
	add.w	d0,d1
	cmp.w	d0,d1
	bhs.s	+	; rts
	btst	#status.player.in_air,status(a1)
	bne.s	+	; rts
	move.w	objoff_36(a0),d0
	add.w	d0,x_pos(a1)
+
	rts
; ===========================================================================

