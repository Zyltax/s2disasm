; ===========================================================================
; ===========================================================================
; table that maps from the subtype ID to which address to load the data from
; the format of the data there is
;	dc.l Pointer_To_Sprite_Mappings
;	dc.w VRAM_Location
;	dc.b render_flags, priority, width_pixels, collision_flags
;
; for whatever reason, only ObjWhisp and later have entries in this table

; off_36628:
SubObjData_Index: offsetTable
	offsetTableEntry.w ObjWhisp_SubObjData	; $0
	offsetTableEntry.w ObjGrounderInWall_SubObjData	; $2
	offsetTableEntry.w ObjGrounderRocks_SubObjData	; $4
	offsetTableEntry.w ObjGrounderRocks_SubObjData2	; $6
	offsetTableEntry.w ObjChopChop_SubObjData	; $8
	offsetTableEntry.w ObjSpiker_SubObjData	; $A
	offsetTableEntry.w Invalid_SubObjData	; $C
	offsetTableEntry.w ObjRexon_SubObjData	; $E
	offsetTableEntry.w ObjRexon_SubObjData2	; $10
	offsetTableEntry.w ObjNebula_SubObjData2	; $12
	offsetTableEntry.w ObjNebula_SubObjData	; $14
	offsetTableEntry.w ObjTurtloid_SubObjData	; $16
	offsetTableEntry.w ObjTurtloidRider_SubObjData	; $18
	offsetTableEntry.w ObjBalkiryJet_SubObjData	; $1A
	offsetTableEntry.w ObjTurtloid_SubObjData2	; $1C
	offsetTableEntry.w ObjCoconuts_SubObjData	; $1E
	offsetTableEntry.w ObjCoconuts_SubObjData2	; $20
	offsetTableEntry.w ObjCrawlton_SubObjData	; $22
	offsetTableEntry.w ObjShellcracker_SubObjData	; $24
	offsetTableEntry.w ObjShellcrackerClaw_SubObjData	; $26
	offsetTableEntry.w ObjSlicer_SubObjData	; $28
	offsetTableEntry.w ObjSlicerPincers_SubObjData	; $2A
	offsetTableEntry.w ObjFlasher_SubObjData	; $2C
	offsetTableEntry.w ObjAsteron_SubObjData	; $2E
	offsetTableEntry.w ObjAsteron_SubObjData2	; $30
	offsetTableEntry.w ObjSpiny_SubObjData	; $32
	offsetTableEntry.w ObjSpinyOnWall_SubObjData	; $34
	offsetTableEntry.w ObjGrabber_SubObjData	; $36
	offsetTableEntry.w ObjGrabber_SubObjData2	; $38
	offsetTableEntry.w ObjGrabberLegs_SubObjData	; $3A
	offsetTableEntry.w ObjGrabberLegs_SubObjData2	; $3C
	offsetTableEntry.w ObjGrabber_SubObjData3	; $3E
	offsetTableEntry.w ObjBalkiry_SubObjData	; $40
	offsetTableEntry.w ObjCluckerBase_SubObjData	; $42
	offsetTableEntry.w ObjCluckerBase_SubObjData2	; $44
	offsetTableEntry.w ObjCluckerBase_SubObjData3	; $46
	offsetTableEntry.w ObjMechaSonic_SubObjData2	; $48
	offsetTableEntry.w ObjMechaSonic_SubObjData	; $4A
	offsetTableEntry.w ObjSonicOnSegaScr_SubObjData	; $4C
	offsetTableEntry.w ObjSegaHideTM_SubObjData	; $4E
	offsetTableEntry.w ObjTornado_SubObjData	; $50
	offsetTableEntry.w ObjTornado_SubObjData	; $52
	offsetTableEntry.w ObjTornado_SubObjData	; $54
	offsetTableEntry.w ObjWFZShipFire_SubObjData2	; $56
	offsetTableEntry.w ObjWFZShipFire_SubObjData2	; $58
	offsetTableEntry.w ObjCloud_SubObjData	; $5A
	offsetTableEntry.w ObjTornado_SubObjData2	; $5C
	offsetTableEntry.w ObjCloud_SubObjData	; $5E
	offsetTableEntry.w ObjCloud_SubObjData	; $60
	offsetTableEntry.w ObjCloud_SubObjData	; $62
	offsetTableEntry.w ObjVPropeller_SubObjData	; $64
	offsetTableEntry.w ObjHPropeller_SubObjData	; $66
	offsetTableEntry.w ObjHPropeller_SubObjData	; $68
	offsetTableEntry.w ObjTiltingPlatform_SubObjData	; $6A
	offsetTableEntry.w ObjTiltingPlatform_SubObjData	; $6C
	offsetTableEntry.w ObjTiltingPlatform_SubObjData	; $6E
	offsetTableEntry.w ObjTiltingPlatform_SubObjData	; $70
	offsetTableEntry.w ObjVerticalLaser_SubObjData	; $72
	offsetTableEntry.w ObjWallTurret_SubObjData	; $74
	offsetTableEntry.w ObjLaser_SubObjData	; $76
	offsetTableEntry.w ObjWFZWheel_SubObjData	; $78
	offsetTableEntry.w ObjBB_SubObjData	; $7A
	offsetTableEntry.w ObjWFZShipFire_SubObjData2	; $7C
	offsetTableEntry.w ObjSmallMetalPform_SubObjData	; $7E
	offsetTableEntry.w ObjSmallMetalPform_SubObjData	; $80
	offsetTableEntry.w ObjLateralCannon_SubObjData	; $82
	offsetTableEntry.w ObjLateralCannon_SubObjData2	; $84
	offsetTableEntry.w ObjSpeedLauncher_SubObjData	; $86
	offsetTableEntry.w ObjBreakablePlating_SubObjData	; $88
	offsetTableEntry.w ObjRivet_SubObjData	; $8A
	offsetTableEntry.w Invalid_SubObjData2	; $8C
	offsetTableEntry.w ObjWallTurret_SubObjData2	; $8E
	offsetTableEntry.w ObjTornadoSmoke_SubObjData	; $90
	offsetTableEntry.w ObjWFZBoss_SubObjData	; $92
	offsetTableEntry.w ObjWFZBoss_SubObjData2	; $94
	offsetTableEntry.w ObjWFZBoss_SubObjData3	; $96
	offsetTableEntry.w ObjWFZBoss_SubObjData3	; $98
	offsetTableEntry.w ObjWFZBoss_SubObjData3	; $9A
	offsetTableEntry.w ObjWFZBoss_SubObjData3	; $9C
	offsetTableEntry.w ObjWFZBoss_SubObjData3	; $9E
	offsetTableEntry.w ObjEggman_SubObjData2	; $A0
	offsetTableEntry.w ObjWFZBoss_SubObjData4	; $A2
	offsetTableEntry.w ObjMechaSonic_SubObjData3	; $A4
	offsetTableEntry.w ObjEggman_SubObjData3	; $A6
	offsetTableEntry.w ObjEggman_SubObjData4	; $A8
	offsetTableEntry.w ObjEggman_SubObjData	; $AA
	offsetTableEntry.w ObjCrawl_SubObjData	; $AC
