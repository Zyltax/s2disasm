; ===========================================================================
; Unused leftover code from Sonic 1: checks whether an object is off-screen

; loc_16F16:
ChkObjectVisible:
	move.w	x_pos(a0),d0	; a0=object
	sub.w	(Camera_X_pos).w,d0
	bmi.s	.offscreen
	cmpi.w	#screen_width,d0
	bge.s	.offscreen
	move.w	y_pos(a0),d1
	sub.w	(Camera_Y_pos).w,d1
	bmi.s	.offscreen
	cmpi.w	#screen_height,d1
	bge.s	.offscreen
	moveq	#0,d0
	rts

.offscreen:
	moveq	#1,d0
	rts
; ===========================================================================
; Unused leftover code from Sonic 1: checks whether an object is off-screen
; with more precision than the above code, taking the object's width into account

; loc_16F3E:
ChkPartiallyVisible:
	moveq	#0,d1
	move.b	width_pixels(a0),d1	; a0=object
	move.w	x_pos(a0),d0
	sub.w	(Camera_X_pos).w,d0
	add.w	d1,d0
	bmi.s	.offscreen
	add.w	d1,d1
	sub.w	d1,d0
	cmpi.w	#screen_width,d0
	bge.s	.offscreen
	move.w	y_pos(a0),d1
	sub.w	(Camera_Y_pos).w,d1
	bmi.s	.offscreen
	cmpi.w	#screen_height,d1
	bge.s	.offscreen
	moveq	#0,d0
	rts

.offscreen:
	moveq	#1,d0
	rts
; ===========================================================================

