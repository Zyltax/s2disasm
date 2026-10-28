;--------------------------------------------------------------------------------------
; Offset index of ring locations
;  The first commented number on each line is an array index; the second is the
;  associated zone.
;--------------------------------------------------------------------------------------
Off_Rings: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w  Rings_EHZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_EHZ_2	; Act 2
	; Zone 1
	zoneOffsetTableEntry.w  Rings_Lev1_1	; Act 1
	zoneOffsetTableEntry.w  Rings_Lev1_2	; Act 2
	; WZ
	zoneOffsetTableEntry.w  Rings_WZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_WZ_2	; Act 2
	; Zone 3
	zoneOffsetTableEntry.w  Rings_Lev3_1	; Act 1
	zoneOffsetTableEntry.w  Rings_Lev3_2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Rings_MTZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_MTZ_2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Rings_MTZ_3	; Act 3
	zoneOffsetTableEntry.w  Rings_MTZ_4	; Act 4
	; WFZ
	zoneOffsetTableEntry.w  Rings_WFZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_WFZ_2	; Act 2
	; HTZ
	zoneOffsetTableEntry.w  Rings_HTZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_HTZ_2	; Act 2
	; HPZ
	zoneOffsetTableEntry.w  Rings_HPZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_HPZ_2	; Act 2
	; Zone 9
	zoneOffsetTableEntry.w  Rings_Lev9_1	; Act 1
	zoneOffsetTableEntry.w  Rings_Lev9_2	; Act 2
	; OOZ
	zoneOffsetTableEntry.w  Rings_OOZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_OOZ_2	; Act 2
	; MCZ
	zoneOffsetTableEntry.w  Rings_MCZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_MCZ_2	; Act 2
	; CNZ
	zoneOffsetTableEntry.w  Rings_CNZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_CNZ_2	; Act 2
	; CPZ
	zoneOffsetTableEntry.w  Rings_CPZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_CPZ_2	; Act 2
	; DEZ
	zoneOffsetTableEntry.w  Rings_DEZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_DEZ_2	; Act 2
	; ARZ
	zoneOffsetTableEntry.w  Rings_ARZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_ARZ_2	; Act 2
	; SCZ
	zoneOffsetTableEntry.w  Rings_SCZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_SCZ_2	; Act 2
    zoneTableEnd

Rings_EHZ_1:	BINCLUDE	"Levels/EHZ/Act 1/Rings.bin"
Rings_EHZ_2:	BINCLUDE	"Levels/EHZ/Act 2/Rings.bin"
Rings_Lev1_1:	BINCLUDE	"Levels/Unused/Rings/01 1.bin"
Rings_Lev1_2:	BINCLUDE	"Levels/Unused/Rings/01 2.bin"
Rings_WZ_1:	BINCLUDE	"Levels/Unused/WZ/Act 1/Rings.bin"
Rings_WZ_2:	BINCLUDE	"Levels/Unused/WZ/Act 2/Rings.bin"
Rings_Lev3_1:	BINCLUDE	"Levels/Unused/Rings/03 1.bin"
Rings_Lev3_2:	BINCLUDE	"Levels/Unused/Rings/03 2.bin"
Rings_MTZ_1:	BINCLUDE	"Levels/MTZ/Act 1/Rings.bin"
Rings_MTZ_2:	BINCLUDE	"Levels/MTZ/Act 2/Rings.bin"
Rings_MTZ_3:	BINCLUDE	"Levels/MTZ/Act 3/Rings.bin"
Rings_MTZ_4:	BINCLUDE	"Levels/MTZ/Act 4/Rings.bin"
Rings_HTZ_1:	BINCLUDE	"Levels/HTZ/Act 1/Rings.bin"
Rings_HTZ_2:	BINCLUDE	"Levels/HTZ/Act 2/Rings.bin"
Rings_HPZ_1:	BINCLUDE	"Levels/Unused/HPZ/Act 1/Rings.bin"
Rings_HPZ_2:	BINCLUDE	"Levels/Unused/HPZ/Act 2/Rings.bin"
Rings_Lev9_1:	BINCLUDE	"Levels/Unused/Rings/09 1.bin"
Rings_Lev9_2:	BINCLUDE	"Levels/Unused/Rings/09 2.bin"
Rings_OOZ_1:	BINCLUDE	"Levels/OOZ/Act 1/Rings.bin"
Rings_OOZ_2:	BINCLUDE	"Levels/OOZ/Act 2/Rings.bin"
Rings_MCZ_1:	BINCLUDE	"Levels/MCZ/Act 1/Rings.bin"
Rings_MCZ_2:	BINCLUDE	"Levels/MCZ/Act 2/Rings.bin"
Rings_CNZ_1:	BINCLUDE	"Levels/CNZ/Act 1/Rings.bin"
Rings_CNZ_2:	BINCLUDE	"Levels/CNZ/Act 2/Rings.bin"
Rings_CPZ_1:	BINCLUDE	"Levels/CPZ/Act 1/Rings.bin"
Rings_CPZ_2:	BINCLUDE	"Levels/CPZ/Act 2/Rings.bin"
Rings_DEZ_1:	BINCLUDE	"Levels/DEZ/Act 1/Rings.bin"
Rings_DEZ_2:	BINCLUDE	"Levels/DEZ/Act 2/Rings.bin"
Rings_WFZ_1:	BINCLUDE	"Levels/WFZ/Act 1/Rings.bin"
Rings_WFZ_2:	BINCLUDE	"Levels/WFZ/Act 2/Rings.bin"
Rings_ARZ_1:	BINCLUDE	"Levels/ARZ/Act 1/Rings.bin"
Rings_ARZ_2:	BINCLUDE	"Levels/ARZ/Act 2/Rings.bin"
Rings_SCZ_1:	BINCLUDE	"Levels/SCZ/Act 1/Rings.bin"
Rings_SCZ_2:	BINCLUDE	"Levels/SCZ/Act 2/Rings.bin"

; --------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
; --------------------------------------------------------------------------------------
	align $200

; --------------------------------------------------------------------------------------
; Offset index of object locations
; --------------------------------------------------------------------------------------
Off_Objects: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w  Objects_EHZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_EHZ_2	; Act 2
	; Zone 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; WZ
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; Zone 3
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Objects_MTZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_MTZ_2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Objects_MTZ_3	; Act 3
	zoneOffsetTableEntry.w  Objects_MTZ_3	; Act 4
	; WFZ
	zoneOffsetTableEntry.w  Objects_WFZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_WFZ_2	; Act 2
	; HTZ
	zoneOffsetTableEntry.w  Objects_HTZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_HTZ_2	; Act 2
	; HPZ
	zoneOffsetTableEntry.w  Objects_HPZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_HPZ_2	; Act 2
	; Zone 9
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; OOZ
	zoneOffsetTableEntry.w  Objects_OOZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_OOZ_2	; Act 2
	; MCZ
	zoneOffsetTableEntry.w  Objects_MCZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_MCZ_2	; Act 2
	; CNZ
	zoneOffsetTableEntry.w  Objects_CNZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_CNZ_2	; Act 2
	; CPZ
	zoneOffsetTableEntry.w  Objects_CPZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_CPZ_2	; Act 2
	; DEZ
	zoneOffsetTableEntry.w  Objects_DEZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_DEZ_2	; Act 2
	; ARZ
	zoneOffsetTableEntry.w  Objects_ARZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_ARZ_2	; Act 2
	; SCZ
	zoneOffsetTableEntry.w  Objects_SCZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_SCZ_2	; Act 2
    zoneTableEnd

	; These things act as boundaries for the object layout parser, so it doesn't read past the end/beginning of the file
	ObjectLayoutBoundary
Objects_EHZ_1:	BINCLUDE	"Levels/EHZ/Act 1/Objects.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; A collision switcher was improperly placed
Objects_EHZ_2:	BINCLUDE	"Levels/EHZ/Act 2/Objects (REV00).bin"
    else
Objects_EHZ_2:	BINCLUDE	"Levels/EHZ/Act 2/Objects (REV01).bin"
    endif

	ObjectLayoutBoundary
Objects_MTZ_1:	BINCLUDE	"Levels/MTZ/Act 1/Objects.bin"
	ObjectLayoutBoundary
Objects_MTZ_2:	BINCLUDE	"Levels/MTZ/Act 2/Objects.bin"
	ObjectLayoutBoundary
Objects_MTZ_3:	BINCLUDE	"Levels/MTZ/Act 3/Objects.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; The lampposts were bugged: their 'remember state' flags weren't set
Objects_WFZ_1:	BINCLUDE	"Levels/WFZ/Act 1/Objects (REV00).bin"
    else
Objects_WFZ_1:	BINCLUDE	"Levels/WFZ/Act 1/Objects (REV01).bin"
    endif

	ObjectLayoutBoundary
Objects_WFZ_2:	BINCLUDE	"Levels/WFZ/Act 2/Objects.bin"
	ObjectLayoutBoundary
Objects_HTZ_1:	BINCLUDE	"Levels/HTZ/Act 1/Objects.bin"
	ObjectLayoutBoundary
Objects_HTZ_2:	BINCLUDE	"Levels/HTZ/Act 2/Objects.bin"
	ObjectLayoutBoundary
Objects_HPZ_1:	BINCLUDE	"Levels/Unused/HPZ/Act 1/Objects.bin"
	ObjectLayoutBoundary
Objects_HPZ_2:	BINCLUDE	"Levels/Unused/HPZ/Act 2/Objects.bin"
	ObjectLayoutBoundary
	; Oddly, there's a gap for another layout here
	ObjectLayoutBoundary
Objects_OOZ_1:	BINCLUDE	"Levels/OOZ/Act 1/Objects.bin"
	ObjectLayoutBoundary
Objects_OOZ_2:	BINCLUDE	"Levels/OOZ/Act 2/Objects.bin"
	ObjectLayoutBoundary
Objects_MCZ_1:	BINCLUDE	"Levels/MCZ/Act 1/Objects.bin"
	ObjectLayoutBoundary
Objects_MCZ_2:	BINCLUDE	"Levels/MCZ/Act 2/Objects.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; The signposts are too low, causing them to poke out the bottom of the ground
Objects_CNZ_1:	BINCLUDE	"Levels/CNZ/Act 1/Objects (REV00).bin"
	ObjectLayoutBoundary
Objects_CNZ_2:	BINCLUDE	"Levels/CNZ/Act 2/Objects (REV00).bin"
    else
Objects_CNZ_1:	BINCLUDE	"Levels/CNZ/Act 1/Objects (REV01).bin"
	ObjectLayoutBoundary
Objects_CNZ_2:	BINCLUDE	"Levels/CNZ/Act 2/Objects (REV01).bin"
    endif

	ObjectLayoutBoundary
Objects_CPZ_1:	BINCLUDE	"Levels/CPZ/Act 1/Objects.bin"
	ObjectLayoutBoundary
Objects_CPZ_2:	BINCLUDE	"Levels/CPZ/Act 2/Objects.bin"
	ObjectLayoutBoundary
Objects_DEZ_1:	BINCLUDE	"Levels/DEZ/Act 1/Objects.bin"
	ObjectLayoutBoundary
Objects_DEZ_2:	BINCLUDE	"Levels/DEZ/Act 2/Objects.bin"
	ObjectLayoutBoundary
Objects_ARZ_1:	BINCLUDE	"Levels/ARZ/Act 1/Objects.bin"
	ObjectLayoutBoundary
Objects_ARZ_2:	BINCLUDE	"Levels/ARZ/Act 2/Objects.bin"
	ObjectLayoutBoundary
Objects_SCZ_1:	BINCLUDE	"Levels/SCZ/Act 1/Objects.bin"
	ObjectLayoutBoundary
Objects_SCZ_2:	BINCLUDE	"Levels/SCZ/Act 2/Objects.bin"
	ObjectLayoutBoundary
Objects_Null:
	ObjectLayoutBoundary
	; Another strange space for a layout
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary
