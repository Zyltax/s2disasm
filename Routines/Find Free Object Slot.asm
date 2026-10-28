; ===========================================================================
; ---------------------------------------------------------------------------
; Single object loading subroutine
; Find an empty object array
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_17FDA: ; allocObject: ; SingleObjLoad:
AllocateObject:
	lea	(Dynamic_Object_RAM).w,a1 ; a1=object
	move.w	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d0 ; search to end of table
	tst.w	(Two_player_mode).w
	beq.s	+
	move.w	#(Dynamic_Object_RAM_2P_End-Dynamic_Object_RAM)/object_size-1,d0 ; search to $BF00 exclusive

/
	tst.b	id(a1)	; is object RAM slot empty?
	beq.s	return_17FF8	; if yes, branch
	lea	next_object(a1),a1 ; load obj address ; goto next object RAM slot
	dbf	d0,-	; repeat until end

return_17FF8:
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Single object loading subroutine
; Find an empty object array AFTER the current one in the table
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_17FFA: ; allocObjectAfterCurrent: ; SingleObjLoad2:
AllocateObjectAfterCurrent:
	movea.l	a0,a1
	move.w	#Dynamic_Object_RAM_End,d0	; $D000
	sub.w	a0,d0	; subtract current object location
    if object_size=$40
	lsr.w	#object_size_bits,d0	; divide by $40
	subq.w	#1,d0	; keep from going over the object zone
	bcs.s	return_18014
    else
	lsr.w	#6,d0			; divide by $40
	move.b	+(pc,d0.w),d0		; load the right number of objects from table
	bmi.s	return_18014		; if negative, we have failed!
    endif

-
	tst.b	id(a1)	; is object RAM slot empty?
	beq.s	return_18014	; if yes, branch
	lea	next_object(a1),a1 ; load obj address ; goto next object RAM slot
	dbf	d0,-	; repeat until end

return_18014:
	rts

    if object_size<>$40
+
.a	set	Dynamic_Object_RAM
.b	set	Dynamic_Object_RAM_End
.c	set	.b			; begin from bottom of array and decrease backwards
	rept	(.b-.a+$40-1)/$40	; repeat for all slots, minus exception
.c	set	.c-$40			; address for previous $40 (also skip last part)
	dc.b	(.b-.c-1)/object_size-1	; write possible slots according to object_size division + hack + dbf hack
	endm
	even
    endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Single object loading subroutine
; Find an empty object at or within < 12 slots after a3
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_18016: ; SingleObjLoad3:
AllocateObject_2P:
	movea.l	a3,a1
	move.w	#12-1,d0

-
	tst.b	id(a1)	; is object RAM slot empty?
	beq.s	return_18028	; if yes, branch
	lea	next_object(a1),a1 ; load obj address ; goto next object RAM slot
	dbf	d0,-	; repeat until end

return_18028:
	rts
