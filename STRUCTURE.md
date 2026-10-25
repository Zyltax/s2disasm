## Style

Code is indented by one tab stop, which on my editor is 8 spaces. Most labels
appear on separate lines, with the exception of nameless temporary labels
which always appear next to the relevant instruction. Blank lines are inserted
after reverse branches, to help make loops clearer; they may also be inserted
before the start of the loop if it is simple enough. If code execution cannot
continue linerally because of an unconditional jump, branch, or a return
instruction, a series of dashed or double-dashed lines is inserted at the
point where PC is altered. (Double dashes indicate possibly more significant
boundaries than single dashes, but there is no hard rule behind the choice.)
These dashes have been removed when breached by nameless temporary variables.

Variables and structures have underscore-seperated names *(e.g. **Decomp\_Buffer**,
**Camera\_X\_Pos**),* while subroutine labels lack underscores for the most part.
The exception here is templated names, where each part of the template is
separated from the rest of the label by underscores. It's easy to figure
out what a templated name refers to, because the template makes it obvious.
For example, Obj##_ always refers to code, because the concept of "object" as
it applies to Genesis Sonic games only makes sense when applied to executable
code.

Variables and labels that are relative to the start of Z80 RAM begin with
a lowercase "z" character. The Z80 sound driver code is in ```Sound/Z80 Driver.asm```.

Colons after certain labels were removed; this is because they ended with
the names of other more important labels and would otherwise make searching
for those other labels more difficult. In those cases, the colon is replaced
with a space, so there is still something to add to your search if you
want to find the definition of one of these conflicting less-important labels.
This only applies to labels starting with "JmpTo_" or "BranchTo_".

As comments on lines that change a subroutine counter, ```=>``` to means
*"this changes the state such that this subroutine will get called:"*
On lines that change a subtype or data loading param, ```<==``` to means
*"this changes the state such that this data will get loaded:"*

In case you want to change the object status table offset values:
Many of these aren't completely safe to change because
some code implicitly assumes the existing order when setting multiple variables,
but swapping x with y, mappings with a position variable,
or variables above $19 with each other should be safe, if you know what you're doing.

The rest of this document is somewhat out of date.

## Templates
```
Obj$(NAME\_OF\_OBJECT)
	Start of object code.
  
Obj_$(OBJECT\_REF\_NUM)_subtbl
	Jump table of subroutine pointers. May be appended with '2' if this is a
	secondary jump table (i.e. it goes with the secondary routine counter).

Obj_$(OBJECT\_REF\_NUM)_sub_$(SUBROUTINE\_VALUE)
	Start of an object subroutine.

MapUnc_$(OBJECT\_REF\_NUM)
	Sprite table for $(OBJECT\_REF\_NUM). If an object has more than one, each is
	appended by _primary, _scndary, _trnary, etc. If a single table is used
	by multiple objects, the reference number of each is listed.
```
Blocks marked (!) require further investigation.

# Folder structure

The project is organised around the three things you actually work on, an object, a zone, or a
game mode, and each of those gets one self-contained folder with everything that belongs to it,
code, animation data, mappings, art, palettes, layouts, all together instead of spread out.

Art in particular lives inside the thing it belongs to, so you're never hunting across the repo
for a zone's art separately from the rest of that zone.

```
Objects/                  every object: code + anim + maps + art
Levels/                    every zone & special stage: collision, layouts, palettes, objpos, art, blocks, chunks
Modes/               every game mode: zone, title, special stage, ending, ...
Libraries/                shared engine code
Sound/                    music, sound effects and the sound driver
sonic2.asm                 main source; the include/binclude statements that reference everything
```

---

## Objects

One folder per object type: badnik, bosses, global, effects misc, holds each objects code, animation data, mappings
and art:

```
Objects/Global/
    Monitor.asm          object code
    Animations/Monitor.ani                 animation script
    Mappings/Monitor.map                 sprite mappings
    Cells/Monitor.nem            art
```

Every object lives here without exception, badniks, bosses, the title screen and ending objects,
the special stage objects, all of it. If it has an object ID, this is where you look, so you
never have to guess which tree it might be filed under instead.

That matters most for objects shared between zones. Crabmeat shows up in both Green Hill and
Spring Yard, Caterkiller in both Marble and Scrap Brain, and filing those under a zone would mean
either duplicating them or picking one zone arbitrarily to own them, neither of which is great.

`Objects/shared/` holds the subroutines objects call into (`sub SolidObject.asm`,
`sub AnimateSprite.asm`, and so on), the mapping macros, and any art that doesn't belong to one
specific object. `Objects/shared/Boss/` holds the Eggman mappings, animation and art that every
boss builds its own code on top of.

---

## Zones

One folder per zone, holding everything that defines it:

```
Zones/EHZ/
    Cells/                  zone art
    Blocks.eni              16x16 block mappings
    Chunks.kos              128x128 chunk mappings
    Collision.bin           front collision index
    Back Collision.bin      back collision index
    Act */Demo.asm          credits demo input data
    Act */Layouts.bin       foreground and background level layouts
    Act */Objects.bin       object placement
    Act */Start Position    Sonic's starting positions
    Palettes/               zone palettes and palette cycles
```

Zones are Emerald Hill, Chemical Plant, Hill Top, Aquatic Ruin, Carnival Night, Mystic Cave, Metropolis, Sky Chase, Wing Fortress and Death Egg.

Zones for Wood, Hidden Palace, and unknowns reside in Levels/Unused.

`Zones/Collision/` holds the cross-zone stuff, the collision arrays and angle map every zone uses.

---

## Game Modes

One assmebly file per game mode, `Zone`, `SEGA`, `Title Screen`, `Special Stage`,
`Continue Screen` and `Menus`.

```
Modes/
    Title Screen.asm    game mode code
    SEGA.asm            game mode code
    Cells/              art 
    Mappings/           block mappings
    Palettes/           palettes
    Palettes/Cycle/      palette cycles
    Maps/               foreground/background tilemaps
```

`sonic2.asm` keeps the game mode table plus the startup, interrupt and main loop code, and pulls
the modes in as includes in the order the ROM expects. That order has to stay put, since it's
what puts the code at the addresses the game actually jumps to.

---

## What stayed where it was

- `Libraries/`, engine code that doesn't belong to any single zone or object: level drawing,
  layer deformation, pattern load cues, palette fading, the object pointer table, HUD updating.
- `Sound/`, the sound driver, its RAM definitions, the music and the sound effects.
- `sonic2.asm`, the main source of the game. Every `include` and `binclude` 
  statement still lives in this file, in ROM order, only the paths changed.
- `_Fixed Binaries/`, optional replacement files for bugs the `FixBugs` flag can't patch. It
  mirrors the layout above, so each replacement sits at the path it'd occupy in the project
  proper.

HUD ends up split on purpose here. `Cards/HUD/` holds object 21 with its mappings and art,
while `Libraries/HUD Update.asm` stays with the engine, the object does nothing other than
render the formatted data, meanwhile the update routine handles the BCD for numerics and
various bonuses, such as gaining a life after collecting X rings.

---

## Conventions

Art goes straight in `Cells/`. The file extension already tells you the compression, `.nem` is
Nemesis, `.unc` is uncompressed, `.kos` is Kosinski, so there's no need for a separate folder per
format on top of that. Mappings follow the same idea, `.eni` for Enigma.