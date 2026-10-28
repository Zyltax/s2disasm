EndingSequence:
	clearRAM Object_RAM,Object_RAM_End
	clearRAM Misc_Variables,Misc_Variables_End
	clearRAM Camera_RAM,Camera_RAM_End

	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l

	stopZ80
	dmaFillVRAM 0,VRAM_Plane_A_Name_Table,VRAM_Plane_Table_Size ; clear Plane A pattern name table
	clr.l	(Vscroll_Factor).w
	clr.l	(unk_F61A).w
	startZ80

	lea	(VDP_control_port).l,a6
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8200|(VRAM_EndSeq_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_EndSeq_Plane_B_Name_Table1/$2000),(a6)	; PNT B base: $E000
	move.w	#$8500|(VRAM_Sprite_Attribute_Table/$200),(a6)		; Sprite attribute table base: $F800
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8720,(a6)		; Background palette/color: 2/0
	move.w	#$8ADF,(Hint_counter_reserve).w	; H-INT every 224th scanline
	move.w	(Hint_counter_reserve).w,(a6)
	clr.b	(Super_Sonic_flag).w
	cmpi.b	#7,(Emerald_count).w
	bne.s	+
	cmpi.w	#2,(Player_mode).w
	beq.s	+
	st.b	(Super_Sonic_flag).w
	move.b	#-1,(Super_Sonic_palette).w
	move.b	#$F,(Palette_timer).w
	move.w	#$30,(Palette_frame).w
+
	moveq	#0,d0
	cmpi.w	#2,(Player_mode).w
	beq.s	+
	tst.b	(Super_Sonic_flag).w
	bne.s	++
	bra.w	+++

; ===========================================================================
+
	addq.w	#2,d0
+
	addq.w	#2,d0
+
	move.w	d0,(Ending_Routine).w
	bsr.w	EndingSequence_LoadCharacterArt
	bsr.w	EndingSequence_LoadFlickyArt
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingFinalTornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingFinalTornado).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingPics),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingPics).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingMiniTornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingMiniTornado).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Tornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Tornado).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Clouds),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Clouds).l,a0
	jsrto	JmpTo_NemDec
	move.w	#death_egg_zone_act_1,(Current_ZoneAndAct).w
	move	#$2300,sr
	moveq	#signextendB(MusID_Ending),d0
	jsrto	JmpTo2_PlayMusic
	move.l	#$EEE0EEE,d1
	lea	(Normal_palette).w,a1

	moveq	#bytesToLcnt(palette_line_size*4),d0
-	move.l	d1,(a1)+
	dbf	d0,-

	lea	(Pal_AC7E).l,a1
	lea	(Target_palette).w,a2

	moveq	#bytesToLcnt(palette_line_size*4),d0
-	move.l	(a1)+,(a2)+
	dbf	d0,-

	clr.b	(Screen_Shaking_Flag).w
	moveq	#0,d0
	move.w	d0,(Debug_placement_mode).w
	move.w	d0,(Level_Inactive_flag).w
	move.w	d0,(Level_frame_counter).w
	move.w	d0,(Camera_X_pos).w
	move.w	d0,(Camera_Y_pos).w
	move.w	d0,(Camera_X_pos_copy).w
	move.w	d0,(Camera_Y_pos_copy).w
	move.w	d0,(Camera_BG_X_pos).w
	move.w	#$C8,(Camera_BG_Y_pos).w
	move.l	d0,(Vscroll_Factor).w
	move.b	d0,(Horiz_block_crossed_flag_BG).w
	move.b	d0,(Verti_block_crossed_flag_BG).w
	move.w	d0,(Ending_VInt_Subrout).w
	move.w	d0,(Credits_Trigger).w

    if fixBugs
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len
    else
	; The '+4' shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len+4
    endif

	move.w	#$7FFF,(PalCycle_Timer).w
	lea	(CutScene).w,a1
	move.b	#ObjID_CutScene,id(a1) ; load objCA (end of game cutscene) at $FFFFB100
	move.b	#6,routine(a1)
	move.w	#$60,objoff_3C(a1)
	move.w	#1,objoff_30(a1)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	move.w	#$10,objoff_2E(a1)
	move.w	#$100,objoff_3C(a1)
+
	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
-
	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	addq.w	#1,(Level_frame_counter).w
	jsr	(RandomNumber).l
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	tst.b	(Ending_PalCycle_flag).w
	beq.s	+
	jsrto	JmpTo_PalCycle_Load
+
	bsr.w	EndgameCredits
	tst.w	(Level_Inactive_flag).w
	beq.w	-
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_9EF4
EndgameCredits:
	tst.b	(Credits_Trigger).w
	beq.w	.return
	bsr.w	Pal_FadeToBlack
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_EndSeq_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_EndSeq_Plane_B_Name_Table1/$2000),(a6)	; PNT B base: $E000
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$9200,(a6)		; Disable window
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	clr.b	(Water_fullscreen_flag).w
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	jsrto	JmpTo_ClearScreen

	clearRAM Object_Display_Lists,Object_Display_Lists_End
	clearRAM Object_RAM,Object_RAM_End
	clearRAM Misc_Variables,Misc_Variables_End
	clearRAM Camera_RAM,Camera_RAM_End

	clr.b	(Screen_Shaking_Flag).w
	moveq	#0,d0
	move.w	d0,(Level_Inactive_flag).w
	move.w	d0,(Level_frame_counter).w
	move.w	d0,(Camera_X_pos).w
	move.w	d0,(Camera_Y_pos).w
	move.w	d0,(Camera_X_pos_copy).w
	move.w	d0,(Camera_Y_pos_copy).w
	move.w	d0,(Camera_BG_X_pos).w
	move.w	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Vscroll_Factor).w
	move.b	d0,(Horiz_block_crossed_flag_BG).w
	move.b	d0,(Verti_block_crossed_flag_BG).w
	move.w	d0,(Ending_VInt_Subrout).w
	move.w	d0,(Credits_Trigger).w

    if fixBugs
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len
    else
	; The '+4' shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len+4
    endif

	moveq	#signextendB(MusID_Credits),d0
	jsrto	JmpTo2_PlaySound
	clr.w	(Target_palette).w
	move.w	#$EEE,(Target_palette+$C).w
	move.w	#$EE,(Target_palette_line2+$C).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_CreditText_CredScr),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_CreditText).l,a0
	jsrto	JmpTo_NemDec
	clr.w	(CreditsScreenIndex).w
-
	jsrto	JmpTo_ClearScreen
	bsr.w	ShowCreditsScreen
	bsr.w	Pal_FadeFromBlack

	; Here's how to calculate new duration values for the below instructions.
	; Each slide of the credits is displayed for $18E frames at 60 FPS, or $144 frames at 50 FPS.
	; We also need to take into account how many frames the fade-in/fade-out take: which is $16 each.
	; Also, there are 21 slides to display.
	; That said, by doing '($18E+$16+$16)*21', we get the total number of frames it takes until
	; the credits reach the Sonic 2 splash (which is technically not an actual slide in the credits).
	; Dividing this by 60 will give us how many seconds it takes. The result being 154.7.
	; Doing the same for 50 FPS, by dividing the result of '($144+$16+$16)*21' by 50, will give us 154.56.
	; Now that we have the time it should take for the credits to end, we can adjust the calculation to account
	; for any slides we may have added. For example, if you added a slide, bringing the total to 22,
	; performing '((154.7*60)/22)-($16+$16)' will give you the new value to put in the 'move.w' instruction below.
	move.w	#$18E,d0
	btst	#6,(Graphics_Flags).w
	beq.s	+
	move.w	#$144,d0

/	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	dbf	d0,-

	bsr.w	Pal_FadeToBlack
	lea	(off_B2CA).l,a1
	addq.w	#1,(CreditsScreenIndex).w
	move.w	(CreditsScreenIndex).w,d0
	lsl.w	#2,d0
	move.l	(a1,d0.w),d0
	bpl.s	--
	bsr.w	Pal_FadeToBlack
	jsrto	JmpTo_ClearScreen
	move.l	#vdpComm($0000,VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingTitle).l,a0
	jsrto	JmpTo_NemDec
	lea	(MapEng_EndGameLogo).l,a0
	lea	(Chunk_Table).l,a1
	move.w	#0,d0
	jsrto	JmpTo_EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLoc(64,12,11),VRAM,WRITE),d0
	moveq	#16-1,d1
	moveq	#6-1,d2
	jsrto	JmpTo2_PlaneMapToVRAM_H40
	clr.w	(CreditsScreenIndex).w
	bsr.w	EndgameLogoFlash

	move.w	#$3B,d0
-	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	dbf	d0,-

	move.w	#$257,d6
-	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	addq.w	#1,(CreditsScreenIndex).w
	bsr.w	EndgameLogoFlash
	cmpi.w	#$5E,(CreditsScreenIndex).w
	blo.s	-
	move.b	(Ctrl_1_Press).w,d1
	andi.b	#button_B_mask|button_C_mask|button_A_mask|button_start_mask,d1
	bne.s	+
	dbf	d6,-
+
	st.b	(Level_Inactive_flag).w
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen

.return:
	rts
; End of function EndgameCredits


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_A0C0
EndgameLogoFlash:
	lea	(Normal_palette+2).w,a2
	move.w	(CreditsScreenIndex).w,d0
	cmpi.w	#$24,d0
	bhs.s	EndgameCredits.return
	btst	#0,d0
	bne.s	EndgameCredits.return
	lsr.w	#1,d0
	move.b	byte_A0EC(pc,d0.w),d0
	mulu.w	#$18,d0
	lea	pal_A0FE(pc,d0.w),a1

	moveq	#5,d0
-	move.l	(a1)+,(a2)+
	dbf	d0,-

	rts
; End of function EndgameLogoFlash

; ===========================================================================
byte_A0EC:
	dc.b   0
	dc.b   1	; 1
	dc.b   2	; 2
	dc.b   3	; 3
	dc.b   4	; 4
	dc.b   3	; 5
	dc.b   2	; 6
	dc.b   1	; 7
	dc.b   0	; 8
	dc.b   5	; 9
	dc.b   6	; 10
	dc.b   7	; 11
	dc.b   8	; 12
	dc.b   7	; 13
	dc.b   6	; 14
	dc.b   5	; 15
	dc.b   0	; 16
	dc.b   0	; 17
	even

; palette cycle for the end-of-game logo
pal_A0FE:	BINCLUDE	"art/palettes/Ending Cycle.bin"

; ===========================================================================
; ----------------------------------------------------------------------------
; Object CA - Cut scene at end of game
; ----------------------------------------------------------------------------
; Sprite_A1D6:
ObjCutScene:
	addq.w	#1,objoff_32(a0)
	; Branch if Tails...
	cmpi.w	#4,(Ending_Routine).w
	beq.s	+
	; ...and branch if not Super Sonic, making the first check redundant.
	; Was Sonic's ending originally *always* going to feature Super Sonic?
	cmpi.w	#2,(Ending_Routine).w
	bne.s	+
	st.b	(Super_Sonic_flag).w
	move.w	#$100,(Ring_count).w
	move.b	#-1,(Super_Sonic_palette).w
+
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCutScene_Index(pc,d0.w),d1
	jmp	ObjCutScene_Index(pc,d1.w)
; ===========================================================================
; off_A208:
ObjCutScene_Index:	offsetTable
		offsetTableEntry.w ObjCutScene_Init	;  0
		offsetTableEntry.w loc_A240	;  2
		offsetTableEntry.w loc_A24E	;  4
		offsetTableEntry.w loc_A240	;  6
		offsetTableEntry.w loc_A256	;  8
		offsetTableEntry.w loc_A30A	; $A
		offsetTableEntry.w loc_A34C	; $C
		offsetTableEntry.w loc_A38E	; $E
; ===========================================================================
; loc_A218:
ObjCutScene_Init:
	moveq	#4,d0
	move.w	#$180,d1
	btst	#6,(Graphics_Flags).w
	beq.s	sub_A22A
	move.w	#$100,d1

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_A22A:

	lea	(EndSeqPaletteChanger).w,a1
	move.b	#ObjID_TtlScrPalChanger,id(a1) ; load objC9 (palette change handler) at $FFFFB0C0
	move.b	d0,subtype(a1)
	addq.b	#2,routine(a0)
	move.w	d1,objoff_3C(a0)
	rts
; End of function sub_A22A

; ===========================================================================

loc_A240:
	subq.w	#1,objoff_3C(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine(a0)
	rts
; ===========================================================================

loc_A24E:
	moveq	#6,d0
	move.w	#$80,d1
	bra.s	sub_A22A
; ===========================================================================

loc_A256:
	move.w	objoff_2E(a0),d0
	cmpi.w	#$10,d0
	bhs.s	+
	addq.w	#4,objoff_2E(a0)
	clr.b	routine(a0)
	move.l	a0,-(sp)
	movea.l	off_A29C(pc,d0.w),a0
	lea	(Chunk_Table).l,a1
	move.w	#make_art_tile(ArtTile_ArtNem_EndingPics,0,0),d0
	jsrto	JmpTo_EniDec
	move	#$2700,sr
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table + planeLoc(64,14,8),VRAM,WRITE),d0
	moveq	#12-1,d1
	moveq	#9-1,d2
	jsrto	JmpTo2_PlaneMapToVRAM_H40
	move	#$2300,sr
	movea.l	(sp)+,a0 ; load 0bj address
	rts
; ===========================================================================
off_A29C:
	dc.l MapEng_Ending1
	dc.l MapEng_Ending2
	dc.l MapEng_Ending3
	dc.l MapEng_Ending4
; ===========================================================================
+
	move.w	#2,(Ending_VInt_Subrout).w
	st.b	(Control_Locked).w
	st.b	(Ending_PalCycle_flag).w
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ending_Routine).w,d0
	move.w	ObjCutScene_State5_States(pc,d0.w),d0
	jsr	ObjCutScene_State5_States(pc,d0.w)
	move.w	#$80,d1
	bsr.w	sub_A22A
	move.w	#$40,objoff_3C(a0)
	rts
; ===========================================================================
ObjCutScene_State5_States:	offsetTable
	offsetTableEntry.w loc_A2E0	; 0
	offsetTableEntry.w loc_A2EE	; 2
	offsetTableEntry.w loc_A2F2	; 4
; ===========================================================================

loc_A2E0:
	moveq	#8,d0
-
	move.b	#ObjID_Sonic,id(a1) ; load Sonic object
	move.b	#$81,obj_control(a1)
	rts
; ===========================================================================

loc_A2EE:
	moveq	#$C,d0
	bra.s	-
; ===========================================================================

loc_A2F2:
	moveq	#$E,d0
	move.b	#ObjID_Tails,id(a1) ; load Tails object
	move.b	#$81,obj_control(a1)
	move.b	#ObjID_TailsTails,(Tails_Tails_Cutscene+id).w ; load ObjTailsTails (Tails' tails) at $FFFFB080
	move.w	a1,(Tails_Tails_Cutscene+parent).w
	rts
; ===========================================================================

loc_A30A:
	subq.w	#1,objoff_3C(a0)
	bpl.s	+
	moveq	#$A,d0
	move.w	#$80,d1
	bsr.w	sub_A22A
	move.w	#$C0,objoff_3C(a0)
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	#AniIDSonAni_Float2,anim(a1)
	move.w	#$A0,x_pos(a1)
	move.w	#$50,y_pos(a1)
	cmpi.w	#2,(Ending_Routine).w
	bne.s	+	; rts
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.w	#$1000,inertia(a1)
+
	rts
; ===========================================================================

loc_A34C:
	subq.w	#1,objoff_3C(a0)
	bmi.s	+
	moveq	#0,d4
	moveq	#0,d5
	move.w	#0,(Camera_X_pos_diff).w
	move.w	#$100,(Camera_Y_pos_diff).w
	bra.w	SwScrl_DEZ
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#$100,objoff_3C(a0)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	return_A38C
	move.w	#$880,objoff_3C(a0)
	btst	#6,(Graphics_Flags).w
	beq.s	return_A38C
	move.w	#$660,objoff_3C(a0)

return_A38C:
	rts
; ===========================================================================

loc_A38E:
	btst	#6,(Graphics_Flags).w
	beq.s	+
	cmpi.w	#$E40,objoff_32(a0)
	beq.s	loc_A3BE
	bra.w	++
; ===========================================================================
+
	cmpi.w	#$1140,objoff_32(a0)
	beq.s	loc_A3BE
+
	subq.w	#1,objoff_3C(a0)
	bne.s	+
	lea	(ChildObject_AD62).l,a2
	jsrto	JmpTo_LoadChildObject
+
	bra.w	loc_AB9C
; ===========================================================================

loc_A3BE:
	addq.b	#2,routine(a0)
	st.b	(Credits_Trigger).w
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object CC - Trigger for rescue plane and birds from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A3C8:
ObjEndingSeqTrigger:
	jsrto	JmpTo_ObjTornado_Animate_Pilot
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjEndingSeqTrigger_Index(pc,d0.w),d1
	jmp	ObjEndingSeqTrigger_Index(pc,d1.w)
; ===========================================================================
; loc_A3DA:
ObjEndingSeqTrigger_Index:	offsetTable
		offsetTableEntry.w ObjEndingSeqTrigger_Init	; 0
		offsetTableEntry.w ObjEndingSeqTrigger_Main	; 2
; ===========================================================================
; loc_A3DE:
ObjEndingSeqTrigger_Init:
	lea	(ObjTornado_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.b	#4,mapping_frame(a0)
	move.b	#1,anim(a0)
+
	move.w	#-$10,x_pos(a0)
	move.w	#$C0,y_pos(a0)
	move.w	#$100,x_vel(a0)
	move.w	#-$80,y_vel(a0)
	move.b	#$14,objoff_35(a0)
	move.b	#3,priority(a0)
	move.w	#4,(Ending_VInt_Subrout).w
	move.l	a0,-(sp)
	lea	(MapEng_EndingTailsPlane).l,a0
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	lea	(MapEng_EndingSonicPlane).l,a0
+
	lea	(Chunk_Table).l,a1
	move.w	#make_art_tile(ArtTile_ArtNem_EndingFinalTornado,0,1),d0
	jsrto	JmpTo_EniDec
	movea.l	(sp)+,a0 ; load 0bj address
	move.w	#$C00,(Normal_palette_line3).w
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
; loc_A456:
ObjEndingSeqTrigger_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjEndingSeqTrigger_State2_States(pc,d0.w),d1
	jsr	ObjEndingSeqTrigger_State2_States(pc,d1.w)
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
ObjEndingSeqTrigger_State2_States: offsetTable
	offsetTableEntry.w loc_A474	;  0
	offsetTableEntry.w loc_A4B6	;  2
	offsetTableEntry.w loc_A5A6	;  4
	offsetTableEntry.w loc_A6C6	;  6
	offsetTableEntry.w loc_A7DE	;  8
	offsetTableEntry.w loc_A83E	; $A
; ===========================================================================

loc_A474:
	cmpi.w	#$A0,x_pos(a0)
	beq.s	+
	jsrto	JmpTo2_ObjectMove
-
	lea	(Ani_objB2_a).l,a1
	jmpto	JmpTo_AnimateSprite
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$480,objoff_3C(a0)
	btst	#6,(Graphics_Flags).w
	beq.s	+
	move.w	#$3D0,objoff_3C(a0)
+
	move.w	#$40,objoff_32(a0)
	st.b	(CutScene+objoff_34).w
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	bra.s	-
; ===========================================================================

loc_A4B6:
	bsr.w	sub_ABBA
	bsr.w	sub_A524
	subq.w	#1,objoff_3C(a0)
	bmi.s	+
	bra.s	-
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#2,objoff_3C(a0)
	clr.w	objoff_32(a0)
	clr.b	mapping_frame(a0)
	cmpi.w	#2,(Ending_Routine).w
	beq.s	+
	move.b	#7,mapping_frame(a0)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	move.b	#$18,mapping_frame(a0)
+
	clr.b	anim(a0)
	clr.b	anim_frame(a0)
	clr.b	anim_frame_duration(a0)
	move.l	#ObjTornadoHelixes_MapUnc_ADA2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsr	(Adjust2PArtPointer).l
	subi.w	#$14,x_pos(a0)
	addi.w	#$14,y_pos(a0)
	bra.w	sub_A58C

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_A524:
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ending_Routine).w,d0
	move.w	off_A534(pc,d0.w),d0
	jmp	off_A534(pc,d0.w)
; End of function sub_A524

; ===========================================================================
off_A534:	offsetTable
		offsetTableEntry.w loc_A53A	; 0
		offsetTableEntry.w loc_A55C	; 2
		offsetTableEntry.w loc_A582	; 4
; ===========================================================================

loc_A53A:
	move.w	y_pos(a0),d0
	subi.w	#$1C,d0
-
	move.w	d0,y_pos(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.l	#(1<<24)|(0<<16)|(AniIDSonAni_Wait<<8)|(AniIDSonAni_Wait<<0),mapping_frame(a1)
	move.w	#$100,anim_frame_duration(a1)
	rts
; ===========================================================================

loc_A55C:
	tst.w	objoff_32(a0)
	beq.s	+
	subq.w	#1,objoff_32(a0)
	addi.l	#$8000,x_pos(a1)
	addq.w	#1,y_pos(a1)
	rts
; ===========================================================================
+
	move.w	#$C0,x_pos(a1)
	move.w	#$90,y_pos(a1)
	rts
; ===========================================================================

loc_A582:
	move.w	y_pos(a0),d0
	subi.w	#$18,d0
	bra.s	-

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_A58C:
	tst.b	(Super_Sonic_flag).w
	bne.w	return_A38C

loc_A594:
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	#$200,x_pos(a1)
	move.w	#0,y_pos(a1)
	rts
; End of function sub_A58C

; ===========================================================================

loc_A5A6:
	bsr.s	sub_A58C
	subq.w	#1,objoff_3C(a0)
	bpl.s	+	; rts
	move.w	#2,objoff_3C(a0)
	move.w	objoff_32(a0),d0
	cmpi.w	#$1C,d0
	bhs.s	++
	addq.w	#1,objoff_32(a0)
	move.w	(Ending_Routine).w,d1
	move.w	off_A5FC(pc,d1.w),d1
	lea	off_A5FC(pc,d1.w),a1
	move.b	(a1,d0.w),mapping_frame(a0)
	add.w	d0,d0
	add.w	d0,d0
	move.l	word_A656(pc,d0.w),d1
	move.w	d1,y_pos(a0)
	swap	d1
	move.w	d1,x_pos(a0)
+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_3C(a0)
	clr.b	objoff_31(a0)
	clr.w	objoff_32(a0)
	rts
; ===========================================================================
off_A5FC:	offsetTable
		offsetTableEntry.w byte_A602	; 0
		offsetTableEntry.w byte_A61E	; 2
		offsetTableEntry.w byte_A63A	; 4
byte_A602:
	dc.b   7,  7,  7,  7,  8,  8,  8,  8,  8,  8,  8,  9,  9,  9, $A, $A
	dc.b  $A, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B; 16
byte_A61E:
	dc.b   0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  3,  3
	dc.b   3,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4; 16
byte_A63A:
	dc.b $18,$18,$18,$18,$19,$19,$19,$19,$19,$19,$19,  9,  9,  9, $A, $A
	dc.b  $A, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B; 16
	even
word_A656:
	dc.w   $A0,  $70,  $B0,  $70,  $B6,  $71,  $BC,  $72
	dc.w   $C4,  $74,  $C8,  $75,  $CA,  $76,  $CC,  $77; 8
	dc.w   $CE,  $78,  $D0,  $79,  $D2,  $7A,  $D4,  $7B; 16
	dc.w   $D6,  $7C,  $D9,  $7E,  $DC,  $81,  $DE,  $84; 24
	dc.w   $E1,  $87,  $E4,  $8B,  $E7,  $8F,  $EC,  $94; 32
	dc.w   $F0,  $99,  $F5,  $9D,  $F9,  $A4, $100,  $AC; 40
	dc.w  $108,  $B8, $112,  $C4, $11F,  $D3, $12C,  $FA; 48
; ===========================================================================

loc_A6C6:
	subq.w	#1,objoff_3C(a0)
	bmi.s	loc_A720
	tst.b	(Super_Sonic_flag).w
	beq.s	+	; rts
	subq.b	#1,objoff_31(a0)
	bpl.s	+	; rts
	addq.b	#3,objoff_31(a0)
	move.w	objoff_32(a0),d0
	addq.w	#4,objoff_32(a0)
	cmpi.w	#$78,d0
	bhs.s	+	; rts
	cmpi.w	#$C,d0
	blo.s	++
	bsr.w	loc_A594
	move.l	word_A766(pc,d0.w),d1
	move.w	d1,y_pos(a0)
	swap	d1
	move.w	d1,x_pos(a0)
	lsr.w	#2,d0
	move.b	byte_A748(pc,d0.w),mapping_frame(a0)
+
	rts
; ===========================================================================
+
	move.l	word_A766(pc,d0.w),d0
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	d0,y_pos(a1)
	swap	d0
	move.w	d0,x_pos(a1)
	rts
; ===========================================================================

loc_A720:
	addq.b	#2,routine_secondary(a0)
	clr.w	objoff_3C(a0)
	clr.w	objoff_32(a0)
	lea	(ChildObject_AD6E).l,a2
	jsrto	JmpTo_LoadChildObject
	tst.b	(Super_Sonic_flag).w
	bne.w	return_A38C
	lea	(ChildObject_AD6A).l,a2
	jmpto	JmpTo_LoadChildObject
; ===========================================================================
byte_A748:
	dc.b $12,$12,$12,$12,$12,$12,$12,$13,$13,$13,$13,$13,$13,$14,$14,$14
	dc.b $14,$15,$15,$15,$16,$16,$16,$16,$16,$16,$16,$16,$16,  0; 16
	even
word_A766:
	dc.w   $C0, $90	; 1
	dc.w   $B0, $91	; 3
	dc.w   $A8, $92	; 5
	dc.w   $9B, $96	; 7
	dc.w   $99, $98	; 9
	dc.w   $98, $99	; 11
	dc.w   $99, $9A	; 13
	dc.w   $9B, $9C	; 15
	dc.w   $9F, $9E	; 17
	dc.w   $A4, $A0	; 19
	dc.w   $AC, $A2	; 21
	dc.w   $B7, $A5	; 23
	dc.w   $C4, $A8	; 25
	dc.w   $D3, $AB	; 27
	dc.w   $DE, $AE	; 29
	dc.w   $E8, $B0	; 31
	dc.w   $EF, $B2	; 33
	dc.w   $F4, $B5	; 35
	dc.w   $F9, $B8	; 37
	dc.w   $FC, $BB	; 39
	dc.w   $FE, $BE	; 41
	dc.w   $FF, $C0	; 43
	dc.w  $100, $C2	; 45
	dc.w  $101, $C5	; 47
	dc.w  $102, $C8	; 49
	dc.w  $102, $CC	; 51
	dc.w  $101, $D1	; 53
	dc.w   $FD, $D7	; 55
	dc.w   $F9, $DE	; 57
	dc.w   $F9,$118	; 59
; ===========================================================================

loc_A7DE:
	bsr.w	loc_A594
	subq.w	#1,objoff_3C(a0)
	bpl.s	+	; rts
	move.w	#2,objoff_3C(a0)
	move.w	objoff_32(a0),d0
	cmpi.w	#$1C,d0
	bhs.s	++
	addq.w	#4,objoff_32(a0)
	lea	word_A822(pc,d0.w),a1
	move.w	(a1)+,d0
	add.w	d0,(Horiz_Scroll_Buf).w
	move.w	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	bset	#status.npc.p1_standing,status(a0)
	clr.b	objoff_31(a0)
	clr.w	objoff_32(a0)
	rts
; ===========================================================================
word_A822:
	dc.w  -$3A
	dc.w   $88	; 1
	dc.w   -$C	; 2
	dc.w   $22	; 3
	dc.w	-8	; 4
	dc.w   $10	; 5
	dc.w	-4	; 6
	dc.w	 8	; 7
	dc.w	-2	; 8
	dc.w	 4	; 9
	dc.w	-1	; 10
	dc.w	 2	; 11
	dc.w	-1	; 12
	dc.w	 2	; 13
; ===========================================================================

loc_A83E:
	tst.b	(Super_Sonic_flag).w
	beq.w	return_A38C
	move.b	#$17,mapping_frame(a0)
	subq.b	#1,objoff_31(a0)
	bpl.s	+	; rts
	addq.b	#3,objoff_31(a0)
	move.w	objoff_32(a0),d0
	cmpi.w	#$20,d0
	bhs.s	+	; rts
	addq.w	#4,objoff_32(a0)
	move.l	word_A874(pc,d0.w),d1
	move.w	d1,y_pos(a0)
	swap	d1
	move.w	d1,x_pos(a0)
+
	rts
; ===========================================================================
word_A874:
	dc.w   $60,$88	; 1
	dc.w   $50,$68	; 3
	dc.w   $44,$46	; 5
	dc.w   $3C,$36	; 7
	dc.w   $36,$2A	; 9
	dc.w   $33,$24	; 11
	dc.w   $31,$20	; 13
	dc.w   $30,$1E	; 15

; ===========================================================================
; ----------------------------------------------------------------------------
; Object CE - Sonic and Tails jumping off the plane from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A894:
ObjEndingSeqTails:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjEndingSeqTails_Index(pc,d0.w),d1
	jmp	ObjEndingSeqTails_Index(pc,d1.w)
; ===========================================================================
; off_A8A2:
ObjEndingSeqTails_Index:	offsetTable
		offsetTableEntry.w ObjEndingSeqTails_Init				; 0
		offsetTableEntry.w loc_A902				; 2
		offsetTableEntry.w loc_A936				; 4
		offsetTableEntry.w BranchTo_JmpTo5_DisplaySprite	; 6
; ===========================================================================
; loc_A8AA:
ObjEndingSeqTails_Init:
	lea	(ObjCloud_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	move.l	#ObjTornadoHelixes_MapUnc_ADA2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,1),art_tile(a0)
	move.b	#1,priority(a0)
	jsr	(Adjust2PArtPointer).l
	move.b	#$C,mapping_frame(a0)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	move.b	#$F,mapping_frame(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,1,1),art_tile(a0)
+
	move.w	#$E8,d0
	move.w	d0,x_pos(a0)
	move.w	d0,objoff_30(a0)
	move.w	#$118,d0
	move.w	d0,y_pos(a0)
	move.w	d0,objoff_32(a0)
	rts
; ===========================================================================

loc_A902:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_standing,status(a1)
	bne.s	+

loc_A90E:
	move.w	objoff_30(a0),d0
	add.w	(Horiz_Scroll_Buf).w,d0
	move.w	d0,x_pos(a0)
	move.w	objoff_32(a0),d0
	sub.w	(Vscroll_Factor_FG).w,d0
	move.w	d0,y_pos(a0)

BranchTo_JmpTo5_DisplaySprite ; BranchTo
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
+
	addq.b	#2,routine(a0)
	clr.w	objoff_3C(a0)
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================

loc_A936:
	subq.w	#1,objoff_3C(a0)
	bpl.s	BranchTo2_JmpTo5_DisplaySprite
	move.w	#4,objoff_3C(a0)
	move.w	objoff_34(a0),d0
	cmpi.w	#4,d0
	bhs.s	++
	addq.w	#2,objoff_34(a0)
	lea	byte_A980(pc,d0.w),a1
	cmpi.w	#2,(Ending_Routine).w
	bne.s	+
	lea	byte_A984(pc,d0.w),a1
+
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d0,x_pos(a0)
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d0,y_pos(a0)
	addq.b	#1,mapping_frame(a0)

BranchTo2_JmpTo5_DisplaySprite ; BranchTo
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
+
	addq.b	#2,routine(a0)
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
byte_A980:
	dc.b   -8,   0
	dc.b -$44,-$38	; 2
byte_A984:
	dc.b   -8,   0
	dc.b -$50,-$40	; 2
; ===========================================================================
; ----------------------------------------------------------------------------
; Object CF - "Plane's helixes" from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A988:
ObjTornadoHelixes:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjTornadoHelixes_Index(pc,d0.w),d1
	jmp	ObjTornadoHelixes_Index(pc,d1.w)
; ===========================================================================
; off_A996:
ObjTornadoHelixes_Index:	offsetTable
		offsetTableEntry.w ObjTornadoHelixes_Init		; 0
		offsetTableEntry.w ObjTornadoHelixes_Animate	; 2
; ===========================================================================
; loc_A99A:
ObjTornadoHelixes_Init:
	lea	(ObjCloud_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	move.l	#ObjTornadoHelixes_MapUnc_ADA2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,1),art_tile(a0)
	move.b	#3,priority(a0)
	jsr	(Adjust2PArtPointer).l
	move.b	#5,mapping_frame(a0)
	move.b	#2,anim(a0)
	move.w	#$10F,d0
	move.w	d0,x_pos(a0)
	move.w	d0,objoff_30(a0)
	move.w	#$15E,d0
	move.w	d0,y_pos(a0)
	move.w	d0,objoff_32(a0)
	rts
; ===========================================================================
; loc_A9E4:
ObjTornadoHelixes_Animate:
	lea	(Ani_objCF).l,a1
	jsrto	JmpTo_AnimateSprite
	bra.w	loc_A90E
; ===========================================================================
; ----------------------------------------------------------------------------
; Object CB - Background clouds from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A9F2:
ObjEndingSeqClouds:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjEndingSeqClouds_Index(pc,d0.w),d1
	jmp	ObjEndingSeqClouds_Index(pc,d1.w)
; ===========================================================================
; off_AA00:
ObjEndingSeqClouds_Index:	offsetTable
		offsetTableEntry.w ObjEndingSeqClouds_Init	; 0
		offsetTableEntry.w loc_AA76	; 2
		offsetTableEntry.w loc_AA8A	; 4
; ===========================================================================
; loc_AA06:
ObjEndingSeqClouds_Init:
	lea	(ObjCloud_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	move.w	art_tile(a0),d0
	andi.w	#$1FFF,d0
	ori.w	#palette_mask,d0
	move.w	d0,art_tile(a0)
	move.b	#$30,width_pixels(a0)
	move.l	(RNG_seed).w,d0
	ror.l	#1,d0
	move.l	d0,(RNG_seed).w
	move.w	d0,d1
	andi.w	#3,d0
	move.b	ObjEndingSeqClouds_Frames(pc,d0.w),mapping_frame(a0)
	add.w	d0,d0
	move.w	ObjEndingSeqClouds_YSpeeds(pc,d0.w),y_vel(a0)
	tst.b	(CutScene+$34).w
	beq.s	+
	andi.w	#$FF,d1
	move.w	d1,y_pos(a0)
	move.w	#$150,x_pos(a0)
	rts
; ===========================================================================
+
	andi.w	#$1FF,d1
	move.w	d1,x_pos(a0)
	move.w	#$100,y_pos(a0)
	rts
; ===========================================================================
; byte_AA6A:
ObjEndingSeqClouds_Frames:
	dc.b   0
	dc.b   1	; 1
	dc.b   2	; 2
	dc.b   0	; 3
	even
; word_AA6E:
ObjEndingSeqClouds_YSpeeds:
	dc.w -$300
	dc.w -$200	; 1
	dc.w -$100	; 2
	dc.w -$300	; 3
; ===========================================================================

loc_AA76:
	tst.b	(CutScene+objoff_34).w
	beq.s	loc_AA8A
	addq.b	#2,routine(a0)
	move.w	y_vel(a0),x_vel(a0)
	clr.w	y_vel(a0)

loc_AA8A:
	jsrto	JmpTo2_ObjectMove
	tst.b	(CutScene+objoff_34).w
	beq.s	+
	cmpi.w	#-$20,x_pos(a0)
	blt.w	JmpTo3_DeleteObject
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
+
	tst.w	y_pos(a0)
	bmi.w	JmpTo3_DeleteObject
	jmpto	JmpTo5_DisplaySprite

    if removeJmpTos
JmpTo3_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; ----------------------------------------------------------------------------
; Object CD - Birds from ending sequence
; ----------------------------------------------------------------------------
endingbird_delay	= objoff_3C	; delay before doing the next action
; Sprite_AAAE:
ObjEndingSeqBird:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjEndingSeqBird_Index(pc,d0.w),d1
	jmp	ObjEndingSeqBird_Index(pc,d1.w)
; ===========================================================================
; off_AABC:
ObjEndingSeqBird_Index:	offsetTable
		offsetTableEntry.w ObjEndingSeqBird_Init	; 0
		offsetTableEntry.w ObjEndingSeqBird_Main	; 2
; ===========================================================================
; loc_AAC0:
ObjEndingSeqBird_Init:
	lea	(ObjEndingSeqBird_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	move.l	(RNG_seed).w,d0
	ror.l	#3,d0
	move.l	d0,(RNG_seed).w
	move.l	d0,d1
	andi.w	#$7F,d0
	move.w	#-$A0,d2
	add.w	d0,d2
	move.w	d2,x_pos(a0)
	ror.l	#3,d1
	andi.w	#$FF,d1
	moveq	#8,d2
	add.w	d1,d2
	move.w	d2,y_pos(a0)
	move.w	#$100,x_vel(a0)
	moveq	#$20,d0
	cmpi.w	#$20,d1
	blo.s	+
	neg.w	d0
+
	move.w	d0,y_vel(a0)
	move.w	#$C0,endingbird_delay(a0)
	rts
; ===========================================================================
; loc_AB0E:
ObjEndingSeqBird_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjEndingSeqBird_Main_States(pc,d0.w),d1
	jsr	ObjEndingSeqBird_Main_States(pc,d1.w)
	jsrto	JmpTo2_ObjectMove
	lea	(Ani_objCD).l,a1
	jsrto	JmpTo_AnimateSprite
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
ObjEndingSeqBird_Main_States:	offsetTable
	offsetTableEntry.w loc_AB34	; 0
	offsetTableEntry.w loc_AB5C	; 2
	offsetTableEntry.w loc_AB8E	; 4
; ===========================================================================

loc_AB34:
	subq.w	#1,endingbird_delay(a0)
	bpl.s	+	; rts
	addq.b	#2,routine_secondary(a0)
	move.w	y_vel(a0),objoff_2E(a0)
	clr.w	x_vel(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.w	#$80,y_vel(a0)
	move.w	#$180,endingbird_delay(a0)
+
	rts
; ===========================================================================

loc_AB5C:
	subq.w	#1,endingbird_delay(a0)
	bmi.s	++
	move.w	y_pos(a0),d0
	moveq	#-4,d1
	cmp.w	objoff_32(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#-$100,x_vel(a0)
	move.w	objoff_2E(a0),y_vel(a0)
	move.w	#$C0,endingbird_delay(a0)
	rts
; ===========================================================================

loc_AB8E:
	subq.w	#1,endingbird_delay(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.w	#4,sp
	jmpto	JmpTo3_DeleteObject
; ===========================================================================

loc_AB9C:
	subq.w	#1,objoff_30(a0)
	bpl.s	+	; rts
	move.l	(RNG_seed).w,d0
	andi.w	#$1F,d0
	move.w	d0,objoff_30(a0)
	lea	(ChildObject_AD5E).l,a2
	jsrto	JmpTo_LoadChildObject
+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_ABBA:
	subq.w	#1,objoff_30(a0)
	bpl.s	+	; rts
	tst.b	objoff_35(a0)
	beq.s	+	; rts
	subq.b	#1,objoff_35(a0)
	move.l	(RNG_seed).w,d0
	andi.w	#$F,d0
	move.w	d0,objoff_30(a0)
	lea	(ChildObject_AD66).l,a2
	jsrto	JmpTo_LoadChildObject
+	rts
; End of function sub_ABBA


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_ABE2:
EndingSequence_LoadCharacterArt:
	move.w	(Ending_Routine).w,d0
	move.w	EndingSequence_LoadCharacterArt_Characters(pc,d0.w),d0
	jmp	EndingSequence_LoadCharacterArt_Characters(pc,d0.w)
; End of function EndingSequence_LoadCharacterArt

; ===========================================================================
EndingSequence_LoadCharacterArt_Characters: offsetTable
	offsetTableEntry.w EndingSequence_LoadCharacterArt_Sonic	; 0
	offsetTableEntry.w EndingSequence_LoadCharacterArt_SuperSonic	; 2
	offsetTableEntry.w EndingSequence_LoadCharacterArt_Tails	; 4
; ===========================================================================
; loc_ABF4:
EndingSequence_LoadCharacterArt_Sonic:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingSonic).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC08:
EndingSequence_LoadCharacterArt_SuperSonic:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingSuperSonic).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC1C:
EndingSequence_LoadCharacterArt_Tails:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingTails).l,a0
	jmpto	JmpTo_NemDec

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_AC30:
EndingSequence_LoadFlickyArt:
	move.w	(Ending_Routine).w,d0
	move.w	EndingSequence_LoadFlickyArt_Flickies(pc,d0.w),d0
	jmp	EndingSequence_LoadFlickyArt_Flickies(pc,d0.w)
; End of function EndingSequence_LoadFlickyArt

; ===========================================================================
EndingSequence_LoadFlickyArt_Flickies: offsetTable
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Flicky	; 0
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Eagle	; 2
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Chicken	; 4
; ===========================================================================
; loc_AC42:
EndingSequence_LoadFlickyArt_Flicky:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Flicky).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC56:
EndingSequence_LoadFlickyArt_Eagle:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Eagle).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC6A:
EndingSequence_LoadFlickyArt_Chicken:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Chicken).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
Pal_AC7E:	BINCLUDE	"art/palettes/Ending Sonic.bin"
Pal_AC9E:	BINCLUDE	"art/palettes/Ending Tails.bin"
Pal_ACDE:	BINCLUDE	"art/palettes/Ending Background.bin"
Pal_AD1E:	BINCLUDE	"art/palettes/Ending Photos.bin"
Pal_AD3E:	BINCLUDE	"art/palettes/Ending Super Sonic.bin"

ChildObject_AD5E:	childObjectData objoff_3E, ObjID_EndingSeqClouds, $00
ChildObject_AD62:	childObjectData objoff_3E, ObjID_EndingSeqTrigger, $00
ChildObject_AD66:	childObjectData objoff_3E, ObjID_EndingSeqBird, $00
ChildObject_AD6A:	childObjectData objoff_3E, ObjID_EndingSeqSonic, $00
ChildObject_AD6E:	childObjectData objoff_3E, ObjID_TornadoHelixes, $00

; off_AD72:
ObjEndingSeqBird_SubObjData:
    if fixBugs
	subObjData ObjAnimal_MapUnc_11E1C,make_art_tile(ArtTile_ArtNem_Animal_2,0,0),1<<render_flags.level_fg,1,8,0
    else
	; This should use priority 1, not 2. As-is, it causes the birds to
	; overlap the Tornado but appear behind Sonic.
	subObjData ObjAnimal_MapUnc_11E1C,make_art_tile(ArtTile_ArtNem_Animal_2,0,0),1<<render_flags.level_fg,2,8,0
    endif

; animation script
; byte_AD7C
Ani_objCD:	offsetTable
		offsetTableEntry.w byte_AD7E	; 0
byte_AD7E:	dc.b   5,  0,  1,$FF
	even

; animation script
; off_AD82
Ani_objCF:	offsetTable
		offsetTableEntry.w byte_AD88	; 0
		offsetTableEntry.w byte_AD8E	; 1
		offsetTableEntry.w byte_AD9E	; 2
byte_AD88:	dc.b   3,  0,  0,  1,$FA,  0
byte_AD8E:	dc.b   3,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  3,  3,  4,$FA,  0
byte_AD9E:	dc.b   1,  5,  6,$FF
	even
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjTornadoHelixes_MapUnc_ADA2:	include "mappings/sprite/objCF.asm"
; --------------------------------------------------------------------------------------
; Enigma compressed art mappings
; "Sonic the Hedgehog 2" mappings		; MapEng_B23A:
	even
MapEng_EndGameLogo:	BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


