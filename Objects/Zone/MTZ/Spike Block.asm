; ===========================================================================
; ---------------------------------------------------------------------------
; Object 68 - Block with a spike that comes out of each side sequentially from MTZ
; ---------------------------------------------------------------------------
spikearoundblock_initial_x_pos =	objoff_30
spikearoundblock_initial_y_pos =	objoff_32
spikearoundblock_offset =		objoff_34 ; offset from the center
spikearoundblock_position =		objoff_36 ; 0 = retracted or expanding, 1 = expanded or retracting
spikearoundblock_waiting =		objoff_38 ; 0 = moving, 1 = waiting
; Sprite_27594:
ObjSpikyBlock:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjSpikyBlock_Index(pc,d0.w),d1
	jmp	ObjSpikyBlock_Index(pc,d1.w)
; ===========================================================================
; off_275A2:
ObjSpikyBlock_Index:	offsetTable
		offsetTableEntry.w ObjSpikyBlock_Init	; 0
		offsetTableEntry.w ObjSpikyBlock_Block	; 2
		offsetTableEntry.w ObjSpikyBlock_Spike	; 4
; ===========================================================================
; loc_275A8:
ObjSpikyBlock_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjSpikyBlock_ObjFloorSpike_MapUnc_27750,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzSpikeBlock,3,0),art_tile(a0)
	jsrto	JmpTo31_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	jsrto	JmpTo12_AllocateObjectAfterCurrent
	bne.s	+
	_move.b	id(a0),id(a1) ; load obj68
	addq.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	x_pos(a1),spikearoundblock_initial_x_pos(a1)
	move.w	y_pos(a1),spikearoundblock_initial_y_pos(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzSpike,1,0),art_tile(a1)
	ori.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#4,priority(a1)
	move.w	(Level_frame_counter).w,d0
	lsr.w	#6,d0
	move.w	d0,d1
	andi.w	#1,d0
	move.w	d0,spikearoundblock_position(a1)
	lsr.w	#1,d1
	add.b	subtype(a0),d1
	andi.w	#3,d1
	move.b	d1,routine_secondary(a1)
	move.b	d1,mapping_frame(a1)
	lea	(ObjSpikyBlock_CollisionFlags).l,a2
	move.b	(a2,d1.w),collision_flags(a1)
+
	move.b	#4,mapping_frame(a0)
; loc_2764A:
ObjSpikyBlock_Block:
	move.w	#$1B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo11_SolidObject
	jmpto	JmpTo20_MarkObjGone
; ===========================================================================
; loc_27662:
ObjSpikyBlock_Spike:
	bsr.w	ObjSpikyBlock_Spike_Action
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	add.w	d0,d0
	move.w	ObjSpikyBlock_Spike_Directions(pc,d0.w),d1
	jsr	ObjSpikyBlock_Spike_Directions(pc,d1.w)
	move.w	spikearoundblock_initial_x_pos(a0),d0
	jmpto	JmpTo2_MarkObjGone2
; ===========================================================================
; off_2767E:
ObjSpikyBlock_Spike_Directions: offsetTable
	offsetTableEntry.w ObjSpikyBlock_Spike_Up	; 0
	offsetTableEntry.w ObjSpikyBlock_Spike_Right	; 1
	offsetTableEntry.w ObjSpikyBlock_Spike_Down	; 2
	offsetTableEntry.w ObjSpikyBlock_Spike_Left	; 3
; ===========================================================================
; These routines update the position of the spike.
; ===========================================================================
; loc_27686:
ObjSpikyBlock_Spike_Up:
	moveq	#0,d0
	move.b	spikearoundblock_offset(a0),d0
	neg.w	d0
	add.w	spikearoundblock_initial_y_pos(a0),d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
; loc_27698:
ObjSpikyBlock_Spike_Right:
	moveq	#0,d0
	move.b	spikearoundblock_offset(a0),d0
	add.w	spikearoundblock_initial_x_pos(a0),d0
	move.w	d0,x_pos(a0)
	rts
; ===========================================================================
; loc_276A8:
ObjSpikyBlock_Spike_Down:
	moveq	#0,d0
	move.b	spikearoundblock_offset(a0),d0
	add.w	spikearoundblock_initial_y_pos(a0),d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
; loc_276B8:
ObjSpikyBlock_Spike_Left:
	moveq	#0,d0
	move.b	spikearoundblock_offset(a0),d0
	neg.w	d0
	add.w	spikearoundblock_initial_x_pos(a0),d0
	move.w	d0,x_pos(a0)
	rts
; ===========================================================================
; loc_276CA:
ObjSpikyBlock_Spike_Action:
	tst.w	spikearoundblock_waiting(a0)
	beq.s	+
	move.b	(Level_frame_counter+1).w,d0
	andi.b	#$3F,d0
	bne.s	ObjSpikyBlock_Spike_Action_End
	clr.w	spikearoundblock_waiting(a0)
	_btst	#render_flags.on_screen,render_flags(a0)	; is the spike on the screen?
	_beq.s	+						; if not, branch
	move.w	#SndID_SpikesMove,d0
	jsr	(PlaySound).l
+
	tst.w	spikearoundblock_position(a0)
	beq.s	ObjSpikyBlock_Spike_Expanding
; ObjSpikyBlock_Spike_Retracting:
	subi.w	#$800,spikearoundblock_offset(a0)	; retract the spike
	bcc.s	ObjSpikyBlock_Spike_Action_End
	move.w	#0,spikearoundblock_offset(a0)
	move.w	#0,spikearoundblock_position(a0)
	move.w	#1,spikearoundblock_waiting(a0)
	addq.b	#1,routine_secondary(a0)
	andi.b	#3,routine_secondary(a0)
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.b	d0,mapping_frame(a0)
	move.b	ObjSpikyBlock_CollisionFlags(pc,d0.w),collision_flags(a0)
	rts
; ===========================================================================
; loc_2772A:
ObjSpikyBlock_Spike_Expanding:
	addi.w	#$800,spikearoundblock_offset(a0)	; expand the spike
	cmpi.w	#$2000,spikearoundblock_offset(a0)	; did it reach full expansion?
	blo.s	ObjSpikyBlock_Spike_Action_End			; if not, return
	move.w	#$2000,spikearoundblock_offset(a0)
	move.w	#1,spikearoundblock_position(a0)
	move.w	#1,spikearoundblock_waiting(a0)
; return_2774A:
ObjSpikyBlock_Spike_Action_End:
	rts
; ===========================================================================
; byte_2774C:
ObjSpikyBlock_CollisionFlags:
	dc.b $84	; 0
	dc.b $A6	; 1
	dc.b $84	; 2
	dc.b $A6	; 3
	even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjSpikyBlock_ObjFloorSpike_MapUnc_27750:	include "mappings/sprite/obj68.asm"
