[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkFontList**

# tkFontList

Lists the fonts installed on the machine by family, style and file.

SDL_ttf opens font **files** and has no list of installed fonts, so tkFontList builds one: `tkFontList_Scan` walks font folders and asks SDL_ttf about every face of every `.ttf`, `.otf` and `.ttc` file (family, style, bold, italic, fixed pitch). Use it for a font picker, or to turn a family name a user typed into the file a tkControls font call needs. [tkApp](tkApp) uses it to find an installed family when a font file it was given is missing.

Scanning opens every face, so it is not free: scan once, when a picker first needs the list. SDL_ttf must be started first (`tkApp_Init` does it).

## Importing

```freebasic
#import "std/containers"
#import "vendor/tkControls/tkFontList"

using containers
using tkFontList
```

`tkFontList_Families` returns an `Array( of string )`, so import `std/containers` to declare one. tkFontList imports `std/fs` and `std/containers` itself and re-exports [tkHost](tkHost).

## Example

```freebasic
dim as long n = tkFontList_Scan()                ' this platform's font folders
print n & " faces in " & int( tkFontList_ScanMs() ) & " ms"

dim as Array( of string ) mono = tkFontList_Families( true )   ' fixed-pitch families only
for each fam as string in mono
    print fam
next

dim as string f = tkFontList_Find( "DejaVu Sans Mono", true )  ' its bold file
if len( f ) = 0 then print "not installed"
```

- `tkFontList_Scan( dirs )` takes folders separated by line feeds; with none it scans `tkFontList_SystemDirs()`: the Windows fonts folder and the per-user one on Windows, `/usr/share/fonts`, `/usr/local/share/fonts` and `~/.local/share/fonts` on Linux, the system, library and user font folders on macOS. Each scan replaces the last; a folder that does not exist is skipped.
- `tkFontList_Families( bMonoOnly )` gives each family once, sorted, ignoring case.
- `tkFontList_Find( family, bBold, bItalic )` gives the file, or `""` when the family is not installed. A missing bold or italic cut falls back to the regular face, then to any face of the family.
- `tkFontList_Count` and `tkFontList_Face( i )` walk every face as `TKFONT_FACE` records.

## Faces in a collection

A `.ttc` file holds several faces, so its face is written `"path|Family"`: the family selects the face inside the file. That is the spelling [tkCodeEdit](tkCodeEdit)'s `tkCodeEdit_SetFontFace` and `tkCodeEdit_SetFallbackFonts` take. A plain `TTF_OpenFont` or `tkHost_OpenFont` wants a bare path, so skip a result that contains `|` there, or split it first.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Types

```freebasic
type TKFONT_FACE
    family as string                  ' UTF-8, as the font names itself
    style  as string                  ' "Regular", "Bold", "Italic", "Bold Italic", ...
    file   as string                  ' "path", or "path|family" for a face of a .ttc
    bMono  as boolean                 ' fixed pitch
    bBold  as boolean
    bItalic as boolean
end type
```

### Procedures

```freebasic
function tkFontList_SystemDirs() as string
function tkFontList_Scan( byref dirs as string = "" ) as long
function tkFontList_ScanMs() as double
function tkFontList_Count() as long
function tkFontList_Face( byval i as long ) as TKFONT_FACE
function tkFontList_Families( byval bMonoOnly as boolean = false ) as Array( of string )
function tkFontList_Find( byref family as string, byval bBold as boolean = false, byval bItalic as boolean = false ) as string
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
