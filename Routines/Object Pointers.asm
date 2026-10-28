; ===========================================================================
; ---------------------------------------------------------------------------
; OBJECT POINTER ARRAY ; object pointers ; sprite pointers ; object list ; sprite list
;
; This array contains the pointers to all the objects used in the game.
; ---------------------------------------------------------------------------
Obj_Index: ; ObjPtrs: ; loc_1600C:
ObjPtr_Sonic:		dc.l ObjSonic	; Sonic
ObjPtr_Tails:		dc.l ObjTails	; Tails
ObjPtr_PlaneSwitcher:	dc.l ObjPlaneSwitcher	; Collision plane/layer switcher
ObjPtr_WaterSurface:	dc.l ObjWaterSurface	; Surface of the water
ObjPtr_TailsTails:	dc.l ObjTailsTails	; Tails' tails
ObjPtr_Spiral:		dc.l ObjSpiral	; Rotating cylinder in MTZ, twisting spiral pathway in EHZ
ObjPtr_Oil:		dc.l ObjOil	; Oil in OOZ
ObjPtr_SpindashDust:
ObjPtr_Splash:		dc.l ObjSplash	; Water splash in Aquatic Ruin Zone, Spindash dust
ObjPtr_SonicSS:		dc.l ObjSonicSS	; Sonic in Special Stage
ObjPtr_SmallBubbles:	dc.l ObjSmallBubbles	; Small bubbles from Sonic's face while underwater
ObjPtr_TippingFloor:	dc.l ObjTippingFloor	; Section of pipe that tips you off from CPZ
			dc.l Obj0C	; Small floating platform (unused)
ObjPtr_Signpost:	dc.l ObjSignpost	; End of level signpost
ObjPtr_TitleIntro:	dc.l ObjTitleIntro	; Title screen intro animation
ObjPtr_TitleMenu:	dc.l ObjTitleMenu	; Title screen menu
ObjPtr_TailsSS:		dc.l ObjTailsSS	; Tails in Special Stage
ObjPtr_Bridge:		dc.l ObjBridge	; Bridge in Emerald Hill Zone and Hidden Palace Zone
ObjPtr_HPZEmerald:	dc.l ObjHPZEmerald	; Emerald from Hidden Palace Zone (unused)
ObjPtr_HPZWaterfall:	dc.l ObjHPZWaterfall	; Waterfall in Hidden Palace Zone (unused)
ObjPtr_Seesaw:		dc.l ObjSeesaw	; Seesaw from Hill Top Zone
ObjPtr_SwingingPlatform:dc.l ObjSwingingPlatform	; Swinging platform from Aquatic Ruin Zone
ObjPtr_HTZLift:		dc.l ObjHTZLift	; Diagonally moving lift from HTZ
			dc.l Obj17	; GHZ rotating log helix spikes (from Sonic 1, unused)
ObjPtr_ARZPlatform:
ObjPtr_EHZPlatform:	dc.l ObjEHZPlatform	; Stationary floating platform from ARZ and EHZ
ObjPtr_CPZPlatform:
ObjPtr_OOZMovingPform:
ObjPtr_WFZPlatform:	dc.l ObjWFZPlatform	; Platform from CPZ, OOZ and WFZ
ObjPtr_HPZCollapsPform:	dc.l ObjHPZCollapsPform	; Collapsing platform from HPZ (and GHZ)
ObjPtr_SpeedBooster:	dc.l ObjSpeedBooster	; Speed booster from from CPZ
ObjPtr_Scenery:
ObjPtr_BridgeStake:
ObjPtr_FallingOil:	dc.l ObjFallingOil	; Bridge stake in Emerald Hill Zone and Hill Top Zone, falling oil in Oil Ocean Zone
ObjPtr_BlueBalls:	dc.l ObjBlueBalls	; Blue balls in CPZ (jumping droplets hazard)
ObjPtr_CPZSpinTube:	dc.l ObjCPZSpinTube	; Spin tube from CPZ
ObjPtr_CollapsPform:	dc.l ObjCollapsPform	; Collapsing platform from ARZ, MCZ and OOZ (and MZ, SLZ and SBZ)
ObjPtr_LavaBubble:	dc.l ObjLavaBubble	; Lava bubble from Hill Top Zone (boss weapon)
ObjPtr_2PResults:	dc.l Obj2PResults	; 2P results
ObjPtr_ArrowShooter:	dc.l ObjArrowShooter	; Arrow shooter from ARZ
ObjPtr_FallingPillar:	dc.l ObjFallingPillar	; Pillar that drops its lower part from ARZ
ObjPtr_ARZBubbles:	dc.l ObjARZBubbles	; Bubbles in Aquatic Ruin Zone
ObjPtr_Ring:		dc.l ObjRing	; A ring
ObjPtr_Monitor:		dc.l ObjMonitor	; Monitor
ObjPtr_Explosion:	dc.l ObjExplosion	; An explosion, giving off an animal and 100 points
ObjPtr_Animal:		dc.l ObjAnimal	; Animal and the 100 points from a badnik
ObjPtr_Points:		dc.l ObjPoints	; "100 points" text
ObjPtr_Stomper:		dc.l ObjStomper	; Stomper from MCZ
ObjPtr_RisingPillar:	dc.l ObjRisingPillar	; Rising pillar from ARZ
ObjPtr_LeavesGenerator:	dc.l ObjLeavesGenerator	; Sprite that makes leaves fly off when you hit it from ARZ
ObjPtr_Barrier:		dc.l ObjBarrier	; One way barrier from CPZ and DEZ
ObjPtr_MonitorContents:	dc.l ObjMonitorContents	; Monitor contents (code for power-up behavior and rising image)
ObjPtr_SmashableGround:	dc.l ObjSmashableGround	; Smashable ground in Hill Top Zone
ObjPtr_RisingLava:	dc.l ObjRisingLava	; Large rising lava during earthquake in HTZ
ObjPtr_LavaMarker:	dc.l ObjLavaMarker	; Lava collision marker
ObjPtr_BreakableBlock:
ObjPtr_BreakableRock:	dc.l ObjBreakableRock	; Breakable block/rock from CPZ and HTZ
ObjPtr_OOZPoppingPform:	dc.l ObjOOZPoppingPform	; Green platform from OOZ
ObjPtr_TitleCard:	dc.l ObjTitleCard	; level title card (screen with red, yellow, and blue)
ObjPtr_InvStars:	dc.l ObjInvStars	; Invincibility Stars
ObjPtr_Spikes:		dc.l ObjSpikes	; Vertical spikes
ObjPtr_LostRings:	dc.l ObjLostRings	; Scattering rings (generated when Sonic is hurt and has rings)
ObjPtr_Shield:		dc.l ObjShield	; Shield
ObjPtr_GameOver:
ObjPtr_TimeOver:	dc.l ObjTimeOver	; Game/Time Over text
ObjPtr_Results:		dc.l ObjResults	; End of level results screen
			dc.l ObjPurpleRock	; Purple rock (from Sonic 1, unused)
			dc.l ObjBreakableWall	; Breakable wall (leftover from S1) (mostly unused)
ObjPtr_OOZLauncher:	dc.l ObjOOZLauncher	; Block thingy in OOZ that launches you into the round ball things
ObjPtr_EggPrison:	dc.l ObjEggPrison	; Egg prison
ObjPtr_Fan:		dc.l ObjFan	; Fan from OOZ
ObjPtr_Springboard:	dc.l ObjSpringboard	; Pressure spring from CPZ, ARZ, and MCZ (the red "diving board" springboard)
ObjPtr_Spring:		dc.l ObjSpring	; Spring
ObjPtr_SteamSpring:	dc.l ObjSteamSpring	; Steam Spring from MTZ
ObjPtr_SlidingSpike:	dc.l ObjSlidingSpike	; Sliding spike obstacle thing from OOZ
ObjPtr_RoundBumper:	dc.l ObjRoundBumper	; Round bumper from Casino Night Zone
ObjPtr_OOZSpring:	dc.l ObjOOZSpring	; Pressure spring from OOZ
ObjPtr_OOZBall:		dc.l ObjOOZBall	; Ball from OOZ (unused, beta leftover)
ObjPtr_Button:		dc.l ObjButton	; Button
ObjPtr_LauncherBall:	dc.l ObjLauncherBall	; Round ball thing from OOZ that fires you off in a different direction
ObjPtr_EHZWaterfall:	dc.l ObjEHZWaterfall	; Waterfall from EHZ
ObjPtr_Octus:		dc.l ObjOctus	; Octus (octopus badnik) from OOZ
ObjPtr_Buzzer:		dc.l ObjBuzzer	; Buzzer (Buzz bomber) from EHZ
			dc.l ObjNull	; Used to be the "BBat" badnik from HPZ
			dc.l ObjNull	; Used to be the "Stego" badnik
			dc.l ObjNull	; Used to be the "Gator" badnik
			dc.l ObjNull	; Used to be the "Redz" badnik from HPZ
ObjPtr_Aquis:		dc.l ObjAquis	; Aquis (seahorse badnik) from OOZ
ObjPtr_CNZBoss:		dc.l ObjCNZBoss	; CNZ boss
ObjPtr_HTZBoss:		dc.l ObjHTZBoss	; HTZ boss ; Used to be the "BFish" badnik
ObjPtr_MTZBossOrb:	dc.l ObjMTZBossOrb	; Shield orbs that surround MTZ boss
ObjPtr_MTZBoss:		dc.l ObjMTZBoss	; MTZ boss
ObjPtr_OOZBoss:		dc.l ObjOOZBoss	; OOZ boss
ObjPtr_EHZBoss:		dc.l ObjEHZBoss	; EHZ boss
ObjPtr_MCZBoss:		dc.l ObjMCZBoss	; MCZ boss
ObjPtr_BossExplosion:	dc.l ObjBossExplosion	; Boss explosion
ObjPtr_SSEmerald:	dc.l ObjSSEmerald	; Emerald from Special Stage
ObjPtr_SSMessage:	dc.l ObjSSMessage	; Messages/checkpoint from Special Stage
ObjPtr_SSRingSpill:	dc.l ObjSSRingSpill	; Ring spray/spill in Special Stage
ObjPtr_Masher:		dc.l ObjMasher	; Masher (jumping piranha fish badnik) from EHZ
ObjPtr_CPZBoss:		dc.l ObjCPZBoss	; CPZ boss
ObjPtr_SSHUD:		dc.l ObjSSHUD	; HUD from Special Stage
ObjPtr_StartBanner:
ObjPtr_EndingController:dc.l ObjEndingController	; Start banner/"Ending controller" from Special Stage
ObjPtr_SSRing:		dc.l ObjSSRing	; Rings from Special Stage
ObjPtr_SSBomb:		dc.l ObjSSBomb	; Bombs from Special Stage
			dc.l ObjNull	; Obj62
ObjPtr_SSShadow:	dc.l ObjSSShadow	; Character shadow from Special Stage
ObjPtr_MTZTwinStompers:	dc.l ObjMTZTwinStompers	; Twin stompers from MTZ
ObjPtr_MTZLongPlatform:	dc.l ObjMTZLongPlatform	; Long moving platform from MTZ
ObjPtr_MTZSpringWall:	dc.l ObjMTZSpringWall	; Yellow spring walls from MTZ
ObjPtr_MTZSpinTube:	dc.l ObjMTZSpinTube	; Spin tube from MTZ
ObjPtr_SpikyBlock:	dc.l ObjSpikyBlock	; Block with a spike that comes out of each side sequentially from MTZ
ObjPtr_Nut:		dc.l ObjNut	; Nut from MTZ
ObjPtr_MCZRotPforms:
ObjPtr_MTZMovingPforms:	dc.l ObjMTZMovingPforms	; Platform that moves when you walk off of it, from MTZ
ObjPtr_MTZPlatform:
ObjPtr_CPZSquarePform:	dc.l ObjCPZSquarePform	; Immobile platform from MTZ
ObjPtr_Conveyor:	dc.l ObjConveyor	; Small platform on pulleys (like at the start of MTZ2)
ObjPtr_FloorSpike:	dc.l ObjFloorSpike	; Floor spike from MTZ
ObjPtr_LargeRotPform:	dc.l ObjLargeRotPform	; Platform moving in a circle (like at the start of MTZ3)
ObjPtr_SSResults:	dc.l ObjSSResults	; End of special stage results screen
ObjPtr_Cog:		dc.l ObjCog	; Giant rotating cog from MTZ
ObjPtr_MTZLavaBubble:
ObjPtr_HPZBridgeStake:
ObjPtr_PulsingOrb:	dc.l ObjPulsingOrb	; Bridge stake and pulsing orb from Hidden Palace Zone
ObjPtr_CNZConveyorBelt:	dc.l ObjCNZConveyorBelt	; Conveyor belt from CNZ
ObjPtr_RotatingRings:	dc.l ObjRotatingRings	; Solid rotating ring thing from Mystic Cave Zone (mostly unused)
ObjPtr_InvisibleBlock:	dc.l ObjInvisibleBlock	; Invisible solid block
ObjPtr_MCZBrick:	dc.l ObjMCZBrick	; Brick from MCZ
ObjPtr_SlidingSpikes:	dc.l ObjSlidingSpikes	; Spike block that slides out of the wall from MCZ
ObjPtr_MCZBridge:	dc.l ObjMCZBridge	; Bridge from MCZ
ObjPtr_CPZStaircase:	dc.l ObjCPZStaircase	; Stairs from CPZ that move down to open the way
ObjPtr_Starpost:	dc.l ObjStarpost	; Star pole / starpost / checkpoint
ObjPtr_SidewaysPform:	dc.l ObjSidewaysPform	; Platform that moves back and fourth on top of water in CPZ
ObjPtr_PipeExitSpring:	dc.l ObjPipeExitSpring	; Warp pipe exit spring from CPZ
ObjPtr_CPZPylon:	dc.l ObjCPZPylon	; Big pylon in foreground of CPZ
			dc.l Obj7D	; Points that can be gotten at the end of an act (unused leftover from S1)
ObjPtr_SuperSonicStars:	dc.l ObjSuperSonicStars	; Super Sonic's stars
ObjPtr_VineSwitch:	dc.l ObjVineSwitch	; Vine switch that you hang off in MCZ
ObjPtr_MovingVine:	dc.l ObjMovingVine	; Vine that you hang off and it moves down from MCZ
ObjPtr_MCZDrawbridge:	dc.l ObjMCZDrawbridge	; Long invisible vertical barrier
ObjPtr_SwingingPform:	dc.l ObjSwingingPform	; Platform that is usually swinging, from ARZ
ObjPtr_ARZRotPforms:	dc.l ObjARZRotPforms	; 3 adjoined platforms from ARZ that rotate in a circle
ObjPtr_ForcedSpin:
ObjPtr_PinballMode:	dc.l ObjPinballMode	; Pinball mode enable/disable (CNZ)
ObjPtr_LauncherSpring:	dc.l ObjLauncherSpring	; Spring from CNZ that you hold jump on to pull back further
ObjPtr_Flipper:		dc.l ObjFlipper	; Flipper from CNZ
ObjPtr_SSNumberOfRings:	dc.l ObjSSNumberOfRings	; Number of rings in Special Stage
ObjPtr_SSTailsTails:	dc.l ObjSSTailsTails	; Tails' tails in Special Stage
ObjPtr_ARZBoss:		dc.l ObjARZBoss	; ARZ boss
			dc.l Obj8A	; Sonic Team Presents/Credits (seemingly unused leftover from S1)
ObjPtr_WFZPalSwitcher:	dc.l ObjWFZPalSwitcher	; Cycling palette switcher from Wing Fortress Zone
ObjPtr_Whisp:		dc.l ObjWhisp	; Whisp (blowfly badnik) from ARZ
ObjPtr_GrounderInWall:	dc.l ObjGrounderInWall	; Grounder in wall, from ARZ
ObjPtr_GrounderInWall2:	dc.l ObjGrounderInWall	; ObjGrounderInWall2 = ObjGrounderInWall
ObjPtr_GrounderWall:	dc.l ObjGrounderWall	; Wall behind which Grounder hides, from ARZ
ObjPtr_GrounderRocks:	dc.l ObjGrounderRocks	; Rocks thrown by Grounder behind wall, from ARZ
ObjPtr_ChopChop:	dc.l ObjChopChop	; Chop Chop (piranha/shark badnik) from ARZ
ObjPtr_Spiker:		dc.l ObjSpiker	; Spiker (drill badnik) from HTZ
ObjPtr_SpikerDrill:	dc.l ObjSpikerDrill	; Drill thrown by Spiker from HTZ
ObjPtr_Rexon:		dc.l ObjRexon	; Rexon (lava snake badnik), from HTZ
ObjPtr_Sol:		dc.l ObjSol	; Sol (fireball-throwing orbit badnik) from HTZ
ObjPtr_Rexon2:		dc.l ObjRexon	; ObjRexon2 = ObjRexon
ObjPtr_RexonHead:	dc.l ObjRexonHead	; Rexon's head, from HTZ
ObjPtr_Projectile:	dc.l ObjProjectile	; Projectile with optional gravity (EHZ coconut, CPZ spiny, etc.)
ObjPtr_Nebula:		dc.l ObjNebula	; Nebula (bomber badnik) from SCZ
ObjPtr_Turtloid:	dc.l ObjTurtloid	; Turtloid (turtle badnik) from Sky Chase Zone
ObjPtr_TurtloidRider:	dc.l ObjTurtloidRider	; Turtloid rider from Sky Chase Zone
ObjPtr_BalkiryJet:	dc.l ObjBalkiryJet	; Balkiry's jet from Sky Chase Zone
ObjPtr_Coconuts:	dc.l ObjCoconuts	; Coconuts (monkey badnik) from EHZ
ObjPtr_Crawlton:	dc.l ObjCrawlton	; Crawlton (snake badnik) from MCZ
ObjPtr_Shellcracker:	dc.l ObjShellcracker	; Shellcraker (crab badnik) from MTZ
ObjPtr_ShellcrackerClaw:dc.l ObjShellcrackerClaw	; Shellcracker's claw from MTZ
ObjPtr_Slicer:		dc.l ObjSlicer	; Slicer (praying mantis dude) from MTZ
ObjPtr_SlicerPincers:	dc.l ObjSlicerPincers	; Slicer's pincers from MTZ
ObjPtr_Flasher:		dc.l ObjFlasher	; Flasher (firefly/glowbug badnik) from MCZ
ObjPtr_Asteron:		dc.l ObjAsteron	; Asteron (exploding starfish badnik) from MTZ
ObjPtr_Spiny:		dc.l ObjSpiny	; Spiny (crawling badnik) from CPZ
ObjPtr_SpinyOnWall:	dc.l ObjSpinyOnWall	; Spiny (on wall) from CPZ
ObjPtr_Grabber:		dc.l ObjGrabber	; Grabber (spider badnik) from CPZ
ObjPtr_GrabberLegs:	dc.l ObjGrabberLegs	; Grabber's legs from CPZ
ObjPtr_GrabberBox:	dc.l ObjGrabberBox	; The little hanger box thing a Grabber's string comes out of
ObjPtr_GrabberString:	dc.l ObjGrabberString	; The thin white string a Grabber hangs from
			dc.l ObjAB	; Unknown (maybe unused?)
ObjPtr_Balkiry:		dc.l ObjBalkiry	; Balkiry (jet badnik) from SCZ
ObjPtr_CluckerBase:	dc.l ObjCluckerBase	; Clucker's base from WFZ
ObjPtr_Clucker:		dc.l ObjClucker	; Clucker (chicken badnik) from WFZ
ObjPtr_MechaSonic:	dc.l ObjMechaSonic	; Mecha Sonic / Silver Sonic from DEZ
ObjPtr_SonicOnSegaScr:	dc.l ObjSonicOnSegaScr	; Sonic on the Sega screen
ObjPtr_SegaHideTM:	dc.l ObjSegaHideTM	; Object that hides TM symbol on JP region
ObjPtr_Tornado:		dc.l ObjTornado	; The Tornado (Tails' plane)
ObjPtr_Cloud:		dc.l ObjCloud	; Clouds (placeable object) from SCZ
ObjPtr_VPropeller:	dc.l ObjVPropeller	; Vertical propeller from WFZ
ObjPtr_HPropeller:	dc.l ObjHPropeller	; Horizontal propeller from WFZ
ObjPtr_TiltingPlatform:	dc.l ObjTiltingPlatform	; Tilting platform from WFZ
ObjPtr_VerticalLaser:	dc.l ObjVerticalLaser	; Unused huge vertical laser from WFZ
ObjPtr_WallTurret:	dc.l ObjWallTurret	; Wall turret from WFZ
ObjPtr_Laser:		dc.l ObjLaser	; Laser from WFZ that shoots down the Tornado
ObjPtr_WFZWheel:	dc.l ObjWFZWheel	; Wheel from WFZ
			dc.l ObjBB	; Unknown
ObjPtr_WFZShipFire:	dc.l ObjWFZShipFire	; Fire coming out of Robotnik's ship in WFZ
ObjPtr_SmallMetalPform:	dc.l ObjSmallMetalPform	; Ascending/descending metal platforms from WFZ
ObjPtr_LateralCannon:	dc.l ObjLateralCannon	; Lateral cannon (temporary platform that pops in/out) from WFZ
ObjPtr_WFZStick:	dc.l ObjWFZStick	; Rotaty-stick badnik from WFZ
ObjPtr_SpeedLauncher:	dc.l ObjSpeedLauncher	; Speed launcher from WFZ
ObjPtr_BreakablePlating:dc.l ObjBreakablePlating	; Breakable plating from WFZ / what Sonic hangs onto on the back of Robotnik's getaway ship
ObjPtr_Rivet:		dc.l ObjRivet	; Rivet thing you bust to get into ship at the end of WFZ
ObjPtr_TornadoSmoke:	dc.l ObjTornadoSmoke	; Plane's smoke from WFZ
ObjPtr_TornadoSmoke2:	dc.l ObjTornadoSmoke 	; ObjTornadoSmoke2 = ObjTornadoSmoke
ObjPtr_WFZBoss:		dc.l ObjWFZBoss	; WFZ boss
ObjPtr_Eggman:		dc.l ObjEggman	; Eggman
ObjPtr_Eggrobo:		dc.l ObjEggrobo	; Eggrobo (final boss) from Death Egg
ObjPtr_Crawl:		dc.l ObjCrawl	; Crawl (shield badnik) from CNZ
ObjPtr_TtlScrPalChanger:dc.l ObjTtlScrPalChanger	; "Palette changing handler" from title screen
ObjPtr_CutScene:	dc.l ObjCutScene	; Cut scene at end of game
ObjPtr_EndingSeqClouds:	dc.l ObjEndingSeqClouds	; Background clouds from ending sequence
ObjPtr_EndingSeqTrigger:dc.l ObjEndingSeqTrigger	; Trigger for rescue plane and birds from ending sequence
ObjPtr_EndingSeqBird:	dc.l ObjEndingSeqBird	; Birds from ending sequence
ObjPtr_EndingSeqSonic:
ObjPtr_EndingSeqTails:	dc.l ObjEndingSeqTails	; Sonic and Tails jumping off the plane from ending sequence
ObjPtr_TornadoHelixes:	dc.l ObjTornadoHelixes	;"Plane's helixes" from ending sequence
			dc.l ObjNull	; ObjD0
			dc.l ObjNull	; ObjD1
ObjPtr_CNZRectBlocks:	dc.l ObjCNZRectBlocks	; Flashing blocks that appear and disappear in a rectangular shape that you can walk across, from CNZ
ObjPtr_BombPrize:	dc.l ObjBombPrize	; Bomb prize from CNZ
ObjPtr_CNZBigBlock:	dc.l ObjCNZBigBlock	; Big block from CNZ that moves back and fourth
ObjPtr_Elevator:	dc.l ObjElevator	; Elevator from CNZ
ObjPtr_PointPokey:	dc.l ObjPointPokey	; Pokey that gives out points from CNZ
ObjPtr_Bumper:		dc.l ObjBumper	; Bumper from Casino Night Zone
ObjPtr_BonusBlock:	dc.l ObjBonusBlock	; Block thingy from CNZ that disappears after 3 hits
ObjPtr_Grab:		dc.l ObjGrab	; Invisible sprite that you can hang on to, like the blocks in WFZ
ObjPtr_ContinueText:
ObjPtr_ContinueIcons:	dc.l ObjContinueIcons	; Continue text
ObjPtr_ContinueChars:	dc.l ObjContinueChars	; Sonic lying down or Tails nagging (continue screen)
ObjPtr_RingPrize:	dc.l ObjRingPrize	; Ring prize from Casino Night Zone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 4C, 4D, 4E, 4F, 62, D0, and D1

; Object removed from the game. All it does is deallocate its array.
; ----------------------------------------------------------------------------

ObjNull: ;;
	bra.w	DeleteObject

