; ===========================================================================
; ---------------------------------------------------------------------------
; Object 19 - Platform from CPZ, OOZ and WFZ
; ---------------------------------------------------------------------------
; Sprite_22018:
ObjWFZPlatform:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjWFZPlatform_Index(pc,d0.w),d1
	jmp	ObjWFZPlatform_Index(pc,d1.w)
; ===========================================================================
; off_22026: ObjWFZPlatform_States:
ObjWFZPlatform_Index:	offsetTable
		offsetTableEntry.w ObjWFZPlatform_Init	; 0
		offsetTableEntry.w ObjWFZPlatform_Main	; 2
; ---------------------------------------------------------------------------
; word_2202A:
ObjWFZPlatform_SubtypeProperties:
	;    width_pixels
	;	  mapping_frame
	dc.b $20, 0
	dc.b $18, 1
	dc.b $40, 2
	dc.b $20, 3
; ===========================================================================
; loc_22032:
ObjWFZPlatform_Init:
	addq.b	#2,routine(a0) ; => ObjWFZPlatform_Main
	move.l	#ObjWFZPlatform_MapUnc_2222A,mappings(a0)

	move.w	#make_art_tile(ArtTile_ArtNem_CPZElevator,3,0),art_tile(a0) ; set default art

	cmpi.b	#oil_ocean_zone,(Current_Zone).w ; are we in OOZ?
	bne.s	+			; if not, branch
	move.w	#make_art_tile(ArtTile_ArtNem_OOZElevator,3,0),art_tile(a0) ; set OOZ art
+
	cmpi.b	#wing_fortress_zone,(Current_Zone).w ; are we in WFZ?
	bne.s	+			; if not, branch
	move.w	#make_art_tile(ArtTile_ArtNem_WfzFloatingPlatform,1,1),art_tile(a0) ; set WTZ art
+
	jsrto	JmpTo15_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#3,d0
	andi.w	#$1E,d0
	lea	ObjWFZPlatform_SubtypeProperties(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.b	#4,priority(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_32(a0)
	andi.b	#$F,subtype(a0)
	cmpi.b	#3,subtype(a0)
	bne.s	loc_220AA
	btst	#status.npc.x_flip,status(a0)
	bne.s	loc_220B2

loc_220AA:
	cmpi.b	#7,subtype(a0)
	bne.s	ObjWFZPlatform_Main

loc_220B2:
	subi.w	#$C0,y_pos(a0)

; loc_220B8:
ObjWFZPlatform_Main:
	move.w	x_pos(a0),-(sp)
	bsr.w	ObjWFZPlatform_Move
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	#$11,d3
	move.w	(sp)+,d4
	jsrto	JmpTo4_PlatformObject
	move.w	objoff_30(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo20_DeleteObject
	jmpto	JmpTo11_DisplaySprite

    if removeJmpTos
JmpTo20_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ---------------------------------------------------------------------------
; loc_220E8:
ObjWFZPlatform_Move:
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	add.w	d0,d0
	move.w	ObjWFZPlatform_MoveTypes(pc,d0.w),d1
	jmp	ObjWFZPlatform_MoveTypes(pc,d1.w)
; ===========================================================================
; platform movement routine table
; off_220FC:
ObjWFZPlatform_MoveTypes:offsetTable
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine1		;  0
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine2		;  1
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine3		;  2
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine4		;  3
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine5		;  4
		offsetTableEntry.w ObjWFZPlatform_MoveRoutineNull	;  5
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine6		;  6
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine6		;  7
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine7		;  8
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine7		;  9
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine7		; $A
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine7		; $B
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine8		; $C
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine8		; $D
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine8		; $E
		offsetTableEntry.w ObjWFZPlatform_MoveRoutine8		; $F

; ===========================================================================
; loc_2211C:
ObjWFZPlatform_MoveRoutine1:
	move.b	(Oscillating_Data+8).w,d0
	move.w	#$40,d1
	bra.s	ObjWFZPlatform_MoveRoutine2_Part2

; ===========================================================================
; loc_22126:
ObjWFZPlatform_MoveRoutine2:
	move.b	(Oscillating_Data+$C).w,d0
	move.w	#$60,d1
; loc_2212E:
ObjWFZPlatform_MoveRoutine2_Part2:
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	neg.w	d0
	add.w	d1,d0
+
	move.w	objoff_30(a0),d1
	sub.w	d0,d1
	move.w	d1,x_pos(a0)
	rts

; ===========================================================================
; loc_22146:
ObjWFZPlatform_MoveRoutine3:
	move.b	(Oscillating_Data+$1C).w,d0
	move.w	#$80,d1
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	neg.w	d0
	add.w	d1,d0
+
	move.w	objoff_32(a0),d1
	sub.w	d0,d1
	move.w	d1,y_pos(a0)
	rts

; ===========================================================================
; loc_22166:
ObjWFZPlatform_MoveRoutine4:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+	; rts
	addq.b	#1,subtype(a0)
+	rts

; ===========================================================================
; loc_22176:
ObjWFZPlatform_MoveRoutine5:
	jsrto	JmpTo5_ObjectMove
	moveq	#8,d1
	move.w	objoff_32(a0),d0
	subi.w	#$60,d0
	cmp.w	y_pos(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	bne.s	ObjWFZPlatform_MoveRoutineNull
	addq.b	#1,subtype(a0)

; return_22196:
ObjWFZPlatform_MoveRoutineNull:
	rts

; ===========================================================================
; loc_22198:
ObjWFZPlatform_MoveRoutine6:
	jsrto	JmpTo5_ObjectMove
	moveq	#8,d1
	move.w	objoff_32(a0),d0
	subi.w	#$60,d0
	cmp.w	y_pos(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	rts

; ===========================================================================
; loc_221B4:
ObjWFZPlatform_MoveRoutine7:
	move.b	(Oscillating_Data+$38).w,d1
	subi.b	#$40,d1
	ext.w	d1
	move.b	(Oscillating_Data+$3C).w,d2
	subi.b	#$40,d2
	ext.w	d2
	btst	#2,d0
	beq.s	+
	neg.w	d1
	neg.w	d2
+
	btst	#1,d0
	beq.s	+
	neg.w	d1
	exg	d1,d2
+
	add.w	objoff_30(a0),d1
	move.w	d1,x_pos(a0)
	add.w	objoff_32(a0),d2
	move.w	d2,y_pos(a0)
	rts

; ===========================================================================
; loc_221EE:
ObjWFZPlatform_MoveRoutine8:
	move.b	(Oscillating_Data+$38).w,d1
	subi.b	#$40,d1
	ext.w	d1
	move.b	(Oscillating_Data+$3C).w,d2
	subi.b	#$40,d2
	ext.w	d2
	btst	#2,d0
	beq.s	+
	neg.w	d1
	neg.w	d2
+
	btst	#1,d0
	beq.s	+
	neg.w	d1
	exg	d1,d2
+
	neg.w	d1
	add.w	objoff_30(a0),d1
	move.w	d1,x_pos(a0)
	add.w	objoff_32(a0),d2
	move.w	d2,y_pos(a0)
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjWFZPlatform_MapUnc_2222A:	include "mappings/sprite/obj19.asm"
; ===========================================================================

