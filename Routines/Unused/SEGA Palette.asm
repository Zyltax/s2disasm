; PalCycle_Sega:
	tst.b	(PalCycle_Timer+1).w
	bne.s	loc_2680
	lea	(Normal_palette_line2).w,a1
	lea	(Pal_Sega1).l,a0
	moveq	#5,d1
	move.w	(PalCycle_Frame).w,d0

loc_2636:
	bpl.s	loc_2640
	addq.w	#2,a0
	subq.w	#1,d1
	addq.w	#2,d0
	bra.s	loc_2636
; ===========================================================================

loc_2640:
	move.w	d0,d2
	andi.w	#$1E,d2
	bne.s	loc_264A
	addq.w	#2,d0

loc_264A:
	cmpi.w	#$60,d0
	bhs.s	loc_2654
	move.w	(a0)+,(a1,d0.w)

loc_2654:
	addq.w	#2,d0
	dbf	d1,loc_2640
	move.w	(PalCycle_Frame).w,d0
	addq.w	#2,d0
	move.w	d0,d2
	andi.w	#$1E,d2
	bne.s	loc_266A
	addq.w	#2,d0

loc_266A:
	cmpi.w	#$64,d0
	blt.s	loc_2678
	move.w	#$401,(PalCycle_Timer).w
	moveq	#-$C,d0

loc_2678:
	move.w	d0,(PalCycle_Frame).w
	moveq	#1,d0
	rts
; ===========================================================================

loc_2680:
	subq.b	#1,(PalCycle_Timer).w
	bpl.s	loc_26D2
	move.b	#4,(PalCycle_Timer).w
	move.w	(PalCycle_Frame).w,d0
	addi.w	#$C,d0
	cmpi.w	#$30,d0
	blo.s	loc_269E
	moveq	#0,d0
	rts
; ===========================================================================

loc_269E:
	move.w	d0,(PalCycle_Frame).w
	lea	(Pal_Sega2).l,a0
	lea	(a0,d0.w),a0
	lea	(Normal_palette+4).w,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	(a0)+,(a1)
	lea	(Normal_palette_line2).w,a1
	moveq	#0,d0
	moveq	#$2C,d1

loc_26BE:
	move.w	d0,d2
	andi.w	#$1E,d2
	bne.s	loc_26C8
	addq.w	#2,d0

loc_26C8:
	move.w	(a0),(a1,d0.w)
	addq.w	#2,d0
	dbf	d1,loc_26BE

loc_26D2:
	moveq	#1,d0
	rts

; ===========================================================================
;----------------------------------------------------------------------------
; Unused palette for the Sega logo
;----------------------------------------------------------------------------
; Pal_26D6:
Pal_Sega1:	BINCLUDE	"art/palettes/Unused Sega logo.bin"
;----------------------------------------------------------------------------
; Unused palette for the Sega logo (fading?)
;----------------------------------------------------------------------------
; Pal_26E2:
Pal_Sega2:	BINCLUDE	"art/palettes/Unused Sega logo 2.bin"

