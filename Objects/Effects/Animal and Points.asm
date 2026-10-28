; ===========================================================================
; ----------------------------------------------------------------------------
; Object 28 - Animal and the 100 points from a badnik
; ----------------------------------------------------------------------------
animal_ground_routine_base = objoff_30
animal_ground_x_vel = objoff_32
animal_ground_y_vel = objoff_34
; Sprite_1188C:
ObjAnimal:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAnimal_Index(pc,d0.w),d1
	jmp	ObjAnimal_Index(pc,d1.w)
; ===========================================================================
; off_1189A:
ObjAnimal_Index:	offsetTable
		offsetTableEntry.w ObjAnimal_Init	;   0
		offsetTableEntry.w ObjAnimal_Main	;   2
		offsetTableEntry.w ObjAnimal_Walk	;   4
		offsetTableEntry.w ObjAnimal_Fly	;   6
		offsetTableEntry.w ObjAnimal_Walk	;   8
		offsetTableEntry.w ObjAnimal_Walk	;  $A
		offsetTableEntry.w ObjAnimal_Walk	;  $C
		offsetTableEntry.w ObjAnimal_Fly	;  $E
		offsetTableEntry.w ObjAnimal_Walk	; $10
		offsetTableEntry.w ObjAnimal_Fly	; $12
		offsetTableEntry.w ObjAnimal_Walk	; $14
		offsetTableEntry.w ObjAnimal_Walk	; $16
		offsetTableEntry.w ObjAnimal_Walk	; $18
		offsetTableEntry.w ObjAnimal_Walk	; $1A
		offsetTableEntry.w ObjAnimal_Prison	; $1C
		; These are the S1 ending actions:
		offsetTableEntry.w ObjAnimal_FlickyWait	; $1E
		offsetTableEntry.w ObjAnimal_FlickyWait	; $20
		offsetTableEntry.w ObjAnimal_FlickyJump	; $22
		offsetTableEntry.w ObjAnimal_RabbitWait	; $24
		offsetTableEntry.w ObjAnimal_LandJump	; $26
		offsetTableEntry.w ObjAnimal_SingleBounce	; $28
		offsetTableEntry.w ObjAnimal_LandJump	; $2A
		offsetTableEntry.w ObjAnimal_SingleBounce	; $2C
		offsetTableEntry.w ObjAnimal_LandJump	; $2E
		offsetTableEntry.w ObjAnimal_FlyBounce	; $30
		offsetTableEntry.w ObjAnimal_DoubleBounce	; $32

; byte_118CE:
ObjAnimal_ZoneAnimals:	zoneOrderedTable 1,2

zoneAnimals macro first,second
	zoneTableEntry.b (ObjAnimal_Properties_first - ObjAnimal_Properties) / 8
	zoneTableEntry.b (ObjAnimal_Properties_second - ObjAnimal_Properties) / 8
    endm
	; This table declares what animals will appear in the zone.
	; When an enemy is destroyed, a random animal is chosen from the 2 selected animals.
	; Note: you must also load the corresponding art in the PLCs.
	zoneAnimals.b Squirrel,	Flicky	; EHZ
	zoneAnimals.b Squirrel,	Flicky	; Zone 1
	zoneAnimals.b Squirrel,	Flicky	; WZ
	zoneAnimals.b Squirrel,	Flicky	; Zone 3
	zoneAnimals.b Monkey,	Eagle	; MTZ1,2
	zoneAnimals.b Monkey,	Eagle	; MTZ3
	zoneAnimals.b Monkey,	Eagle	; WFZ
	zoneAnimals.b Monkey,	Eagle	; HTZ
	zoneAnimals.b Mouse,	Seal	; HPZ
	zoneAnimals.b Mouse,	Seal	; Zone 9
	zoneAnimals.b Penguin,	Seal	; OOZ
	zoneAnimals.b Mouse,	Chicken	; MCZ
	zoneAnimals.b Bear,	Flicky	; CNZ
	zoneAnimals.b Rabbit,	Eagle	; CPZ
	zoneAnimals.b Pig,	Chicken	; DEZ
	zoneAnimals.b Penguin,	Flicky	; ARZ
	zoneAnimals.b Turtle,	Chicken	; SCZ
    zoneTableEnd

; word_118F0:
ObjAnimal_Properties:

obj28decl macro	xvel,yvel,mappings,{INTLABEL}
ObjAnimal_Properties___LABEL__: label *
	dc.w xvel
	dc.w yvel
	dc.l mappings
    endm
		; This table declares the speed and mappings of each animal.
Rabbit:		obj28decl -$200,-$400,ObjAnimal_MapUnc_11EAC
Chicken:	obj28decl -$200,-$300,ObjAnimal_MapUnc_11E1C
Penguin:	obj28decl -$180,-$300,ObjAnimal_MapUnc_11EAC
Seal:		obj28decl -$140,-$180,ObjAnimal_MapUnc_11E88
Pig:		obj28decl -$1C0,-$300,ObjAnimal_MapUnc_11E64
Flicky:		obj28decl -$300,-$400,ObjAnimal_MapUnc_11E1C
Squirrel:	obj28decl -$280,-$380,ObjAnimal_MapUnc_11E40
Eagle:		obj28decl -$280,-$300,ObjAnimal_MapUnc_11E1C
Mouse:		obj28decl -$200,-$380,ObjAnimal_MapUnc_11E40
Monkey:		obj28decl -$2C0,-$300,ObjAnimal_MapUnc_11E40
Turtle:		obj28decl -$140,-$200,ObjAnimal_MapUnc_11E40
Bear:		obj28decl -$200,-$300,ObjAnimal_MapUnc_11E40

	; The following tables tell the properties of animals based on their subtype.

; word_11950:
ObjAnimal_Speeds:
	dc.w -$440, -$400
	dc.w -$440, -$400	; 2
	dc.w -$440, -$400	; 4
	dc.w -$300, -$400	; 6
	dc.w -$300, -$400	; 8
	dc.w -$180, -$300	; 10
	dc.w -$180, -$300	; 12
	dc.w -$140, -$180	; 14
	dc.w -$1C0, -$300	; 16
	dc.w -$200, -$300	; 18
	dc.w -$280, -$380	; 20
; off_1197C:
ObjAnimal_Mappings:
	dc.l ObjAnimal_MapUnc_11E1C
	dc.l ObjAnimal_MapUnc_11E1C	; 1
	dc.l ObjAnimal_MapUnc_11E1C	; 2
	dc.l ObjAnimal_MapUnc_11EAC	; 3
	dc.l ObjAnimal_MapUnc_11EAC	; 4
	dc.l ObjAnimal_MapUnc_11EAC	; 5
	dc.l ObjAnimal_MapUnc_11EAC	; 6
	dc.l ObjAnimal_MapUnc_11E88	; 7
	dc.l ObjAnimal_MapUnc_11E64	; 8
	dc.l ObjAnimal_MapUnc_11E1C	; 9
	dc.l ObjAnimal_MapUnc_11E40	; 10
; word_119A8:
ObjAnimal_ArtLocations:
	dc.w  ArtTile_ArtNem_S1EndFlicky	;  0	Flicky
	dc.w  ArtTile_ArtNem_S1EndFlicky	;  1	Flicky
	dc.w  ArtTile_ArtNem_S1EndFlicky	;  2	Flicky
	dc.w  ArtTile_ArtNem_S1EndRabbit	;  3	Rabbit
	dc.w  ArtTile_ArtNem_S1EndRabbit	;  4	Rabbit
	dc.w  ArtTile_ArtNem_S1EndPenguin	;  5	Penguin
	dc.w  ArtTile_ArtNem_S1EndPenguin	;  6	Penguin
	dc.w  ArtTile_ArtNem_S1EndSeal		;  7	Seal
	dc.w  ArtTile_ArtNem_S1EndPig		;  8	Pig
	dc.w  ArtTile_ArtNem_S1EndChicken	;  9	Chicken
	dc.w  ArtTile_ArtNem_S1EndSquirrel	; 10	Squirrel

; ===========================================================================
; loc_119BE:
ObjAnimal_Init:
	tst.b	subtype(a0)
	beq.w	ObjAnimal_InitRandom
	moveq	#0,d0
	move.b	subtype(a0),d0
	add.w	d0,d0
	move.b	d0,routine(a0)
	subi.w	#$14,d0
	move.w	ObjAnimal_ArtLocations(pc,d0.w),art_tile(a0)
	add.w	d0,d0
	move.l	ObjAnimal_Mappings(pc,d0.w),mappings(a0)
	lea	ObjAnimal_Speeds(pc),a1
	move.w	(a1,d0.w),animal_ground_x_vel(a0)
	move.w	(a1,d0.w),x_vel(a0)
	move.w	2(a1,d0.w),animal_ground_y_vel(a0)
	move.w	2(a1,d0.w),y_vel(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$C,y_radius(a0)
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	bset	#render_flags.x_flip,render_flags(a0)
	move.b	#6,priority(a0)
	move.b	#8,width_pixels(a0)
	move.b	#7,anim_frame_duration(a0)
	bra.w	DisplaySprite
; ===========================================================================
; loc_11A2C:
ObjAnimal_InitRandom:
	addq.b	#2,routine(a0)
	jsrto	JmpTo_RandomNumber
	move.w	#make_art_tile(ArtTile_ArtNem_Animal_1,0,0),art_tile(a0)
	andi.w	#1,d0
	beq.s	+
	move.w	#make_art_tile(ArtTile_ArtNem_Animal_2,0,0),art_tile(a0)
+
	moveq	#0,d1
	move.b	(Current_Zone).w,d1
	add.w	d1,d1
	add.w	d0,d1
	lea	ObjAnimal_ZoneAnimals(pc),a1
	move.b	(a1,d1.w),d0
	move.b	d0,animal_ground_routine_base(a0)
	lsl.w	#3,d0
	lea	ObjAnimal_Properties(pc),a1
	adda.w	d0,a1
	move.w	(a1)+,animal_ground_x_vel(a0)
	move.w	(a1)+,animal_ground_y_vel(a0)
	move.l	(a1)+,mappings(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$C,y_radius(a0)
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	bset	#render_flags.x_flip,render_flags(a0)
	move.b	#6,priority(a0)
	move.b	#8,width_pixels(a0)
	move.b	#7,anim_frame_duration(a0)
	move.b	#2,mapping_frame(a0)
	move.w	#-$400,y_vel(a0)
	tst.b	objoff_38(a0)
	bne.s	++
	bsr.w	AllocateObject
	bne.s	+
	_move.b	#ObjID_Points,id(a1) ; load obj29
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	objoff_3E(a0),d0
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a1)
+	bra.w	DisplaySprite
; ===========================================================================
+
	move.b	#$1C,routine(a0)
	clr.w	x_vel(a0)
	bra.w	DisplaySprite
; ===========================================================================
;loc_11ADE
ObjAnimal_Main:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	DeleteObject
	bsr.w	ObjectMoveAndFall
	tst.w	y_vel(a0)
	bmi.s	+
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_x_vel(a0),x_vel(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
	move.b	#1,mapping_frame(a0)
	move.b	animal_ground_routine_base(a0),d0
	add.b	d0,d0
	addq.b	#4,d0
	move.b	d0,routine(a0)
	tst.b	objoff_38(a0)
	beq.s	+
	btst	#4,(Vint_runcount+3).w
	beq.s	+
	neg.w	x_vel(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
+	bra.w	DisplaySprite
; ===========================================================================
;loc_11B38
ObjAnimal_Walk:

	bsr.w	ObjectMoveAndFall
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	+
	move.b	#0,mapping_frame(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	tst.b	subtype(a0)
	bne.s	ObjAnimal_ChkDel
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
;loc_11B74
ObjAnimal_Fly:
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)
	tst.w	y_vel(a0)
	bmi.s	+
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
	tst.b	subtype(a0)
	beq.s	+
	cmpi.b	#$A,subtype(a0)
	beq.s	+
	neg.w	x_vel(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
+
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#1,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#1,mapping_frame(a0)
+
	tst.b	subtype(a0)
	bne.s	ObjAnimal_ChkDel
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
;loc_11BD8
ObjAnimal_ChkDel:
	move.w	x_pos(a0),d0
	sub.w	(MainCharacter+x_pos).w,d0
	bcs.s	+
	subi.w	#$180,d0
	bpl.s	+
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	DeleteObject
+
	bra.w	DisplaySprite
; ===========================================================================
;loc_11BF4
ObjAnimal_Prison:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	DeleteObject
	subq.w	#1,objoff_36(a0)
	bne.w	+
	move.b	#2,routine(a0)
	move.b	#1,priority(a0)
+
	bra.w	DisplaySprite
; ===========================================================================
;loc_11C14
ObjAnimal_FlickyWait:
	bsr.w	ChkAnimalInRange
	bcc.s	+
	move.w	animal_ground_x_vel(a0),x_vel(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
	move.b	#$E,routine(a0)
	bra.w	ObjAnimal_Fly
; ===========================================================================
+
	bra.w	ObjAnimal_ChkDel
; ===========================================================================
;loc_11C34
ObjAnimal_FlickyJump:
	bsr.w	ChkAnimalInRange
	bpl.s	+
	clr.w	x_vel(a0)
	clr.w	animal_ground_x_vel(a0)
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)
	bsr.w	AnimalJump
	bsr.w	AnimalFaceSonic
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#1,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#1,mapping_frame(a0)
+
	bra.w	ObjAnimal_ChkDel
; ===========================================================================
;loc_11C6E
ObjAnimal_RabbitWait:
	bsr.w	ChkAnimalInRange
	bpl.s	++
	move.w	animal_ground_x_vel(a0),x_vel(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
	move.b	#4,routine(a0)
	bra.w	ObjAnimal_Walk
; ===========================================================================
;loc_11C8A
ObjAnimal_DoubleBounce:
	bsr.w	ObjectMoveAndFall
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	++
	move.b	#0,mapping_frame(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	++
	not.b	objoff_29(a0)
	bne.s	+
	neg.w	x_vel(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	bra.w	ObjAnimal_ChkDel
; ===========================================================================
;loc_11CC8
ObjAnimal_LandJump:
	bsr.w	ChkAnimalInRange
	bpl.s	+
	clr.w	x_vel(a0)
	clr.w	animal_ground_x_vel(a0)
	bsr.w	ObjectMoveAndFall
	bsr.w	AnimalJump
	bsr.w	AnimalFaceSonic
+
	bra.w	ObjAnimal_ChkDel
; ===========================================================================
;loc_11CE6
ObjAnimal_SingleBounce:
	bsr.w	ChkAnimalInRange
	bpl.s	+
	bsr.w	ObjectMoveAndFall
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	+
	move.b	#0,mapping_frame(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	neg.w	x_vel(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	bra.w	ObjAnimal_ChkDel
; ===========================================================================
;loc_11D24
ObjAnimal_FlyBounce:
	bsr.w	ChkAnimalInRange
	bpl.s	+++
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)
	tst.w	y_vel(a0)
	bmi.s	++
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	++
	not.b	objoff_29(a0)
	bne.s	+
	neg.w	x_vel(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#1,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#1,mapping_frame(a0)
+
	bra.w	ObjAnimal_ChkDel

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_11D78
AnimalJump:
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	+	; rts
	move.b	#0,mapping_frame(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+	; rts
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	rts
; End of function AnimalJump


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_11DA0
AnimalFaceSonic:
	bset	#render_flags.x_flip,render_flags(a0)
	move.w	x_pos(a0),d0
	sub.w	(MainCharacter+x_pos).w,d0
	bcc.s	+	; rts
	bclr	#render_flags.x_flip,render_flags(a0)
+
	rts
; End of function AnimalFaceSonic


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_11DB8
ChkAnimalInRange:
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	subi.w	#$B8,d0
	rts
; End of function ChkAnimalInRange

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 29 - "100 points" text
; ----------------------------------------------------------------------------
; Sprite_11DC6:
ObjPoints:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjPoints_Index(pc,d0.w),d1
	jmp	ObjPoints_Index(pc,d1.w)
; ===========================================================================
; off_11DD4:
ObjPoints_Index:	offsetTable
		offsetTableEntry.w ObjPoints_Init	; 0
		offsetTableEntry.w ObjPoints_Main	; 2
; ===========================================================================

ObjPoints_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjPoints_MapUnc_11ED0,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Numbers,0,1),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#8,width_pixels(a0)
	move.w	#-$300,y_vel(a0)	; set initial speed (upwards)

ObjPoints_Main:
	tst.w	y_vel(a0)		; test speed
	bpl.w	DeleteObject		; if it's positive (>= 0), delete the object
	bsr.w	ObjectMove		; move the points
	addi.w	#$18,y_vel(a0)		; slow down
	bra.w	DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjAnimal_MapUnc_11E1C:	include "mappings/sprite/obj28_a.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjAnimal_MapUnc_11E40:	include "mappings/sprite/obj28_b.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjAnimal_MapUnc_11E64:	include "mappings/sprite/obj28_c.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjAnimal_MapUnc_11E88:	include "mappings/sprite/obj28_d.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjAnimal_MapUnc_11EAC:	include "mappings/sprite/obj28_e.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjPoints_MapUnc_11ED0:	include "mappings/sprite/obj29.asm"

