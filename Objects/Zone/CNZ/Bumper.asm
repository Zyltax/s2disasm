; ===========================================================================
; ---------------------------------------------------------------------------
; Object D7 - Bumper from Casino Night Zone
; ---------------------------------------------------------------------------
; Sprite_2C448:
ObjBumper:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBumper_Index(pc,d0.w),d1
	jmp	ObjBumper_Index(pc,d1.w)
; ===========================================================================
; off_2C456:
ObjBumper_Index:	offsetTable
		offsetTableEntry.w ObjBumper_Init	; 0
		offsetTableEntry.w ObjBumper_Main	; 2
; ===========================================================================
; loc_2C45A:
ObjBumper_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjBumper_MapUnc_2C626,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZHexBumper,2,0),art_tile(a0)
	jsrto	JmpTo55_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	#$CA,collision_flags(a0)
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	move.b	#1,objoff_34(a0)
+
	move.w	x_pos(a0),d0
	move.w	d0,d1
	subi.w	#$60,d0
	move.w	d0,objoff_30(a0)
	addi.w	#$60,d1
	move.w	d1,objoff_32(a0)
; loc_2C4AC:
ObjBumper_Main:
	move.b	collision_property(a0),d0
	beq.w	ObjBumper_MainContinued
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#0,collision_property(a0)
	beq.s	+
	bsr.s	ObjBumper_BouncePlayerOff
+
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#1,collision_property(a0)
	beq.s	+
	bsr.s	ObjBumper_BouncePlayerOff
+
	clr.b	collision_property(a0)
	bra.w	ObjBumper_MainContinued
; ===========================================================================
; loc_2C4D8:
ObjBumper_BouncePlayerOff:
	move.w	x_pos(a0),d1
	move.w	y_pos(a0),d2
	sub.w	x_pos(a1),d1
	sub.w	y_pos(a1),d2
	jsr	(CalcAngle).l
	addi.b	#$20,d0
	andi.w	#$C0,d0
	cmpi.w	#$40,d0
	beq.s	ObjBumper_BounceDown
	cmpi.w	#$80,d0
	beq.s	ObjBumper_BounceRight
	cmpi.w	#$C0,d0
	beq.s	ObjBumper_BounceUp
	move.w	#-$800,x_vel(a1)
	move.b	#2,anim(a0)
	bra.s	ObjBumper_BounceEnd
; ===========================================================================
; loc_2C516:
ObjBumper_BounceDown:
	subi.w	#$200,x_vel(a1)
	tst.w	d1
	bpl.s	+
	addi.w	#$400,x_vel(a1)
+
	move.w	#-$800,y_vel(a1)
	move.b	#1,anim(a0)
	bra.s	ObjBumper_BounceEnd
; ===========================================================================
; loc_2C534:
ObjBumper_BounceRight:
	move.w	#$800,x_vel(a1)
	move.b	#2,anim(a0)
	bra.s	ObjBumper_BounceEnd
; ===========================================================================
; loc_2C542:
ObjBumper_BounceUp:
	subi.w	#$200,x_vel(a1)
	tst.w	d1
	bpl.s	+
	addi.w	#$400,x_vel(a1)
+
	move.w	#$800,y_vel(a1)
	move.b	#1,anim(a0)
; loc_2C55E:
ObjBumper_BounceEnd:
	bset	#status.player.in_air,status(a1)
	bclr	#status.player.rolljumping,status(a1)
	bclr	#status.player.pushing,status(a1)
	clr.b	jumping(a1)
	move.w	#SndID_Bumper,d0
	jmp	(PlaySound).l
; ===========================================================================
; loc_2C57E:
ObjBumper_MainContinued:
	lea	(Ani_objD7).l,a1
	jsrto	JmpTo11_AnimateSprite
	tst.b	subtype(a0)
	beq.w	JmpTo30_MarkObjGone
	tst.b	objoff_34(a0)
	beq.s	loc_2C5AE
	move.w	x_pos(a0),d0
	subq.w	#1,d0
	cmp.w	objoff_30(a0),d0
	bne.s	+
	move.b	#0,objoff_34(a0)
+
	move.w	d0,x_pos(a0)
	bra.s	loc_2C5C4
; ===========================================================================

loc_2C5AE:
	move.w	x_pos(a0),d0
	addq.w	#1,d0
	cmp.w	objoff_32(a0),d0
	bne.s	+
	move.b	#1,objoff_34(a0)
+
	move.w	d0,x_pos(a0)

loc_2C5C4:
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	JmpTo30_DisplaySprite
; ---------------------------------------------------------------------------
+
	move.w	objoff_30(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bls.s	+
	move.w	objoff_32(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	loc_2C5F8
+
	jmp	(DisplaySprite).l
; ===========================================================================

loc_2C5F8:
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	jmp	(DeleteObject).l

    if removeJmpTos
JmpTo30_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
    endif
; ===========================================================================
; animation script
; off_2C610:
Ani_objD7:	offsetTable
		offsetTableEntry.w byte_2C616	; 0
		offsetTableEntry.w byte_2C619	; 1
		offsetTableEntry.w byte_2C61F	; 2
byte_2C616:	dc.b  $F,  0,$FF
	rev02even
byte_2C619:	dc.b   3,  1,  0,  1,$FD,  0
	rev02even
byte_2C61F:	dc.b   3,  2,  0,  2,$FD,  0
	even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjBumper_MapUnc_2C626:	include "mappings/sprite/objD7.asm"
; ===========================================================================

