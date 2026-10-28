; ===========================================================================
; ---------------------------------------------------------------------------
; Object 16 - Diagonally moving lift from HTZ
; ---------------------------------------------------------------------------
; Sprite_21DAC:
ObjHTZLift:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjHTZLift_Index(pc,d0.w),d1
	jmp	ObjHTZLift_Index(pc,d1.w)
; ===========================================================================
; off_21DBA:
ObjHTZLift_Index:	offsetTable
		offsetTableEntry.w ObjHTZLift_Init	; 0
		offsetTableEntry.w ObjHTZLift_Main	; 2
; ===========================================================================
; loc_21DBE:
ObjHTZLift_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjHTZLift_MapUnc_21F14,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HtzZipline,2,0),art_tile(a0)
	jsrto	JmpTo14_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#0,mapping_frame(a0)
	move.b	#1,priority(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.b	#$40,y_radius(a0)
	bset	#render_flags.explicit_height,render_flags(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#3,d0
	move.w	d0,objoff_34(a0)
; loc_21E10:
ObjHTZLift_Main:
	move.w	x_pos(a0),-(sp)
	bsr.w	ObjHTZLift_RunSecondaryRoutine
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	#-$28,d3
	move.w	(sp)+,d4
	jsrto	JmpTo3_PlatformObject
	jmpto	JmpTo5_MarkObjGone
; ===========================================================================
; loc_21E2C:
ObjHTZLift_RunSecondaryRoutine:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjHTZLift_Main_States(pc,d0.w),d1
	jmp	ObjHTZLift_Main_States(pc,d1.w)
; ===========================================================================
; off_21E3A:
ObjHTZLift_Main_States: offsetTable
	offsetTableEntry.w ObjHTZLift_Wait	; 0
	offsetTableEntry.w ObjHTZLift_Slide	; 2
	offsetTableEntry.w ObjHTZLift_Fall	; 4
; ===========================================================================
; loc_21E40:
ObjHTZLift_Wait:
	move.b	status(a0),d0	; get the status flags
	andi.b	#standing_mask,d0	; is one of the players standing on it?
	beq.s	++		; if not, branch
	addq.b	#2,routine_secondary(a0)
	move.w	#$200,x_vel(a0)
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	neg.w	x_vel(a0)
+
	move.w	#$100,y_vel(a0)
+
	rts
; ===========================================================================
; loc_21E68:
ObjHTZLift_Slide:
	move.w	(Level_frame_counter).w,d0
	andi.w	#$F,d0	; play the sound only every 16 frames
	bne.s	+
	move.w	#SndID_HTZLiftClick,d0
	jsr	(PlaySound).l
+
	jsrto	JmpTo4_ObjectMove
	subq.w	#1,objoff_34(a0)
	bne.s	+	; rts
	addq.b	#2,routine_secondary(a0)
	move.b	#2,mapping_frame(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	jsrto	JmpTo4_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	#ObjID_Scenery,id(a1) ; load obj1C
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	#6,subtype(a1)
+	rts
; ===========================================================================
; loc_21EC2:
ObjHTZLift_Fall:
	jsrto	JmpTo4_ObjectMove
	addi.w	#$38,y_vel(a0)
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#screen_height,d0
	cmp.w	y_pos(a0),d0
	bhs.s	+++	; rts
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	++
	bclr	#p1_standing_bit,status(a0)
	beq.s	+
	bclr	#status.player.on_object,(MainCharacter+status).w
	bset	#status.player.in_air,(MainCharacter+status).w
+
	bclr	#p2_standing_bit,status(a0)
	beq.s	+
	bclr	#status.player.on_object,(Sidekick+status).w
	bset	#status.player.in_air,(Sidekick+status).w
+
	move.w	#$4000,x_pos(a0)
+
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjHTZLift_MapUnc_21F14:	include "mappings/sprite/obj16.asm"
; ===========================================================================

