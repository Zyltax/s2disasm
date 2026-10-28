; Sonic the Hedgehog 2 disassembled binary

; Nemesis,   2004: Created original disassembly for SNASM68K
; Aurochs,   2005: Translated to AS and annotated
; Xenowhirl, 2007: More annotation, overall cleanup, Z80 disassembly
; ---------------------------------------------------------------------------
; NOTES:
;
; Set your editor's tab width to 8 characters wide for viewing this file.
;
; It is highly suggested that you read the AS User's Manual before diving too
; far into this disassembly. At least read the section on nameless temporary
; symbols. Your brain may melt if you don't know how those work.
;
; See s2.notes.txt for more comments about this disassembly and other useful info.

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ASSEMBLY OPTIONS:
;
gameRevision = 1
;	| If 0, a REV00 ROM is built
;	| If 1, a REV01 ROM is built, which contains some fixes
;	| If 2, a (theoretical) REV02 ROM is built, which contains even more fixes
padToPowerOfTwo = 1
;	| If 1, pads the end of the ROM to the next power of two bytes (for real hardware)
;
fixBugs = 0
;	| If 1, enables all bug-fixes
;	| See also the 'FixDriverBugs' flag in 's2.sounddriver.asm'
;	| See also the 'FixMusicAndSFXDataBugs' flag in 'build.lua'
allOptimizations = 0
;	| If 1, enables all optimizations
;
skipChecksumCheck = 0
;	| If 1, disables the slow bootup checksum calculation
;
zeroOffsetOptimization = 0|allOptimizations
;	| If 1, makes a handful of zero-offset instructions smaller
;
removeJmpTos = 0|(gameRevision>=2)|allOptimizations
;	| If 1, many unnecessary JmpTos are removed, improving performance
;
addsubOptimize = 0|(gameRevision=2)|allOptimizations
;	| If 1, some add/sub instructions are optimized to addq/subq
;
relativeLea = 0|(gameRevision<2)|allOptimizations
;	| If 1, makes some instructions use pc-relative addressing, instead of absolute long
;
useFullWaterTables = 0
;	| If 1, zone offset tables for water levels cover all level slots instead of only slots 8-$F
;	| Set to 1 if you've shifted level IDs around or you want water in levels with a level slot below 8

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; AS-specific macros and assembler settings
	CPU 68000
	include "Define/Macros (Assembler Specific).asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Simplifying macros and functions
	include "Define/Macros (General).asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.
	include "Define/Constants.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Expressing SMPS bytecode in a portable and human-readable form
FixMusicAndSFXDataBugs = fixBugs
SonicDriverVer = 2 ; Tell SMPS2ASM that we are targetting Sonic 2's sound driver
	include "Sound/SMPS2ASM Macros.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Expressing sprite mappings and DPLCs in a portable and human-readable form
SonicMappingsVer := 2
SonicDplcVer := 2
	include "mappings/MapMacros.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; start of ROM
	include "Routines/System/Vectors.asm"
	include "Routines/System/Initalize.asm"
	include "Routines/System/Game Mode.asm"
	include "Routines/System/Vertical Interrupt.asm"
	include "Routines/System/Horizontal Interrupt.asm"
	include "Routines/System/Load Palette.asm"
	include "Routines/System/Proccess Sound Queue.asm"
	jmpTos JmpTo_LoadTilesAsYouMove,JmpTo_SegaScr_VInt

	include "Routines/System/Joypad.asm"
	include "Routines/System/VDP.asm"
	include "Routines/System/Load Sound.asm"
	include "Routines/System/Pause.asm"
	include "Routines/System/Load Tilemap.asm"
	include "Routines/System/DMA.asm"

	include "Routines/Decompress/Nemesis.asm"
	include "Routines/System/PLC.asm"

	include "Routines/Decompress/Enigma.asm"
	include "Routines/Decompress/Kosinski.asm"
	jmpTos ; Empty

	include "Routines/Palette Cycle.asm"
	include "Routines/Palette Fade.asm"
	include "Routines/Unused/SEGA Palette.asm"
	include "Routines/Palette Load.asm"
	jmpTos ; Empty




; ---------------------------------------------------------------------------
; Subroutine to perform vertical synchronization
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_3384: DelayProgram:
WaitForVint:
	move	#$2300,sr

-	tst.b	(Vint_routine).w
	bne.s	-
	rts
; End of function WaitForVint

; ===========================================================================
	include "Routines/Math.asm"
	jmpTos ; Empty
	
; ===========================================================================
	include "Modes/SEGA.asm"
	jmpTos JmpTo_RunObjects
	
; ===========================================================================
	include "Modes/Title Screen.asm"
	jmpTos JmpTo_SwScrl_Title
	
; ===========================================================================
	include "Sound/Music Table.asm"
	
; ===========================================================================
	include "Modes/Zone.asm"
	jmpTos JmpTo_loadZoneBlockMaps,JmpTo_DeformBgLayer,JmpTo_AniArt_Load,JmpTo_DrawInitialBG

; ===========================================================================
	include "Modes/Special Stage.asm"
	jmpTos JmpTo_DisplaySprite,JmpTo_LoadTitleCardSS,JmpTo_DeleteObject,JmpTo_ObjSSMessage_CreateRingReqMessage,JmpTo_ObjSSMessage_PrintPhrase,JmpTo_ObjectMove,JmpTo_Hud_Base

; ===========================================================================
	include "Modes/Continue.asm"
	jmpTos JmpTo_Adjust2PArtPointer2,JmpTo_Adjust2PArtPointer

; ===========================================================================
	include "Modes/2P Results.asm"
	jmpTos JmpTo2_Adjust2PArtPointer,JmpTo_Dynamic_Normal

; ===========================================================================
	include "Modes/Menu.asm"
	jmpTos JmpTo_PlaySound,JmpTo_PlayMusic,JmpTo_PlaneMapToVRAM_H40,JmpTo2_Dynamic_Normal

; ===========================================================================
	include "Modes/End Cutscene.asm"
	include "Modes/Credits.asm"
	jmpTos JmpTo5_DisplaySprite,JmpTo3_DeleteObject,JmpTo2_PlaySound,JmpTo_ObjTornado_Animate_Pilot,JmpTo_AnimateSprite,JmpTo_NemDec,JmpTo_EniDec,JmpTo_ClearScreen,JmpTo2_PlayMusic,JmpTo_LoadChildObject,JmpTo2_PlaneMapToVRAM_H40,JmpTo2_ObjectMove,JmpTo_PalCycle_Load,JmpTo_LoadSubObject_Part3

; ===========================================================================
; ---------------------------------------------------------------------------
; >> END OF MAIN GAME LOGIC - Everything below this point is file includes and jmpTo Tables <<
; ---------------------------------------------------------------------------
; ===========================================================================

; Where possible, includes to _maps and _anim were appended to the _incObj
; file includes themselves. However, in some cases this wasn't possible,
; as the developers weren't very consistent with the placement, especially
; during the early stages of production. Those includes are still here.

; ===========================================================================
; >>> Level rendering, loading, and updating
	include "Routines/Load Level and Background Speed.asm"
	include "Routines/Deform Layers.asm"
	include "Routines/Draw Level.asm"
	include "Routines/Load Level Layout.asm"
	jmpTos JmpTo_PalLoad_Now,JmpTo_LoadPLC,JmpTo_KosDec

	include "Routines/Level Events.asm"
	jmpTos JmpTo_AllocateObject,JmpTo3_PlaySound,JmpTo2_PalLoad_Now,JmpTo2_LoadPLC,JmpTo3_PlayMusic

; ===========================================================================
; >>> Various level objects
	include "Objects/Zone/Shared/Bridge.asm"
	jmpTos JmpTo_AllocateObjectAfterCurrent,JmpTo_PlatformObject11_cont,JmpTo_CalcSine

	include "Objects/Zone/ARZ/Swinging Platform.asm"
	jmpTos JmpTo_PlatformObject2,JmpTo2_AllocateObjectAfterCurrent,JmpTo2_CalcSine,JmpTo_ObjCheckRightWallDist

	include "Objects/Unused/GHZ Helix.asm"
	jmpTos ; Empty

	include "Objects/Zone/Shared/Stationary Platform.asm"
	jmpTos JmpTo3_CalcSine,JmpTo_PlatformObject,JmpTo_SolidObject

	include "Objects/Zone/Shared/Collapsing Platform.asm"
	jmpTos JmpTo_SlopedPlatform,JmpTo2_PlatformObject

	include "Objects/Zone/Shared/Stake, Falling Oil and Pulse Orb.asm"
	jmpTos ; Empty

	include "Objects/Badniks/Stomper.asm"
	include "Objects/Zone/CPZ/One Way Barrier.asm"
	jmpTos JmpTo2_SolidObject

	include "Objects/Effects/Animal and Points.asm"
	jmpTos JmpTo_RandomNumber
	
	include "Objects/Global/Ring.asm"
	include "Objects/Unused/Big Ring.asm"

	include "Objects/Zone/CNZ/Ring Prize.asm"
	jmpTos JmpTo4_CalcSine

	include "Objects/Global/Monitor.asm"
	jmpTos ; Empty

	include "Objects/Misc/Title Screen Intro.asm"
	jmpTos0 JmpTo4_PlaySound,JmpTo4_PlayMusic

	include "Objects/Misc/Title Card.asm"
	include "Objects/Effects/DPLCs/Animal.dplc"
	include "Objects/Misc/Over Card.asm"
	include "Objects/Misc/Got Through Card.asm"
	include "Objects/Misc/Special Stage Results.asm"

	include "Objects/Misc/Mappings/Title Card.map"
	include "Objects/Misc/Mappings/Over Card.map"
	include "Objects/Misc/Mappings/Got Through Card.map"
	include "Objects/Misc/Mappings/Special Stage Results.map"

	include "Routines/Load Title Card.asm"
	jmpTos JmpTo2_NemDec,JmpTo_NemDecToRAM,JmpTo3_LoadPLC,JmpTo_sub_8476

	include "Objects/Global/Spike.asm"
	jmpTos ; Empty

	include "Objects/Unused/GHZ Purple Rock.asm"
	jmpTos0 ; Empty

	
; While unused, the BreakObjectToPieces routine inside it is used by other objects.
	include "Objects/Unused/GHZ Breakable Wall.asm"

; ===========================================================================
; Subroutines to run, render, and update objects
	include "Routines/Execute Objects.asm"
	include "Routines/Object Pointers.asm"
	include "Objects/Subroutines/Move and Fall.asm"
	include "Objects/Subroutines/Mark and Delete.asm"
	include "Objects/Subroutines/Display Sprite.asm"
	include "Objects/Subroutines/Animate Sprite.asm"
	include "Objects/Subroutines/Build Sprite.asm"
	include "Objects/Subroutines/Draw Sprite.asm"
	include "Objects/Subroutines/Build Sprite 2P.asm"
	include "Objects/Subroutines/Draw Sprite 2P.asm"
	include "Routines/Unused/Check Object Visibility.asm"
	jmpTos JmpTo_BuildHUD,JmpTo_BuildHUD_P1,JmpTo_BuildHUD_P2

	include "Routines/Ring Manager.asm"
	jmpTos0 ; Empty

	include "Routines/CNZ Bumper Manager.asm"
	jmpTos ; Empty
	
	include "Routines/Dynamic Object Loader.asm"
	include "Routines/Find Free Object Slot.asm"

; ===========================================================================
; CNZ object layouts for 2-player mode (various objects were deleted)

    if fixBugs
	; Sonic Team forgot to put a boundary marker here, meaning the game
	; could potentially read past the start of the file and load random
	; objects.
	ObjectLayoutBoundary
    endif

    if gameRevision=0
Objects_CNZ1_2P:	BINCLUDE	"Levels/CNZ/Act 1/2P/Objects (REV00).bin"
	ObjectLayoutBoundary
Objects_CNZ2_2P:	BINCLUDE	"Levels/CNZ/Act 2/2P/Objects (REV00).bin"
    else
    ; a Crawl badnik was moved slightly further away from a ledge
    ; 2 flippers were moved closer to a wall
Objects_CNZ1_2P:	BINCLUDE	"Levels/CNZ/Act 1/2P/Objects (REV01).bin"
	ObjectLayoutBoundary
    ; 4 Crawl badniks were slightly moved, placing them closer/farther away from ledges
    ; 2 flippers were moved away from a wall to keep players from getting stuck behind them
Objects_CNZ2_2P:	BINCLUDE	"Levels/CNZ/Act 2/2P/Objects (REV01).bin"
    endif

	ObjectLayoutBoundary
	jmpTos ; Empty

; ===========================================================================
; >>> More level objects
	include "Objects/Global/Spring.asm"
	jmpTos ; Empty

	include "Objects/Global/Signpost.asm"
	jmpTos ; Empty

	include "Objects/Subroutines/Solid Object.asm"
	include "Objects/Subroutines/Move with Platform.asm"
	include "Objects/Subroutines/Platform Object.asm"
	include "Objects/Global/Sonic.asm"
	jmpTos0 JmpTo_KillCharacter

	include "Objects/Global/Tails.asm"
	jmpTos JmpTo2_KillCharacter

	include "Objects/Effects/Small Bubble.asm"
	include "Objects/Effects/Shield.asm"
	include "Objects/Effects/Invincibility Stars.asm"
	include "Objects/Effects/Splash and Dusts.asm"
	include "Objects/Effects/Super Stars.asm"
	jmpTos ; Empty

	include "Objects/Global/Player (Ground Collision).asm"
	include "Objects/Subroutines/Find Tile, Floor and Wall.asm"
	include "Routines/Unused/Convert Collision Array.asm"
	jmpTos ; Empty

	include "Objects/Global/Player (Collision Detection).asm"
	include "Objects/Global/Star Post.asm"
	jmpTos JmpTo_MarkObjGone,JmpTo2_AnimateSprite,JmpTo3_Adjust2PArtPointer
	
	include "Objects/Unused/Hidden Points.asm"
	jmpTos JmpTo4_Adjust2PArtPointer

	include "Objects/Zone/CNZ/Round Bumper.asm"
	jmpTos JmpTo2_MarkObjGone,JmpTo3_AnimateSprite,JmpTo5_Adjust2PArtPointer

	include "Objects/Zone/ARZ/Bubbles.asm"
	jmpTos JmpTo7_DisplaySprite,JmpTo15_DeleteObject,JmpTo6_Adjust2PArtPointer,JmpTo3_ObjectMove

	include "Objects/Global/Path Switcher.asm"
	jmpTos JmpTo7_Adjust2PArtPointer

	include "Objects/Zone/CPZ/Pipe Router.asm"
	jmpTos JmpTo3_MarkObjGone,JmpTo8_Adjust2PArtPointer

	include "Objects/Unused/CPZ Small Platform.asm"
	jmpTos JmpTo4_MarkObjGone,JmpTo9_Adjust2PArtPointer,JmpTo5_CalcSine

	include "Objects/Unused/HPZ/Emerald.asm"
	jmpTos JmpTo8_DisplaySprite,JmpTo16_DeleteObject,JmpTo10_Adjust2PArtPointer

	include "Objects/Unused/HPZ/Waterfall.asm"
	jmpTos JmpTo9_DisplaySprite,JmpTo17_DeleteObject,JmpTo2_Adjust2PArtPointer2,JmpTo11_Adjust2PArtPointer

	include "Objects/Zone/Shared/Water Surface.asm"
	include "Objects/Zone/EHZ/Waterfall.asm"
	include "Objects/Zone/Shared/Lava Marker.asm"
	include "Objects/Global/Invisible Barrier.asm"
	include "Objects/Zone/CPZ/Pylon.asm"
	include "Objects/Effects/Explosion.asm"
	include "Objects/Zone/CNZ/Pinball Mode.asm"
	include "Objects/Zone/WFZ/Palette Switcher.asm"
	jmpTos JmpTo10_DisplaySprite,JmpTo18_DeleteObject,JmpTo2_AllocateObject,JmpTo12_Adjust2PArtPointer

	include "Objects/Zone/Shared/Spiral Rotator.asm"
	jmpTos JmpTo6_CalcSine

	include "Objects/Zone/HTZ/Seesaw.asm"
	jmpTos JmpTo3_AllocateObjectAfterCurrent,JmpTo13_Adjust2PArtPointer,JmpTo_ObjectMoveAndFall,JmpTo_MarkObjGone2

	include "Objects/Zone/HTZ/Lift.asm"
	jmpTos JmpTo5_MarkObjGone,JmpTo4_AllocateObjectAfterCurrent,JmpTo14_Adjust2PArtPointer,JmpTo3_PlatformObject,JmpTo4_ObjectMove

	include "Objects/Zone/Shared/Platform.asm"
	jmpTos JmpTo11_DisplaySprite,JmpTo20_DeleteObject,JmpTo15_Adjust2PArtPointer,JmpTo4_PlatformObject,JmpTo5_ObjectMove

	include "Objects/Zone/CPZ/Speed Booster.asm"
	jmpTos JmpTo6_MarkObjGone,JmpTo16_Adjust2PArtPointer

	include "Objects/Zone/CPZ/Blue Balls.asm"
	jmpTos JmpTo7_MarkObjGone,JmpTo5_AllocateObjectAfterCurrent,JmpTo3_Adjust2PArtPointer2,JmpTo6_ObjectMove

	include "Objects/Zone/CPZ/Spin Tube.asm"
	jmpTos JmpTo_MarkObjGone3

	include "Objects/Zone/HTZ/Lava Bubble.asm"
	jmpTos JmpTo21_DeleteObject,JmpTo8_MarkObjGone,JmpTo6_AllocateObjectAfterCurrent,JmpTo4_AnimateSprite,JmpTo17_Adjust2PArtPointer,JmpTo7_ObjectMove

	include "Objects/Zone/HTZ/Breakable Ground.asm"
	include "Objects/Zone/Shared/Breakable Block.asm"
ObjSmashableGround_MapUnc_236FA:	include "mappings/sprite/obj2F.asm"
ObjBreakableRock_MapUnc_23852:	include "mappings/sprite/obj32_a.asm"
ObjBreakableRock_MapUnc_23886:	include "mappings/sprite/obj32_b.asm"
	jmpTos JmpTo12_DisplaySprite,JmpTo22_DeleteObject,JmpTo3_AllocateObject,JmpTo9_MarkObjGone,JmpTo18_Adjust2PArtPointer,JmpTo_BreakObjectToPieces,JmpTo3_SolidObject,JmpTo8_ObjectMove

	include "Objects/Zone/HTZ/Rising Lava.asm"
	jmpTos JmpTo23_DeleteObject,JmpTo_Touch_ChkHurt,JmpTo2_MarkObjGone3,JmpTo_DropOnFloor,JmpTo_SolidObject_Always,JmpTo_SlopedSolid

	include "Objects/Zone/OOZ/Popping Platform.asm"
	jmpTos JmpTo10_MarkObjGone,JmpTo7_AllocateObjectAfterCurrent,JmpTo4_SolidObject
	
	include "Objects/Zone/OOZ/Sliding Spike.asm"
	jmpTos JmpTo8_AllocateObjectAfterCurrent,JmpTo19_Adjust2PArtPointer

	include "Objects/Zone/OOZ/Oil Ocean.asm"
	jmpTos JmpTo3_KillCharacter,JmpTo_PlatformObject_SingleCharacter

	include "Objects/Zone/OOZ/Pressure Spring.asm"
	include "Objects/Unused/OOZ Ball.asm"
	jmpTos JmpTo25_DeleteObject,JmpTo4_AllocateObject,JmpTo11_MarkObjGone,JmpTo20_Adjust2PArtPointer,JmpTo5_SolidObject,JmpTo_SolidObject_Always_SingleCharacter,JmpTo_SolidObject45,JmpTo9_ObjectMove

	include "Objects/Zone/Shared/Button.asm"
	jmpTos JmpTo12_MarkObjGone,JmpTo21_Adjust2PArtPointer,JmpTo6_SolidObject

	include "Objects/Zone/OOZ/Ground Cannon.asm"
	jmpTos JmpTo14_DisplaySprite,JmpTo26_DeleteObject,JmpTo13_MarkObjGone,JmpTo9_AllocateObjectAfterCurrent,JmpTo3_MarkObjGone3,JmpTo22_Adjust2PArtPointer,JmpTo2_BreakObjectToPieces,JmpTo7_SolidObject,JmpTo10_ObjectMove

	include "Objects/Zone/OOZ/Sphere Cannon.asm"
	jmpTos JmpTo15_DisplaySprite,JmpTo14_MarkObjGone,JmpTo23_Adjust2PArtPointer

	include "Objects/Zone/ARZ/Arrow Shooter.asm"
	jmpTos JmpTo27_DeleteObject,JmpTo5_AllocateObject,JmpTo15_MarkObjGone,JmpTo5_AnimateSprite,JmpTo24_Adjust2PArtPointer,JmpTo11_ObjectMove

	include "Objects/Zone/ARZ/Falling Pillar.asm"
	include "Objects/Zone/ARZ/Rising Pillar.asm"
	jmpTos JmpTo16_DisplaySprite,JmpTo28_DeleteObject,JmpTo16_MarkObjGone,JmpTo10_AllocateObjectAfterCurrent,JmpTo25_Adjust2PArtPointer,JmpTo8_SolidObject,JmpTo12_ObjectMove

	include "Objects/Zone/ARZ/Leaves Generator.asm"
	jmpTos JmpTo17_DisplaySprite,JmpTo29_DeleteObject,JmpTo6_AllocateObject,JmpTo2_RandomNumber,JmpTo7_CalcSine

	include "Objects/Zone/Shared/Springboard.asm"
	jmpTos JmpTo17_MarkObjGone,JmpTo6_AnimateSprite,JmpTo26_Adjust2PArtPointer,JmpTo_SlopedSolid_SingleCharacter

	include "Objects/Zone/MTZ/Steam Spring.asm"
	jmpTos JmpTo18_DisplaySprite,JmpTo30_DeleteObject,JmpTo7_AllocateObject,JmpTo18_MarkObjGone,JmpTo27_Adjust2PArtPointer,JmpTo2_SolidObject_Always_SingleCharacter

	include "Objects/Zone/MTZ/Twin Stompers.asm"
	jmpTos JmpTo28_Adjust2PArtPointer,JmpTo9_SolidObject

	include "Objects/Zone/MTZ/Long Platform.asm"
	jmpTos JmpTo19_MarkObjGone,JmpTo11_AllocateObjectAfterCurrent,JmpTo29_Adjust2PArtPointer,JmpTo10_SolidObject

	include "Objects/Zone/MTZ/Spring Wall.asm"
    if gameRevision=0
	jmpTos JmpTo47_DisplaySprite,JmpTo33_DeleteObject,JmpTo30_Adjust2PArtPointer,JmpTo3_SolidObject_Always_SingleCharacter
    else
	jmpTos JmpTo33_DeleteObject,JmpTo30_Adjust2PArtPointer,JmpTo3_SolidObject_Always_SingleCharacter
    endif

	include "Objects/Zone/MTZ/Spin Tube.asm"
	jmpTos JmpTo19_DisplaySprite,JmpTo7_AnimateSprite,JmpTo4_MarkObjGone3

	include "Objects/Zone/MTZ/Spike Block.asm"
	include "Objects/Zone/MTZ/Floor Spike.asm"
	jmpTos JmpTo20_MarkObjGone,JmpTo12_AllocateObjectAfterCurrent,JmpTo31_Adjust2PArtPointer,JmpTo11_SolidObject,JmpTo2_MarkObjGone2

	include "Objects/Zone/MTZ/Nut.asm"
	jmpTos JmpTo21_MarkObjGone,JmpTo_ObjCheckFloorDist,JmpTo32_Adjust2PArtPointer,JmpTo12_SolidObject,JmpTo13_ObjectMove

	include "Objects/Zone/MTZ/Moving Platform.asm"
	jmpTos JmpTo13_AllocateObjectAfterCurrent,JmpTo33_Adjust2PArtPointer,JmpTo13_SolidObject,JmpTo3_MarkObjGone2

	include "Objects/Zone/Shared/CPZ, MTZ Platform.asm"
	jmpTos JmpTo34_Adjust2PArtPointer,JmpTo14_SolidObject,JmpTo4_MarkObjGone2,JmpTo14_ObjectMove

	include "Objects/Zone/Shared/Conveyor.asm"
	jmpTos JmpTo20_DisplaySprite,JmpTo34_DeleteObject,JmpTo8_AllocateObject,JmpTo35_Adjust2PArtPointer,JmpTo5_PlatformObject,JmpTo15_ObjectMove

	include "Objects/Zone/Shared/Large Rotating Platform.asm"
	jmpTos JmpTo36_Adjust2PArtPointer,JmpTo15_SolidObject

	include "Objects/Zone/MTZ/Cog.asm"
	jmpTos JmpTo14_AllocateObjectAfterCurrent,JmpTo4_Adjust2PArtPointer2,JmpTo16_SolidObject

	include "Objects/Zone/CNZ/Conveyor Belt.asm"
	jmpTos JmpTo5_MarkObjGone3

	include "Objects/Unused/MCZ Rotating Rings.asm"
	jmpTos JmpTo21_DisplaySprite,JmpTo9_AllocateObject,JmpTo_DeleteObject2,JmpTo37_Adjust2PArtPointer,JmpTo17_SolidObject

	include "Objects/Zone/MCZ/Brick.asm"
	jmpTos JmpTo_DisplaySprite3,JmpTo22_DisplaySprite,JmpTo38_DeleteObject,JmpTo22_MarkObjGone,JmpTo2_DeleteObject2,JmpTo15_AllocateObjectAfterCurrent,JmpTo38_Adjust2PArtPointer,JmpTo8_CalcSine,JmpTo18_SolidObject

	include "Objects/Zone/MCZ/Sliding Spikes.asm"
	jmpTos JmpTo_Touch_ChkHurt2,JmpTo39_Adjust2PArtPointer,JmpTo19_SolidObject,JmpTo5_MarkObjGone2

	include "Objects/Zone/MCZ/Bridge.asm"
	jmpTos JmpTo23_MarkObjGone,JmpTo40_Adjust2PArtPointer,JmpTo20_SolidObject

	include "Objects/Zone/CPZ/Staircase.asm"
	jmpTos JmpTo16_AllocateObjectAfterCurrent,JmpTo5_Adjust2PArtPointer2,JmpTo21_SolidObject,JmpTo6_MarkObjGone2

	include "Objects/Zone/CPZ/Water Platform.asm"
	jmpTos JmpTo24_DisplaySprite,JmpTo17_AllocateObjectAfterCurrent,JmpTo41_Adjust2PArtPointer,JmpTo6_PlatformObject

	include "Objects/Zone/CPZ/Pipe Exit Spring.asm"
	jmpTos JmpTo25_DisplaySprite,JmpTo40_DeleteObject,JmpTo8_AnimateSprite,JmpTo42_Adjust2PArtPointer,JmpTo4_SolidObject_Always_SingleCharacter

	include "Objects/Zone/MCZ/Vine Switch.asm"
	jmpTos JmpTo24_MarkObjGone,JmpTo43_Adjust2PArtPointer
	
	include "Objects/Zone/MCZ/Moving Vine.asm"
	jmpTos JmpTo25_MarkObjGone,JmpTo44_Adjust2PArtPointer

	include "Objects/Zone/MCZ/Drawbridge.asm"
	jmpTos JmpTo2_DisplaySprite3,JmpTo26_DisplaySprite,JmpTo41_DeleteObject,JmpTo3_DeleteObject2,JmpTo18_AllocateObjectAfterCurrent,JmpTo45_Adjust2PArtPointer,JmpTo9_CalcSine,JmpTo22_SolidObject

	include "Objects/Zone/ARZ/Swinging Platform 2.asm"
	jmpTos JmpTo2_ObjCheckFloorDist,JmpTo46_Adjust2PArtPointer,JmpTo_ObjCheckCeilingDist,JmpTo23_SolidObject,JmpTo7_MarkObjGone2,JmpTo16_ObjectMove

	include "Objects/Zone/ARZ/Rotating Platforms.asm"
	jmpTos JmpTo3_DisplaySprite3,JmpTo27_DisplaySprite,JmpTo42_DeleteObject,JmpTo4_DeleteObject2,JmpTo19_AllocateObjectAfterCurrent,JmpTo47_Adjust2PArtPointer,JmpTo10_CalcSine,JmpTo7_PlatformObject,JmpTo8_MarkObjGone2

	include "Objects/Zone/OOZ/Fan.asm"
	jmpTos JmpTo26_MarkObjGone,JmpTo48_Adjust2PArtPointer

	include "Objects/Zone/CNZ/Spring Launcher.asm"
	jmpTos JmpTo4_DisplaySprite3,JmpTo43_DeleteObject,JmpTo49_Adjust2PArtPointer,JmpTo5_SolidObject_Always_SingleCharacter

	include "Objects/Zone/CNZ/Flipper.asm"
	jmpTos JmpTo27_MarkObjGone,JmpTo9_AnimateSprite,JmpTo50_Adjust2PArtPointer,JmpTo11_CalcSine,JmpTo6_SolidObject_Always_SingleCharacter,JmpTo2_SlopedSolid

	include "Objects/Zone/CNZ/Rectangular Blocks.asm"
	jmpTos JmpTo6_MarkObjGone3,JmpTo51_Adjust2PArtPointer,JmpTo24_SolidObject,JmpTo9_MarkObjGone2

	include "Objects/Zone/CNZ/Bomb Prize.asm"
	jmpTos JmpTo28_DisplaySprite,JmpTo44_DeleteObject

	include "Objects/Zone/CNZ/Big Block.asm"
	jmpTos JmpTo52_Adjust2PArtPointer,JmpTo25_SolidObject,JmpTo10_MarkObjGone2,JmpTo17_ObjectMove

	include "Objects/Zone/CNZ/Elevator.asm"
	jmpTos JmpTo28_MarkObjGone,JmpTo53_Adjust2PArtPointer,JmpTo_PlatformObjectD5,JmpTo18_ObjectMove

	include "Objects/Zone/CNZ/Point Pokey.asm"
	include "Routines/Slot Machine.asm"
	jmpTos JmpTo10_AllocateObject,JmpTo29_MarkObjGone,JmpTo10_AnimateSprite,JmpTo6_Adjust2PArtPointer2,JmpTo54_Adjust2PArtPointer,JmpTo12_CalcSine,JmpTo7_SolidObject_Always_SingleCharacter

	include "Objects/Zone/CNZ/Bumper.asm"
	jmpTos JmpTo30_DisplaySprite,JmpTo30_MarkObjGone,JmpTo11_AnimateSprite,JmpTo55_Adjust2PArtPointer

	include "Objects/Zone/CNZ/Bonus Bumper.asm"
	jmpTos JmpTo46_DeleteObject,JmpTo11_AllocateObject,JmpTo31_MarkObjGone,JmpTo12_AnimateSprite,JmpTo56_Adjust2PArtPointer

	include "Objects/Zone/Shared/Grabber.asm"
	jmpTos JmpTo7_MarkObjGone3

	include "Objects/Badniks/Octus.asm"
	jmpTos0 JmpTo31_DisplaySprite,JmpTo47_DeleteObject,JmpTo32_MarkObjGone,JmpTo13_AnimateSprite,JmpTo2_ObjectMoveAndFall,JmpTo19_ObjectMove

	include "Objects/Badniks/Aquis.asm"
	jmpTos JmpTo32_DisplaySprite,JmpTo48_DeleteObject,JmpTo12_AllocateObject,JmpTo33_MarkObjGone,JmpTo14_AnimateSprite,JmpTo_Obj_GetOrientationToPlayer,JmpTo_Obj_CapSpeed,JmpTo_Obj_MoveStop,JmpTo20_ObjectMove

	include "Objects/Badniks/Buzzer.asm"
	jmpTos0 JmpTo49_DeleteObject,JmpTo20_AllocateObjectAfterCurrent,JmpTo15_AnimateSprite,JmpTo7_Adjust2PArtPointer2,JmpTo_MarkObjGone_P1,JmpTo57_Adjust2PArtPointer,JmpTo21_ObjectMove

	include "Objects/Badniks/Masher.asm"
	jmpTos0 JmpTo34_MarkObjGone,JmpTo16_AnimateSprite,JmpTo58_Adjust2PArtPointer,JmpTo22_ObjectMove

	include "Objects/Effects/Boss Explosion.asm"
	include "Objects/Subroutines/Boss Handler.asm"
	jmpTos JmpTo33_DisplaySprite,JmpTo50_DeleteObject,JmpTo4_LoadPLC,JmpTo_AddPoints,JmpTo59_Adjust2PArtPointer

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5D - CPZ boss
; ----------------------------------------------------------------------------
	include "Objects/Bosses/Water Eggman.asm"
	jmpTos JmpTo34_DisplaySprite,JmpTo51_DeleteObject,JmpTo35_MarkObjGone,JmpTo5_PlaySound,JmpTo8_Adjust2PArtPointer2,JmpTo5_LoadPLC,JmpTo2_AddPoints,JmpTo60_Adjust2PArtPointer,JmpTo_PlayLevelMusic,JmpTo_LoadPLC_AnimalExplosion,JmpTo3_ObjectMoveAndFall,JmpTo23_ObjectMove

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 56 - EHZ boss
; ----------------------------------------------------------------------------
	include "Objects/Bosses/Drill Eggman.asm"
	jmpTos JmpTo35_DisplaySprite,JmpTo52_DeleteObject,JmpTo36_MarkObjGone,JmpTo5_DeleteObject2,JmpTo6_PlaySound,JmpTo21_AllocateObjectAfterCurrent,JmpTo17_AnimateSprite,JmpTo9_Adjust2PArtPointer2,JmpTo3_ObjCheckFloorDist,JmpTo6_LoadPLC,JmpTo3_AddPoints,JmpTo61_Adjust2PArtPointer,JmpTo2_PlayLevelMusic,JmpTo2_LoadPLC_AnimalExplosion,JmpTo4_ObjectMoveAndFall

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 52 - HTZ boss
; ----------------------------------------------------------------------------
	include "Objects/Bosses/Submarine Eggman.asm"
	jmpTos0 JmpTo36_DisplaySprite,JmpTo53_DeleteObject,JmpTo13_AllocateObject,JmpTo37_MarkObjGone,JmpTo7_PlaySound,JmpTo18_AnimateSprite,JmpTo4_ObjCheckFloorDist,JmpTo7_LoadPLC,JmpTo_ObjLavaBubble,JmpTo4_AddPoints,JmpTo62_Adjust2PArtPointer,JmpTo3_PlayLevelMusic,JmpTo3_LoadPLC_AnimalExplosion

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 89 - ARZ boss
; ----------------------------------------------------------------------------
	include "Objects/Bosses/Hammer Eggman.asm"
	jmpTos JmpTo37_DisplaySprite,JmpTo55_DeleteObject,JmpTo14_AllocateObject,JmpTo8_PlaySound,JmpTo22_AllocateObjectAfterCurrent,JmpTo19_AnimateSprite,JmpTo3_RandomNumber,JmpTo8_LoadPLC,JmpTo5_AddPoints,JmpTo4_PlayLevelMusic,JmpTo4_LoadPLC_AnimalExplosion,JmpTo8_PlatformObject,JmpTo26_SolidObject

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 57 - MCZ boss
; ----------------------------------------------------------------------------
	include "Objects/Bosses/Drill Eggman II.asm"
	jmpTos JmpTo38_DisplaySprite,JmpTo57_DeleteObject,JmpTo15_AllocateObject,JmpTo4_RandomNumber,JmpTo9_LoadPLC,JmpTo6_AddPoints,JmpTo5_PlayLevelMusic,JmpTo5_LoadPLC_AnimalExplosion,JmpTo5_ObjectMoveAndFall

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 51 - CNZ boss
; ----------------------------------------------------------------------------
	include "Objects/Bosses/Catcher Eggman.asm"
	jmpTos JmpTo39_DisplaySprite,JmpTo59_DeleteObject,JmpTo16_AllocateObject,JmpTo9_PlaySound,JmpTo23_AllocateObjectAfterCurrent,JmpTo20_AnimateSprite,JmpTo10_LoadPLC,JmpTo7_AddPoints,JmpTo6_PlayLevelMusic,JmpTo6_LoadPLC_AnimalExplosion

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 54 - MTZ boss
; ----------------------------------------------------------------------------
	include "Objects/Bosses/Flying Eggman.asm"
	jmpTos0 JmpTo40_DisplaySprite,JmpTo61_DeleteObject,JmpTo17_AllocateObject,JmpTo10_PlaySound,JmpTo21_AnimateSprite,JmpTo11_LoadPLC,JmpTo8_AddPoints,JmpTo7_PlayLevelMusic,JmpTo7_LoadPLC_AnimalExplosion,JmpTo6_ObjectMoveAndFall,JmpTo24_ObjectMove

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 55 - OOZ boss
; ----------------------------------------------------------------------------
	include "Objects/Bosses/Submarine Eggman II.asm"
	jmpTos JmpTo41_DisplaySprite,JmpTo62_DeleteObject,JmpTo18_AllocateObject,JmpTo38_MarkObjGone,JmpTo11_PlaySound,JmpTo24_AllocateObjectAfterCurrent,JmpTo22_AnimateSprite,JmpTo5_RandomNumber,JmpTo63_Adjust2PArtPointer,JmpTo13_CalcSine,JmpTo8_PlayLevelMusic,JmpTo8_LoadPLC_AnimalExplosion,JmpTo25_ObjectMove

	include "Objects/Global/Sonic (Special Stage).asm"
	jmpTos JmpTo42_DisplaySprite,JmpTo_SSAllocateObject

	include "Objects/Global/Tails (Special Stage).asm"
	jmpTos JmpTo43_DisplaySprite,JmpTo23_AnimateSprite

	include "Objects/Special/SS Bomb and Ring.asm"
	include "Objects/Special/Messages.asm"
	include "Objects/Special/Emerald.asm"
	include "Objects/Special/Animations/SS Ring.ani"
; ----------------------------------------------------------------------------
; sprite mappings/animations
; ----------------------------------------------------------------------------
ObjSSMessage_ObjSSRingSpill_ObjSSRing_MapUnc_3632A:	include "Objects/Special/Mappings/Ring and Messages.map"
	include "Objects/Special/Animations/SS Bomb.ani"
ObjSSBomb_MapUnc_36508:	include "Objects/Special/Mappings/SS Bomb.map"

	jmpTos0 JmpTo44_DisplaySprite,JmpTo63_DeleteObject,JmpTo24_AnimateSprite,JmpTo_SSStartNewAct,JmpTo_CalcAngle,JmpTo14_CalcSine,JmpTo7_ObjectMoveAndFall,JmpTo_SSAllocateObjectAfterCurrent,JmpTo2_SSAllocateObject

	include "Objects/Subroutines/Load Sub Object.asm"
	include "Routines/Sub Object Pointers.asm"
	include "Objects/Subroutines/Get Orientation to Player.asm"
	include "Objects/Subroutines/Cap Speed.asm"
	include "Objects/Subroutines/Stop Movement.asm"
	include "Objects/Subroutines/Align Child XY.asm"
	include "Objects/Subroutines/Delete Behind Screen.asm"
	include "Objects/Subroutines/Inherit Parent Flip.asm"
	include "Objects/Subroutines/Load Child Object.asm"
	include "Objects/Subroutines/Create Projectiles.asm"
	include "Objects/Subroutines/Animate Mecha Sprite.asm"
	include "Objects/Subroutines/Delete Off-Screen.asm"
    if removeJmpTos
JmpTo65_DeleteObject ; JmpTo
    endif

JmpTo64_DeleteObject ; JmpTo
	jmp	(DeleteObject).l

	include "Objects/Badniks/Whisp.asm"
	include "Objects/Badniks/Grounder.asm"
	include "Objects/Badniks/Chop Chop.asm"
	include "Objects/Badniks/Spiker.asm"
	include "Objects/Badniks/Sol.asm"
	include "Objects/Badniks/Rexon.asm"
	include "Objects/Badniks/Projectile.asm"
	include "Objects/Badniks/Nebula.asm"
	include "Objects/Badniks/Turtloid and Balkiry Jet.asm"

	include "Objects/Badniks/Animations/Turtloid.ani"
	include "Objects/Badniks/Animations/Balkiry Jet.ani"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjTurtloid_ObjProjectile_MapUnc_37B62:	include "mappings/sprite/obj9C.asm"

	include "Objects/Badniks/Coconuts.asm"
	include "Objects/Badniks/Crawlton.asm"
	include "Objects/Badniks/Shellcracker.asm"
	include "Objects/Badniks/Slicer.asm"
	include "Objects/Badniks/Flasher.asm"
	include "Objects/Badniks/Asteron.asm"
	include "Objects/Badniks/Spiny.asm"
	include "Objects/Badniks/Grabber.asm"
	include "Objects/Badniks/Balkiry.asm"
	include "Objects/Badniks/Clucker.asm"

	include "Objects/Bosses/Mecha Sonic.asm"

	include "Objects/Misc/Sonic (SEGA Screen) and TM Hider.asm"
	include "Routines/SEGA Vertical Interrupt.asm"

	include "Objects/Zone/Shared/Tornado.asm"
	include "Objects/Zone/SCZ/Clouds.asm"

	include "Objects/Zone/WFZ/Propeller.asm"
	include "Objects/Zone/WFZ/Tilting Platform.asm"
	include "Objects/Unused/WFZ Large Laser.asm"
	include "Objects/Zone/WFZ/Wall Turret.asm"
	include "Objects/Zone/WFZ/Laser.asm"
	include "Objects/Zone/WFZ/Wheel.asm"
	include "Objects/Zone/WFZ/Ship Fire.asm"
	include "Objects/Zone/WFZ/Small Metal Platform.asm"
	include "Objects/Zone/WFZ/Lateral Cannon.asm"
	include "Objects/Badniks/WFZ Stick.asm"
	include "Objects/Zone/WFZ/Speed Launcher.asm"
	include "Objects/Zone/WFZ/Breakable Plating.asm"
	include "Objects/Zone/WFZ/Rivet.asm"
	include "Objects/Zone/WFZ/Tornado Smoke.asm"
	include "Objects/Bosses/Barrier Eggman.asm"
	include "Objects/Bosses/Eggman.asm"
	include "Objects/Badniks/Crawl.asm"
	include "Objects/Bosses/Robo Eggman.asm"

	include "Routines/Upscale Graphics 2X.asm"
	jmpTos0 JmpTo5_DisplaySprite3,JmpTo45_DisplaySprite,JmpTo65_DeleteObject,JmpTo19_AllocateObject,JmpTo39_MarkObjGone,JmpTo6_DeleteObject2,JmpTo12_PlaySound,JmpTo25_AllocateObjectAfterCurrent,JmpTo25_AnimateSprite,JmpTo_PlaySoundLocal,JmpTo6_RandomNumber,JmpTo2_MarkObjGone_P1,JmpTo_Pal_FadeToWhite.UpdateColour,JmpTo_LoadTailsDynPLC_Part2,JmpTo_LoadSonicDynPLC_Part2,JmpTo8_MarkObjGone3,JmpTo64_Adjust2PArtPointer,JmpTo5_PlayMusic,JmpTo_Boss_LoadExplosion,JmpTo9_PlatformObject,JmpTo27_SolidObject,JmpTo8_ObjectMoveAndFall,JmpTo26_ObjectMove

	include "Objects/Unused/S1 Credits.asm"
	jmpTos JmpTo65_Adjust2PArtPointer

	include "Objects/Global/Prison Capsule.asm"
	jmpTos JmpTo66_DeleteObject,JmpTo20_AllocateObject

	include "Objects/Global/Player (Object Reactions).asm"
	jmpTos JmpTo_Sonic_ResetOnFloor_Part2,JmpTo_Check_CNZ_bumpers,JmpTo_Touch_Rings

	include "Routines/Zone Animation Procedures.asm"
	jmpTos JmpTo2_NemDecToRAM
	
	include "Routines/Build HUD.asm"
	include "Routines/Add Points.asm"
	include "Routines/HUD Update.asm"
	include "Routines/Time Over.asm"
	include "Routines/HUD Initalize Rings.asm"
	include "Routines/Load Number and Life Patterns.asm"
Art_Hud:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 1.bin"
Art_LivesNums:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 2.bin"
Art_Text:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 3.bin"
	jmpTos JmpTo_DrawSprite_2P_Loop,JmpTo_DrawSprite_Loop

	include "Objects/Debug Mode.asm"
	jmpTos JmpTo66_Adjust2PArtPointer

	include "Routines/Level Cell Pointers.asm"
	include "Routines/PLC List.asm"

;---------------------------------------------------------------------------------------
; Collision Data
;---------------------------------------------------------------------------------------
ColCurveMap:		BINCLUDE	"Levels/Collision/Angle Map.bin"
	even
ColArrayVertical:	BINCLUDE	"Levels/Collision/Vertical Array.bin"
ColArrayHorizontal:	BINCLUDE	"Levels/Collision/Horizontal Array.bin"
	even

; These are all compressed in the Kosinski format.
ColP_EHZHTZ:	BINCLUDE	"Levels/EHZ/Collision.kos"
	even
ColS_EHZHTZ:	BINCLUDE	"Levels/EHZ/2nd Collision.kos"
	even
ColP_WZ:	;BINCLUDE	"Levels/Unused/WZ/Collision.kos"
	;even
ColP_MTZ:	BINCLUDE	"Levels/MTZ/Collision.kos"
	even
ColP_HPZ:	;BINCLUDE	"Levels/Unused/HPZ/Collision.kos"
	;even
ColS_HPZ:	;BINCLUDE	"Levels/Unused/HPZ/2nd Collision.kos"
	;even
ColP_OOZ:	BINCLUDE	"Levels/OOZ/Collision.kos"
	even
ColP_MCZ:	BINCLUDE	"Levels/MCZ/Collision.kos"
	even
ColP_CNZ:	BINCLUDE	"Levels/CNZ/Collision.kos"
	even
ColS_CNZ:	BINCLUDE	"Levels/CNZ/2nd Collision.kos"
	even
ColP_CPZDEZ:	BINCLUDE	"Levels/CPZ/Collision.kos"
	even
ColS_CPZDEZ:	BINCLUDE	"Levels/CPZ/2nd Collision.kos"
	even
ColP_ARZ:	BINCLUDE	"Levels/ARZ/Collision.kos"
	even
ColS_ARZ:	BINCLUDE	"Levels/ARZ/2nd Collision.kos"
	even
ColP_WFZSCZ:	BINCLUDE	"Levels/WFZ/Collision.kos"
	even
ColS_WFZSCZ:	BINCLUDE	"Levels/WFZ/2nd Collision.kos"
	even
ColP_Invalid:




;---------------------------------------------------------------------------------------
; Offset index of level layouts
; Two entries per zone, pointing to the level layouts for acts 1 and 2 of each zone
; respectively.
;---------------------------------------------------------------------------------------
Off_Level: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w Level_EHZ1	; Act 1
	zoneOffsetTableEntry.w Level_EHZ2	; Act 2
	; Zone 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; WZ
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; Zone 3
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; MTZ
	zoneOffsetTableEntry.w Level_MTZ1	; Act 1
	zoneOffsetTableEntry.w Level_MTZ2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w Level_MTZ3	; Act 3
	zoneOffsetTableEntry.w Level_MTZ3	; Act 4
	; WFZ
	zoneOffsetTableEntry.w Level_WFZ	; Act 1
	zoneOffsetTableEntry.w Level_WFZ	; Act 2
	; HTZ
	zoneOffsetTableEntry.w Level_HTZ1	; Act 1
	zoneOffsetTableEntry.w Level_HTZ2	; Act 2
	; HPZ
	zoneOffsetTableEntry.w Level_HPZ1	; Act 1
	zoneOffsetTableEntry.w Level_HPZ1	; Act 2
	; Zone 9
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; OOZ
	zoneOffsetTableEntry.w Level_OOZ1	; Act 1
	zoneOffsetTableEntry.w Level_OOZ2	; Act 2
	; MCZ
	zoneOffsetTableEntry.w Level_MCZ1	; Act 1
	zoneOffsetTableEntry.w Level_MCZ2	; Act 2
	; CNZ
	zoneOffsetTableEntry.w Level_CNZ1	; Act 1
	zoneOffsetTableEntry.w Level_CNZ2	; Act 2
	; CPZ
	zoneOffsetTableEntry.w Level_CPZ1	; Act 1
	zoneOffsetTableEntry.w Level_CPZ2	; Act 2
	; DEZ
	zoneOffsetTableEntry.w Level_DEZ	; Act 1
	zoneOffsetTableEntry.w Level_DEZ	; Act 2
	; ARZ
	zoneOffsetTableEntry.w Level_ARZ1	; Act 1
	zoneOffsetTableEntry.w Level_ARZ2	; Act 2
	; SCZ
	zoneOffsetTableEntry.w Level_SCZ	; Act 1
	zoneOffsetTableEntry.w Level_SCZ	; Act 2
    zoneTableEnd

; These are all compressed in the Kosinski format.
Level_Invalid:
Level_EHZ1:	BINCLUDE	"Levels/EHZ/Act 1/Layout.kos"
	even
Level_EHZ2:	BINCLUDE	"Levels/EHZ/Act 2/Layout.kos"
	even
Level_MTZ1:	BINCLUDE	"Levels/MTZ/Act 1/Layout.kos"
	even
Level_MTZ2:	BINCLUDE	"Levels/MTZ/Act 2/Layout.kos"
	even
Level_MTZ3:	BINCLUDE	"Levels/MTZ/Act 3/Layout.kos"
	even
Level_WFZ:	BINCLUDE	"Levels/WFZ/Layout.kos"
	even
Level_HTZ1:	BINCLUDE	"Levels/HTZ/Act 1/Layout.kos"
	even
Level_HTZ2:	BINCLUDE	"Levels/HTZ/Act 2/Layout.kos"
	even
Level_HPZ1:	;BINCLUDE	"Levels/Unused/HPZ/Act 1/Layout.kos"
	;even
Level_OOZ1:	BINCLUDE	"Levels/OOZ/Act 1/Layout.kos"
	even
Level_OOZ2:	BINCLUDE	"Levels/OOZ/Act 2/Layout.kos"
	even
Level_MCZ1:	BINCLUDE	"Levels/MCZ/Act 1/Layout.kos"
	even
Level_MCZ2:	BINCLUDE	"Levels/MCZ/Act 2/Layout.kos"
	even
Level_CNZ1:	BINCLUDE	"Levels/CNZ/Act 1/Layout.kos"
	even
Level_CNZ2:	BINCLUDE	"Levels/CNZ/Act 2/Layout.kos"
	even
Level_CPZ1:	BINCLUDE	"Levels/CPZ/Act 1/Layout.kos"
	even
Level_CPZ2:	BINCLUDE	"Levels/CPZ/Act 2/Layout.kos"
	even
Level_DEZ:	BINCLUDE	"Levels/DEZ/Layout.kos"
	even
Level_ARZ1:	BINCLUDE	"Levels/ARZ/Act 1/Layout.kos"
	even
Level_ARZ2:	BINCLUDE	"Levels/ARZ/Act 2/Layout.kos"
	even
Level_SCZ:	BINCLUDE	"Levels/SCZ/Layout.kos"
	even




;---------------------------------------------------------------------------------------
; Animated Level Art
;---------------------------------------------------------------------------------------
; EHZ and HTZ
ArtUnc_Flowers1:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 1.bin"
ArtUnc_Flowers2:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 2.bin"
ArtUnc_Flowers3:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 3.bin"
ArtUnc_Flowers4:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 4.bin"
ArtUnc_EHZPulseBall:	BINCLUDE	"art/uncompressed/Pulsing ball against checkered background (EHZ).bin"
ArtNem_HTZCliffs:	BINCLUDE	"art/nemesis/Dynamically reloaded cliffs in HTZ background.nem"
	even
ArtUnc_HTZClouds:	BINCLUDE	"art/uncompressed/Background clouds (HTZ).bin"

; MTZ
ArtUnc_MTZCylinder:	BINCLUDE	"art/uncompressed/Spinning metal cylinder (MTZ).bin"
ArtUnc_Lava:		BINCLUDE	"art/uncompressed/Lava.bin"
ArtUnc_MTZAnimBack:	BINCLUDE	"art/uncompressed/Animated section of MTZ background.bin"

; HPZ
ArtUnc_HPZPulseOrb:	;BINCLUDE	"art/uncompressed/Pulsing orb (HPZ).bin"

; OOZ
ArtUnc_OOZPulseBall:	BINCLUDE	"art/uncompressed/Pulsing ball (OOZ).bin"
ArtUnc_OOZSquareBall1:	BINCLUDE	"art/uncompressed/Square rotating around ball in OOZ - 1.bin"
ArtUnc_OOZSquareBall2:	BINCLUDE	"art/uncompressed/Square rotating around ball in OOZ - 2.bin"
ArtUnc_Oil1:		BINCLUDE	"art/uncompressed/Oil - 1.bin"
ArtUnc_Oil2:		BINCLUDE	"art/uncompressed/Oil - 2.bin"

; CNZ
ArtUnc_CNZFlipTiles:	BINCLUDE	"art/uncompressed/Flipping foreground section (CNZ).bin"
ArtUnc_CNZSlotPics:	BINCLUDE	"art/uncompressed/Slot pictures.bin"
ArtUnc_CPZAnimBack:	BINCLUDE	"art/uncompressed/Animated background section (CPZ and DEZ).bin"

; ARZ
ArtUnc_Waterfall1:	BINCLUDE	"art/uncompressed/ARZ waterfall patterns - 1.bin"
ArtUnc_Waterfall2:	BINCLUDE	"art/uncompressed/ARZ waterfall patterns - 2.bin"
ArtUnc_Waterfall3:	BINCLUDE	"art/uncompressed/ARZ waterfall patterns - 3.bin"

;---------------------------------------------------------------------------------------
; Player Assets
;---------------------------------------------------------------------------------------
	align tiles_to_bytes(1)
ArtUnc_Sonic:			BINCLUDE	"Objects/Global/Cells/Sonic.unc"
	align tiles_to_bytes(1)
ArtUnc_Tails:			BINCLUDE	"Objects/Global/Cells/Tails.unc"

MapUnc_Sonic:			include		"Objects/Global/Mappings/Sonic.map"

MapRUnc_Sonic:			include		"Objects/Global/DPLCs/Sonic.dplc"

ArtNem_Shield:			BINCLUDE	"art/nemesis/Shield.nem"
	even
ArtNem_Invincible_stars:	BINCLUDE	"art/nemesis/Invincibility stars.nem"
	even
ArtUnc_SplashAndDust:		BINCLUDE	"art/uncompressed/Splash and skid dust.bin"

ArtNem_SuperSonic_stars:	BINCLUDE	"art/nemesis/Super Sonic stars.nem"
	even
MapUnc_Tails:			include		"Objects/Global/Mappings/Tails.map"

MapRUnc_Tails:			include		"Objects/Global/DPLCs/Tails.dplc"

;---------------------------------------------------------------------------------------
; Sega Screen Assets
;---------------------------------------------------------------------------------------
ArtNem_SEGA:			BINCLUDE	"art/nemesis/SEGA.nem"
	even
ArtNem_IntroTrails:		BINCLUDE	"art/nemesis/Shaded blocks from intro.nem"
	even
MapEng_SEGA:			BINCLUDE	"mappings/misc/SEGA mappings.eni"
	even

;---------------------------------------------------------------------------------------
; Title Screen Assets
;---------------------------------------------------------------------------------------
MapEng_TitleScreen:		BINCLUDE	"mappings/misc/Mappings for title screen background.eni"
	even
MapEng_TitleBack:		BINCLUDE	"mappings/misc/Mappings for title screen background 2.eni" ; title screen background (smaller part, water/horizon)
	even
MapEng_TitleLogo:		BINCLUDE	"mappings/misc/Sonic the Hedgehog 2 title screen logo mappings.eni"
	even
ArtNem_Title:			BINCLUDE	"art/nemesis/Main patterns from title screen.nem"
	even
ArtNem_TitleSprites:		BINCLUDE	"art/nemesis/Sonic and Tails from title screen.nem"
	even
ArtNem_MenuJunk:		BINCLUDE	"art/nemesis/A few menu blocks.nem"
	even

;---------------------------------------------------------------------------------------
; General Level Assets
;---------------------------------------------------------------------------------------
ArtNem_Button:			BINCLUDE	"art/nemesis/Button.nem"
	even
ArtNem_VrtclSprng:		BINCLUDE	"Objects/Global/Cells/Spring (Vertical).nem"
	even
ArtNem_HrzntlSprng:		BINCLUDE	"Objects/Global/Cells/Spring (Horizontal).nem"
	even
ArtNem_DignlSprng:		BINCLUDE	"Objects/Global/Cells/Spring (Diagonal).nem"
	even
ArtNem_HUD:			BINCLUDE	"art/nemesis/HUD.nem" ; Score, Rings, Time
	even
ArtNem_Sonic_life_counter:	BINCLUDE	"art/nemesis/Sonic lives counter.nem"
	even
ArtNem_Ring:			BINCLUDE	"Objects/Global/Cells/Ring.nem"
	even
ArtNem_Powerups:		BINCLUDE	"Objects/Global/Cells/Monitor.nem"
	even
ArtNem_Spikes:			BINCLUDE	"Objects/Global/Cells/Spike.nem"
	even
ArtNem_Numbers:			BINCLUDE	"art/nemesis/Numbers.nem"
	even
ArtNem_Checkpoint:		BINCLUDE	"Objects/Global/Cells/Star Post.nem"
	even
ArtNem_Signpost:		BINCLUDE	"Objects/Global/Cells/Signpost.nem" ; For one-player mode.
	even
ArtUnc_Signpost:		BINCLUDE	"Objects/Global/Cells/Signpost 2P.unc" ; For two-player mode.
	even
ArtNem_LeverSpring:		BINCLUDE	"art/nemesis/Lever spring.nem"
	even
ArtNem_HorizSpike:		BINCLUDE	"art/nemesis/Long horizontal spike.nem"
	even
ArtNem_BigBubbles:		BINCLUDE	"art/nemesis/Bubble generator.nem" ; Bubble from underwater
	even
ArtNem_Bubbles:			BINCLUDE	"art/nemesis/Bubbles.nem" ; Bubbles from character
	even
ArtUnc_Countdown:		BINCLUDE	"art/uncompressed/Numbers for drowning countdown.bin"
	even
ArtNem_Game_Over:		BINCLUDE	"art/nemesis/Game and Time Over text.nem"
	even
ArtNem_Explosion:		BINCLUDE	"art/nemesis/Explosion.nem"
	even
ArtNem_MilesLife:		BINCLUDE	"art/nemesis/Miles life counter.nem"
	even
ArtNem_Capsule:			BINCLUDE	"Objects/Global/Cells/Prison Capsule.nem"
	even
ArtNem_ContinueTails:		BINCLUDE	"art/nemesis/Tails on continue screen.nem"
	even
ArtNem_MiniSonic:		BINCLUDE	"art/nemesis/Sonic continue.nem"
	even
ArtNem_TailsLife:		BINCLUDE	"art/nemesis/Tails life counter.nem"
	even
ArtNem_MiniTails:		BINCLUDE	"art/nemesis/Tails continue.nem"
	even

;---------------------------------------------------------------------------------------
; Menu Assets
;---------------------------------------------------------------------------------------
ArtNem_FontStuff:		BINCLUDE	"art/nemesis/Standard font.nem"
	even
ArtNem_1P2PWins:		BINCLUDE	"art/nemesis/1P and 2P wins text from 2P mode.nem"
	even
MapEng_MenuBack:		BINCLUDE	"mappings/misc/Sonic and Miles animated background.eni"
	even
ArtUnc_MenuBack:		BINCLUDE	"art/uncompressed/Sonic and Miles animated background.bin"
	even
ArtNem_TitleCard:		BINCLUDE	"art/nemesis/Title card.nem"
	even
ArtNem_TitleCard2:		BINCLUDE	"art/nemesis/Font using large broken letters.nem"
	even
ArtNem_MenuBox:			BINCLUDE	"art/nemesis/A menu box with a shadow.nem"
	even
ArtNem_LevelSelectPics:		BINCLUDE	"art/nemesis/Pictures in level preview box from level select.nem"
	even
ArtNem_ResultsText:		BINCLUDE	"art/nemesis/End of level results text.nem" ; Text for Sonic or Tails Got Through Act and Bonus/Perfect
	even
ArtNem_SpecialStageResults:	BINCLUDE	"art/nemesis/Special stage results screen art and some emeralds.nem"
	even
ArtNem_Perfect:			BINCLUDE	"art/nemesis/Perfect text.nem"
	even

;---------------------------------------------------------------------------------------
; Small Animal Assets
;---------------------------------------------------------------------------------------
ArtNem_Flicky:			BINCLUDE	"art/nemesis/Flicky.nem"
	even
ArtNem_Squirrel:		BINCLUDE	"art/nemesis/Squirrel.nem" ; Ricky
	even
ArtNem_Mouse:			BINCLUDE	"art/nemesis/Mouse.nem"    ; Micky
	even
ArtNem_Chicken:			BINCLUDE	"art/nemesis/Chicken.nem"  ; Cucky
	even
ArtNem_Monkey:			BINCLUDE	"art/nemesis/Monkey.nem"   ; Wocky
	even
ArtNem_Eagle:			BINCLUDE	"art/nemesis/Eagle.nem"    ; Locky
	even
ArtNem_Pig:			BINCLUDE	"art/nemesis/Pig.nem"      ; Picky
	even
ArtNem_Seal:			BINCLUDE	"art/nemesis/Seal.nem"     ; Rocky
	even
ArtNem_Penguin:			BINCLUDE	"art/nemesis/Penguin.nem"  ; Pecky
	even
ArtNem_Turtle:			BINCLUDE	"art/nemesis/Turtle.nem"   ; Tocky
	even
ArtNem_Bear:			BINCLUDE	"art/nemesis/Bear.nem"     ; Becky
	even
ArtNem_Rabbit:			BINCLUDE	"art/nemesis/Rabbit.nem"   ; Pocky
	even

;---------------------------------------------------------------------------------------
; WFZ Assets
;---------------------------------------------------------------------------------------
ArtNem_WfzSwitch:		BINCLUDE	"art/nemesis/WFZ boss chamber switch.nem" ; Rivet thing that you bust to get inside the ship
	even
ArtNem_BreakPanels:		BINCLUDE	"art/nemesis/Breakaway panels from WFZ.nem"
	even

;---------------------------------------------------------------------------------------
; OOZ Assets
;---------------------------------------------------------------------------------------
ArtNem_SpikyThing:		BINCLUDE	"art/nemesis/Spiked ball from OOZ.nem"
	even
ArtNem_BurnerLid:		BINCLUDE	"art/nemesis/Burner Platform from OOZ.nem"
	even
ArtNem_StripedBlocksVert:	BINCLUDE	"art/nemesis/Striped blocks from CPZ.nem"
	even
ArtNem_Oilfall:			BINCLUDE	"art/nemesis/Cascading oil hitting oil from OOZ.nem"
	even
ArtNem_Oilfall2:		BINCLUDE	"art/nemesis/Cascading oil from OOZ.nem"
	even
ArtNem_BallThing:		BINCLUDE	"art/nemesis/Ball on spring from OOZ (beta holdovers).nem"
	even
ArtNem_LaunchBall:		BINCLUDE	"art/nemesis/Transporter ball from OOZ.nem"
	even
ArtNem_OOZPlatform:		BINCLUDE	"art/nemesis/OOZ collapsing platform.nem"
	even
ArtNem_PushSpring:		BINCLUDE	"art/nemesis/Push spring from OOZ.nem"
	even
ArtNem_OOZSwingPlat:		BINCLUDE	"art/nemesis/Swinging platform from OOZ.nem"
	even
ArtNem_StripedBlocksHoriz:	BINCLUDE	"art/nemesis/4 stripy blocks from OOZ.nem"
	even
ArtNem_OOZElevator:		BINCLUDE	"art/nemesis/Rising platform from OOZ.nem"
	even
ArtNem_OOZFanHoriz:		BINCLUDE	"art/nemesis/Fan from OOZ.nem"
	even
ArtNem_OOZBurn:			BINCLUDE	"art/nemesis/Green flame from OOZ burners.nem"
	even

;---------------------------------------------------------------------------------------
; CNZ Assets
;---------------------------------------------------------------------------------------
ArtNem_CNZSnake:		BINCLUDE	"art/nemesis/Caterpiller platforms from CNZ.nem" ; Patterns for appearing and disappearing string of platforms
	even
ArtNem_CNZBonusSpike:		BINCLUDE	"art/nemesis/Spikey ball from CNZ slots.nem"
	even
ArtNem_BigMovingBlock:		BINCLUDE	"art/nemesis/Moving block from CNZ and CPZ.nem"
	even
ArtNem_CNZElevator:		BINCLUDE	"art/nemesis/CNZ elevator.nem"
	even
ArtNem_CNZCage:			BINCLUDE	"art/nemesis/CNZ slot machine bars.nem"
	even
ArtNem_CNZHexBumper:		BINCLUDE	"art/nemesis/Hexagonal bumper from CNZ.nem"
	even
ArtNem_CNZRoundBumper:		BINCLUDE	"art/nemesis/Round bumper from CNZ.nem"
	even
ArtNem_CNZDiagPlunger:		BINCLUDE	"art/nemesis/Diagonal impulse spring from CNZ.nem"
	even
ArtNem_CNZVertPlunger:		BINCLUDE	"art/nemesis/Vertical impulse spring.nem"
	even
ArtNem_CNZMiniBumper:		BINCLUDE	"art/nemesis/Drop target from CNZ.nem" ; Weird blocks that you hit 3 times to get rid of
	even
ArtNem_CNZFlipper:		BINCLUDE	"art/nemesis/Flippers.nem"
	even

;---------------------------------------------------------------------------------------
; CPZ Assets
;---------------------------------------------------------------------------------------
ArtNem_CPZElevator:		BINCLUDE	"art/nemesis/Large moving platform from CPZ.nem"
	even
ArtNem_WaterSurface:		BINCLUDE	"art/nemesis/Top of water in HPZ and CNZ.nem"
	even
ArtNem_CPZBooster:		BINCLUDE	"art/nemesis/Speed booster from CPZ.nem"
	even
ArtNem_CPZDroplet:		BINCLUDE	"art/nemesis/CPZ worm enemy.nem"
	even
ArtNem_CPZMetalThings:		BINCLUDE	"art/nemesis/CPZ metal things.nem" ; Girder, cylinders
	even
ArtNem_CPZMetalBlock:		BINCLUDE	"art/nemesis/CPZ large moving platform blocks.nem"
	even
ArtNem_ConstructionStripes:	BINCLUDE	"art/nemesis/Stripy blocks from CPZ.nem"
	even
ArtNem_CPZAnimatedBits:		BINCLUDE	"art/nemesis/Small yellow moving platform from CPZ.nem"
	even
ArtNem_CPZStairBlock:		BINCLUDE	"art/nemesis/Moving block from CPZ.nem"
	even
ArtNem_CPZTubeSpring:		BINCLUDE	"art/nemesis/CPZ spintube exit cover.nem"
	even

;---------------------------------------------------------------------------------------
; ARZ Assets
;---------------------------------------------------------------------------------------
ArtNem_WaterSurface2:		BINCLUDE	"art/nemesis/Top of water in ARZ.nem"
	even
ArtNem_Leaves:			BINCLUDE	"art/nemesis/Leaves in ARZ.nem"
	even
ArtNem_ArrowAndShooter:		BINCLUDE	"art/nemesis/Arrow shooter and arrow from ARZ.nem"
	even
ArtNem_ARZBarrierThing:		BINCLUDE	"art/nemesis/One way barrier from ARZ.nem" ; Unused
	even

;---------------------------------------------------------------------------------------
; EHZ/OOZ Badnik Assets
;---------------------------------------------------------------------------------------
; These Badniks being grouped together here is unusual, but can be explained by two things:
; 1. This is where all Badnik tiles were kept in the earliest prototypes.
; 2. These are the only Badniks left from those prototypes.
ArtNem_Buzzer:			BINCLUDE	"art/nemesis/Buzzer enemy.nem"
	even
ArtNem_Octus:			BINCLUDE	"art/nemesis/Octopus badnik from OOZ.nem"
	even
ArtNem_Aquis:			BINCLUDE	"art/nemesis/Seahorse from OOZ.nem"
	even
ArtNem_Masher:			BINCLUDE	"art/nemesis/EHZ Pirahna badnik.nem"
	even

;---------------------------------------------------------------------------------------
; Boss Assets
;---------------------------------------------------------------------------------------
ArtNem_Eggpod:			BINCLUDE	"art/nemesis/Eggpod.nem" ; Robotnik's main ship
	even
ArtNem_CPZBoss:			BINCLUDE	"art/nemesis/CPZ boss.nem"
	even
ArtNem_FieryExplosion:		BINCLUDE	"art/nemesis/Large explosion.nem"
	even
ArtNem_EggpodJets:		BINCLUDE	"art/nemesis/Horizontal jet.nem"
	even
ArtNem_BossSmoke:		BINCLUDE	"art/nemesis/Smoke trail from CPZ and HTZ bosses.nem"
	even
ArtNem_EHZBoss:			BINCLUDE	"art/nemesis/EHZ boss.nem"
	even
ArtNem_EggChoppers:		BINCLUDE	"art/nemesis/Chopper blades for EHZ boss.nem"
	even
ArtNem_HTZBoss:			BINCLUDE	"art/nemesis/HTZ boss.nem"
	even
ArtNem_ARZBoss:			BINCLUDE	"art/nemesis/ARZ boss.nem"
	even
ArtNem_MCZBoss:			BINCLUDE	"art/nemesis/MCZ boss.nem"
	even
ArtNem_CNZBoss:			BINCLUDE	"art/nemesis/CNZ boss.nem"
	even
ArtNem_OOZBoss:			BINCLUDE	"art/nemesis/OOZ boss.nem"
	even
ArtNem_MTZBoss:			BINCLUDE	"art/nemesis/MTZ boss.nem"
	even
ArtUnc_FallingRocks:		BINCLUDE	"art/uncompressed/Falling rocks and stalactites from MCZ.bin"
	even

;---------------------------------------------------------------------------------------
; ARZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Whisp:			BINCLUDE	"art/nemesis/Blowfly from ARZ.nem"
	even
ArtNem_Grounder:		BINCLUDE	"art/nemesis/Grounder from ARZ.nem"
	even
ArtNem_ChopChop:		BINCLUDE	"art/nemesis/Shark from ARZ.nem"
	even

;---------------------------------------------------------------------------------------
; HTZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Rexon:			BINCLUDE	"art/nemesis/Rexxon (lava snake) from HTZ.nem"
	even
ArtNem_Spiker:			BINCLUDE	"art/nemesis/Driller badnik from HTZ.nem"
	even

;---------------------------------------------------------------------------------------
; SCZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Nebula:			BINCLUDE	"art/nemesis/Bomber badnik from SCZ.nem"
	even
ArtNem_Turtloid:		BINCLUDE	"art/nemesis/Turtle badnik from SCZ.nem"
	even

;---------------------------------------------------------------------------------------
; EHZ Badnik Assets (again)
;---------------------------------------------------------------------------------------
ArtNem_Coconuts:		BINCLUDE	"art/nemesis/Coconuts badnik from EHZ.nem"
	even

;---------------------------------------------------------------------------------------
; MCZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Crawlton:		BINCLUDE	"art/nemesis/Snake badnik from MCZ.nem"
	even
ArtNem_Flasher:			BINCLUDE	"art/nemesis/Firefly from MCZ.nem"
	even

;---------------------------------------------------------------------------------------
; MTZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_MtzMantis:		BINCLUDE	"art/nemesis/Praying mantis badnik from MTZ.nem"
	even
ArtNem_Shellcracker:		BINCLUDE	"art/nemesis/Shellcracker badnik from MTZ.nem"
	even
ArtNem_MtzSupernova:		BINCLUDE	"art/nemesis/Exploding star badnik from MTZ.nem"
	even

;---------------------------------------------------------------------------------------
; CPZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Spiny:			BINCLUDE	"art/nemesis/Weird crawling badnik from CPZ.nem"
	even
ArtNem_Grabber:			BINCLUDE	"art/nemesis/Spider badnik from CPZ.nem"
	even

;---------------------------------------------------------------------------------------
; WFZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_WfzScratch:		BINCLUDE	"art/nemesis/Scratch from WFZ.nem" ; Chicken badnik
	even
ArtNem_Balkrie:			BINCLUDE	"art/nemesis/Balkrie (jet badnik) from SCZ.nem" ; This SCZ badnik is here for some reason.
	even

;---------------------------------------------------------------------------------------
; WFZ/DEZ Assets
; It seems that these were haphazardly thrown together instead of neatly-split like the
; other zones' assets.
;---------------------------------------------------------------------------------------
ArtNem_SilverSonic:		BINCLUDE	"art/nemesis/Silver Sonic.nem"
	even
ArtNem_Tornado:			BINCLUDE	"art/nemesis/The Tornado.nem" ; Sonic's plane.
	even
ArtNem_WfzWallTurret:		BINCLUDE	"art/nemesis/Wall turret from WFZ.nem"
	even
ArtNem_WfzHook:			BINCLUDE	"art/nemesis/Hook on chain from WFZ.nem"
	even
ArtNem_WfzGunPlatform:		BINCLUDE	"art/nemesis/Retracting platform from WFZ.nem"
	even
ArtNem_WfzConveyorBeltWheel:	BINCLUDE	"art/nemesis/Wheel for belt in WFZ.nem"
	even
ArtNem_WfzFloatingPlatform:	BINCLUDE	"art/nemesis/Moving platform from WFZ.nem"
	even
ArtNem_WfzVrtclLazer:		BINCLUDE	"art/nemesis/Unused vertical laser in WFZ.nem"
	even
ArtNem_Clouds:			BINCLUDE	"art/nemesis/Clouds.nem"
	even
ArtNem_WfzHrzntlLazer:		BINCLUDE	"art/nemesis/Red horizontal laser from WFZ.nem"
	even
ArtNem_WfzLaunchCatapult:	BINCLUDE	"art/nemesis/Catapult that shoots Sonic to the side from WFZ.nem"
	even
ArtNem_WfzBeltPlatform:		BINCLUDE	"art/nemesis/Platform on belt in WFZ.nem"
	even
ArtNem_WfzUnusedBadnik:		BINCLUDE	"art/nemesis/Unused badnik from WFZ.nem" ; This is not grouped with the zone's badniks, suggesting that it's not a badnik at all.
	even
ArtNem_WfzVrtclPrpllr:		BINCLUDE	"art/nemesis/Vertical spinning blades in WFZ.nem"
	even
ArtNem_WfzHrzntlPrpllr:		BINCLUDE	"art/nemesis/Horizontal spinning blades in WFZ.nem"
	even
ArtNem_WfzTiltPlatforms:	BINCLUDE	"art/nemesis/Tilting plaforms in WFZ.nem"
	even
ArtNem_WfzThrust:		BINCLUDE	"art/nemesis/Thrust from Robotnik's getaway ship in WFZ.nem"
	even
ArtNem_WFZBoss:			BINCLUDE	"art/nemesis/WFZ boss.nem"
	even
ArtNem_RobotnikUpper:		BINCLUDE	"art/nemesis/Robotnik's head.nem"
	even
ArtNem_RobotnikRunning:		BINCLUDE	"art/nemesis/Robotnik.nem"
	even
ArtNem_RobotnikLower:		BINCLUDE	"art/nemesis/Robotnik's lower half.nem"
	even
ArtNem_DEZWindow:		BINCLUDE	"art/nemesis/Window in back that Robotnik looks through in DEZ.nem"
	even
ArtNem_DEZBoss:			BINCLUDE	"art/nemesis/Eggrobo.nem"
	even
; This last-minute badnik addition was mistakenly included with the WFZ/DEZ assets instead of in its own 'CNZ Badnik Assets' section.
ArtNem_Crawl:			BINCLUDE	"art/nemesis/Bouncer badnik from CNZ.nem"
	even
ArtNem_TornadoThruster:		BINCLUDE	"art/nemesis/Rocket thruster for Tornado.nem"
	even

;---------------------------------------------------------------------------------------
; Ending Assets
;---------------------------------------------------------------------------------------
MapEng_Ending1:			BINCLUDE	"mappings/misc/End of game sequence frame 1.eni"
	even
MapEng_Ending2:			BINCLUDE	"mappings/misc/End of game sequence frame 2.eni"
	even
MapEng_Ending3:			BINCLUDE	"mappings/misc/End of game sequence frame 3.eni"
	even
MapEng_Ending4:			BINCLUDE	"mappings/misc/End of game sequence frame 4.eni"
	even
MapEng_EndingTailsPlane:	BINCLUDE	"mappings/misc/Closeup of Tails flying plane in ending sequence.eni"
	even
MapEng_EndingSonicPlane:	BINCLUDE	"mappings/misc/Closeup of Sonic flying plane in ending sequence.eni"
	even

; Strange unused mappings (duplicates of MapEng_EndGameLogo)
    rept 9
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
    endm

ArtNem_EndingPics:		BINCLUDE	"art/nemesis/Movie sequence at end of game.nem"
	even
ArtNem_EndingFinalTornado:	BINCLUDE	"art/nemesis/Final image of Tornado with it and Sonic facing screen.nem"
	even
ArtNem_EndingMiniTornado:	BINCLUDE	"art/nemesis/Small pictures of Tornado in final ending sequence.nem"
	even
ArtNem_EndingSonic:		BINCLUDE	"art/nemesis/Small pictures of Sonic and final image of Sonic.nem"
	even
ArtNem_EndingSuperSonic:	BINCLUDE	"art/nemesis/Small pictures of Sonic and final image of Sonic in Super Sonic mode.nem"
	even
ArtNem_EndingTails:		BINCLUDE	"art/nemesis/Final image of Tails.nem"
	even
ArtNem_EndingTitle:		BINCLUDE	"art/nemesis/Sonic the Hedgehog 2 image at end of credits.nem"
	even


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; LEVEL ART AND BLOCK MAPPINGS (16x16 and 128x128)
;
; #define BLOCK_TBL_LEN  // table length unknown
; #define BIGBLOCK_TBL_LEN // table length unknown
; typedef uint16_t uword
;
; struct blockMapElement {
;  uword unk : 5;    // u
;  uword patternIndex : 11; };  // i
; // uuuu uiii iiii iiii
;
; blockMapElement (*blockMapTable)[BLOCK_TBL_LEN][4] = 0xFFFF9000
;
; struct bigBlockMapElement {
;  uword : 4
;  uword blockMapIndex : 12; };  //I
; // 0000 IIII IIII IIII
;
; bigBlockMapElement (*bigBlockMapTable)[BIGBLOCK_TBL_LEN][64] = 0xFFFF0000
;
; /*
; This data determines how the level blocks will be constructed graphically. There are
; two kinds of block mappings: 16x16 and 128x128.
;
; 16x16 blocks are made up of four cells arranged in a square (thus, 16x16 pixels).
; Two bytes are used to define each cell, so the block is 8 bytes long. It can be
; represented by the bitmap blockMapElement, of which the members are:
;
; unk
;  These bits have to do with pattern orientation. I do not know their exact
;  meaning.
; patternIndex
;  The pattern's address divided by $20. Otherwise said: an index into the
;  pattern array.
;
; Each mapping can be expressed as an array of four blockMapElements, while the
; whole table is expressed as a two-dimensional array of blockMapElements (blockMapTable).
; The maps are read in left-to-right, top-to-bottom order.
;
; 128x128 maps are basically lists of indices into blockMapTable. The levels are built
; out of these "big blocks", rather than the "small" 16x16 blocks. bigBlockMapTable is,
; predictably, the table of big block mappings.
; Each big block is 8 16x16 blocks, or 16 cells, square. This produces a total of 16
; blocks or 64 cells.
; As noted earlier, each element of the table provides 'i' for blockMapTable[i][j].
; */

; All of these are compressed in the Kosinski format.

BM16_EHZ:	BINCLUDE	"Levels/EHZ/Blocks.kos"
ArtKos_EHZ:	BINCLUDE	"art/kosinski/EHZ_HTZ.kos"
BM16_HTZ:	BINCLUDE	"Levels/HTZ/Blocks.kos"
ArtKos_HTZ:	BINCLUDE	"art/kosinski/HTZ_Supp.kos" ; HTZ pattern suppliment to EHZ level patterns
BM128_EHZ:	BINCLUDE	"Levels/EHZ/Chunks.kos"

BM16_MTZ:	BINCLUDE	"Levels/MTZ/Blocks.kos"
ArtKos_MTZ:	BINCLUDE	"art/kosinski/MTZ.kos"
BM128_MTZ:	BINCLUDE	"Levels/MTZ/Chunks.kos"

BM16_HPZ:	;BINCLUDE	"Levels/HPZ/Blocks.kos"
ArtKos_HPZ:	;BINCLUDE	"art/kosinski/HPZ.kos"
BM128_HPZ:	;BINCLUDE	"Levels/HPZ/Chunks.kos"

BM16_OOZ:	BINCLUDE	"Levels/OOZ/Blocks.kos"
ArtKos_OOZ:	BINCLUDE	"art/kosinski/OOZ.kos"
BM128_OOZ:	BINCLUDE	"Levels/OOZ/Chunks.kos"

BM16_MCZ:	BINCLUDE	"Levels/MCZ/Blocks.kos"
ArtKos_MCZ:	BINCLUDE	"art/kosinski/MCZ.kos"
BM128_MCZ:	BINCLUDE	"Levels/MCZ/Chunks.kos"

BM16_CNZ:	BINCLUDE	"Levels/CNZ/Blocks.kos"
ArtKos_CNZ:	BINCLUDE	"art/kosinski/CNZ.kos"
BM128_CNZ:	BINCLUDE	"Levels/CNZ/Chunks.kos"

BM16_CPZ:	BINCLUDE	"Levels/CPZ/Blocks.kos"
ArtKos_CPZ:	BINCLUDE	"art/kosinski/CPZ_DEZ.kos"
BM128_CPZ:	BINCLUDE	"Levels/CPZ/Chunks.kos"

; This file contains $320 blocks, overflowing the 'Block_table' buffer. This causes
; 'TempArray_LayerDef' to be overwritten with (empty) block data.
; If only 'fixBugs' could fix this...
BM16_ARZ:	BINCLUDE	"Levels/ARZ/Blocks.kos"
ArtKos_ARZ:	BINCLUDE	"art/kosinski/ARZ.kos"
BM128_ARZ:	BINCLUDE	"Levels/ARZ/Chunks.kos"

BM16_WFZ:	BINCLUDE	"Levels/WFZ/Blocks.kos"
ArtKos_SCZ:	BINCLUDE	"art/kosinski/WFZ_SCZ.kos"
ArtKos_WFZ:	BINCLUDE	"art/kosinski/WFZ_Supp.kos" ; WFZ pattern suppliment to SCZ tiles
BM128_WFZ:	BINCLUDE	"Levels/WFZ/Chunks.kos"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;-----------------------------------------------------------------------------------
; Special Stage Assets
;-----------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------
; Exit curve + slope up
;-----------------------------------------------------------------------------------
MapSpec_Rise1:		BINCLUDE	"mappings/special stage/Slope up - Frame 1.bin"
MapSpec_Rise2:		BINCLUDE	"mappings/special stage/Slope up - Frame 2.bin"
MapSpec_Rise3:		BINCLUDE	"mappings/special stage/Slope up - Frame 3.bin"
MapSpec_Rise4:		BINCLUDE	"mappings/special stage/Slope up - Frame 4.bin"
MapSpec_Rise5:		BINCLUDE	"mappings/special stage/Slope up - Frame 5.bin"
MapSpec_Rise6:		BINCLUDE	"mappings/special stage/Slope up - Frame 6.bin"
MapSpec_Rise7:		BINCLUDE	"mappings/special stage/Slope up - Frame 7.bin"
MapSpec_Rise8:		BINCLUDE	"mappings/special stage/Slope up - Frame 8.bin"
MapSpec_Rise9:		BINCLUDE	"mappings/special stage/Slope up - Frame 9.bin"
MapSpec_Rise10:		BINCLUDE	"mappings/special stage/Slope up - Frame 10.bin"
MapSpec_Rise11:		BINCLUDE	"mappings/special stage/Slope up - Frame 11.bin"
MapSpec_Rise12:		BINCLUDE	"mappings/special stage/Slope up - Frame 12.bin"
MapSpec_Rise13:		BINCLUDE	"mappings/special stage/Slope up - Frame 13.bin"
MapSpec_Rise14:		BINCLUDE	"mappings/special stage/Slope up - Frame 14.bin"
MapSpec_Rise15:		BINCLUDE	"mappings/special stage/Slope up - Frame 15.bin"
MapSpec_Rise16:		BINCLUDE	"mappings/special stage/Slope up - Frame 16.bin"
MapSpec_Rise17:		BINCLUDE	"mappings/special stage/Slope up - Frame 17.bin"

;-----------------------------------------------------------------------------------
; Straight path
;-----------------------------------------------------------------------------------
MapSpec_Straight1:	BINCLUDE	"mappings/special stage/Straight path - Frame 1.bin"
MapSpec_Straight2:	BINCLUDE	"mappings/special stage/Straight path - Frame 2.bin"
MapSpec_Straight3:	BINCLUDE	"mappings/special stage/Straight path - Frame 3.bin"
MapSpec_Straight4:	BINCLUDE	"mappings/special stage/Straight path - Frame 4.bin"

;-----------------------------------------------------------------------------------
; Exit curve + slope down
;-----------------------------------------------------------------------------------
MapSpec_Drop1:		BINCLUDE	"mappings/special stage/Slope down - Frame 1.bin"
MapSpec_Drop2:		BINCLUDE	"mappings/special stage/Slope down - Frame 2.bin"
MapSpec_Drop3:		BINCLUDE	"mappings/special stage/Slope down - Frame 3.bin"
MapSpec_Drop4:		BINCLUDE	"mappings/special stage/Slope down - Frame 4.bin"
MapSpec_Drop5:		BINCLUDE	"mappings/special stage/Slope down - Frame 5.bin"
MapSpec_Drop6:		BINCLUDE	"mappings/special stage/Slope down - Frame 6.bin"
MapSpec_Drop7:		BINCLUDE	"mappings/special stage/Slope down - Frame 7.bin"
MapSpec_Drop8:		BINCLUDE	"mappings/special stage/Slope down - Frame 8.bin"
MapSpec_Drop9:		BINCLUDE	"mappings/special stage/Slope down - Frame 9.bin"
MapSpec_Drop10:		BINCLUDE	"mappings/special stage/Slope down - Frame 10.bin"
MapSpec_Drop11:		BINCLUDE	"mappings/special stage/Slope down - Frame 11.bin"
MapSpec_Drop12:		BINCLUDE	"mappings/special stage/Slope down - Frame 12.bin"
MapSpec_Drop13:		BINCLUDE	"mappings/special stage/Slope down - Frame 13.bin"
MapSpec_Drop14:		BINCLUDE	"mappings/special stage/Slope down - Frame 14.bin"
MapSpec_Drop15:		BINCLUDE	"mappings/special stage/Slope down - Frame 15.bin"
MapSpec_Drop16:		BINCLUDE	"mappings/special stage/Slope down - Frame 16.bin"
MapSpec_Drop17:		BINCLUDE	"mappings/special stage/Slope down - Frame 17.bin"

;-----------------------------------------------------------------------------------
; Curved path
;-----------------------------------------------------------------------------------
MapSpec_Turning1:	BINCLUDE	"mappings/special stage/Curve right - Frame 1.bin"
MapSpec_Turning2:	BINCLUDE	"mappings/special stage/Curve right - Frame 2.bin"
MapSpec_Turning3:	BINCLUDE	"mappings/special stage/Curve right - Frame 3.bin"
MapSpec_Turning4:	BINCLUDE	"mappings/special stage/Curve right - Frame 4.bin"
MapSpec_Turning5:	BINCLUDE	"mappings/special stage/Curve right - Frame 5.bin"
MapSpec_Turning6:	BINCLUDE	"mappings/special stage/Curve right - Frame 6.bin"

;-----------------------------------------------------------------------------------
; Exit curve
;-----------------------------------------------------------------------------------
MapSpec_Unturn1:	BINCLUDE	"mappings/special stage/Curve right - Frame 7.bin"
MapSpec_Unturn2:	BINCLUDE	"mappings/special stage/Curve right - Frame 8.bin"
MapSpec_Unturn3:	BINCLUDE	"mappings/special stage/Curve right - Frame 9.bin"
MapSpec_Unturn4:	BINCLUDE	"mappings/special stage/Curve right - Frame 10.bin"
MapSpec_Unturn5:	BINCLUDE	"mappings/special stage/Curve right - Frame 11.bin"

;-----------------------------------------------------------------------------------
; Enter curve
;-----------------------------------------------------------------------------------
MapSpec_Turn1:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 1.bin"
MapSpec_Turn2:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 2.bin"
MapSpec_Turn3:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 3.bin"
MapSpec_Turn4:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 4.bin"
MapSpec_Turn5:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 5.bin"
MapSpec_Turn6:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 6.bin"
MapSpec_Turn7:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 7.bin"

;--------------------------------------------------------------------------------------
; Special stage level patterns
; Note: Only one line of each tile is stored in this archive. The other 7 lines are
;  the same as this one line, so to get the full tiles, each line needs to be
;  duplicated 7 times over.					; ArtKoz_DCA38:
;--------------------------------------------------------------------------------------
ArtKos_Special:			BINCLUDE	"art/kosinski/SpecStag.kos"
	even

ArtNem_SpecialBack:		BINCLUDE	"art/nemesis/Background art for special stage.nem"
	even
MapEng_SpecialBack:		BINCLUDE	"mappings/misc/Main background mappings for special stage.eni"
	even
MapEng_SpecialBackBottom:	BINCLUDE	"mappings/misc/Lower background mappings for special stage.eni"
	even
ArtNem_SpecialHUD:		BINCLUDE	"art/nemesis/Sonic and Miles number text from special stage.nem"
	even
ArtNem_SpecialStart:		BINCLUDE	"art/nemesis/Start text from special stage.nem" ; Also includes checkered flag
	even
ArtNem_SpecialStars:		BINCLUDE	"art/nemesis/Stars in special stage.nem"
	even
ArtNem_SpecialPlayerVSPlayer:	BINCLUDE	"art/nemesis/Special stage Player VS Player text.nem"
	even
ArtNem_SpecialRings:		BINCLUDE	"art/nemesis/Special stage ring art.nem"
	even
ArtNem_SpecialFlatShadow:	BINCLUDE	"art/nemesis/Horizontal shadow from special stage.nem"
	even
ArtNem_SpecialDiagShadow:	BINCLUDE	"art/nemesis/Diagonal shadow from special stage.nem"
	even
ArtNem_SpecialSideShadow:	BINCLUDE	"art/nemesis/Vertical shadow from special stage.nem"
	even
ArtNem_SpecialExplosion:	BINCLUDE	"art/nemesis/Explosion from special stage.nem"
	even
ArtNem_SpecialBomb:		BINCLUDE	"art/nemesis/Bomb from special stage.nem"
	even
ArtNem_SpecialEmerald:		BINCLUDE	"art/nemesis/Emerald from special stage.nem"
	even
ArtNem_SpecialMessages:		BINCLUDE	"art/nemesis/Special stage messages and icons.nem"
	even
ArtNem_SpecialSonicAndTails:	BINCLUDE	"art/nemesis/Sonic and Tails animation frames in special stage.nem" ; [fixBugs] In this file, Tails' arms are tan instead of orange.
	even
ArtNem_SpecialTailsText:	BINCLUDE	"art/nemesis/Tails text patterns from special stage.nem"
	even
MiscKoz_SpecialPerspective:	BINCLUDE	"misc/Special stage object perspective data.kos"
	even
MiscNem_SpecialLevelLayout:	BINCLUDE	"misc/Special stage level layouts.nem"
	even
MiscKoz_SpecialObjectLocations:	BINCLUDE	"misc/Special stage object location lists.kos"
	even

;--------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
;--------------------------------------------------------------------------------------
	align $100

	include "Routines/Object Locations.asm"

; --------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
; --------------------------------------------------------------------------------------
	align $1000

	include "Routines/Load Sound Driver.asm"
	include "Routines/Decompress/Saxman.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; S2 sound driver (Sound driver compression (slightly modified Saxman))
; ---------------------------------------------------------------------------
; loc_EC0E8:
Snd_Driver:
	save
	include "Sound/Z80 Driver.asm" ; CPU Z80
	restore
	padding off
	!org (Snd_Driver+Size_of_Snd_driver_guess) ; don't worry; I know what I'm doing


; loc_ED04C:
Snd_Driver_End:

; ---------------------------------------------------------------------------
; Filler (free space)
; ---------------------------------------------------------------------------
	; the DAC data has to line up with the end of the bank.

	; actually it only has to fit within one bank, but we'll line it up to the end anyway
	; because the padding gives the sound driver some room to grow
	cnop -Size_of_DAC_samples, $8000

; ---------------------------------------------------------------------------
; DAC samples
; ---------------------------------------------------------------------------

; loc_ED100:
SndDAC_Start:

SndDAC_Kick:	include	"Sound/DAC/DPCM/Generated/Kick.inc"
SndDAC_Snare:	include	"Sound/DAC/DPCM/Generated/Snare.inc"
SndDAC_Timpani:	include	"Sound/DAC/DPCM/Generated/Timpani.inc"
SndDAC_Tom:	include	"Sound/DAC/DPCM/Generated/Tom.inc"
SndDAC_Clap:	include	"Sound/DAC/DPCM/Generated/Clap.inc"
SndDAC_Scratch:	include	"Sound/DAC/DPCM/Generated/Scratch.inc"
SndDAC_Bongo:	include	"Sound/DAC/DPCM/Generated/Bongo.inc"

SndDAC_End

	if SndDAC_End - SndDAC_Start > $8000
		fatal "DAC samples must fit within $8000 bytes, but you have $\{SndDAC_End-SndDAC_Start } bytes of DAC samples."
	endif
	if SndDAC_End - SndDAC_Start > Size_of_DAC_samples
		fatal "Size_of_DAC_samples = $\{Size_of_DAC_samples}, but you have $\{SndDAC_End-SndDAC_Start} bytes of DAC samples."
	endif

; ---------------------------------------------------------------------------
; Music pointers
; ---------------------------------------------------------------------------

music_ptr macro DATA
DATA.pointer label *
	rom_ptr_z80	DATA
    endm

; loc_F0000:
MusicPoint1:	startBank
		music_ptr	Mus_Continue

Mus_Continue:	include	"Sound/Music/Generated/9C - Continue.inc"

	finishBank

	align $20

; --------------------------------------------------------------------------------------
; EHZ/HTZ Assets
; --------------------------------------------------------------------------------------
ArtNem_HtzFireball1:		BINCLUDE	"art/nemesis/Fireball 1.nem"
	even
ArtNem_Waterfall:		BINCLUDE	"art/nemesis/Waterfall tiles.nem"
	even
ArtNem_HtzFireball2:		BINCLUDE	"art/nemesis/Fireball 2.nem"
	even
ArtNem_EHZ_Bridge:		BINCLUDE	"art/nemesis/EHZ bridge.nem"
	even
ArtNem_HtzZipline:		BINCLUDE	"art/nemesis/HTZ zip-line platform.nem"
	even
ArtNem_HtzValveBarrier:		BINCLUDE	"art/nemesis/One way barrier from HTZ.nem"
	even
ArtNem_HtzSeeSaw:		BINCLUDE	"art/nemesis/See-saw in HTZ.nem"
	even
				BINCLUDE	"art/nemesis/Fireball 3.nem" ; Unused
	even
ArtNem_HtzRock:			BINCLUDE	"art/nemesis/Rock from HTZ.nem"
	even
ArtNem_Sol:			BINCLUDE	"art/nemesis/Sol badnik from HTZ.nem" ; Not grouped with the other badniks for some reason...
	even

; --------------------------------------------------------------------------------------
; MTZ Assets
; --------------------------------------------------------------------------------------
ArtNem_MtzWheel:		BINCLUDE	"art/nemesis/Large spinning wheel from MTZ.nem"
	even
ArtNem_MtzWheelIndent:		BINCLUDE	"art/nemesis/Large spinning wheel from MTZ - indent.nem"
	even
ArtNem_MtzSpikeBlock:		BINCLUDE	"art/nemesis/MTZ spike block.nem"
	even
ArtNem_MtzSteam:		BINCLUDE	"art/nemesis/Steam from MTZ.nem"
	even
ArtNem_MtzSpike:		BINCLUDE	"art/nemesis/Spike from MTZ.nem"
	even
ArtNem_MtzAsstBlocks:		BINCLUDE	"art/nemesis/Similarly shaded blocks from MTZ.nem"
	even
ArtNem_MtzLavaBubble:		BINCLUDE	"art/nemesis/Lava bubble from MTZ.nem"
	even
ArtNem_LavaCup:			BINCLUDE	"art/nemesis/Lava cup from MTZ.nem"
	even
ArtNem_BoltEnd_Rope:		BINCLUDE	"art/nemesis/Bolt end and rope from MTZ.nem"
	even
ArtNem_MtzCog:			BINCLUDE	"art/nemesis/Small cog from MTZ.nem"
	even
ArtNem_MtzSpinTubeFlash:	BINCLUDE	"art/nemesis/Spin tube flash from MTZ.nem"
	even

; --------------------------------------------------------------------------------------
; MCZ Assets
; --------------------------------------------------------------------------------------
ArtNem_Crate:			BINCLUDE	"art/nemesis/Large wooden box from MCZ.nem"
	even
ArtNem_MCZCollapsePlat:		BINCLUDE	"art/nemesis/Collapsing platform from MCZ.nem"
	even
ArtNem_VineSwitch:		BINCLUDE	"art/nemesis/Pull switch from MCZ.nem"
	even
ArtNem_VinePulley:		BINCLUDE	"art/nemesis/Vine that lowers from MCZ.nem"
	even
ArtNem_MCZGateLog:		BINCLUDE	"art/nemesis/Drawbridge logs from MCZ.nem"
	even

; ----------------------------------------------------------------------------------
; Filler (free space)
; ----------------------------------------------------------------------------------
	; the PCM data has to line up with the end of the bank.
	cnop -Size_of_SEGA_sound, $8000

; -------------------------------------------------------------------------------
; Sega Intro Sound
; 8-bit unsigned raw audio at 16Khz
; -------------------------------------------------------------------------------
; loc_F1E8C:
Snd_Sega:	include	"Sound/DAC/PCM/Generated/SEGA.inc"

	if Snd_Sega.size > $8000
		fatal "Sega sound must fit within $8000 bytes, but you have a $\{Snd_Sega.size} byte Sega sound."
	endif
	if Snd_Sega.size > Size_of_SEGA_sound
		fatal "Size_of_SEGA_sound = $\{Size_of_SEGA_sound}, but you have a $\{Snd_Sega.size} byte Sega sound."
	endif

; ------------------------------------------------------------------------------
; Music pointers
; ------------------------------------------------------------------------------
; loc_F8000:
MusicPoint2:	startBank
		music_ptr	Mus_CNZ_2P
		music_ptr	Mus_EHZ
		music_ptr	Mus_MTZ
		music_ptr	Mus_CNZ
		music_ptr	Mus_MCZ
		music_ptr	Mus_MCZ_2P
		music_ptr	Mus_ARZ
		music_ptr	Mus_DEZ
		music_ptr	Mus_SpecStage
		music_ptr	Mus_Options
		music_ptr	Mus_Ending
		music_ptr	Mus_EndBoss
		music_ptr	Mus_CPZ
		music_ptr	Mus_Boss
		music_ptr	Mus_SCZ
		music_ptr	Mus_OOZ
		music_ptr	Mus_WFZ
		music_ptr	Mus_EHZ_2P
		music_ptr	Mus_2PResult
		music_ptr	Mus_SuperSonic
		music_ptr	Mus_HTZ
		music_ptr	Mus_ExtraLife
		music_ptr	Mus_Title
		music_ptr	Mus_EndLevel
		music_ptr	Mus_GameOver
		music_ptr	Mus_Invincible
		music_ptr	Mus_Emerald
		music_ptr	Mus_HPZ
		music_ptr	Mus_Drowning
		music_ptr	Mus_Credits

; loc_F803C:
Mus_HPZ:	include	"Sound/Music/Generated/90 - HPZ.inc"
Mus_Drowning:	include	"Sound/Music/Generated/9F - Drowning.inc"
Mus_Invincible:	include	"Sound/Music/Generated/97 - Invincible.inc"
Mus_CNZ_2P:	include	"Sound/Music/Generated/88 - CNZ 2P.inc"
Mus_EHZ:	include	"Sound/Music/Generated/82 - EHZ.inc"
Mus_MTZ:	include	"Sound/Music/Generated/85 - MTZ.inc"
Mus_CNZ:	include	"Sound/Music/Generated/89 - CNZ.inc"
Mus_MCZ:	include	"Sound/Music/Generated/8B - MCZ.inc"
Mus_MCZ_2P:	include	"Sound/Music/Generated/83 - MCZ 2P.inc"
Mus_ARZ:	include	"Sound/Music/Generated/87 - ARZ.inc"
Mus_DEZ:	include	"Sound/Music/Generated/8A - DEZ.inc"
Mus_SpecStage:	include	"Sound/Music/Generated/92 - Special Stage.inc"
Mus_Options:	include	"Sound/Music/Generated/91 - Options.inc"
Mus_Ending:	include	"Sound/Music/Generated/95 - Ending.inc"
Mus_EndBoss:	include	"Sound/Music/Generated/94 - Final Boss.inc"
Mus_CPZ:	include	"Sound/Music/Generated/8E - CPZ.inc"
Mus_Boss:	include	"Sound/Music/Generated/93 - Boss.inc"
Mus_SCZ:	include	"Sound/Music/Generated/8D - SCZ.inc"
Mus_OOZ:	include	"Sound/Music/Generated/84 - OOZ.inc"
Mus_WFZ:	include	"Sound/Music/Generated/8F - WFZ.inc"
Mus_EHZ_2P:	include	"Sound/Music/Generated/8C - EHZ 2P.inc"
Mus_2PResult:	include	"Sound/Music/Generated/81 - 2 Player Menu.inc"
Mus_SuperSonic:	include	"Sound/Music/Generated/96 - Super Sonic.inc"
Mus_HTZ:	include	"Sound/Music/Generated/86 - HTZ.inc"
Mus_Title:	include	"Sound/Music/Generated/99 - Title Screen.inc"
Mus_EndLevel:	include	"Sound/Music/Generated/9A - End of Act.inc"
Mus_ExtraLife:	include	"Sound/Music/Generated/98 - Extra Life.inc"
Mus_GameOver:	include	"Sound/Music/Generated/9B - Game Over.inc"
Mus_Emerald:	include	"Sound/Music/Generated/9D - Got Emerald.inc"
Mus_Credits:	include	"Sound/Music/Generated/9E - Credits.inc"

; ------------------------------------------------------------------------------------------
; Sound effect pointers
; ------------------------------------------------------------------------------------------
; WARNING the sound driver treats certain sounds specially
; going by the ID of the sound.
; SndID_Ring, SndID_RingLeft, SndID_Gloop, SndID_SpindashRev
; are referenced by the sound driver directly.
; If needed you can change this in s2.sounddriver.asm


; NOTE: the exact order of this list determines the priority of each sound, since it determines the sound's SndID.
;       a sound can get dropped if a higher-priority sound is already playing.
;       see zSFXPriority for the priority allocation itself.
; loc_FEE91: SoundPoint:
SoundIndex:
SndPtr_Jump:		rom_ptr_z80	Sound20	; jumping sound
SndPtr_Checkpoint:	rom_ptr_z80	Sound21	; checkpoint ding-dong sound
SndPtr_SpikeSwitch:	rom_ptr_z80	Sound22	; spike switch sound
SndPtr_Hurt:		rom_ptr_z80	Sound23	; hurt sound
SndPtr_Skidding:	rom_ptr_z80	Sound24	; skidding sound
SndPtr_MissileDissolve:	rom_ptr_z80	Sound25	; missile dissolve sound from Sonic 1 (unused)
SndPtr_HurtBySpikes:	rom_ptr_z80	Sound26	; spiky impalement sound
SndPtr_Sparkle:		rom_ptr_z80	Sound27	; sparkling sound
SndPtr_Beep:		rom_ptr_z80	Sound28	; short beep
SndPtr_Bwoop:		rom_ptr_z80	Sound29	; bwoop (unused)
SndPtr_Splash:		rom_ptr_z80	Sound2A	; splash sound
SndPtr_Swish:		rom_ptr_z80	Sound2B	; swish
SndPtr_BossHit:		rom_ptr_z80	Sound2C	; boss hit
SndPtr_InhalingBubble:	rom_ptr_z80	Sound2D	; inhaling a bubble
SndPtr_ArrowFiring:
SndPtr_LavaBall:	rom_ptr_z80	Sound2E	; arrow firing
SndPtr_Shield:		rom_ptr_z80	Sound2F	; shield sound
SndPtr_LaserBeam:	rom_ptr_z80	Sound30	; laser beam
SndPtr_Zap:		rom_ptr_z80	Sound31	; zap (unused)
SndPtr_Drown:		rom_ptr_z80	Sound32	; drownage
SndPtr_FireBurn:	rom_ptr_z80	Sound33	; fire + burn
SndPtr_Bumper:		rom_ptr_z80	Sound34	; bumper bing
SndPtr_Ring:
SndPtr_RingRight:	rom_ptr_z80	Sound35	; ring sound
SndPtr_SpikesMove:	rom_ptr_z80	Sound36
SndPtr_Rumbling:	rom_ptr_z80	Sound37	; rumbling
			rom_ptr_z80	Sound38	; (unused)
SndPtr_Smash:		rom_ptr_z80	Sound39	; smash/breaking
			rom_ptr_z80	Sound3A	; nondescript ding (unused)
SndPtr_DoorSlam:	rom_ptr_z80	Sound3B	; door slamming shut
SndPtr_SpindashRelease:	rom_ptr_z80	Sound3C	; spindash unleashed
SndPtr_Hammer:		rom_ptr_z80	Sound3D	; slide-thunk
SndPtr_Roll:		rom_ptr_z80	Sound3E	; rolling sound
SndPtr_ContinueJingle:	rom_ptr_z80	Sound3F	; got continue
SndPtr_CasinoBonus:	rom_ptr_z80	Sound40	; short bonus ding
SndPtr_Explosion:	rom_ptr_z80	Sound41	; badnik bust
SndPtr_WaterWarning:	rom_ptr_z80	Sound42	; warning ding-ding
SndPtr_EnterGiantRing:	rom_ptr_z80	Sound43	; special stage ring flash (mostly unused)
SndPtr_BossExplosion:	rom_ptr_z80	Sound44	; thunk
SndPtr_TallyEnd:	rom_ptr_z80	Sound45	; cha-ching
SndPtr_RingSpill:	rom_ptr_z80	Sound46	; losing rings
			rom_ptr_z80	Sound47	; chain pull chink-chink (unused)
SndPtr_Flamethrower:	rom_ptr_z80	Sound48	; flamethrower
SndPtr_Bonus:		rom_ptr_z80	Sound49	; bonus pwoieeew (mostly unused)
SndPtr_SpecStageEntry:	rom_ptr_z80	Sound4A	; special stage entry
SndPtr_SlowSmash:	rom_ptr_z80	Sound4B	; slower smash/crumble
SndPtr_Spring:		rom_ptr_z80	Sound4C	; spring boing
SndPtr_Blip:		rom_ptr_z80	Sound4D	; selection blip
SndPtr_RingLeft:	rom_ptr_z80	Sound4E	; another ring sound (only plays in the left speaker?)
SndPtr_Signpost:	rom_ptr_z80	Sound4F	; signpost spin sound
SndPtr_CNZBossZap:	rom_ptr_z80	Sound50	; mosquito zapper
			rom_ptr_z80	Sound51	; (unused)
			rom_ptr_z80	Sound52	; (unused)
SndPtr_Signpost2P:	rom_ptr_z80	Sound53
SndPtr_OOZLidPop:	rom_ptr_z80	Sound54	; OOZ lid pop sound
SndPtr_SlidingSpike:	rom_ptr_z80	Sound55
SndPtr_CNZElevator:	rom_ptr_z80	Sound56
SndPtr_PlatformKnock:	rom_ptr_z80	Sound57
SndPtr_BonusBumper:	rom_ptr_z80	Sound58	; CNZ bonusy bumper sound
SndPtr_LargeBumper:	rom_ptr_z80	Sound59	; CNZ baaang bumper sound
SndPtr_Gloop:		rom_ptr_z80	Sound5A	; CNZ gloop / water droplet sound
SndPtr_PreArrowFiring:	rom_ptr_z80	Sound5B
SndPtr_Fire:		rom_ptr_z80	Sound5C
SndPtr_ArrowStick:	rom_ptr_z80	Sound5D	; chain clink
SndPtr_Helicopter:
SndPtr_WingFortress:	rom_ptr_z80	Sound5E	; helicopter
SndPtr_SuperTransform:	rom_ptr_z80	Sound5F
SndPtr_SpindashRev:	rom_ptr_z80	Sound60	; spindash charge
SndPtr_Rumbling2:	rom_ptr_z80	Sound61	; rumbling
SndPtr_CNZLaunch:	rom_ptr_z80	Sound62
SndPtr_Flipper:		rom_ptr_z80	Sound63	; CNZ blooing bumper
SndPtr_HTZLiftClick:	rom_ptr_z80	Sound64	; HTZ track click sound
SndPtr_Leaves:		rom_ptr_z80	Sound65	; kicking up leaves sound
SndPtr_MegaMackDrop:	rom_ptr_z80	Sound66	; leaf splash?
SndPtr_DrawbridgeMove:	rom_ptr_z80	Sound67
SndPtr_QuickDoorSlam:	rom_ptr_z80	Sound68	; door slamming quickly (unused)
SndPtr_DrawbridgeDown:	rom_ptr_z80	Sound69
SndPtr_LaserBurst:	rom_ptr_z80	Sound6A	; robotic laser burst
SndPtr_Scatter:
SndPtr_LaserFloor:	rom_ptr_z80	Sound6B	; scatter
SndPtr_Teleport:	rom_ptr_z80	Sound6C
SndPtr_Error:		rom_ptr_z80	Sound6D	; error sound
SndPtr_MechaSonicBuzz:	rom_ptr_z80	Sound6E	; Silver Sonic buzz saw
SndPtr_LargeLaser:	rom_ptr_z80	Sound6F
SndPtr_OilSlide:	rom_ptr_z80	Sound70
SndPtr__End:

Sound20:	include "Sound/SFX/A0 - Jump.asm"
Sound21:	include "Sound/SFX/A1 - Checkpoint.asm"
Sound22:	include "Sound/SFX/A2 - Spike Switch.asm"
Sound23:	include "Sound/SFX/A3 - Hurt.asm"
Sound24:	include "Sound/SFX/A4 - Skidding.asm"
Sound25:	include "Sound/SFX/A5 - Block Push.asm"
Sound26:	include "Sound/SFX/A6 - Hurt by Spikes.asm"
Sound27:	include "Sound/SFX/A7 - Sparkle.asm"
Sound28:	include "Sound/SFX/A8 - Beep.asm"
Sound29:	include "Sound/SFX/A9 - Special Stage Item (Unused).asm"
Sound2A:	include "Sound/SFX/AA - Splash.asm"
Sound2B:	include "Sound/SFX/AB - Swish.asm"
Sound2C:	include "Sound/SFX/AC - Boss Hit.asm"
Sound2D:	include "Sound/SFX/AD - Inhaling Bubble.asm"
Sound2E:	include "Sound/SFX/AE - Lava Ball.asm"
Sound2F:	include "Sound/SFX/AF - Shield.asm"
Sound30:	include "Sound/SFX/B0 - Laser Beam.asm"
Sound31:	include "Sound/SFX/B1 - Electricity (Unused).asm"
Sound32:	include "Sound/SFX/B2 - Drown.asm"
Sound33:	include "Sound/SFX/B3 - Fire Burn.asm"
Sound34:	include "Sound/SFX/B4 - Bumper.asm"
Sound35:	include "Sound/SFX/B5 - Ring.asm"
Sound36:	include "Sound/SFX/B6 - Spikes Move.asm"
Sound37:	include "Sound/SFX/B7 - Rumbling.asm"
Sound38:	include "Sound/SFX/B8 - Unknown (Unused).asm"
Sound39:	include "Sound/SFX/B9 - Smash.asm"
Sound3A:	include "Sound/SFX/BA - Special Stage Glass (Unused).asm"
Sound3B:	include "Sound/SFX/BB - Door Slam.asm"
Sound3C:	include "Sound/SFX/BC - Spin Dash Release.asm"
Sound3D:	include "Sound/SFX/BD - Hammer.asm"
Sound3E:	include "Sound/SFX/BE - Roll.asm"
Sound3F:	include "Sound/SFX/BF - Continue Jingle.asm"
Sound40:	include "Sound/SFX/C0 - Casino Bonus.asm"
Sound41:	include "Sound/SFX/C1 - Explosion.asm"
Sound42:	include "Sound/SFX/C2 - Water Warning.asm"
Sound43:	include "Sound/SFX/C3 - Enter Giant Ring (Unused).asm"
Sound44:	include "Sound/SFX/C4 - Boss Explosion.asm"
Sound45:	include "Sound/SFX/C5 - Tally End.asm"
Sound46:	include "Sound/SFX/C6 - Ring Spill.asm"
Sound47:	include "Sound/SFX/C7 - Chain Rise (Unused).asm"
Sound48:	include "Sound/SFX/C8 - Flamethrower.asm"
Sound49:	include "Sound/SFX/C9 - Hidden Bonus (Unused).asm"
Sound4A:	include "Sound/SFX/CA - Special Stage Entry.asm"
Sound4B:	include "Sound/SFX/CB - Slow Smash.asm"
Sound4C:	include "Sound/SFX/CC - Spring.asm"
Sound4D:	include "Sound/SFX/CD - Switch.asm"
Sound4E:	include "Sound/SFX/CE - Ring Left Speaker.asm"
Sound4F:	include "Sound/SFX/CF - Signpost.asm"
Sound50:	include "Sound/SFX/D0 - CNZ Boss Zap.asm"
Sound51:	include "Sound/SFX/D1 - Unknown (Unused).asm"
Sound52:	include "Sound/SFX/D2 - Unknown (Unused).asm"
Sound53:	include "Sound/SFX/D3 - Signpost 2P.asm"
Sound54:	include "Sound/SFX/D4 - OOZ Lid Pop.asm"
Sound55:	include "Sound/SFX/D5 - Sliding Spike.asm"
Sound56:	include "Sound/SFX/D6 - CNZ Elevator.asm"
Sound57:	include "Sound/SFX/D7 - Platform Knock.asm"
Sound58:	include "Sound/SFX/D8 - Bonus Bumper.asm"
Sound59:	include "Sound/SFX/D9 - Large Bumper.asm"
Sound5A:	include "Sound/SFX/DA - Gloop.asm"
Sound5B:	include "Sound/SFX/DB - Pre-Arrow Firing.asm"
Sound5C:	include "Sound/SFX/DC - Fire.asm"
Sound5D:	include "Sound/SFX/DD - Arrow Stick.asm"
Sound5E:	include "Sound/SFX/DE - Helicopter.asm"
Sound5F:	include "Sound/SFX/DF - Super Transform.asm"
Sound60:	include "Sound/SFX/E0 - Spin Dash Rev.asm"
Sound61:	include "Sound/SFX/E1 - Rumbling 2.asm"
Sound62:	include "Sound/SFX/E2 - CNZ Launch.asm"
Sound63:	include "Sound/SFX/E3 - Flipper.asm"
Sound64:	include "Sound/SFX/E4 - HTZ Lift Click.asm"
Sound65:	include "Sound/SFX/E5 - Leaves.asm"
Sound66:	include "Sound/SFX/E6 - Mega Mack Drop.asm"
Sound67:	include "Sound/SFX/E7 - Drawbridge Move.asm"
Sound68:	include "Sound/SFX/E8 - Quick Door Slam.asm"
Sound69:	include "Sound/SFX/E9 - Drawbridge Down.asm"
Sound6A:	include "Sound/SFX/EA - Laser Burst.asm"
Sound6B:	include "Sound/SFX/EB - Scatter.asm"
Sound6C:	include "Sound/SFX/EC - Teleport.asm"
Sound6D:	include "Sound/SFX/ED - Error.asm"
Sound6E:	include "Sound/SFX/EE - Mecha Sonic Buzz.asm"
Sound6F:	include "Sound/SFX/EF - Large Laser.asm"
Sound70:	include "Sound/SFX/F0 - Oil Slide.asm"

	finishBank

; end of 'ROM'
	if padToPowerOfTwo && (*-StartOfRom)&(*-StartOfRom-1)
		cnop	-1,2<<lastbit(*-StartOfRom-1)
		dc.b	$00
paddingSoFar	:= paddingSoFar+1
	else
		even
	endif
EndOfRom:
	if MOMPASS=2
		; "About" because it will be off by the same amount that Size_of_Snd_driver_guess is incorrect (if you changed it), and because I may have missed a small amount of internal padding somewhere
		message "ROM size is $\{EndOfRom-StartOfRom} bytes (\{(EndOfRom-StartOfRom)/1024.0} KiB). About $\{paddingSoFar} bytes are padding. "
	endif
	; share these symbols externally (WARNING: don't rename, move or remove these labels!)
	shared movewZ80CompSize
	END
