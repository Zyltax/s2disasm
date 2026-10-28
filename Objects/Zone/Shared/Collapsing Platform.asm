; ===========================================================================
; ----------------------------------------------------------------------------
; Object 1A - Collapsing platform from HPZ (and GHZ)
; also supports OOZ, but never made use of
;
; Unlike Object 1F, this supports sloped platforms and subtype-dependant
; mappings. Both are used by GHZ, the latter to allow different shading
; on right-facing ledges.
; ----------------------------------------------------------------------------
; Sprite_108BC:
ObjHPZCollapsPform:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjHPZCollapsPform_Index(pc,d0.w),d1
	jmp	ObjHPZCollapsPform_Index(pc,d1.w)
; ===========================================================================
; off_108CA:
ObjHPZCollapsPform_Index:	offsetTable
		offsetTableEntry.w ObjHPZCollapsPform_Init		; 0
		offsetTableEntry.w ObjHPZCollapsPform_Main		; 2
		offsetTableEntry.w ObjHPZCollapsPform_Fragment	; 4
; ===========================================================================

collapsing_platform_delay_pointer = objoff_34
collapsing_platform_delay_counter = objoff_38
collapsing_platform_stood_on_flag = objoff_3A
collapsing_platform_slope_pointer = objoff_3C

; loc_108D0:
ObjHPZCollapsPform_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjHPZCollapsPform_MapUnc_10C6C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#7,collapsing_platform_delay_counter(a0)
	move.b	subtype(a0),mapping_frame(a0)
	move.l	#ObjHPZCollapsPform_DelayData,collapsing_platform_delay_pointer(a0)
	cmpi.b	#hidden_palace_zone,(Current_Zone).w
	bne.s	+
	move.l	#ObjHPZCollapsPform_MapUnc_1101C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZPlatform,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$30,width_pixels(a0)
	move.l	#ObjHPZCollapsPform_HPZ_SlopeData,collapsing_platform_slope_pointer(a0)
	move.l	#ObjHPZCollapsPform_HPZ_DelayData,collapsing_platform_delay_pointer(a0)
	bra.s	ObjHPZCollapsPform_Main
; ===========================================================================
+
	cmpi.b	#oil_ocean_zone,(Current_Zone).w
	bne.s	+
	move.l	#ObjCollapsPform_MapUnc_110C6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$40,width_pixels(a0)
	move.l	#ObjHPZCollapsPform_OOZ_SlopeData,collapsing_platform_slope_pointer(a0)
	bra.s	ObjHPZCollapsPform_Main
; ===========================================================================
+
	move.l	#ObjHPZCollapsPform_GHZ_SlopeData,collapsing_platform_slope_pointer(a0)
    if fixBugs
	move.b	#$30,width_pixels(a0)
    else
	; This is too wide, causing the player to teleport downwards when
	; running off the platform. Sonic 1 used a width of $30 for the
	; collision and $64 for width_pixels, but in Sonic 2 they must be
	; the same. $64 seems to be overkill, as $30 still results in good
	; sprite culling.
	move.b	#$34,width_pixels(a0)
    endif
	move.b	#$38,y_radius(a0)
	bset	#render_flags.explicit_height,render_flags(a0)
; loc_1097C:
ObjHPZCollapsPform_Main:
	tst.b	collapsing_platform_stood_on_flag(a0)
	beq.s	+
	tst.b	collapsing_platform_delay_counter(a0)
	beq.w	ObjHPZCollapsPform_CreateFragments	; time up; collapse
	subq.b	#1,collapsing_platform_delay_counter(a0)
+
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	sub_1099E
	move.b	#1,collapsing_platform_stood_on_flag(a0)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_1099E:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	movea.l	collapsing_platform_slope_pointer(a0),a2 ; a2=object
	move.w	x_pos(a0),d4
	jsrto	JmpTo_SlopedPlatform
	bra.w	MarkObjGone
; End of function sub_1099E

; ===========================================================================
; loc_109B4:
ObjHPZCollapsPform_Fragment:
	tst.b	collapsing_platform_delay_counter(a0)
	beq.s	ObjHPZCollapsPform_FragmentFall	; time up; collapse
	tst.b	collapsing_platform_stood_on_flag(a0)
	bne.s	+
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bra.w	DisplaySprite
; ===========================================================================
+
	bsr.w	sub_1099E
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bne.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	sub_109DC
	lea	(Sidekick).w,a1 ; a1=character

sub_109DC:
	btst	#status.player.on_object,status(a1)
	beq.s	+
	bclr	#status.player.on_object,status(a1)
	bclr	#status.player.pushing,status(a1)
	move.b	#AniIDSonAni_Run,prev_anim(a1)	; Force player's animation to restart
+
	rts
; End of function sub_109DC

; ===========================================================================
; loc_109F8:
ObjHPZCollapsPform_FragmentFall:
	bsr.w	ObjectMoveAndFall
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 1F - Collapsing platform from ARZ, MCZ and OOZ (and MZ, SLZ and SBZ)
; ----------------------------------------------------------------------------
; Sprite_10A08:
ObjCollapsPform:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCollapsPform_Index(pc,d0.w),d1
	jmp	ObjCollapsPform_Index(pc,d1.w)
; ===========================================================================
; off_10A16:
ObjCollapsPform_Index:	offsetTable
		offsetTableEntry.w ObjCollapsPform_Init		; 0
		offsetTableEntry.w ObjCollapsPform_Main		; 2
		offsetTableEntry.w ObjCollapsPform_Fragment	; 4
; ===========================================================================
; loc_10A1C:
ObjCollapsPform_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjCollapsPform_MapUnc_10F0C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MZ_Platform,2,0),art_tile(a0)
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#7,collapsing_platform_delay_counter(a0)
	move.b	#$44,width_pixels(a0)
	lea	(ObjCollapsPform_DelayData_EvenSubtype).l,a4
	btst	#0,subtype(a0)
	beq.s	+
	lea	(ObjCollapsPform_DelayData_OddSubtype).l,a4
+
	move.l	a4,collapsing_platform_delay_pointer(a0)
	cmpi.b	#oil_ocean_zone,(Current_Zone).w
	bne.s	+
	move.l	#ObjCollapsPform_MapUnc_110C6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$40,width_pixels(a0)
	move.l	#ObjCollapsPform_OOZ_DelayData,collapsing_platform_delay_pointer(a0)
+
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	bne.s	+
	move.l	#ObjCollapsPform_MapUnc_11106,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MCZCollapsePlat,3,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$20,width_pixels(a0)
	move.l	#ObjCollapsPform_MCZ_DelayData,collapsing_platform_delay_pointer(a0)
+
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	ObjCollapsPform_Main
	move.l	#ObjCollapsPform_MapUnc_1115E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$20,width_pixels(a0)
	move.l	#ObjCollapsPform_ARZ_DelayData,collapsing_platform_delay_pointer(a0)
; loc_10AD6:
ObjCollapsPform_Main:
	tst.b	collapsing_platform_stood_on_flag(a0)
	beq.s	+
	tst.b	collapsing_platform_delay_counter(a0)
	beq.w	ObjCollapsPform_CreateFragments	; time up; collapse
	subq.b	#1,collapsing_platform_delay_counter(a0)
+
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	sub_10AF8
	move.b	#1,collapsing_platform_stood_on_flag(a0)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_10AF8:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	#$10,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo2_PlatformObject
	bra.w	MarkObjGone
; End of function sub_10AF8

; ===========================================================================
; loc_10B0E:
ObjCollapsPform_Fragment:
	tst.b	collapsing_platform_delay_counter(a0)
	beq.s	ObjCollapsPform_FragmentFall	; time up; collapse
	tst.b	collapsing_platform_stood_on_flag(a0)
	bne.s	+
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bra.w	DisplaySprite
; ===========================================================================
+
	bsr.w	sub_10AF8
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bne.s	+	; rts
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	sub_10B36
	lea	(Sidekick).w,a1 ; a1=character

sub_10B36:
	btst	#status.player.on_object,status(a1)
	beq.s	+	; rts
	bclr	#status.player.on_object,status(a1)
	bclr	#status.player.pushing,status(a1)
	move.b	#AniIDSonAni_Run,prev_anim(a1)	; Force player's animation to restart
+
	rts
; End of function sub_10B36

; ===========================================================================
; loc_10B52:
ObjCollapsPform_FragmentFall:
	bsr.w	ObjectMoveAndFall
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
; loc_10B62:
ObjCollapsPform_CreateFragments:
	addq.b	#1,mapping_frame(a0)
	bra.s	+
; ===========================================================================
; loc_10B68:
ObjHPZCollapsPform_CreateFragments:
	addq.b	#2,mapping_frame(a0)
+
	movea.l	collapsing_platform_delay_pointer(a0),a4
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	add.w	d0,d0
	movea.l	mappings(a0),a3
	adda.w	(a3,d0.w),a3
	move.w	(a3)+,d1
	subq.w	#1,d1
	bset	#render_flags.static_mappings,render_flags(a0)
	_move.b	id(a0),d4
	move.b	render_flags(a0),d5
	movea.l	a0,a1
	bra.s	+
; ===========================================================================
-	bsr.w	AllocateObject
	bne.s	+++
	addq.w	#8,a3
+
	move.b	#4,routine(a1)
	_move.b	d4,id(a1) ; load obj1F
	move.l	a3,mappings(a1)
	move.b	d5,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	priority(a0),priority(a1)
	move.b	width_pixels(a0),width_pixels(a1)
	move.b	y_radius(a0),y_radius(a1)
	move.b	(a4)+,collapsing_platform_delay_counter(a1)
	cmpa.l	a0,a1
	bhs.s	+
	bsr.w	DisplaySprite2
+	dbf	d1,-
+
	bsr.w	DisplaySprite
	move.w	#SndID_Smash,d0
	jmp	(PlaySound).l
; ===========================================================================
; Delay data for obj1A in all but HPZ:
;byte_10BF2:
ObjHPZCollapsPform_DelayData:
	dc.b $1C,$18,$14,$10,$1A,$16,$12, $E, $A,  6,$18,$14,$10, $C,  8,  4
	dc.b $16,$12, $E, $A,  6,  2,$14,$10, $C; 16
	rev02even
; Delay data for obj1A in HPZ:
;byte_10C0B:
ObjHPZCollapsPform_HPZ_DelayData:
	dc.b $18,$1C,$20,$1E,$1A,$16,  6, $E,$14,$12, $A,  2
	rev02even
; Delay data for obj1F even subtypes in all levels without more specific data:
;byte_10C17:
ObjCollapsPform_DelayData_EvenSubtype:
	dc.b $1E,$16, $E,  6,$1A,$12, $A,  2
	rev02even
; Delay data for obj1F odd subtypes in all levels without more specific data:
;byte_10C1F:
ObjCollapsPform_DelayData_OddSubtype:
	dc.b $16,$1E,$1A,$12,  6, $E, $A,  2
	rev02even
; Delay data for obj1F in OOZ:
;byte_10C27:
ObjCollapsPform_OOZ_DelayData:
	dc.b $1A,$12, $A,  2,$16, $E,  6
	rev02even
; Delay data for obj1F in MCZ:
;byte_10C2E:
ObjCollapsPform_MCZ_DelayData:
	dc.b $1A,$16,$12, $E, $A,  2
	rev02even
; Delay data for obj1F in ARZ:
;byte_10C34:
ObjCollapsPform_ARZ_DelayData:
	dc.b $16,$1A,$18,$12,  6, $E, $A,  2
	rev02even
; S1 remnant: Height data for GHZ collapsing platform (unused):
;byte_10C3C:
ObjHPZCollapsPform_GHZ_SlopeData:
	dc.b $20,$20,$20,$20,$20,$20,$20,$20,$21,$21,$22,$22,$23,$23,$24,$24
	dc.b $25,$25,$26,$26,$27,$27,$28,$28,$29,$29,$2A,$2A,$2B,$2B,$2C,$2C; 16
	dc.b $2D,$2D,$2E,$2E,$2F,$2F,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30; 32
	even
; -------------------------------------------------------------------------------
; unused sprite mappings (GHZ)
; -------------------------------------------------------------------------------
ObjHPZCollapsPform_MapUnc_10C6C:	include "mappings/sprite/obj1A_a.asm"
; ----------------------------------------------------------------------------
; unused sprite mappings (MZ, SLZ, SBZ)
; ----------------------------------------------------------------------------
ObjCollapsPform_MapUnc_10F0C:	include "mappings/sprite/obj1F_a.asm"

; Slope data for platforms.
;byte_10FDC:
ObjHPZCollapsPform_OOZ_SlopeData:
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
;byte_10FEC:
ObjHPZCollapsPform_HPZ_SlopeData
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	even
; ----------------------------------------------------------------------------
; sprite mappings (HPZ)
; ----------------------------------------------------------------------------
ObjHPZCollapsPform_MapUnc_1101C:	include "mappings/sprite/obj1A_b.asm"
; ----------------------------------------------------------------------------
; sprite mappings (OOZ)
; ----------------------------------------------------------------------------
ObjCollapsPform_MapUnc_110C6:	include "mappings/sprite/obj1F_b.asm"
; -------------------------------------------------------------------------------
; sprite mappings (MCZ)
; -------------------------------------------------------------------------------
ObjCollapsPform_MapUnc_11106:	include "mappings/sprite/obj1F_c.asm"
; -------------------------------------------------------------------------------
; sprite mappings (ARZ)
; -------------------------------------------------------------------------------
ObjCollapsPform_MapUnc_1115E:	include "mappings/sprite/obj1F_d.asm"
; ===========================================================================

