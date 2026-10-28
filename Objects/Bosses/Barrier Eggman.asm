; ===========================================================================
; ----------------------------------------------------------------------------
; Object C5 - WFZ boss
; ----------------------------------------------------------------------------
; Sprite_3C442:
ObjWFZBoss:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjWFZBoss_Index(pc,d0.w),d1
	jmp	ObjWFZBoss_Index(pc,d1.w)
; ===========================================================================
ObjWFZBoss_Index:	offsetTable
		offsetTableEntry.w ObjWFZBoss_Init			;   0 - Main loading sequence
		offsetTableEntry.w ObjWFZBoss_LaserCase		;   2 - Laser case (inside is laser)
		offsetTableEntry.w ObjWFZBoss_LaserWall		;   4 - Laser wall
		offsetTableEntry.w ObjWFZBoss_PlatformReleaser	;   6 - Platform releaser
		offsetTableEntry.w ObjWFZBoss_Platform		;   8 - Platform
		offsetTableEntry.w ObjWFZBoss_PlatformHurt		;  $A - Invisible object that gets the platform's spikes to hurt Sonic
		offsetTableEntry.w ObjWFZBoss_LaserShooter		;  $C - Laser shooter
		offsetTableEntry.w ObjWFZBoss_Laser			;  $E - Laser
		offsetTableEntry.w ObjWFZBoss_Robotnik		; $10 - Robotnik
		offsetTableEntry.w ObjWFZBoss_RobotnikPlatform	; $12 - Platform Robotnik's on
; ===========================================================================

ObjWFZBoss_Init:
	bsr.w	LoadSubObject
	move.b	subtype(a0),d0
	subi.b	#$90,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================

ObjWFZBoss_LaserCase:	; also the "mother" object
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjWFZBoss_CaseIndex(pc,d0.w),d1
	jsr	ObjWFZBoss_CaseIndex(pc,d1.w)
	bra.w	ObjWFZBoss_HandleHits
; ===========================================================================
ObjWFZBoss_CaseIndex:offsetTable
		offsetTableEntry.w ObjWFZBoss_CaseBoundary		;   0 - Sets up boundaries for movement and basic things
		offsetTableEntry.w ObjWFZBoss_CaseWaitStart		;   2 - Waits for Sonic to start
		offsetTableEntry.w ObjWFZBoss_CaseWaitDown		;   4 - Waits to make the laser go down
		offsetTableEntry.w ObjWFZBoss_CaseDown		;   6 - Moves the case down
		offsetTableEntry.w ObjWFZBoss_CaseXSpeed		;   8 - Sets an X speed for the case
		offsetTableEntry.w ObjWFZBoss_CaseBoundaryChk	;  $A - Checks to make sure the case doesn't go through the boundaries
		offsetTableEntry.w ObjWFZBoss_CaseAnimate		;  $C - Animates the case (opening and closing)
		offsetTableEntry.w ObjWFZBoss_CaseLSLoad		;  $E - Laser shooter loading
		offsetTableEntry.w ObjWFZBoss_CaseLSDown		; $10 - Moves the laser shooter down
		offsetTableEntry.w ObjWFZBoss_CaseWaitLoadLaser	; $12 - Waits to load the laser
		offsetTableEntry.w ObjWFZBoss_CaseWaitMove		; $14 - Waits to move (checks if laser is completely loaded (as big as it gets))
		offsetTableEntry.w ObjWFZBoss_CaseBoundaryLaserChk	; $16 - Checks boundaries when moving with the laser
		offsetTableEntry.w ObjWFZBoss_CaseLSUp		; $18 - wait for laser shooter to go back up
		offsetTableEntry.w ObjWFZBoss_CaseAnimate		; $1A - Animates the case (opening and closing)
		offsetTableEntry.w ObjWFZBoss_CaseStartOver		; $1C - Sets secondary routine to 8
		offsetTableEntry.w ObjWFZBoss_CaseDefeated		; $1E - When defeated goes here (explosions and stuff)
; ===========================================================================

ObjWFZBoss_CaseBoundary:
	addq.b	#2,routine_secondary(a0)
	move.b	#0,collision_flags(a0)
	move.b	#8,collision_property(a0)	; Hit points
	move.w	#$442,d0
	move.w	d0,(Camera_Max_Y_pos).w
	move.w	d0,(Camera_Max_Y_pos_target).w
	move.w	x_pos(a0),d0
	subi.w	#$60,d0			; Max Left position
	move.w	d0,objoff_34(a0)
	addi.w	#$C0,d0			; Max Right Position
	move.w	d0,objoff_36(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseWaitStart:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$20,d2
	cmpi.w	#$40,d2			; How far away Sonic is to start the boss
	blo.s	ObjWFZBoss_CaseStart
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseStart:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,y_vel(a0)		; Speed at which the laser carrier goes down
	lea	(ChildObject_ObjWFZBossLaserWall).l,a2
	bsr.w	LoadChildObject
	subi.w	#$88,x_pos(a1)		; where to load the left laser wall (x)
	addi.w	#$60,y_pos(a1)		; left laser wall (y)
	lea	(ChildObject_ObjWFZBossLaserWall).l,a2
	bsr.w	LoadChildObject
	addi.w	#$88,x_pos(a1)		; right laser wall (x)
	addi.w	#$60,y_pos(a1)		; right laser wall (y)
	lea	(ChildObject_ObjWFZBossLaserShooter).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObject_ObjWFZBossPlatformReleaser).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObject_ObjWFZBossRobotnik).l,a2
	bsr.w	LoadChildObject
	move.w	#$5A,objoff_2A(a0)	; How long for the boss music to start playing and the boss to start
	moveq	#signextendB(MusID_FadeOut),d0
	jsrto	JmpTo12_PlaySound
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseWaitDown:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjWFZBoss_CaseSpeedDown
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseSpeedDown:
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_2A(a0)	; How long the laser carrier goes down
	moveq	#signextendB(MusID_Boss),d0
	jsrto	JmpTo5_PlayMusic
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseDown:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjWFZBoss_CaseStopDown
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseStopDown:
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)		; stop the laser carrier from going down
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseXSpeed:
	addq.b	#2,routine_secondary(a0)
	bsr.w	Obj_GetOrientationToPlayer
	move.w	#$100,d1		; Speed of carrier (when going back and forth before sending out laser)
	tst.w	d0
	bne.s	ObjWFZBoss_CasePMLoader
	neg.w	d1

ObjWFZBoss_CasePMLoader:
	move.w	d1,x_vel(a0)
	bset	#status.npc.misc,status(a0)		; makes the platform maker load
	move.w	#$70,objoff_2A(a0)	; how long to go back and forth before letting out laser
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseBoundaryChk:			; waits and makes sure the carrier does not go beyond the limit
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjWFZBoss_CaseOpeningAnim
	move.w	x_pos(a0),d0
	tst.w	x_vel(a0)
	bmi.s	ObjWFZBoss_CaseBoundaryChk2
	cmp.w	objoff_36(a0),d0
	bhs.s	ObjWFZBoss_CaseNegSpeed
	bra.w	ObjWFZBoss_CaseMoveDisplay
; ===========================================================================

ObjWFZBoss_CaseBoundaryChk2:
	cmp.w	objoff_34(a0),d0
	bhs.s	ObjWFZBoss_CaseMoveDisplay

ObjWFZBoss_CaseNegSpeed:
	neg.w	x_vel(a0)

ObjWFZBoss_CaseMoveDisplay:
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseOpeningAnim:
	addq.b	#2,routine_secondary(a0)
	clr.b	anim(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseAnimate:
	lea	(Ani_objC5).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseLSLoad:		; loads up the laser shooter (LS)
	addq.b	#2,routine_secondary(a0)
	move.w	#$E,objoff_2A(a0)	; Time the laser shooter moves down
	movea.w	objoff_3C(a0),a1 ; a1=object (laser shooter)
	move.b	#4,routine_secondary(a1)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseLSDown:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjWFZBoss_CaseAddCollision
	movea.w	objoff_3C(a0),a1 ; a1=object (laser shooter)
	addq.w	#1,y_pos(a1)	; laser shooter down speed
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseAddCollision:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)	; Length before shooting laser
	bset	#status.npc.p2_standing,status(a0)		; makes the hit sound and flashes happen only once when you hit it
	bset	#status.npc.p2_pushing,status(a0)		; makes sure collision gets restored
	move.b	#6,collision_flags(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseWaitLoadLaser:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjWFZBoss_CaseLoadLaser
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseLoadLaser:
	addq.b	#2,routine_secondary(a0)
	lea	(ChildObject_ObjWFZBossLaser).l,a2
	bsr.w	LoadChildObject		; loads laser
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseWaitMove:
	movea.w	parent(a0),a1 ; a1=object
	btst	#status.npc.misc,status(a1)		; waits to check if laser fired
	bne.s	ObjWFZBoss_CaseLaserSpeed
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseLaserSpeed:
	addq.b	#2,routine_secondary(a0)
	move.w	#$80,objoff_2A(a0)	; how long to move the laser
	bsr.w	Obj_GetOrientationToPlayer	; tests if Sonic is to the right or left
	move.w	#$80,d1		; Speed when moving with laser
	tst.w	d0
	bne.s	ObjWFZBoss_CaseLaserSpeedSet
	neg.w	d1

ObjWFZBoss_CaseLaserSpeedSet:
	move.w	d1,x_vel(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseBoundaryLaserChk:		; make sure you stay in range when firing laser
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjWFZBoss_CaseStopLaserDelete
	move.w	x_pos(a0),d0
	tst.w	x_vel(a0)
	bmi.s	ObjWFZBoss_CaseBoundaryLaserChk2
	cmp.w	objoff_36(a0),d0
	bhs.s	ObjWFZBoss_CaseLaserStopMove
	bra.w	ObjWFZBoss_CaseLaserMoveDisplay
; ===========================================================================

ObjWFZBoss_CaseBoundaryLaserChk2:
	cmp.w	objoff_34(a0),d0
	bhs.s	ObjWFZBoss_CaseLaserMoveDisplay

ObjWFZBoss_CaseLaserStopMove:
	clr.w	x_vel(a0)	; stop moving

ObjWFZBoss_CaseLaserMoveDisplay:
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseStopLaserDelete:		; stops collision and deletes laser
	addq.b	#2,routine_secondary(a0)
	move.w	#$E,objoff_2A(a0)	; time for laser shooter to move back up
	bclr	#status.npc.p1_standing,status(a0)
	bclr	#status.npc.p2_standing,status(a0)
	bclr	#status.npc.p2_pushing,status(a0)
	clr.b	collision_flags(a0)	; no more collision
	movea.w	parent(a0),a1 		; a1=object (laser)
	jsrto	JmpTo6_DeleteObject2	; delete the laser
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseLSUp:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjWFZBoss_CaseClosingAnim
	movea.w	objoff_3C(a0),a1 ; a1=object (laser shooter)
	subq.w	#1,y_pos(a1)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseClosingAnim: ;sets which animation to do
	addq.b	#2,routine_secondary(a0)
	move.b	#1,anim(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseStartOver:
	move.b	#8,routine_secondary(a0)
	bsr.w	ObjWFZBoss_CaseXSpeed
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_CaseDefeated:
	clr.b	collision_flags(a0)
	st.b	collision_property(a0)
	bclr	#status.npc.p2_pushing,status(a0)
	subq.w	#1,objoff_30(a0)	; timer
	bmi.s	ObjWFZBoss_End
	jsrto	JmpTo_Boss_LoadExplosion
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_End:	; play music and change camera speed
	moveq	#signextendB(MusID_WFZ),d0
	jsrto	JmpTo5_PlayMusic
	move.w	#$720,d0
	move.w	d0,(Camera_Max_Y_pos).w
	move.w	d0,(Camera_Max_Y_pos_target).w
	jsrto	JmpTo65_DeleteObject
	addq.w	#4,sp
	rts
; ===========================================================================

ObjWFZBoss_LaserWall:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjWFZBoss_LaserWallIndex(pc,d0.w),d1
	jsr	ObjWFZBoss_LaserWallIndex(pc,d1.w)
	tst.b	(a0)
	beq.w	return_37A48
	move.w	x_pos(a0),-(sp)
	move.w	#$13,d1
	move.w	#$40,d2
	move.w	#$80,d3
	move.w	(sp)+,d4
	jmpto	JmpTo27_SolidObject
; ===========================================================================
ObjWFZBoss_LaserWallIndex: offsetTable
	offsetTableEntry.w ObjWFZBoss_LaserWallMappings	; 0 - selects the mappings
	offsetTableEntry.w ObjWFZBoss_LaserWallWaitDelete	; 2 - Waits till set to delete (when the boss is defeated)
	offsetTableEntry.w ObjWFZBoss_LaserWallDelete	; 4 - After a little time it deletes
; ===========================================================================

ObjWFZBoss_LaserWallMappings:
	addq.b	#2,routine_secondary(a0)
	move.b	#$C,mapping_frame(a0)	; loads the laser wall from the WFZ boss art
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_LaserWallWaitDelete:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_pushing,status(a1)
	bne.s	ObjWFZBoss_LaserWallTimerSet
	bchg	#0,objoff_2F(a0)	; makes it "flash" if set it won't flash
	bne.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_LaserWallTimerSet:	; sets a small timer
	addq.b	#2,routine_secondary(a0)
	move.b	#4,objoff_30(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_LaserWallDelete:
	subq.b	#1,anim_frame_duration(a0)
	bpl.w	return_37A48
	move.b	anim_frame_duration(a0),d0
	move.b	anim_frame(a0),d1
	addq.b	#2,d0
	bpl.s	ObjWFZBoss_LaserWallDisplay
	move.b	d1,anim_frame_duration(a0)
	subq.b	#1,objoff_30(a0)
	bpl.s	ObjWFZBoss_LaserWallDisplay
	move.b	#$10,objoff_30(a0)
	addq.b	#1,d1
	cmpi.b	#5,d1
	bhs.w	JmpTo65_DeleteObject
	move.b	d1,anim_frame(a0)
	move.b	d1,anim_frame_duration(a0)

ObjWFZBoss_LaserWallDisplay:
	bclr	#0,objoff_2F(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_PlatformReleaser:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjWFZBoss_PlatformReleaserIndex(pc,d0.w),d1
	jmp	ObjWFZBoss_PlatformReleaserIndex(pc,d1.w)
; ===========================================================================
ObjWFZBoss_PlatformReleaserIndex: offsetTable
	offsetTableEntry.w ObjWFZBoss_PlatformReleaserInit		; 0 - Load mappings and position
	offsetTableEntry.w ObjWFZBoss_PlatformReleaserWaitDown	; 2 - Waits for laser case to move down
	offsetTableEntry.w ObjWFZBoss_PlatformReleaserDown		; 4 - Goes down until time limit is up
	offsetTableEntry.w ObjWFZBoss_PlatformReleaserLoadWait	; 6 - Waits to load the platforms (the interval of time between each is from this) and makes sure only 3 are loaded
	offsetTableEntry.w ObjWFZBoss_PlatformReleaserDelete		; 8 - Explodes then deletes
; ===========================================================================

ObjWFZBoss_PlatformReleaserInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,mapping_frame(a0)
	addq.w	#8,y_pos(a0)		; Move down a little
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_PlatformReleaserWaitDown:
	movea.w	objoff_2C(a0),a1 ; a1=object laser case
	btst	#status.npc.misc,status(a1)		; checks if laser case is done moving down (so it starts loading the platforms)
	bne.s	ObjWFZBoss_PlatformReleaserSetDown
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_PlatformReleaserSetDown:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)	; time to go down
	move.w	#$40,y_vel(a0)		; speed to go down
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_PlatformReleaserDown:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjWFZBoss_PlatformReleaserStop
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_PlatformReleaserStop:
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)
	move.w	#$10,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_PlatformReleaserLoadWait:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_pushing,status(a1)
	bne.s	ObjWFZBoss_PlatformReleaserDestroyP
	subq.w	#1,objoff_2A(a0)
	bne.s	BranchTo8_JmpTo45_DisplaySprite
	move.w	#$80,objoff_2A(a0)	; Time between loading platforms
	moveq	#0,d0
	move.b	objoff_2E(a0),d0
	addq.b	#1,d0
	cmpi.b	#3,d0			; How many platforms to load
	blo.s	ObjWFZBoss_PlatformReleaserLoadP
	moveq	#0,d0

ObjWFZBoss_PlatformReleaserLoadP:	; P=Platforms
	move.b	d0,objoff_2E(a0)
	tst.b	objoff_30(a0,d0.w)
	bne.s	BranchTo8_JmpTo45_DisplaySprite
	st.b	objoff_30(a0,d0.w)
	lea	(ChildObject_ObjWFZBossPlatform).l,a2
	bsr.w	LoadChildObject
	move.b	objoff_2E(a0),objoff_2E(a1)

BranchTo8_JmpTo45_DisplaySprite ; BranchTo
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_PlatformReleaserDestroyP: 	; P=Platforms
	addq.b	#2,routine_secondary(a0)
	bset	#status.npc.p1_pushing,status(a0)		; destroy platforms
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_PlatformReleaserDelete:
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_WFZBoss,id(a1)
	bne.w	JmpTo65_DeleteObject
	jsrto	JmpTo_Boss_LoadExplosion
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_Platform:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjWFZBoss_PlatformIndex(pc,d0.w),d1
	jsr	ObjWFZBoss_PlatformIndex(pc,d1.w)
	lea	(Ani_objC5).l,a1
	jsrto	JmpTo25_AnimateSprite
	tst.b	(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
ObjWFZBoss_PlatformIndex: offsetTable
	offsetTableEntry.w ObjWFZBoss_PlatformInit			; 0 - Selects mappings, anim ation, y speed and loads the object that hurts Sonic (by spiky area)
	offsetTableEntry.w ObjWFZBoss_PlatformDownWait		; 2 - Wait till the platform goes down some
	offsetTableEntry.w ObjWFZBoss_PlatformTestChangeDirection	; 4 - checks if time limit is over and if so to change direction
; ===========================================================================

ObjWFZBoss_PlatformInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,anim(a0)
	move.b	#7,mapping_frame(a0)
	move.w	#$100,y_vel(a0)			; Y speed
	move.w	#$60,objoff_2A(a0)
	lea	(ChildObject_ObjWFZBossPlatformHurt).l,a2	; loads the invisible object that hurts Sonic
	bra.w	LoadChildObject
; ===========================================================================

ObjWFZBoss_PlatformDownWait:		; waits for it to go down some
	bsr.w	ObjWFZBoss_PlatformCheckExplode
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjWFZBoss_PlatformLeft
	bra.w	ObjWFZBoss_PlatformMakeSolid
; ===========================================================================

ObjWFZBoss_PlatformLeft:			; goes left and makes a time limit (for going left)
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_2A(a0)
	move.w	#-$100,x_vel(a0)		; X speed
	move.w	y_pos(a0),objoff_34(a0)
	bra.w	ObjWFZBoss_PlatformMakeSolid
; ===========================================================================

ObjWFZBoss_PlatformTestChangeDirection:
	bsr.w	ObjWFZBoss_PlatformCheckExplode
	subq.w	#1,objoff_2A(a0)
	bne.s	ObjWFZBoss_PlatformTestLeftRight
	move.w	#$C0,objoff_2A(a0)
	neg.w	x_vel(a0)

ObjWFZBoss_PlatformTestLeftRight:	; tests to see if a value should be added to go left or right
	moveq	#4,d0
	move.w	y_pos(a0),d1
	cmp.w	objoff_34(a0),d1
	blo.s	ObjWFZBoss_PlatformChangeY
	neg.w	d0

ObjWFZBoss_PlatformChangeY:	; give it that curving feel
	add.w	d0,y_vel(a0)
	bra.w	ObjWFZBoss_PlatformMakeSolid

ObjWFZBoss_PlatformMakeSolid:	; makes into a platform and moves
	move.w	x_pos(a0),-(sp)
	jsrto	JmpTo26_ObjectMove
	move.w	#$10,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	(sp)+,d4
	jmpto	JmpTo9_PlatformObject
; ===========================================================================

ObjWFZBoss_PlatformCheckExplode:	; checks to see if platforms should explode
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_pushing,status(a1)
	bne.w	ObjWFZBoss_PlatformExplode
	rts
; ===========================================================================

ObjWFZBoss_PlatformExplode:
	bsr.w	loc_3B7BC
	move.b	#ObjID_BossExplosion,id(a0) ; load 0bj58 (explosion)
	clr.b	routine(a0)
	movea.w	objoff_3C(a0),a1 ; a1=object (invisible hurting thing)
	jsrto	JmpTo6_DeleteObject2
	addq.w	#4,sp
	rts
; ===========================================================================

ObjWFZBoss_PlatformHurt:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjWFZBoss_PlatformHurtIndex(pc,d0.w),d1
	jmp	ObjWFZBoss_PlatformHurtIndex(pc,d1.w)
; ===========================================================================
ObjWFZBoss_PlatformHurtIndex: offsetTable
	offsetTableEntry.w ObjWFZBoss_PlatformHurtCollision		; 0 - Gives collision that hurts Sonic
	offsetTableEntry.w ObjWFZBoss_PlatformHurtFollowPlatform	; 2 - Follows around the platform and waits to be deleted
; ===========================================================================

ObjWFZBoss_PlatformHurtCollision:
	addq.b	#2,routine_secondary(a0)
	move.b	#$98,collision_flags(a0)
	rts
; ===========================================================================

ObjWFZBoss_PlatformHurtFollowPlatform:
	movea.w	objoff_2C(a0),a1 ; a1=object (platform)
	btst	#status.npc.p1_pushing,status(a1)
	bne.w	JmpTo65_DeleteObject
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),d0
	addi.w	#$C,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================

ObjWFZBoss_LaserShooter:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	btst	#status.npc.p1_pushing,status(a1)
	bne.w	JmpTo65_DeleteObject
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjWFZBoss_LaserShooterIndex(pc,d0.w),d1
	jmp	ObjWFZBoss_LaserShooterIndex(pc,d1.w)
; ===========================================================================
ObjWFZBoss_LaserShooterIndex: offsetTable
	offsetTableEntry.w ObjWFZBoss_LaserShooterInit	; 0 - Loads up mappings
	offsetTableEntry.w ObjWFZBoss_LaserShooterFollow	; 2 - Goes back and forth with the laser case
	offsetTableEntry.w ObjWFZBoss_LaserShooterDown	; 4 - Laser case sets it to this routine which then makes it go down
; ===========================================================================

ObjWFZBoss_LaserShooterInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#4,mapping_frame(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_LaserShooterFollow:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_LaserShooterDown:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	move.w	x_pos(a1),x_pos(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_Laser:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_pushing,status(a1)
	bne.w	JmpTo65_DeleteObject
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjWFZBoss_LaserIndex(pc,d0.w),d1
	jsr	ObjWFZBoss_LaserIndex(pc,d1.w)
	bchg	#0,objoff_2F(a0)
	bne.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
ObjWFZBoss_LaserIndex: offsetTable
	offsetTableEntry.w ObjWFZBoss_LaserInit	; 0 - Loads mappings and collision and such
	offsetTableEntry.w ObjWFZBoss_LaserFlash	; 2 - Makes the laser flash (gives the charging up effect)
	offsetTableEntry.w ObjWFZBoss_LaseWaitShoot	; 4 - Waits a little to launch the laser when it's done flickering (charging)
	offsetTableEntry.w ObjWFZBoss_LaserShoot	; 6 - Shoots down the laser untill it's fully shot out
	offsetTableEntry.w ObjWFZBoss_LaserMove	; 8 - Moves with laser case and shooter
; ===========================================================================

ObjWFZBoss_LaserInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#$D,mapping_frame(a0)
	move.b	#4,priority(a0)
	move.b	#0,collision_flags(a0)
	addi.w	#$10,y_pos(a0)
	move.b	#$C,anim_frame(a0)
	subq.w	#3,y_pos(a0)
	rts
; ===========================================================================

ObjWFZBoss_LaserFlash:
	bset	#0,objoff_2F(a0)
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	ObjWFZBoss_LaserNoLaser
	move.b	anim_frame_duration(a0),d0
	addq.b	#2,d0
	bpl.s	ObjWFZBoss_LaserFlicker
	move.b	anim_frame(a0),d0
	subq.b	#1,d0
	beq.s	ObjWFZBoss_LaseNext
	move.b	d0,anim_frame(a0)
	move.b	d0,anim_frame_duration(a0)

ObjWFZBoss_LaserFlicker:	; this is what makes the laser flicker before being fully loaded (covering laser shooter)
	bclr	#0,objoff_2F(a0)

ObjWFZBoss_LaserNoLaser: ; without this the laser would just stay on the shooter not going down
	rts
; ===========================================================================

ObjWFZBoss_LaseNext:		; just sets up a time to wait for the laser to shoot when it's loaded and done flickering
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)
	rts
; ===========================================================================

ObjWFZBoss_LaseWaitShoot:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjWFZBoss_LaseStartShooting
	rts
; ===========================================================================

ObjWFZBoss_LaseStartShooting:
	addq.b	#2,routine_secondary(a0)
	addi.w	#$10,y_pos(a0)
	rts
; ===========================================================================

ObjWFZBoss_LaserShoot:
	moveq	#0,d0
	move.b	objoff_2E(a0),d0
	addq.b	#1,d0
	cmpi.b	#5,d0
	bhs.s	ObjWFZBoss_LaseShotOut
	addi.w	#$10,y_pos(a0)
	move.b	d0,objoff_2E(a0)
	move.b	ObjWFZBoss_LaserMappingsData(pc,d0.w),mapping_frame(a0)
	move.b	ObjWFZBoss_LaserCollisionData(pc,d0.w),collision_flags(a0)
	rts
; ===========================================================================

ObjWFZBoss_LaseShotOut:	; laser is fully shot out and lets the laser case know so it moves
	addq.b	#2,routine_secondary(a0)
	move.w	#$80,objoff_2A(a0)
	bset	#status.npc.misc,status(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	bset	#status.npc.p1_standing,status(a1)
	rts
; ===========================================================================
ObjWFZBoss_LaserMappingsData:
	dc.b  $E
	dc.b  $F	; 1
	dc.b $10	; 2
	dc.b $11	; 3
	dc.b $12	; 4
	dc.b   0	; 5
ObjWFZBoss_LaserCollisionData:
	dc.b $86
	dc.b $AB	; 1
	dc.b $AC	; 2
	dc.b $AD	; 3
	dc.b $AE	; 4
	dc.b   0	; 5
	even
; ===========================================================================

ObjWFZBoss_LaserMove:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	rts
; ===========================================================================

ObjWFZBoss_Robotnik:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjWFZBoss_RobotnikIndex(pc,d0.w),d1
	jmp	ObjWFZBoss_RobotnikIndex(pc,d1.w)
; ===========================================================================
ObjWFZBoss_RobotnikIndex: offsetTable
	offsetTableEntry.w ObjWFZBoss_RobotnikInit		; 0 - Loads art, animation and position
	offsetTableEntry.w ObjWFZBoss_RobotnikAnimate	; 2 - Animates Robotnik and waits till the case is defeated
	offsetTableEntry.w ObjWFZBoss_RobotnikDown		; 4 - Goes down until timer is up
; ===========================================================================

ObjWFZBoss_RobotnikInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#0,mapping_frame(a0)
	move.b	#1,anim(a0)
	move.w	#$2C60,x_pos(a0)
	move.w	#$4E6,y_pos(a0)
	lea	(ChildObject_ObjWFZBossRobotnikPlatform).l,a2
	bsr.w	LoadChildObject
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_RobotnikAnimate:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	btst	#status.npc.p1_pushing,status(a1)
	bne.s	ObjWFZBoss_RobotnikTimer
	lea	(Ani_objC5_objC6).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_RobotnikTimer:		; Increase routine and set timer
	addq.b	#2,routine_secondary(a0)
	move.w	#$C0,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_RobotnikDown:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjWFZBoss_RobotnikDelete
	addq.w	#1,y_pos(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjWFZBoss_RobotnikDelete:		; Deletes Robotnik and the platform he's on
	movea.w	parent(a0),a1 ; a1=object (Robotnik Platform)
	jsrto	JmpTo6_DeleteObject2
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

ObjWFZBoss_RobotnikPlatform:	; Just displays the platform and move accordingly to the Robotnik object
	movea.w	objoff_2C(a0),a1 ; a1=object (Robotnik)
	move.w	y_pos(a1),d0
	addi.w	#$26,d0
	move.w	d0,y_pos(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
	; some unused/dead code, At one point it appears a section of the platform was solid
	move.w	x_pos(a0),-(sp)
	jsrto	JmpTo26_ObjectMove
	move.w	#$F,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	(sp)+,d4
	jmpto	JmpTo9_PlatformObject
; ===========================================================================

ObjWFZBoss_HandleHits:
	tst.b	collision_property(a0)
	beq.s	ObjWFZBoss_NoHitPointsLeft
	tst.b	collision_flags(a0)
	bne.s	return_3CC3A
	tst.b	objoff_30(a0)
	bne.s	ObjWFZBoss_FlashSetUp
	btst	#status.npc.p2_pushing,status(a0)
	beq.s	return_3CC3A
	move.b	#$20,objoff_30(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l

ObjWFZBoss_FlashSetUp:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	ObjWFZBoss_FlashCollisionRestore
	move.w	#$EEE,d0

ObjWFZBoss_FlashCollisionRestore:
	move.w	d0,(a1)
	subq.b	#1,objoff_30(a0)
	bne.s	return_3CC3A
	btst	#status.npc.p2_standing,status(a0)	; makes sure the boss doesn't need collision
	beq.s	return_3CC3A
	move.b	#6,collision_flags(a0)	; restore collision

return_3CC3A:
	rts
; ===========================================================================

ObjWFZBoss_NoHitPointsLeft:	; when the boss is defeated this tells it what to do
	moveq	#100,d0
	bsr.w	AddPoints
	clr.b	collision_flags(a0)
	move.w	#$EF,objoff_30(a0)
	move.b	#$1E,routine_secondary(a0)
	bset	#status.npc.p1_pushing,status(a0)
	bclr	#status.npc.p2_pushing,status(a0)
	rts
; ===========================================================================
ChildObject_ObjWFZBossLaserWall:		childObjectData objoff_2A, ObjID_WFZBoss, $94
ChildObject_ObjWFZBossPlatform:		childObjectData objoff_3E, ObjID_WFZBoss, $98
ChildObject_ObjWFZBossPlatformHurt:		childObjectData objoff_3C, ObjID_WFZBoss, $9A
ChildObject_ObjWFZBossLaserShooter:		childObjectData objoff_3C, ObjID_WFZBoss, $9C
ChildObject_ObjWFZBossPlatformReleaser:	childObjectData objoff_3A, ObjID_WFZBoss, $96
ChildObject_ObjWFZBossLaser:			childObjectData objoff_3E, ObjID_WFZBoss, $9E
ChildObject_ObjWFZBossRobotnik:		childObjectData objoff_38, ObjID_WFZBoss, $A0
ChildObject_ObjWFZBossRobotnikPlatform:	childObjectData objoff_3E, ObjID_WFZBoss, $A2

; off_3CC80:
ObjWFZBoss_SubObjData:		; Laser Case
	subObjData ObjWFZBoss_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),1<<render_flags.level_fg,4,$20,0
; off_3CC8A:
ObjWFZBoss_SubObjData2:		; Laser Walls
	subObjData ObjWFZBoss_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),1<<render_flags.level_fg,1,8,0
; off_3CC94:
ObjWFZBoss_SubObjData3:		; Platforms, platform releaser, laser and laser shooter
	subObjData ObjWFZBoss_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),1<<render_flags.level_fg,5,$10,0
; off_3CC9E:
ObjEggman_SubObjData2:		; Robotnik
	subObjData ObjEggman_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),1<<render_flags.level_fg,5,$20,0
; off_3CCA8:
ObjWFZBoss_SubObjData4:		; Robotnik platform
	subObjData ObjWFZBoss_MapUnc_3CEBC,make_art_tile(ArtTile_ArtNem_WfzFloatingPlatform,1,1),1<<render_flags.level_fg,5,$20,0

; animation script
; off_3CCB2:
Ani_objC5:	offsetTable
		offsetTableEntry.w byte_3CCBA	; 0
		offsetTableEntry.w byte_3CCC4	; 1
		offsetTableEntry.w byte_3CCCC	; 2
		offsetTableEntry.w byte_3CCD0	; 3
byte_3CCBA:	dc.b   5,  0,  1,  2,  3,  3,  3,  3,$FA,  0
byte_3CCC4:	dc.b   3,  3,  2,  1,  0,  0,$FA,  0
byte_3CCCC:	dc.b   3,  5,  6,$FF
byte_3CCD0:	dc.b   3,  7,  8,  9, $A, $B,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjWFZBoss_MapUnc_3CCD8:	include "mappings/sprite/objC5_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjWFZBoss_MapUnc_3CEBC:	include "mappings/sprite/objC5_b.asm"
