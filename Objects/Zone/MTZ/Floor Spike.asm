; ===========================================================================
; ---------------------------------------------------------------------------
; Object 6D - Floor spike from MTZ
; ---------------------------------------------------------------------------
floorspike_initial_x_pos =	objoff_30
floorspike_initial_y_pos =	objoff_32
floorspike_offset =		objoff_34 ; on the y axis
floorspike_position =		objoff_36 ; 0 = retracted or expanding, 1 = expanded or retracting
floorspike_waiting =		objoff_38 ; 0 = moving, 1 = waiting
floorspike_delay =		objoff_3A ; short delay before the spike retracts
; Sprite_27794:
ObjFloorSpike:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjFloorSpike_Index(pc,d0.w),d1
	jmp	ObjFloorSpike_Index(pc,d1.w)
; ===========================================================================
; off_277A2:
ObjFloorSpike_Index:	offsetTable
		offsetTableEntry.w ObjFloorSpike_Init	; 0
		offsetTableEntry.w ObjFloorSpike_Main	; 2
; ===========================================================================
; loc_277A6:
ObjFloorSpike_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjSpikyBlock_ObjFloorSpike_MapUnc_27750,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzSpike,1,0),art_tile(a0)
	jsrto	JmpTo31_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#4,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	x_pos(a0),floorspike_initial_x_pos(a0)
	move.w	y_pos(a0),floorspike_initial_y_pos(a0)
	move.b	#$84,collision_flags(a0)
; loc_277E0:
ObjFloorSpike_Main:
	bsr.w	ObjFloorSpike_Action
	moveq	#0,d0
	move.b	floorspike_offset(a0),d0
	neg.w	d0
	add.w	floorspike_initial_y_pos(a0),d0
	move.w	d0,y_pos(a0)
	move.w	floorspike_initial_x_pos(a0),d0
	jmpto	JmpTo2_MarkObjGone2
; ===========================================================================
; loc_277FC:
ObjFloorSpike_Action:
	tst.w	floorspike_delay(a0)
	beq.s	+
	subq.w	#1,floorspike_delay(a0)
	rts
; ---------------------------------------------------------------------------
+
	tst.w	floorspike_waiting(a0)
	beq.s	+
	move.b	(Level_frame_counter+1).w,d0
	sub.b	subtype(a0),d0
	andi.b	#$7F,d0
	bne.s	ObjFloorSpike_Action_End
	clr.w	floorspike_waiting(a0)
+
	tst.w	floorspike_position(a0)
	beq.s	ObjFloorSpike_Expanding
; ObjFloorSpike_Retracting:
	subi.w	#$400,floorspike_offset(a0)
	bcc.s	ObjFloorSpike_Action_End
	move.w	#0,floorspike_offset(a0)
	move.w	#0,floorspike_position(a0)
	move.w	#1,floorspike_waiting(a0)
	rts
; ===========================================================================
; loc_27842:
ObjFloorSpike_Expanding:
	addi.w	#$400,floorspike_offset(a0)
	cmpi.w	#$2000,floorspike_offset(a0)
	blo.s	ObjFloorSpike_Action_End
	move.w	#$2000,floorspike_offset(a0)
	move.w	#1,floorspike_position(a0)
	move.w	#3,floorspike_delay(a0)
; return_27862:
ObjFloorSpike_Action_End:
	rts
; ===========================================================================

