[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkImage**

# tkImage

Loads an image file once and draws it in any tkControls window.

`tkImageFile` holds one decoded image. You declare it, load it once, keep it as long as something shows it, and draw it with `tkImage_Paint` from a paint callback. The decoded pixels stay in memory; a texture is made the first time the image is drawn in a window and kept for that window, so the same image can appear in the main window, a popup menu and a tooltip. When a window goes, its textures go with it.

Formats are SDL_image's: `.png`, `.bmp`, `.jpg` / `.jpeg`, `.gif`, `.ico` / `.cur`, `.tga`, `.qoi` and more. Controls with an image slot load one for you from a path, for example `tkToolbar_SetItemImage` and `tkIconPanel_SetImage`.

## Importing

```freebasic
#import "vendor/tkControls/tkImage"

using tkImage
using tkHost
using tkPaint
```

tkImage re-exports [tkHost](tkHost), and through it [tkPaint](tkPaint), which holds `TK_IMGFIT_*`. On Linux, put any `std/*` import before the tkControls ones.

## Example

```freebasic
#import "vendor/tkControls/tkApp"
#import "vendor/tkControls/tkImage"
using tkApp
using tkHost
using tkPaint
using tkImage

dim shared as tkImageFile gLogo

sub Main_Paint( byval f as TK_FORM ptr, byval b as TK_PAINT ptr )
    dim as TKRECT rc
    tkRect_Set( rc, 0, 0, tkForm_Scale( f, 96 ), tkForm_Scale( f, 96 ) )
    tkImage_Paint( b, @gLogo, @rc, TK_IMGFIT_ASPECT )   ' nothing when the load failed
end sub

tkApp_Init()
if gLogo.Load( "logo.png" ) = 0 then print "logo.png: " & *SDL_GetError()
dim as TK_FORM ptr f = tkApp_NewForm( "Logo", 320, 200 )
tkForm_OnPaint( f, @Main_Paint )
end tkApp_Run( f )
```

- `Load( path )`, `LoadFromSurface( s )` (copies an `SDL_Surface`; you keep yours) and `LoadFromPixels( w, h, argb )` (rows of `&hAARRGGBB`) return non-zero on success. A failed load clears the image held before.
- `NaturalWidth` / `NaturalHeight` give the size in pixels; `IsValid` says whether an image is held; `Dispose` frees it early.
- `TK_IMGFIT_ASPECT` fits the image inside the rect with its proportions kept, `_STRETCH` fills the rect, `_CENTER` draws it at its natural size, centred and clipped.
- `Surface()` and `Texture( renderer )` hand out what the object owns: never destroy them.

## Coming from PsImage

| [PsImage](PsImage) | tkImage |
| --- | --- |
| `PsImageFile` | `tkImageFile` |
| `PS_IMGFIT_*` | `TK_IMGFIT_*` (in [tkPaint](tkPaint)) |
| `buffer.PaintImage( img.Image( ), rc, fit )` | `tkImage_Paint( b, @img, @rc, fit )` |
| `Image( )` | `Surface( )`, `Texture( renderer )` |
| `LoadFromBitmap` (`HBITMAP`), `LoadFromIcon` (`HICON`) | `LoadFromSurface`, `LoadFromPixels` |

- Decoding is SDL_image's, so the formats are SDL_image's rather than GDI+'s.
- One object draws in every window; there is nothing to reload per window or per scale.

The [PsImage](PsImage) page remains the behaviour reference for everything not listed here.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Types

```freebasic
type TKIMG_TEX
    r   as SDL_Renderer ptr
    tex as SDL_Texture ptr
end type

type tkImageFile
    pSurf      as SDL_Surface ptr
    cache(0 to 7) as TKIMG_TEX
    pNextLive  as tkImageFile ptr
    pPrevLive  as tkImageFile ptr
    declare sub DropTextures()
    declare constructor()
    declare destructor()
    declare function Load( byval path as ustring ) as long
    declare function LoadFromSurface( byval s as SDL_Surface ptr ) as long
    declare function LoadFromPixels( byval w as long, byval h as long, byval argb as ulong ptr ) as long
    declare sub Dispose()
    declare function IsValid() as long
    declare function NaturalWidth() as long
    declare function NaturalHeight() as long
    declare function Surface() as SDL_Surface ptr
    declare function Texture( byval r as SDL_Renderer ptr ) as SDL_Texture ptr
    declare sub PurgeRenderer( byval r as SDL_Renderer ptr )
end type
```

### Procedures

```freebasic
sub tkImage_Paint( byval p as TK_PAINT ptr, byval img as tkImageFile ptr, byval rc as TKRECT ptr, byval nFit as long = TK_IMGFIT_ASPECT )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsImage](PsImage), the PsControls module
