; ===========================================================================
; ----------------------------------------------------------------------------
; Object 98 - Projectile with optional gravity (EHZ coconut, CPZ spiny, etc.)
; ----------------------------------------------------------------------------
; Sprite_376E8:
ObjProjectile:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjProjectile_Index(pc,d0.w),d1
	jmp	ObjProjectile_Index(pc,d1.w)
; ===========================================================================
; off_376F6: ObjProjectile_States:
ObjProjectile_Index:	offsetTable
		offsetTableEntry.w ObjProjectile_Init	; 0
		offsetTableEntry.w ObjProjectile_Main	; 2
; ===========================================================================
; loc_376FA:
ObjProjectile_Init: ;;
	bra.w	LoadSubObject
; ===========================================================================
; loc_376FE:
ObjProjectile_Main:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	JmpTo65_DeleteObject
	movea.l	objoff_2A(a0),a1
	jsr	(a1)	; dynamic call! to ObjProjectile_NebulaBombFall, ObjProjectile_TurtloidShotMove, ObjProjectile_CoconutFall, ObjProjectile_CluckerShotMove, ObjProjectile_SpinyShotFall, or ObjProjectile_WallTurretShotMove, assuming the code hasn't been changed
	jmpto	JmpTo39_MarkObjGone

; ===========================================================================
; for obj99
; loc_37710:
ObjProjectile_NebulaBombFall:
	bchg	#palette_bit_0,art_tile(a0) ; bypass the animation system and make it blink
	jmpto	JmpTo8_ObjectMoveAndFall

; ===========================================================================
; for obj9A
; loc_3771A:
ObjProjectile_TurtloidShotMove:
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_TurtloidShot).l,a1
	jmpto	JmpTo25_AnimateSprite

; ===========================================================================
; for obj9D
; loc_37728:
ObjProjectile_CoconutFall:
	addi.w	#$20,y_vel(a0) ; apply gravity (less than normal)
	jsrto	JmpTo26_ObjectMove
	rts

; ===========================================================================
; for objAE
; loc_37734:
ObjProjectile_CluckerShotMove:
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_CluckerShot).l,a1
	jmpto	JmpTo25_AnimateSprite

; ===========================================================================
; for objA6
; loc_37742:
ObjProjectile_SpinyShotFall:
	addi.w	#$20,y_vel(a0) ; apply gravity (less than normal)
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_SpinyShot).l,a1
	jmpto	JmpTo25_AnimateSprite

; ===========================================================================
; for objB8
; loc_37756:
ObjProjectile_WallTurretShotMove:
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_WallTurretShot).l,a1
	jmpto	JmpTo25_AnimateSprite

; ===========================================================================
; off_37764:
ObjRexon_SubObjData2:
	subObjData ObjRexon_ObjProjectile_MapUnc_37678,make_art_tile(ArtTile_ArtNem_Rexon,1,0),1<<render_flags.on_screen|1<<render_flags.level_fg,4,4,$98
; off_3776E:
ObjNebula_SubObjData:
	subObjData ObjNebula_ObjProjectile_MapUnc_3789A,make_art_tile(ArtTile_ArtNem_Nebula,1,1),1<<render_flags.on_screen|1<<render_flags.level_fg,4,8,$8B
; off_37778:
ObjTurtloid_SubObjData2:
	subObjData ObjTurtloid_ObjProjectile_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),1<<render_flags.on_screen|1<<render_flags.level_fg,4,4,$98
; off_37782:
ObjCoconuts_SubObjData2:
	subObjData ObjCoconuts_ObjProjectile_MapUnc_37D96,make_art_tile(ArtTile_ArtNem_Coconuts,0,0),1<<render_flags.on_screen|1<<render_flags.level_fg,4,8,$8B
; off_3778C:
ObjAsteron_SubObjData2:
	subObjData ObjAsteron_ObjProjectile_MapUnc_38A96,make_art_tile(ArtTile_ArtNem_MtzSupernova,0,1),1<<render_flags.on_screen|1<<render_flags.level_fg,5,4,$98
; off_37796:
ObjSpinyOnWall_SubObjData:
	subObjData ObjSpiny_ObjSpinyOnWall_ObjProjectile_MapUnc_38CCA,make_art_tile(ArtTile_ArtNem_Spiny,1,0),1<<render_flags.on_screen|1<<render_flags.level_fg,5,4,$98
; off_377A0:
ObjGrabber_SubObjData3:
	subObjData ObjGrabber_ObjGrabberLegs_ObjGrabberBox_ObjProjectile_MapUnc_3921A,make_art_tile(ArtTile_ArtNem_Grabber,1,1),1<<render_flags.on_screen|1<<render_flags.level_fg,4,4,$98
; off_377AA:
ObjCluckerBase_SubObjData3:
	subObjData ObjCluckerBase_ObjProjectile_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),1<<render_flags.on_screen|1<<render_flags.level_fg,5,4,$98
; off_377B4:
ObjMechaSonic_SubObjData:
	subObjData ObjMechaSonic_ObjProjectile_MapUnc_39E68,make_art_tile(ArtTile_ArtNem_CNZBonusSpike,1,0),1<<render_flags.on_screen|1<<render_flags.level_fg,5,4,$98
; off_377BE:
ObjWallTurret_SubObjData2:
	subObjData ObjWallTurret_ObjProjectile_MapUnc_3BA46,make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0),1<<render_flags.on_screen|1<<render_flags.level_fg,3,4,$98




