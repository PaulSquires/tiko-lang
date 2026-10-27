[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkTest**

# tkTest

Drives tkControls self-tests by pushing real SDL input events and checking the results.

tkTest is the small kit the toolchain's `examples/tkControls/*/selftest.tiko` programs are written with, and it serves a self-test of your own program or widget the same way. Input is never faked by calling a control directly: each `tkTest_Push*` call pushes the SDL event a user would have produced and pumps the surface, so the code under test runs the same dispatch path as the real program. Coordinates are window pixels.

## Importing

```freebasic
#import "vendor/tkControls/tkTest"

using tkTest
using tkHost
```

tkTest re-exports [tkHost](tkHost). On Linux, put any `std/*` import before the tkControls ones.

## Example

```freebasic
#import "vendor/tkControls/tkButton"
#import "vendor/tkControls/tkTest"
using tkButton
using tkTest
using tkHost

dim shared as long gClicks
sub OnClick( byval hButton as TK_WIDGET ptr, byval id as long )
    gClicks += 1
end sub

if tkTest_Init() = false then end 99
tkTest_Begin( "scale 1.0" )
dim as TK_HOST ptr h = tkHost_Create( "selftest", 400, 200, tkHost_FontDir() & TK_FONT_UI, 1.0 )
dim as TK_WIDGET ptr b = tkButton_Create( tkHost_Root( h ), 1 )
tkButton_SetClickCallback( b, @OnClick )
tkWidget_SetPos( b, 20, 20, 120, 32 )
tkHost_Show( h )
tkHost_Pump( h )
tkTest_Click( h, tkTest_CX( b ), tkTest_CY( b ) )
tkTest_Check( "a click fires the callback once", gClicks = 1, "clicks=" & gClicks )
tkHost_Destroy( h )
dim as long nFail = tkTest_Report( "mybutton" )
tkTest_Quit()
end nFail                                   ' the exit code is the number of failures
```

- **Results:** `tkTest_Check( name, ok, detail )` prints only failures, tagged with the pass name `tkTest_Begin` set; `tkTest_Report` prints one summary line and returns the failure count.
- **Input:** `tkTest_PushMotion`, `PushButton`, `Click`, `PushWheel`, `PushKey` (with an optional scancode, for [tkKeys](tkKeys) chords), `PushText`, `PushEditing` (an IME composition), `PushDrop` and `PushWindowEvent`.
- **Time:** `tkTest_PumpFor( h, ms )` runs the loop in real time, so timers fire and popups appear.
- **Pixels:** after `tkHost_RenderTo( h, false )`, `tkTest_PixelAt`, `tkTest_TonesIn` and `tkTest_HashRect` read the back buffer.
- Pin the scale with `tkHost_Create`'s last argument (the examples run every test at 1.0 and 1.75) so geometry can be asserted exactly.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Procedures

```freebasic
sub tkTest_Begin( byref passName as const string )
sub tkTest_Check( byref name_ as const string, byval ok as boolean, byref detail as const string = "" )
function tkTest_Passed() as long
function tkTest_Failed() as long
function tkTest_Report( byref title as string ) as long
function tkTest_Init() as boolean
sub tkTest_Quit()
sub tkTest_PushMotion( byval h as TK_HOST ptr, byval px as single, byval py as single )
sub tkTest_PushButton( byval h as TK_HOST ptr, byval bDown as boolean, byval px as single, byval py as single, byval button as long = SDL_BUTTON_LEFT, byval clicks as long = 1 )
sub tkTest_Click( byval h as TK_HOST ptr, byval px as single, byval py as single, byval button as long = SDL_BUTTON_LEFT, byval clicks as long = 1 )
sub tkTest_PushWheel( byval h as TK_HOST ptr, byval px as single, byval py as single, byval dx as single, byval dy as single )
sub tkTest_PushKey( byval h as TK_HOST ptr, byval key as long, byval mods as long = 0, byval bDown as boolean = true, byval scancode as long = 0 )
sub tkTest_PushText( byval h as TK_HOST ptr, byref s as ustring )
sub tkTest_PushDrop( byval h as TK_HOST ptr, byref items as string, byval px as single, byval py as single, byval bText as boolean = false )
sub tkTest_PushEditing( byval h as TK_HOST ptr, byref s as ustring, byval nStart as long, byval nLen as long )
sub tkTest_PushWindowEvent( byval h as TK_HOST ptr, byval t as Uint32 )
function tkTest_CX( byval w as TK_WIDGET ptr ) as single
function tkTest_CY( byval w as TK_WIDGET ptr ) as single
sub tkTest_PumpFor( byval h as TK_HOST ptr, byval ms as long )
function tkTest_TonesIn( byval h as TK_HOST ptr, byval x as long, byval y as long, byval w as long, byval hh as long, byref c0 as ulong ) as long
function tkTest_PixelAt( byval h as TK_HOST ptr, byval x as long, byval y as long ) as ulong
function tkTest_HashRect( byval h as TK_HOST ptr, byval x as long, byval y as long, byval w as long, byval hh as long ) as ulongint
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
