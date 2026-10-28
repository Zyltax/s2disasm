; ---------------------------------------------------------------------------
; Subroutine to initialize ring counter on the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4105A:
; Hud_LoadZero:
Hud_InitRings:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Rings),VRAM,WRITE),(VDP_control_port).l
	lea	Hud_TilesRings(pc),a2
	move.w	#(Hud_TilesBase_End-Hud_TilesRings)-1,d2
	bra.s	loc_41090

; ---------------------------------------------------------------------------
; Subroutine to load uncompressed HUD patterns ("E", "0", colon)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_4106E:
Hud_Base:
	lea	(VDP_data_port).l,a6
	bsr.w	Hud_Lives
	tst.w	(Two_player_mode).w
	bne.s	loc_410BC
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Score_E),VRAM,WRITE),(VDP_control_port).l
	lea	Hud_TilesBase(pc),a2
	move.w	#(Hud_TilesBase_End-Hud_TilesBase)-1,d2

loc_41090:
	lea	Art_Hud(pc),a1

loc_41094:
	move.w	#bytesToLcnt(tiles_to_bytes(hud_letter_num_tiles)),d1
	move.b	(a2)+,d0
	bmi.s	loc_410B0
	ext.w	d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a3

loc_410A4:
	move.l	(a3)+,(a6)
	dbf	d1,loc_410A4

loc_410AA:
	dbf	d2,loc_41094
	rts
; ===========================================================================

loc_410B0:
	move.l	#0,(a6)
	dbf	d1,loc_410B0
	bra.s	loc_410AA
; End of function Hud_Base

; ===========================================================================

loc_410BC:
	bsr.w	Hud_Lives2
	move.l	#Art_Hud,d1 ; source addreses
	move.w	#tiles_to_bytes(ArtTile_Art_HUD_Numbers_2P),d2 ; destination VRAM address
	move.w	#tiles_to_words(22),d3 ; DMA transfer length (in words)
	jmp	(QueueDMATransfer).l
; ===========================================================================

	charset	' ',$FF
	charset	'0',0
	charset	'1',2
	charset	'2',4
	charset	'3',6
	charset	'4',8
	charset	'5',$A
	charset	'6',$C
	charset	'7',$E
	charset	'8',$10
	charset	'9',$12
	charset	':',$14
	charset	'E',$16

; byte_410D4:
Hud_TilesBase:
	dc.b "E      0"
	dc.b "0:00"
; byte_410E0:
; Hud_TilesZero:
Hud_TilesRings:
	dc.b "  0"
Hud_TilesBase_End

	charset
	even
