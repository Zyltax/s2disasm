; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

    if ~~fixBugs
	; This check has been moved, so it is redundant.
	; See the bugfix under 'DrawSprite_Loop'.
; sub_1680A:
ChkDrawSprite:
	cmpi.b	#80,d5		; has the sprite limit been reached?
	blo.s	DrawSprite_Cont	; if it hasn't, branch
	rts	; otherwise, return
; End of function ChkDrawSprite
    endif


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16812:
DrawSprite:
	movea.w	art_tile(a0),a3
    if ~~fixBugs
	; This check has been moved, so it is redundant.
	; See the bugfix under 'DrawSprite_Loop'.
	cmpi.b	#80,d5
	bhs.s	DrawSprite_Done
    endif

    if fixBugs
; sub_1680A:
ChkDrawSprite:
    else
; loc_1681C:
DrawSprite_Cont:
    endif
	btst	#0,d4	; is the sprite to be X-flipped?
	bne.s	DrawSprite_FlipX	; if it is, branch
	btst	#1,d4	; is the sprite to be Y-flipped?
	bne.w	DrawSprite_FlipY	; if it is, branch
; loc__1682A:
DrawSprite_Loop:
    if fixBugs
	; In a rather overzealous optimisation, this game doesn't check if
	; the sprite limit has been reached every time it processes a sprite
	; piece. Naturally, this leads to the 'Sprite_Table' buffer being
	; overflowed if too many sprites are processed. To mitigate this, the
	; developers placed an $80 byte large spill buffer after
	; 'Sprite_Table', to 'catch' the overflow. Unfortunately, this spill
	; buffer is not big enough to catch all overflow: this oversight is
	; responsible for the famous 'Ashua' bug. To fix this, we'll just
	; undo this optimistaion. Sonic 3 & Knuckles undid this optimistaion
	; too, but heavily optimised the rest of 'BuildSprites' to make up
	; for it.
	cmpi.b	#80,d5		; has the sprite limit been reached?
	bhs.s	DrawSprite_Done	; if it has, branch
    endif
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set sprite size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0
	add.w	a3,d0
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0	; avoid activating sprite masking
+
	move.w	d0,(a2)+	; set X pos
	dbf	d1,DrawSprite_Loop	; repeat for next sprite
; return_16852:
DrawSprite_Done:
	rts
; ===========================================================================
; loc_16854:
DrawSprite_FlipX:
	btst	#1,d4	; is it to be Y-flipped as well?
	bne.w	DrawSprite_FlipXY	; if it is, branch

-
    if fixBugs
	; See the bugfix under 'DrawSprite_Loop'.
	cmpi.b	#80,d5		; has the sprite limit been reached?
	bhs.s	++		; if it has, branch
    endif
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4	; store size for later use
	move.b	d4,(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$800,d0	; toggle X flip flag
	move.w	d0,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	neg.w	d0	; negate X offset
	move.b	CellOffsets_XFlip(pc,d4.w),d4
	sub.w	d4,d0	; subtract sprite size
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,-
+
	rts
; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_168B4:
DrawSprite_FlipY:
-
    if fixBugs
	; See the bugfix under 'DrawSprite_Loop'.
	cmpi.b	#80,d5		; has the sprite limit been reached?
	bhs.s	++		; if it has, branch
    endif
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	CellOffsets_YFlip(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1000,d0	; toggle Y flip flag
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+	; set X pos
	dbf	d1,-
+
	rts
; ===========================================================================
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip2:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_168FC:
DrawSprite_FlipXY:
-
    if fixBugs
	; See the bugfix under 'DrawSprite_Loop'.
	cmpi.b	#80,d5		; has the sprite limit been reached?
	bhs.s	++		; if it has, branch
    endif
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	CellOffsets_YFlip2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	d4,(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1800,d0	; toggle X and Y flip flags
	move.w	d0,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	neg.w	d0
	move.b	CellOffsets_XFlip2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,-
+
	rts
; End of function DrawSprite

; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip2:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; ===========================================================================

