; ----------------------------------------------------------------------------
; Object 0E - Title screen intro animation
; ----------------------------------------------------------------------------
obj0e_counter		= objoff_2A
obj0e_array_index	= objoff_2C
obj0e_intro_complete	= objoff_2F
obj0e_music_playing	= objoff_30
obj0e_current_frame	= objoff_34

obj0e_make_sprite_position macro x,y
	dc.w	spriteScreenPositionXCentered(x),spriteScreenPositionYCentered(y)
    endm

; Sprite_12E18:
ObjTitleIntro:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjTitleIntro_Index(pc,d0.w),d1
	jmp	ObjTitleIntro_Index(pc,d1.w)
; ===========================================================================
; off_12E26: ObjTitleIntro_States:
ObjTitleIntro_Index: offsetTable
	offsetTableEntry.w ObjTitleIntro_Init		;   0
	offsetTableEntry.w ObjTitleIntro_Sonic		;   2
	offsetTableEntry.w ObjTitleIntro_Tails		;   4
	offsetTableEntry.w ObjTitleIntro_LogoTop	;   6
	offsetTableEntry.w ObjTitleIntro_FlashingStar	;   8
	offsetTableEntry.w ObjTitleIntro_SonicHand	;  $A
	offsetTableEntry.w ObjTitleIntro_FallingStar	;  $C
	offsetTableEntry.w ObjTitleIntro_MaskingSprite	;  $E
	offsetTableEntry.w ObjTitleIntro_TailsHand	; $10
; ===========================================================================
; loc_12E38:
ObjTitleIntro_Init:
	addq.b	#2,routine(a0)	; useless, because it's overwritten with the subtype below
	move.l	#ObjTitleIntro_MapUnc_136A8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_TitleSprites,0,0),art_tile(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),routine(a0)
	bra.s	ObjTitleIntro
; ===========================================================================

ObjTitleIntro_Sonic:
	addq.w	#1,obj0e_current_frame(a0)
	cmpi.w	#288,obj0e_current_frame(a0)
	bhs.s	+
	bsr.w	TitleScreen_SetFinalState
+
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjTitleIntro_Sonic_Index(pc,d0.w),d1
	jmp	ObjTitleIntro_Sonic_Index(pc,d1.w)
; ===========================================================================
; off_12E76:
ObjTitleIntro_Sonic_Index: offsetTable
	offsetTableEntry.w ObjTitleIntro_Sonic_Init			;   0
	offsetTableEntry.w ObjTitleIntro_Sonic_FadeInAndPlayMusic	;   2
	offsetTableEntry.w ObjTitleIntro_Sonic_LoadPalette		;   4
	offsetTableEntry.w ObjTitleIntro_Sonic_Move			;   6
	offsetTableEntry.w ObjTitleIntro_Animate			;   8
	offsetTableEntry.w ObjTitleIntro_Sonic_AnimationFinished	;  $A
	offsetTableEntry.w ObjTitleIntro_Sonic_SpawnTails		;  $C
	offsetTableEntry.w ObjTitleIntro_Sonic_FlashBackground		;  $E
	offsetTableEntry.w ObjTitleIntro_Sonic_SpawnFallingStar		; $10
	offsetTableEntry.w ObjTitleIntro_Sonic_MakeStarSparkle		; $12
; ===========================================================================
; spawn more stars
ObjTitleIntro_Sonic_Init:
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_Sonic_FadeInAndPlayMusic
	move.b	#5,mapping_frame(a0)

	move.w	#spriteScreenPositionXCentered(-16),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-16),y_pixel(a0)

	; Load flashing star object.
	lea	(IntroFlashingStar).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#8,subtype(a1)

	; Load emblem top object.
	lea	(IntroEmblemTop).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#6,subtype(a1)

	; Play twinkling sound.
	moveq	#signextendB(SndID_Sparkle),d0
	jmpto	JmpTo4_PlaySound
; ===========================================================================
; loc_12EC2:
ObjTitleIntro_Sonic_FadeInAndPlayMusic:
	; Wait.
	cmpi.w	#56,obj0e_current_frame(a0)
	bhs.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_Sonic_LoadPalette

	; Load palette-changer object.
	lea	(TitleScreenPaletteChanger3).w,a1
	move.b	#ObjID_TtlScrPalChanger,id(a1)
	move.b	#0,subtype(a1)

	; Play title screen music.
	st.b	obj0e_music_playing(a0)
	moveq	#signextendB(MusID_Title),d0
	jmpto	JmpTo4_PlayMusic
; ===========================================================================
; loc_12EE8:
ObjTitleIntro_Sonic_LoadPalette:
	; Wait.
	cmpi.w	#128,obj0e_current_frame(a0)
	bhs.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_Sonic_Move

	; Load Sonic's palette to palette line 1.
	lea	(Pal_133EC).l,a1
	lea	(Normal_palette).w,a2
	moveq	#bytesToWcnt(palette_line_size),d6
-	move.w	(a1)+,(a2)+
	dbf	d6,-
; sub_12F08: ObjTitleIntro_Sonic_LoadSky:
ObjTitleIntro_LoadMaskingSprite:
	; Load sprite mask object.
	lea	(IntroMaskingSprite).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$E,subtype(a1)
	rts
; End of function ObjTitleIntro_Sonic_LoadPalette

; ===========================================================================
; loc_12F18:
ObjTitleIntro_Sonic_Move:
	; 'd2' is used to detect when the end of the position array has been
	; reached.
	moveq	#ObjTitleIntro_Sonic_Positions_End-ObjTitleIntro_Sonic_Positions+4,d2
	lea	(ObjTitleIntro_Sonic_Positions).l,a1
; loc_12F20:
ObjTitleIntro_Move:
	; Change position every 4 frames.
	move.w	obj0e_counter(a0),d0
	addq.w	#1,d0
	move.w	d0,obj0e_counter(a0)
	andi.w	#3,d0
	bne.s	+

	; Advance index, while checking if we've reached the end of the
	; position array.
	move.w	obj0e_array_index(a0),d1
	addq.w	#4,d1
	cmp.w	d2,d1
	bhs.w	ObjTitleIntro_NextRoutineSecondary
	move.w	d1,obj0e_array_index(a0)

	; Obtain position from the array and apply it to the object.
	move.l	-4(a1,d1.w),d0
	move.w	d0,y_pixel(a0)
	swap	d0
	move.w	d0,x_pixel(a0)
+
	bra.w	DisplaySprite
; ===========================================================================
; loc_12F52:
ObjTitleIntro_Animate:
	lea	(Ani_obj0E).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================
; ObjTitleIntro_Sonic_LastFrame:
ObjTitleIntro_Sonic_AnimationFinished:
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_Sonic_SpawnTails
	move.b	#$12,mapping_frame(a0)

	; Load Sonic's hand object.
	lea	(IntroSonicHand).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$A,subtype(a1)

	bra.w	DisplaySprite
; ===========================================================================
; loc_12F7C:
ObjTitleIntro_Sonic_SpawnTails:
	cmpi.w	#192,obj0e_current_frame(a0)
	blo.s	+
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_Sonic_FlashBackground

	; Load Tails object.
	lea	(IntroTails).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#4,subtype(a1)
+
	bra.w	DisplaySprite
; ===========================================================================
; loc_12F9A:
ObjTitleIntro_Sonic_FlashBackground:
	cmpi.w	#288,obj0e_current_frame(a0)
	blo.s	+
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_Sonic_SpawnFallingStar
	clr.w	obj0e_array_index(a0)
	st.b	obj0e_intro_complete(a0)

	; Fill palette line 3 with white.
	lea	(Normal_palette_line3).w,a1
	move.w	#$EEE,d0
	moveq	#bytesToWcnt(palette_line_size),d6
-	move.w	d0,(a1)+
	dbf	d6,-

	; Load palette-changer object.
	lea	(TitleScreenPaletteChanger2).w,a1
	move.b	#ObjID_TtlScrPalChanger,id(a1)
	move.b	#2,subtype(a1)

	; Load title screen menu object.
	move.b	#ObjID_TitleMenu,(TitleScreenMenu+id).w
+
	bra.w	DisplaySprite
; ===========================================================================
; loc_12FD6:
ObjTitleIntro_Sonic_SpawnFallingStar:
	; Wait a different amount of time on PAL consoles so that it's timed
	; right with the music.
	btst	#6,(Graphics_Flags).w
	beq.s	+
	cmpi.w	#400,obj0e_current_frame(a0)
	beq.s	++
	bra.w	DisplaySprite
; ===========================================================================
+
	cmpi.w	#464,obj0e_current_frame(a0)
	beq.s	+
	bra.w	DisplaySprite
; ===========================================================================
+
	; Create falling star object.
	lea	(IntroFallingStar).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$C,subtype(a1)

	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_Sonic_MakeStarSparkle

	; Delete sprite mask object.
	lea	(IntroMaskingSprite).w,a1
	bsr.w	DeleteObject2

	bra.w	DisplaySprite
; ===========================================================================
; loc_13014:
ObjTitleIntro_Sonic_MakeStarSparkle:
	; Animate the falling star every 8 frames.
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	bne.s	++

	; Advance index, while checking if we've reached the end of the
	; colour array.
	move.w	obj0e_array_index(a0),d0
	addq.w	#2,d0
	cmpi.w	#CyclingPal_TitleStar_End-CyclingPal_TitleStar,d0
	blo.s	+
	moveq	#0,d0
+
	move.w	d0,obj0e_array_index(a0)

	; Obtain colour from the array and apply it to the palette line.
	move.w	CyclingPal_TitleStar(pc,d0.w),(Normal_palette_line3+5*2).w
+
	bra.w	DisplaySprite
; ===========================================================================
; word_1303A:
CyclingPal_TitleStar:
	binclude "art/palettes/Title Star Cycle.bin"
CyclingPal_TitleStar_End

;word_13046:
ObjTitleIntro_Sonic_Positions:
	;                             X,   Y
	obj0e_make_sprite_position  -24, -32
	obj0e_make_sprite_position  -32, -48
	obj0e_make_sprite_position  -40, -64
	obj0e_make_sprite_position  -42, -74
	obj0e_make_sprite_position  -38, -82
	obj0e_make_sprite_position  -32, -86
	obj0e_make_sprite_position  -28, -87
	obj0e_make_sprite_position  -24, -88
ObjTitleIntro_Sonic_Positions_End
; ===========================================================================

ObjTitleIntro_Tails:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjTitleIntro_Tails_Index(pc,d0.w),d1
	jmp	ObjTitleIntro_Tails_Index(pc,d1.w)
; ===========================================================================
; off_13074:
ObjTitleIntro_Tails_Index: offsetTable
	offsetTableEntry.w ObjTitleIntro_Tails_Init			; 0
	offsetTableEntry.w ObjTitleIntro_Tails_Move			; 2
	offsetTableEntry.w ObjTitleIntro_Animate			; 4
	offsetTableEntry.w ObjTitleIntro_Tails_AnimationFinished	; 6
	offsetTableEntry.w BranchTo10_DisplaySprite		; 8
; ===========================================================================

ObjTitleIntro_Tails_Init:
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_Tails_Move
    if fixBugs
	; Tails' priority is never set, even though it is set in
	; 'TitleScreen_SetFinalState', suggesting that it was meant to be.
	; This causes Tails to be layered behind Sonic instead of in front of
	; him.
	move.b	#3,priority(a0)
    endif
	move.w	#spriteScreenPositionXCentered(-72),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-24),y_pixel(a0)
	move.b	#1,anim(a0)
	rts
; ===========================================================================
; loc_13096:
ObjTitleIntro_Tails_Move:
	moveq	#ObjTitleIntro_Tails_Positions_End-ObjTitleIntro_Tails_Positions+4,d2
	lea	(ObjTitleIntro_Tails_Positions).l,a1
	bra.w	ObjTitleIntro_Move
; ===========================================================================
; loc_130A2:
ObjTitleIntro_Tails_AnimationFinished:
	addq.b	#2,routine_secondary(a0)	; BranchTo10_DisplaySprite

	; Load Tails' hand object.
	lea	(IntroTailsHand).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$10,subtype(a1)

BranchTo10_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; word_130B8:
ObjTitleIntro_Tails_Positions:
	;                             X,   Y
	obj0e_make_sprite_position  -73, -40
	obj0e_make_sprite_position  -77, -56
	obj0e_make_sprite_position  -82, -68
	obj0e_make_sprite_position  -84, -74
	obj0e_make_sprite_position  -86, -78
	obj0e_make_sprite_position  -87, -79
	obj0e_make_sprite_position  -88, -80
ObjTitleIntro_Tails_Positions_End
; ===========================================================================

ObjTitleIntro_LogoTop:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjTitleIntro_LogoTop_Index(pc,d0.w),d1
	jmp	ObjTitleIntro_LogoTop_Index(pc,d1.w)
; ===========================================================================
; off_130E2:
ObjTitleIntro_LogoTop_Index: offsetTable
	offsetTableEntry.w ObjTitleIntro_LogoTop_Init		; 0
	offsetTableEntry.w BranchTo11_DisplaySprite	; 2
; ===========================================================================

ObjTitleIntro_LogoTop_Init:
	; Don't show the trademark symbol on Japanese consoles.
	move.b	#$B,mapping_frame(a0)
	tst.b	(Graphics_Flags).w
	bmi.s	+
	move.b	#$A,mapping_frame(a0)
+
	move.b	#2,priority(a0)
	move.w	#spriteScreenPositionXCentered(0),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-8),y_pixel(a0)
; loc_1310A:
ObjTitleIntro_NextRoutineSecondary:
	addq.b	#2,routine_secondary(a0)	; BranchTo11_DisplaySprite

BranchTo11_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; ObjTitleIntro_SkyPiece:
ObjTitleIntro_MaskingSprite:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjTitleIntro_MaskingSprite_Index(pc,d0.w),d1
	jmp	ObjTitleIntro_MaskingSprite_Index(pc,d1.w)
; ===========================================================================
; off_13120:
ObjTitleIntro_MaskingSprite_Index: offsetTable
	offsetTableEntry.w ObjTitleIntro_MaskingSprite_Init	; 0
	offsetTableEntry.w BranchTo12_DisplaySprite	; 2
; ===========================================================================

ObjTitleIntro_MaskingSprite_Init:
	addq.b	#2,routine_secondary(a0)	; BranchTo12_DisplaySprite
	move.w	#make_art_tile(ArtTile_ArtNem_Title,0,0),art_tile(a0)
	move.b	#$11,mapping_frame(a0)
	move.b	#2,priority(a0)
	; Masking sprites normally must have an X coordinate of 0. I don't
	; know why it isn't set to that here, but it is corrected to 0 in
	; 'TitleScreen_Loop'.
	move.w	#spriteScreenPositionXCentered(-32),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(0),y_pixel(a0)

BranchTo12_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; ObjTitleIntro_LargeStar:
ObjTitleIntro_FlashingStar:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjTitleIntro_FlashingStar_Index(pc,d0.w),d1
	jmp	ObjTitleIntro_FlashingStar_Index(pc,d1.w)
; ===========================================================================
; off_13158:
ObjTitleIntro_FlashingStar_Index: offsetTable
	offsetTableEntry.w ObjTitleIntro_FlashingStar_Init	; 0
	offsetTableEntry.w ObjTitleIntro_Animate		; 2
	offsetTableEntry.w ObjTitleIntro_FlashingStar_Wait	; 4
	offsetTableEntry.w ObjTitleIntro_FlashingStar_Move	; 6
; ===========================================================================

ObjTitleIntro_FlashingStar_Init:
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_Animate
	move.b	#$C,mapping_frame(a0)
	ori.w	#high_priority,art_tile(a0)
	move.b	#2,anim(a0)
	move.b	#1,priority(a0)
	move.w	#spriteScreenPositionXCentered(-32),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-72),y_pixel(a0)
	move.w	#4,obj0e_counter(a0)
	rts
; ===========================================================================
; loc_13190:
ObjTitleIntro_FlashingStar_Wait:
	subq.w	#1,obj0e_counter(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_FlashingStar_Move
	rts
; ===========================================================================
; loc_1319E:
ObjTitleIntro_FlashingStar_Move:
	move.b	#2,routine_secondary(a0)	; ObjTitleIntro_Animate
	move.b	#0,anim_frame(a0)
	move.b	#0,anim_frame_duration(a0)
	move.w	#6,obj0e_counter(a0)

	; Advance index, while checking if we've reached the end of the
	; position array.
	move.w	obj0e_array_index(a0),d0
	addq.w	#4,d0
	cmpi.w	#ObjTitleIntro_FlashingStar_Positions_End-ObjTitleIntro_FlashingStar_Positions+4,d0
	bhs.w	DeleteObject
	move.w	d0,obj0e_array_index(a0)

	; Obtain position from the array and apply it to the object.
	move.l	ObjTitleIntro_FlashingStar_Positions-4(pc,d0.w),d0
	move.w	d0,y_pixel(a0)
	swap	d0
	move.w	d0,x_pixel(a0)

	; Play twinkling sound.
	moveq	#signextendB(SndID_Sparkle),d0
	jmpto	JmpTo4_PlaySound
; ===========================================================================
; word_131DC:
ObjTitleIntro_FlashingStar_Positions:
	;                             X,   Y
	obj0e_make_sprite_position  -70,   2
	obj0e_make_sprite_position   80,   8
	obj0e_make_sprite_position   18,  65
	obj0e_make_sprite_position  126, -78
	obj0e_make_sprite_position  -96, -13
	obj0e_make_sprite_position   96, -16
	obj0e_make_sprite_position  -19,  75
	obj0e_make_sprite_position  -96, -69
	obj0e_make_sprite_position   69,  23
ObjTitleIntro_FlashingStar_Positions_End
; ===========================================================================

ObjTitleIntro_SonicHand:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjTitleIntro_SonicHand_Index(pc,d0.w),d1
	jmp	ObjTitleIntro_SonicHand_Index(pc,d1.w)
; ===========================================================================
; off_1320E:
ObjTitleIntro_SonicHand_Index: offsetTable
	offsetTableEntry.w ObjTitleIntro_SonicHand_Init		; 0
	offsetTableEntry.w ObjTitleIntro_SonicHand_Move		; 2
	offsetTableEntry.w BranchTo13_DisplaySprite	; 4
; ===========================================================================

ObjTitleIntro_SonicHand_Init:
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_SonicHand_Move
	move.b	#9,mapping_frame(a0)
    if fixBugs
	; This matches 'TitleScreen_SetFinalState'.
	move.b	#2,priority(a0)
    else
	; This is inconsistent with 'TitleScreen_SetFinalState'.
	move.b	#3,priority(a0)
    endif
	move.w	#spriteScreenPositionXCentered(37),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-49),y_pixel(a0)

BranchTo13_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; loc_13234:
ObjTitleIntro_SonicHand_Move:
	moveq	#ObjTitleIntro_SonicHand_Positions_End-ObjTitleIntro_SonicHand_Positions+4,d2
	lea	(ObjTitleIntro_SonicHand_Positions).l,a1
	bra.w	ObjTitleIntro_Move
; ===========================================================================
; word_13240:
ObjTitleIntro_SonicHand_Positions:
	;                            X,   Y
	obj0e_make_sprite_position  35, -47
	obj0e_make_sprite_position  32, -46
	obj0e_make_sprite_position  33, -47
ObjTitleIntro_SonicHand_Positions_End
; ===========================================================================

ObjTitleIntro_TailsHand:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjTitleIntro_TailsHand_Index(pc,d0.w),d1
	jmp	ObjTitleIntro_TailsHand_Index(pc,d1.w)
; ===========================================================================
; off_1325A:
ObjTitleIntro_TailsHand_Index: offsetTable
	offsetTableEntry.w ObjTitleIntro_TailsHand_Init		; 0
	offsetTableEntry.w ObjTitleIntro_TailsHand_Move		; 2
	offsetTableEntry.w BranchTo14_DisplaySprite	; 4
; ===========================================================================

ObjTitleIntro_TailsHand_Init:
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_TailsHand_Move
	move.b	#$13,mapping_frame(a0)
    if fixBugs
	; This matches 'TitleScreen_SetFinalState'.
	move.b	#2,priority(a0)
    else
	; This is inconsistent with 'TitleScreen_SetFinalState', and causes
	; the hand to be layered behind Tails if his priority is fixed.
	move.b	#3,priority(a0)
    endif
	move.w	#spriteScreenPositionXCentered(-17),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-27),y_pixel(a0)

BranchTo14_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; loc_13280:
ObjTitleIntro_TailsHand_Move:
	moveq	#ObjTitleIntro_TailsHand_Positions_End-ObjTitleIntro_TailsHand_Positions+4,d2
	lea	(ObjTitleIntro_TailsHand_Positions).l,a1
	bra.w	ObjTitleIntro_Move
; ===========================================================================
; word_1328C:
ObjTitleIntro_TailsHand_Positions:
	;                             X,   Y
	obj0e_make_sprite_position  -20, -32
	obj0e_make_sprite_position  -19, -31
ObjTitleIntro_TailsHand_Positions_End
; ===========================================================================
; ObjTitleIntro_SmallStar:
ObjTitleIntro_FallingStar:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjTitleIntro_FallingStar_Index(pc,d0.w),d1
	jmp	ObjTitleIntro_FallingStar_Index(pc,d1.w)
; ===========================================================================
; off_132A2:
ObjTitleIntro_FallingStar_Index: offsetTable
	offsetTableEntry.w ObjTitleIntro_FallingStar_Init	; 0
	offsetTableEntry.w ObjTitleIntro_FallingStar_Main	; 2
; ===========================================================================
; ObjTitleIntro_SmallStar_Init:
ObjTitleIntro_FallingStar_Init:
	addq.b	#2,routine_secondary(a0)	; ObjTitleIntro_FallingStar_Main
	move.b	#$C,mapping_frame(a0)
	move.b	#5,priority(a0)
	move.w	#spriteScreenPositionXCentered(80),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-112),y_pixel(a0)
	move.b	#3,anim(a0)
	move.w	#140,obj0e_counter(a0)
	bra.w	DisplaySprite
; ===========================================================================
; loc_132D2: ObjTitleIntro_SmallStar_Main:
ObjTitleIntro_FallingStar_Main:
	subq.w	#1,obj0e_counter(a0)
	bmi.w	DeleteObject

	; Make the star fall.
	subq.w	#2,x_pixel(a0)
	addq.w	#1,y_pixel(a0)

	lea	(Ani_obj0E).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite

; ===========================================================================
; ----------------------------------------------------------------------------
; Object C9 - "Palette changing handler" from title screen
; ----------------------------------------------------------------------------
ttlscrpalchanger_fadein_time_left = objoff_30
ttlscrpalchanger_fadein_time = objoff_31
ttlscrpalchanger_fadein_amount = objoff_32
ttlscrpalchanger_start_offset = objoff_34
ttlscrpalchanger_length = objoff_36
ttlscrpalchanger_codeptr = objoff_3A

; Sprite_132F0:
ObjTtlScrPalChanger:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjTtlScrPalChanger_Index(pc,d0.w),d1
	jmp	ObjTtlScrPalChanger_Index(pc,d1.w)
; ===========================================================================
ObjTtlScrPalChanger_Index:	offsetTable
		offsetTableEntry.w ObjTtlScrPalChanger_Init	; 0
		offsetTableEntry.w ObjTtlScrPalChanger_Main	; 2
; ===========================================================================

ObjTtlScrPalChanger_Init:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lea	(PaletteChangerDataIndex).l,a1
	adda.w	(a1,d0.w),a1
	move.l	(a1)+,ttlscrpalchanger_codeptr(a0)
	movea.l	(a1)+,a2
	move.b	(a1)+,d0
	move.w	d0,ttlscrpalchanger_start_offset(a0)
	lea	(Target_palette).w,a3
	adda.w	d0,a3
	move.b	(a1)+,d0
	move.w	d0,ttlscrpalchanger_length(a0)

-	move.w	(a2)+,(a3)+
	dbf	d0,-

	move.b	(a1)+,d0
	move.b	d0,ttlscrpalchanger_fadein_time_left(a0)
	move.b	d0,ttlscrpalchanger_fadein_time(a0)
	move.b	(a1)+,ttlscrpalchanger_fadein_amount(a0)
	rts
; ===========================================================================

ObjTtlScrPalChanger_Main:
	subq.b	#1,ttlscrpalchanger_fadein_time_left(a0)
	bpl.s	+
	move.b	ttlscrpalchanger_fadein_time(a0),ttlscrpalchanger_fadein_time_left(a0)
	subq.b	#1,ttlscrpalchanger_fadein_amount(a0)
	bmi.w	DeleteObject
	movea.l	ttlscrpalchanger_codeptr(a0),a2
	movea.l	a0,a3
	move.w	ttlscrpalchanger_length(a0),d0
	move.w	ttlscrpalchanger_start_offset(a0),d1
	lea	(Normal_palette).w,a0
	adda.w	d1,a0
	lea	(Target_palette).w,a1
	adda.w	d1,a1

-	jsr	(a2)	; dynamic call! to Pal_FadeFromBlack.UpdateColour, loc_1344C, or loc_1348A, assuming the PaletteChangerData pointers haven't been changed
	dbf	d0,-

	movea.l	a3,a0
+
	rts
; ===========================================================================
; off_1337C:
PaletteChangerDataIndex: offsetTable
	offsetTableEntry.w off_1338C	;  0
	offsetTableEntry.w off_13398	;  2
	offsetTableEntry.w off_133A4	;  4
	offsetTableEntry.w off_133B0	;  6
	offsetTableEntry.w off_133BC	;  8
	offsetTableEntry.w off_133C8	; $A
	offsetTableEntry.w off_133D4	; $C
	offsetTableEntry.w off_133E0	; $E

C9PalInfo macro codeptr,dataptr,loadtoOffset,length,fadeinTime,fadeinAmount
	dc.l codeptr, dataptr
	dc.b loadtoOffset, length, fadeinTime, fadeinAmount
    endm

off_1338C:	C9PalInfo Pal_FadeFromBlack.UpdateColour, Pal_1342C, $60, $F,2,$15
off_13398:	C9PalInfo                      loc_1344C, Pal_1340C, $40, $F,4,7
off_133A4:	C9PalInfo                      loc_1344C,  Pal_AD1E,   0, $F,8,7
off_133B0:	C9PalInfo                      loc_1348A,  Pal_AD1E,   0, $F,8,7
off_133BC:	C9PalInfo                      loc_1344C,  Pal_AC7E,   0,$1F,4,7
off_133C8:	C9PalInfo                      loc_1344C,  Pal_ACDE, $40,$1F,4,7
off_133D4:	C9PalInfo                      loc_1344C,  Pal_AD3E,   0, $F,4,7
off_133E0:	C9PalInfo                      loc_1344C,  Pal_AC9E,   0,$1F,4,7

Pal_133EC:	BINCLUDE "art/palettes/Title Sonic.bin"
Pal_1340C:	BINCLUDE "art/palettes/Title Background.bin"
Pal_1342C:	BINCLUDE "art/palettes/Title Emblem.bin"

; ===========================================================================

loc_1344C:

	move.b	(a1)+,d2
	andi.b	#$E,d2
	move.b	(a0),d3
	cmp.b	d2,d3
	bls.s	loc_1345C
	subq.b	#2,d3
	move.b	d3,(a0)

loc_1345C:
	addq.w	#1,a0
	move.b	(a1)+,d2
	move.b	d2,d3
	andi.b	#$E0,d2
	andi.b	#$E,d3
	move.b	(a0),d4
	move.b	d4,d5
	andi.b	#$E0,d4
	andi.b	#$E,d5
	cmp.b	d2,d4
	bls.s	loc_1347E
	subi.b	#$20,d4

loc_1347E:
	cmp.b	d3,d5
	bls.s	loc_13484
	subq.b	#2,d5

loc_13484:
	or.b	d4,d5
	move.b	d5,(a0)+
	rts
; ===========================================================================

loc_1348A:
	moveq	#$E,d2
	move.b	(a0),d3
	and.b	d2,d3
	cmp.b	d2,d3
	bhs.s	loc_13498
	addq.b	#2,d3
	move.b	d3,(a0)

loc_13498:
	addq.w	#1,a0
	move.b	(a0),d3
	move.b	d3,d4
	andi.b	#$E0,d3
	andi.b	#$E,d4
	cmpi.b	#-$20,d3
	bhs.s	loc_134B0
	addi.b	#$20,d3

loc_134B0:
	cmp.b	d2,d4
	bhs.s	loc_134B6
	addq.b	#2,d4

loc_134B6:
	or.b	d3,d4
	move.b	d4,(a0)+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


TitleScreen_SetFinalState:
	tst.b	obj0e_intro_complete(a0)
	bne.w	+	; rts

	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_1_Press).w
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_2_Press).w
	andi.b	#button_start_mask,d0
	beq.w	+	; rts

	; Initialise Sonic object.
	st.b	obj0e_intro_complete(a0)
	move.b	#$10,routine_secondary(a0)
	move.b	#$12,mapping_frame(a0)
	move.w	#spriteScreenPositionXCentered(-24),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-88),y_pixel(a0)

	; Initialise Sonic's hand object.
	lea	(IntroSonicHand).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$A,routine(a1)
	move.b	#2,priority(a1)
	move.b	#9,mapping_frame(a1)
	move.b	#4,routine_secondary(a1)
	move.w	#spriteScreenPositionXCentered(33),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(-47),y_pixel(a1)

	; Initialise Tails object.
	lea	(IntroTails).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#4,routine(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#6,routine_secondary(a1)
	move.b	#3,priority(a1)
	move.w	#spriteScreenPositionXCentered(-88),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(-80),y_pixel(a1)

	; Initialise Tails' hand object.
	lea	(IntroTailsHand).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$10,routine(a1)
	move.b	#2,priority(a1)
	move.b	#$13,mapping_frame(a1)
	move.b	#4,routine_secondary(a1)
	move.w	#spriteScreenPositionXCentered(-19),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(-31),y_pixel(a1)

	; Initialise top-of-emblem object.
	lea	(IntroEmblemTop).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#6,subtype(a1)

	; Initialise sprite mask object.
	bsr.w	ObjTitleIntro_LoadMaskingSprite

	; Initialise title screen menu object.
	move.b	#ObjID_TitleMenu,(TitleScreenMenu+id).w

	; Delete palette-changer object.
	lea	(TitleScreenPaletteChanger).w,a1
	bsr.w	DeleteObject2

	; Load palette line 4.
	lea_	Pal_1342C,a1
	lea	(Normal_palette_line4).w,a2
	moveq	#bytesToLcnt(palette_line_size),d6
-	move.l	(a1)+,(a2)+
	dbf	d6,-

	; Load palette line 3.
	lea_	Pal_1340C,a1
	lea	(Normal_palette_line3).w,a2
	moveq	#bytesToLcnt(palette_line_size),d6
-	move.l	(a1)+,(a2)+
	dbf	d6,-

	; Load palette line 1.
	lea_	Pal_133EC,a1
	lea	(Normal_palette).w,a2
	moveq	#bytesToLcnt(palette_line_size),d6
-	move.l	(a1)+,(a2)+
	dbf	d6,-

	; Play title screen music if it isn't already playing.
	tst.b	obj0e_music_playing(a0)
	bne.s	+
	moveq	#signextendB(MusID_Title),d0
	jsrto	JmpTo4_PlayMusic
+
	rts
; End of function TitleScreen_SetFinalState


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_135EA:
TitleScreen_InitSprite:
	move.l	#ObjTitleIntro_MapUnc_136A8,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_TitleSprites,0,0),art_tile(a1)
	move.b	#4,priority(a1)
	rts
; End of function TitleScreen_InitSprite

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 0F - Title screen menu
; ----------------------------------------------------------------------------
; Sprite_13600:
ObjTitleMenu:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjTitleMenu_Index(pc,d0.w),d1
	jsr	ObjTitleMenu_Index(pc,d1.w)
	bra.w	DisplaySprite
; ===========================================================================
; off_13612: ObjTitleMenu_States:
ObjTitleMenu_Index:	offsetTable
		offsetTableEntry.w ObjTitleMenu_Init	; 0
		offsetTableEntry.w ObjTitleMenu_Main	; 2
; ===========================================================================
; loc_13616:
ObjTitleMenu_Init:
	addq.b	#2,routine(a0) ; => ObjTitleMenu_Main
	move.w	#spriteScreenPositionXCentered(8),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(92),y_pixel(a0)
	move.l	#ObjTitleMenu_MapUnc_13B70,mappings(a0)
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	andi.b	#1,(Title_screen_option).w
	move.b	(Title_screen_option).w,mapping_frame(a0)

; loc_13644:
ObjTitleMenu_Main:
	moveq	#0,d2
	move.b	(Title_screen_option).w,d2
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_up,d0
	beq.s	+
	subq.b	#1,d2
	bcc.s	+
	move.b	#2,d2
+
	btst	#button_down,d0
	beq.s	+
	addq.b	#1,d2
	cmpi.b	#3,d2
	blo.s	+
	moveq	#0,d2
+
	move.b	d2,mapping_frame(a0)
	move.b	d2,(Title_screen_option).w
	andi.b	#button_up_mask|button_down_mask,d0
	beq.s	+	; rts
	moveq	#signextendB(SndID_Blip),d0 ; selection blip sound
	jsrto	JmpTo4_PlaySound
+
	rts
; ===========================================================================
; animation script
; off_13686:
Ani_obj0E:	offsetTable
		offsetTableEntry.w Ani_obj0E_Sonic		; 0
		offsetTableEntry.w Ani_obj0E_Tails		; 1
		offsetTableEntry.w Ani_obj0E_FlashingStar	; 2
		offsetTableEntry.w Ani_obj0E_FallingStar	; 3
; byte_1368E:
Ani_obj0E_Sonic:
	dc.b   1
	dc.b   5
	dc.b   6
	dc.b   7
    if ~~fixBugs
	; This appears to be a leftover prototype frame: it's a duplicate of
	; frame $12, except Sonic is missing his right arm. The old frame
	; being here in this animation script causes Sonic to appear with
	; both of his arms missing for a single frame.
	dc.b   8
    endif
	dc.b $FA
	even
; byte_13694:
Ani_obj0E_Tails:
	dc.b   1
	dc.b   0
	dc.b   1
	dc.b   2
	dc.b   3
	dc.b   4
	dc.b $FA
	even
; byte_1369C:
Ani_obj0E_FlashingStar:
	dc.b   1
	dc.b  $C
	dc.b  $D
	dc.b  $E
	dc.b  $D
	dc.b  $C
	dc.b $FA
	even
; byte_136A4:
Ani_obj0E_FallingStar:
	dc.b   3
	dc.b  $C
	dc.b  $F
	dc.b $FF
	even
; -----------------------------------------------------------------------------
; Sprite Mappings - Flashing stars from intro (ObjTitleIntro)
; -----------------------------------------------------------------------------
ObjTitleIntro_MapUnc_136A8:	include "mappings/sprite/obj0E.asm"
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjTitleMenu_MapUnc_13B70:	include "mappings/sprite/obj0F.asm"

