; loc_367AA:
InheritParentXYFlip:
	move.b	render_flags(a0),d0
	andi.b	#~(1<<render_flags.x_flip|1<<render_flags.y_flip),d0
	move.b	status(a0),d2
	andi.b	#~(1<<status.npc.x_flip|1<<status.npc.y_flip),d2
	move.b	render_flags(a1),d1
	andi.b	#1<<render_flags.x_flip|1<<render_flags.y_flip,d1
	or.b	d1,d0
	or.b	d1,d2
	move.b	d0,render_flags(a0)
	move.b	d2,status(a0)
	rts
; ===========================================================================

