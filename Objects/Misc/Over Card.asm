; ===========================================================================
; ----------------------------------------------------------------------------
; Object 39 - Game/Time Over text
; ----------------------------------------------------------------------------
; Sprite_13F74:
ObjTimeOver: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjTimeOver_Index(pc,d0.w),d1
	jmp	ObjTimeOver_Index(pc,d1.w)
; ===========================================================================
ObjTimeOver_Index:	offsetTable
		offsetTableEntry.w ObjTimeOver_Init		; 0
		offsetTableEntry.w ObjTimeOver_SlideIn	; 2
		offsetTableEntry.w ObjTimeOver_Wait		; 4
; ===========================================================================
; loc_13F88:
ObjTimeOver_Init:
	tst.l	(Plc_Buffer).w
	beq.s	+
	rts		; wait until the art is loaded
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine(a0)
	move.w	#spriteScreenPositionX(-48),x_pixel(a0)
	btst	#0,mapping_frame(a0)
	beq.s	+
	move.w	#spriteScreenPositionX(screen_width+48),x_pixel(a0)
+
	move.w	#spriteScreenPositionYCentered(0),y_pixel(a0)
	move.l	#Map_obj39,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Game_Over,0,1),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#0,render_flags(a0)
	move.b	#0,priority(a0)
; loc_13FCC:
ObjTimeOver_SlideIn:
	moveq	#16,d1
	cmpi.w	#spriteScreenPositionXCentered(0),x_pixel(a0)
	beq.s	ObjTimeOver_SetTimer
	blo.s	+
	neg.w	d1
+
	add.w	d1,x_pixel(a0)
	bra.w	DisplaySprite
; ===========================================================================
; loc_13FE2:
ObjTimeOver_SetTimer:
	move.w	#$2D0,anim_frame_duration(a0)
	addq.b	#2,routine(a0)
    if fixBugs
	bra.w	DisplaySprite
    else
	; There should be a branch to DisplaySprite here, but there isn't,
	; causing a one-frame flicker when the two words combine.
	rts
    endif
; ===========================================================================
; loc_13FEE:
ObjTimeOver_Wait:
	btst	#0,mapping_frame(a0)
	bne.w	ObjTimeOver_Display
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	bne.s	ObjTimeOver_Dismiss
	tst.w	anim_frame_duration(a0)
	beq.s	ObjTimeOver_Dismiss
	subq.w	#1,anim_frame_duration(a0)
	bra.w	DisplaySprite
; ===========================================================================
; loc_14014:
ObjTimeOver_Dismiss:
	tst.b	(Time_Over_flag).w
	bne.s	ObjTimeOver_TimeOver
	tst.b	(Time_Over_flag_2P).w
	bne.s	ObjTimeOver_TimeOver
	move.b	#GameModeID_ContinueScreen,(Game_Mode).w ; => ContinueScreen
	tst.b	(Continue_count).w
	bne.s	ObjTimeOver_Check2PMode
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	bra.s	ObjTimeOver_Check2PMode
; ===========================================================================
; loc_14034:
ObjTimeOver_TimeOver:
	clr.l	(Saved_Timer).w
	move.w	#1,(Level_Inactive_flag).w
; loc_1403E:
ObjTimeOver_Check2PMode:
	tst.w	(Two_player_mode).w
	beq.s	ObjTimeOver_Display

	move.w	#0,(Level_Inactive_flag).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	move.w	#VsRSID_Act,(Results_Screen_2P).w
	tst.b	(Time_Over_flag).w
	bne.s	ObjTimeOver_Display
	tst.b	(Time_Over_flag_2P).w
	bne.s	ObjTimeOver_Display
	move.w	#1,(Game_Over_2P).w
	move.w	#VsRSID_Zone,(Results_Screen_2P).w
	jsrto	JmpTo_sub_8476
	move.w	#-1,(a4)
	tst.b	parent+1(a0)
	beq.s	+
	addq.w	#1,a4
+
	move.b	#-2,(a4)
; BranchTo17_DisplaySprite
ObjTimeOver_Display:
	bra.w	DisplaySprite
