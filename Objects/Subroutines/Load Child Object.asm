;loc_367D0:
LoadChildObject:
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	+	; rts
	move.w	(a2)+,d0
	move.w	a1,(a0,d0.w) ; store pointer to child in parent's SST
	_move.b	(a2)+,id(a1) ; load obj
	move.b	(a2)+,subtype(a1)
	move.w	a0,objoff_2C(a1) ; store pointer to parent in child's SST
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+
	rts
; ===========================================================================
	; unused/dead code ; a0=object
	bsr.w	Obj_GetOrientationToPlayer
	bclr	#render_flags.x_flip,render_flags(a0)
	bclr	#status.npc.x_flip,status(a0)
	tst.w	d0
	beq.s	return_36818
	bset	#render_flags.x_flip,render_flags(a0)
	bset	#status.npc.x_flip,status(a0)

return_36818:
	rts
