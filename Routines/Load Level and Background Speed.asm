LevelSizeLoad:
	clr.w	(Scroll_flags).w
	clr.w	(Scroll_flags_BG).w
	clr.w	(Scroll_flags_BG2).w
	clr.w	(Scroll_flags_BG3).w
	clr.w	(Scroll_flags_P2).w
	clr.w	(Scroll_flags_BG_P2).w
	clr.w	(Scroll_flags_BG2_P2).w
	clr.w	(Scroll_flags_BG3_P2).w
	clr.w	(Scroll_flags_copy).w
	clr.w	(Scroll_flags_BG_copy).w
	clr.w	(Scroll_flags_BG2_copy).w
	clr.w	(Scroll_flags_BG3_copy).w
	clr.w	(Scroll_flags_copy_P2).w
	clr.w	(Scroll_flags_BG_copy_P2).w
	clr.w	(Scroll_flags_BG2_copy_P2).w
	clr.w	(Scroll_flags_BG3_copy_P2).w
	clr.b	(Deform_lock).w
	clr.b	(Screen_Shaking_Flag_HTZ).w
	clr.b	(Screen_Shaking_Flag).w
	clr.b	(Scroll_lock).w
	clr.b	(Scroll_lock_P2).w
	moveq	#0,d0
	move.b	d0,(Dynamic_Resize_Routine).w ; load level boundaries
    if gameRevision>=2
	move.w	d0,(WFZ_LevEvent_Subrout).w
	move.w	d0,(WFZ_BG_Y_Speed).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	d0,(Camera_BG_Y_offset).w
    endif
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#4,d0
	lea	LevelSize(pc,d0.w),a0
	move.l	(a0)+,d0
	move.l	d0,(Camera_Min_X_pos).w		; Also sets Camera_Max_X_pos.
	move.l	d0,(Camera_Min_X_pos_target).w	; Also sets Camera_Max_X_pos_target.
	move.l	d0,(Tails_Min_X_pos).w		; Also sets Tails_Max_X_pos.
	move.l	(a0)+,d0
	move.l	d0,(Camera_Min_Y_pos).w		; Also sets Camera_Max_Y_pos.
	move.l	d0,(Camera_Min_Y_pos_target).w	; Also sets Camera_Max_Y_pos_target.
	move.l	d0,(Tails_Min_Y_pos).w		; Also sets Tails_Max_Y_pos.
	move.w	#$1010,(Horiz_block_crossed_flag).w
	move.w	#(screen_height/2)-16,(Camera_Y_pos_bias).w
	move.w	#(screen_height/2)-16,(Camera_Y_pos_bias_P2).w
	bra.w	+
; ===========================================================================
; ----------------------------------------------------------------------------
; LEVEL SIZE ARRAY

; This array defines the screen boundaries for each act in the game.
; ----------------------------------------------------------------------------
;				xstart	xend	ystart	yend	; ZID ; Zone
LevelSize: zoneOrderedTable 2,8	; WrdArr_LvlSize
	; EHZ
	zoneTableEntry.w	$0,	$29A0,	$0,	$320	; Act 1
	zoneTableEntry.w	$0,	$2940,	$0,	$420	; Act 2
	; Zone 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; WZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; Zone 3
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; MTZ
	zoneTableEntry.w	$0,	$2280,	-$100,	$800	; Act 1
	zoneTableEntry.w	$0,	$1E80,	-$100,	$800	; Act 2
	; MTZ
	zoneTableEntry.w	$0,	$2A80,	-$100,	$800	; Act 3
	zoneTableEntry.w	$0,	$3FFF,	-$100,	$800	; Act 4
	; WFZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; HTZ
	zoneTableEntry.w	$0,	$2800,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3280,	$0,	$720	; Act 2
	; HPZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; Zone 9
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; OOZ
	zoneTableEntry.w	$0,	$2F80,	$0,	$680	; Act 1
	zoneTableEntry.w	$0,	$2D00,	$0,	$680	; Act 2
	; MCZ
	zoneTableEntry.w	$0,	$2380,	$3C0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$60,	$720	; Act 2
	; CNZ
	zoneTableEntry.w	$0,	$27A0,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; Act 2
	; CPZ
	zoneTableEntry.w	$0,	$2780,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; Act 2
	; DEZ
	zoneTableEntry.w	$0,	$1000,	$C8,	 $C8	; Act 1
	zoneTableEntry.w	$0,	$1000,  $C8,	 $C8	; Act 2
	; ARZ
	zoneTableEntry.w	$0,	$28C0,	$200,	$600	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$180,	$710	; Act 2
	; SCZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$000	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
    zoneTableEnd

; ===========================================================================
+
	tst.b	(Last_star_pole_hit).w		; was a star pole hit yet?
	beq.s	+				; if not, branch
	jsr	(ObjStarpost_LoadData).l		; load the previously saved data
	move.w	(MainCharacter+x_pos).w,d1
	move.w	(MainCharacter+y_pos).w,d0
	bra.s	++
; ===========================================================================
+	; Put the character at the start location for the level
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#5,d0
	lea	StartLocations(pc,d0.w),a1
	moveq	#0,d1
	move.w	(a1)+,d1
	move.w	d1,(MainCharacter+x_pos).w
	moveq	#0,d0
	move.w	(a1),d0
	move.w	d0,(MainCharacter+y_pos).w
+
	subi.w	#$A0,d1
	bcc.s	+
	moveq	#0,d1
+
	move.w	(Camera_Max_X_pos).w,d2
	cmp.w	d2,d1
	blo.s	+
	move.w	d2,d1
+
	move.w	d1,(Camera_X_pos).w
	move.w	d1,(Camera_X_pos_P2).w
	subi.w	#$60,d0
	bcc.s	+
	moveq	#0,d0
+
	cmp.w	(Camera_Max_Y_pos).w,d0
	blt.s	+
	move.w	(Camera_Max_Y_pos).w,d0
+
	move.w	d0,(Camera_Y_pos).w
	move.w	d0,(Camera_Y_pos_P2).w
	bsr.w	InitCameraValues
	rts
; End of function LevelSizeLoad

; ===========================================================================
; --------------------------------------------------------------------------------------
; CHARACTER START LOCATION ARRAY

; 2 entries per act, corresponding to the X and Y locations that you want the player to
; appear at when the level starts.
; --------------------------------------------------------------------------------------
StartLocations: zoneOrderedTable 2,4	; WrdArr_StartLoc
	; EHZ
	zoneTableBinEntry	2, "Levels/EHZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/EHZ/Act 2/Start Position.bin"	; Act 2
	; Zone 1
	zoneTableBinEntry	2, "Levels/Unused/Start Positions/01 1.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/Unused/Start Positions/01 2.bin"	; Act 2
	; WZ
	zoneTableBinEntry	2, "Levels/Unused/WZ/Act 1/Start Position.bin"		; Act 1
	zoneTableBinEntry	2, "Levels/Unused/WZ/Act 2/Start Position.bin"		; Act 2
	; Zone 3
	zoneTableBinEntry	2, "Levels/Unused/Start Positions/03 1.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/Unused/Start Positions/03 2.bin"	; Act 2
	; MTZ
	zoneTableBinEntry	2, "Levels/MTZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/MTZ/Act 2/Start Position.bin"	; Act 2
	; MTZ
	zoneTableBinEntry	2, "Levels/MTZ/Act 3/Start Position.bin"	; Act 3
	zoneTableBinEntry	2, "Levels/MTZ/Act 4/Start Position.bin"	; Act 4
	; WFZ
	zoneTableBinEntry	2, "Levels/WFZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/WFZ/Act 2/Start Position.bin"	; Act 2
	; HTZ
	zoneTableBinEntry	2, "Levels/HTZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/HTZ/Act 2/Start Position.bin"	; Act 2
	; HPZ
	zoneTableBinEntry	2, "Levels/Unused/HPZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/Unused/HPZ/Act 2/Start Position.bin"	; Act 2
	; Zone 9
	zoneTableBinEntry	2, "Levels/Unused/Start Positions/09 1.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/Unused/Start Positions/09 2.bin"	; Act 2
	; OOZ
	zoneTableBinEntry	2, "Levels/OOZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/OOZ/Act 2/Start Position.bin"	; Act 2
	; MCZ
	zoneTableBinEntry	2, "Levels/MCZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/MCZ/Act 2/Start Position.bin"	; Act 2
	; CNZ
	zoneTableBinEntry	2, "Levels/CNZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/CNZ/Act 2/Start Position.bin"	; Act 2
	; CPZ
	zoneTableBinEntry	2, "Levels/CPZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/CPZ/Act 2/Start Position.bin"	; Act 2
	; DEZ
	zoneTableBinEntry	2, "Levels/DEZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/DEZ/Act 2/Start Position.bin"	; Act 2
	; ARZ
	zoneTableBinEntry	2, "Levels/ARZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/ARZ/Act 2/Start Position.bin"	; Act 2
	; SCZ
	zoneTableBinEntry	2, "Levels/SCZ/Act 1/Start Position.bin"	; Act 1
	zoneTableBinEntry	2, "Levels/SCZ/Act 2/Start Position.bin"	; Act 2
    zoneTableEnd

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_C258:
InitCameraValues:
	tst.b	(Last_star_pole_hit).w	; was a star pole hit yet?
	bne.s	+			; if yes, branch
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG2_Y_pos).w
	move.w	d1,(Camera_BG_X_pos).w
	move.w	d1,(Camera_BG2_X_pos).w
	move.w	d1,(Camera_BG3_X_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	move.w	d0,(Camera_BG2_Y_pos_P2).w
	move.w	d1,(Camera_BG_X_pos_P2).w
	move.w	d1,(Camera_BG2_X_pos_P2).w
	move.w	d1,(Camera_BG3_X_pos_P2).w
+
	moveq	#0,d2
	move.b	(Current_Zone).w,d2
	add.w	d2,d2
	move.w	InitCam_Index(pc,d2.w),d2
	jmp	InitCam_Index(pc,d2.w)
; End of function InitCameraValues

; ===========================================================================
; off_C296:
InitCam_Index: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w InitCam_EHZ	; EHZ
	zoneOffsetTableEntry.w InitCam_Null0	; Zone 1
	zoneOffsetTableEntry.w InitCam_WZ	; WZ
	zoneOffsetTableEntry.w InitCam_Null0	; Zone 3
	zoneOffsetTableEntry.w InitCam_Std	; MTZ1,2
	zoneOffsetTableEntry.w InitCam_Std	; MTZ3
	zoneOffsetTableEntry.w InitCam_Null1	; WFZ
	zoneOffsetTableEntry.w InitCam_HTZ	; HTZ
	zoneOffsetTableEntry.w InitCam_HPZ	; HPZ
	zoneOffsetTableEntry.w InitCam_Null2	; Zone 9
	zoneOffsetTableEntry.w InitCam_OOZ	; OOZ
	zoneOffsetTableEntry.w InitCam_MCZ	; MCZ
	zoneOffsetTableEntry.w InitCam_CNZ	; CNZ
	zoneOffsetTableEntry.w InitCam_CPZ	; CPZ
	zoneOffsetTableEntry.w InitCam_Null3	; DEZ
	zoneOffsetTableEntry.w InitCam_ARZ	; ARZ
	zoneOffsetTableEntry.w InitCam_SCZ	; SCZ
    zoneTableEnd
; ===========================================================================
;loc_C2B8:
InitCam_EHZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	clr.l	(Camera_BG2_Y_pos).w
	clr.l	(Camera_BG3_Y_pos).w
	lea	(TempArray_LayerDef).w,a2
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(Camera_BG_X_pos_P2).w
	clr.l	(Camera_BG_Y_pos_P2).w
	clr.l	(Camera_BG2_Y_pos_P2).w
	clr.l	(Camera_BG3_Y_pos_P2).w
	rts
; ===========================================================================
; wtf:
InitCam_Null0:
    if gameRevision=0
	rts
    endif
; ===========================================================================
; Wood_Zone_BG:
InitCam_WZ:
    if gameRevision=0
	asr.w	#2,d0
	addi.w	#$400,d0
	move.w	d0,(Camera_BG_Y_pos).w
	asr.w	#3,d1
	move.w	d1,(Camera_BG_X_pos).w
	rts
    endif
; ===========================================================================
;loc_C2E4:
InitCam_Std:
	asr.w	#2,d0
	move.w	d0,(Camera_BG_Y_pos).w
	asr.w	#3,d1
	move.w	d1,(Camera_BG_X_pos).w
	rts
; ===========================================================================
;return_C2F2:
InitCam_Null1:
	rts
; ===========================================================================
;loc_C2F4:
InitCam_HTZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	clr.l	(Camera_BG2_Y_pos).w
	clr.l	(Camera_BG3_Y_pos).w
	lea	(TempArray_LayerDef).w,a2
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(Camera_BG_X_pos_P2).w
	clr.l	(Camera_BG_Y_pos_P2).w
	clr.l	(Camera_BG2_Y_pos_P2).w
	clr.l	(Camera_BG3_Y_pos_P2).w
	rts
; ===========================================================================
; Hidden_Palace_Zone_BG:
InitCam_HPZ:
    if gameRevision=0
	asr.w	#1,d0
	move.w	d0,(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_X_pos).w
	rts
    endif
; ===========================================================================
; Leftover Spring Yard Zone code from Sonic 1

; Unknown_Zone_BG:
;InitCam_SYZ:
    if gameRevision=0
	asl.l	#4,d0
	move.l	d0,d2
	asl.l	#1,d0
	add.l	d2,d0
	asr.l	#8,d0
	addq.w	#1,d0
	move.w	d0,(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_X_pos).w
	rts
    endif

; ===========================================================================
;return_C320:
InitCam_Null2:
	rts
; ===========================================================================
;loc_C322:
InitCam_OOZ:
	lsr.w	#3,d0
	addi.w	#$50,d0
	move.w	d0,(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_X_pos).w
	rts
; ===========================================================================
;loc_C332:
InitCam_MCZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_X_pos_P2).w
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#$140,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	rts
; ===========================================================================
+
	divu.w	#6,d0
	subi.w	#$10,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	rts
; ===========================================================================
;loc_C364:
InitCam_CNZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_Y_pos_P2).w
	rts
; ===========================================================================
;loc_C372:
InitCam_CPZ:
	lsr.w	#2,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	lsr.w	#1,d1
	move.w	d1,(Camera_BG2_X_pos).w
	lsr.w	#2,d1
	move.w	d1,(Camera_BG_X_pos).w
	rts
; ===========================================================================
;return_C38A:
InitCam_Null3:
	rts
; ===========================================================================
;loc_C38C:
InitCam_ARZ:
	tst.b	(Current_Act).w
	beq.s	+
	subi.w	#$E0,d0
	lsr.w	#1,d0
	move.w	d0,(Camera_BG_Y_pos).w
	bra.s	loc_C3A6
; ===========================================================================
+
	subi.w	#$180,d0
	move.w	d0,(Camera_BG_Y_pos).w

loc_C3A6:
	muls.w	#$119,d1
	asr.l	#8,d1
	move.w	d1,(Camera_BG_X_pos).w
	move.w	d1,(Camera_ARZ_BG_X_pos).w
	clr.w	(Camera_BG_X_pos+2).w
	clr.w	(Camera_ARZ_BG_X_pos+2).w
	clr.l	(Camera_BG2_Y_pos).w
	clr.l	(Camera_BG3_Y_pos).w
	rts
; ===========================================================================
;loc_C3C6:
InitCam_SCZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	rts
