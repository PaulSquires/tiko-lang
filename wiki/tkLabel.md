[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkLabel**

# tkLabel

Shows a line or block of text that the user can't edit.

`tkLabel` is the [tkControls](Category-tkControls) caption. It is never a tab stop. A one-line label can cut its text with an ellipsis when it does not fit; a wrapped label breaks the text at word boundaries and clips it to the control. The text sits left, centred or right (`LBL_ALIGN_*`) and top, middle or bottom (`LBL_VALIGN_*`) inside the client area.

The label is transparent by default, so it shows whatever is behind it. `tkLabel_SetBackColor` gives it a background of its own. With auto size on, the control resizes to its text whenever the text, font or wrapping changes.

A click is reported only when a click callback is set. Without one the label takes no mouse input of its own. The callback runs on the mouse release, and only if the cursor is still inside the label.

Any run of the text can be a **link**: a few words inside an ordinary sentence, drawn in the link colour and underlined, with the hand cursor over them. A click on a link goes to the link callback; if no callback handles it, the link's URL opens in the browser.

## Importing

```freebasic
#import "vendor/tkControls/tkLabel"

using tkLabel
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and SDL_image) and [tkTheme](tkTheme).

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example.

```freebasic
sub Hint_Click( byval hLabel as TK_WIDGET ptr, byval id as long )
    print "label " & id & " clicked"
end sub

dim as TK_WIDGET ptr lbl = tkLabel_Create( tkHost_Root( host ), 2000 )
tkLabel_SetText( lbl, "A long caption that wraps to the width of the control." )
tkLabel_SetWordWrap( lbl, true )
tkLabel_SetAlign( lbl, LBL_ALIGN_CENTER )
tkLabel_SetVAlign( lbl, LBL_VALIGN_TOP )
tkLabel_SetClickCallback( lbl, @Hint_Click )

tkWidget_SetPos( lbl, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), _
                 tkHost_Scale( host, 240 ), tkHost_Scale( host, 60 ) )
```

A single line that sizes itself:

```freebasic
dim as TK_WIDGET ptr title = tkLabel_Create( tkHost_Root( host ), 2001 )
tkLabel_SetAutoSize( title, true )
tkLabel_SetText( title, "Settings" )     ' the control is now as wide as the text
```

## Links

`tkLabel_AddLink` names a link by its words: the first run of the label's text that reads them, and is not a link already, becomes one. The rest of the text stays plain.

```freebasic
function Label_Link( byval hLabel as TK_WIDGET ptr, byval id as long, _
                     byval nLink as long, byref url as ustring ) as boolean
    if len( url ) then return false             ' not handled: the browser opens the URL
    print "clicked: " & tkLabel_GetLinkText( hLabel, nLink )
    return true                                 ' handled: nothing more happens
end function

dim as TK_WIDGET ptr about = tkLabel_Create( tkHost_Root( host ), 2003 )
tkWidget_SetPos( about, tkHost_Scale( host, 20 ), tkHost_Scale( host, 90 ), _
                 tkHost_Scale( host, 400 ), tkHost_Scale( host, 28 ) )
tkLabel_SetText( about, "Read more at tiko-lang.net, or show the version." )
tkLabel_AddLink( about, "tiko-lang.net", "https://tiko-lang.net" )
tkLabel_AddLink( about, "show the version", "" )    ' no URL: only the callback hears it
tkLabel_SetLinkClickCallback( about, @Label_Link )
```

`examples/tkControls/tkLabel/demo.tiko` has this label on its last row.

## Typed wrapper

The module also provides `Label`, a typed value for designed forms (see [tkForms](tkForms) and the [Form Designer](Form-Designer)). `Label.Handle` is the `TK_WIDGET ptr` and reaches the whole API above. It has `Create( hParent, id )`, `SetFocus( )`, and these properties, each read and write:

`Enabled`, `Visible`, `Text`, `Align`, `VAlign`, `WordWrap`, `Ellipsis`, `AutoSize`, `TextColor`, `BackColor`, `Transparent`, `Font`.

```freebasic
dim as Label lbl
lbl.Create( tkHost_Root( host ), 2002 )
lbl.Text = "Name:"
lbl.Align = LBL_ALIGN_RIGHT
```

## Behaviour notes

- `tkLabel_SetAlign` and `tkLabel_SetVAlign` ignore a value outside the enums.
- `tkLabel_GetIdealSize` measures the text with the label's font. For a wrapped label the ideal width is the current width, and only the height comes from the text.
- `tkLabel_SetTextColor` and `tkLabel_SetBackColor` pin the colours: they then survive a theme change until `tkLabel_UnpinColors`. `tkLabel_SetBackColor` also turns the background on.
- `tkLabel_SetFont` borrows the font: it must outlive the label. Pass 0 to return to the surface's default font.
- A disabled label draws its text in `TextColorDisabled`, links included, and its links take no clicks.
- `tkLabel_AddLink` returns the link's index, or -1 when the text has no free run of those words. Call it after `tkLabel_SetText`: new text drops every link, since the links named runs of the old text.
- A link may have an empty URL. Its clicks then do nothing unless the link callback acts on them.
- A label with links lays its text out itself: hard line breaks always, and with word wrap the control's width. It ignores the ellipsis setting. A link that wraps is underlined on each of its lines and can be clicked on any of them.
- The link colour is the theme's `Accent`, and `AccentHot` under the mouse. `tkLabel_SetLinkColor` pins both until `tkLabel_UnpinColors`.
- Links are not tab stops, and a key press does not follow one. Give keyboard users another way to reach the address.
- `tkLabel_LinkAt` and `tkLabel_GetLinkRect` work in the label's client coordinates. `tkLabel_GetLinkRect` gives the rectangle of the link's first line.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
enum
    LBL_ALIGN_LEFT = 0
    LBL_ALIGN_CENTER
    LBL_ALIGN_RIGHT
end enum

enum
    LBL_VALIGN_TOP = 0
    LBL_VALIGN_CENTER
    LBL_VALIGN_BOTTOM
end enum
```

### Types

```freebasic
type TKLABEL_COLORS
    TextColor         as ulong
    TextColorDisabled as ulong
    BackColor         as ulong
end type

type TKLABEL_STATE   ' per-instance state; reach it through the procedures

type LBL_ClickCallbackSub as sub( byval hLabel as TK_WIDGET ptr, byval id as long )
' A link was clicked: TRUE = handled. Unhandled, its URL (when it has one) opens in the browser.
type LBL_LinkClickFunc as function( byval hLabel as TK_WIDGET ptr, byval id as long, _
                                    byval nLink as long, byref url as ustring ) as boolean

' One link: a run of the text's UTF-8 bytes, [nStart, nEnd).
type TKLABEL_LINK
    nStart as long
    nEnd   as long
    url    as ustring
end type

' One piece of a laid-out line: plain text, or (nLink >= 0) all or part of a link.
type TKLABEL_RUN
    nStart as long
    nEnd   as long
    nLink  as long
    rc     as TKRECT        ' client coordinates
end type
```

### Procedures

```freebasic
function tkLabel_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as long ) as TK_WIDGET ptr
function tkLabel_GetText( byval h as TK_WIDGET ptr ) as ustring
sub tkLabel_SetText( byval h as TK_WIDGET ptr, byref s as const ustring )
sub tkLabel_SetFont( byval h as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkLabel_GetFont( byval h as TK_WIDGET ptr ) as TTF_Font ptr
function tkLabel_GetAlign( byval h as TK_WIDGET ptr ) as long
sub tkLabel_SetAlign( byval h as TK_WIDGET ptr, byval nAlign as long )
function tkLabel_GetVAlign( byval h as TK_WIDGET ptr ) as long
sub tkLabel_SetVAlign( byval h as TK_WIDGET ptr, byval nVAlign as long )
function tkLabel_GetWordWrap( byval h as TK_WIDGET ptr ) as boolean
sub tkLabel_SetWordWrap( byval h as TK_WIDGET ptr, byval bWrap as boolean )
function tkLabel_GetEllipsis( byval h as TK_WIDGET ptr ) as boolean
sub tkLabel_SetEllipsis( byval h as TK_WIDGET ptr, byval bEllipsis as boolean )
function tkLabel_GetAutoSize( byval h as TK_WIDGET ptr ) as boolean
sub tkLabel_SetAutoSize( byval h as TK_WIDGET ptr, byval bAutoSize as boolean )
sub tkLabel_GetIdealSize( byval h as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
function tkLabel_GetTextColor( byval h as TK_WIDGET ptr ) as ulong
sub tkLabel_SetTextColor( byval h as TK_WIDGET ptr, byval clr as ulong )
function tkLabel_GetBackColor( byval h as TK_WIDGET ptr ) as ulong
sub tkLabel_SetBackColor( byval h as TK_WIDGET ptr, byval clr as ulong )
function tkLabel_GetTransparent( byval h as TK_WIDGET ptr ) as boolean
sub tkLabel_SetTransparent( byval h as TK_WIDGET ptr, byval bTransparent as boolean )
sub tkLabel_SetClickCallback( byval h as TK_WIDGET ptr, byval usersub as LBL_ClickCallbackSub )
function tkLabel_ThemeColors( byref t as TKTHEME_COLORS ) as TKLABEL_COLORS
sub tkLabel_ApplyTheme( byval h as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkLabel_UnpinColors( byval h as TK_WIDGET ptr )
function tkLabel_AddLink( byval h as TK_WIDGET ptr, byref sWords as const ustring, byref url as const ustring ) as long
sub tkLabel_ClearLinks( byval h as TK_WIDGET ptr )
function tkLabel_GetLinkCount( byval h as TK_WIDGET ptr ) as long
function tkLabel_GetLinkUrl( byval h as TK_WIDGET ptr, byval nLink as long ) as ustring
function tkLabel_GetLinkText( byval h as TK_WIDGET ptr, byval nLink as long ) as ustring
function tkLabel_LinkAt( byval h as TK_WIDGET ptr, byval x as long, byval y as long ) as long
function tkLabel_GetLinkRect( byval h as TK_WIDGET ptr, byval nLink as long, byref rc as TKRECT ) as boolean
sub tkLabel_SetLinkClickCallback( byval h as TK_WIDGET ptr, byval cb as LBL_LinkClickFunc )
function tkLabel_GetLinkColor( byval h as TK_WIDGET ptr ) as ulong
sub tkLabel_SetLinkColor( byval h as TK_WIDGET ptr, byval clr as ulong, byval clrHot as ulong = 0 )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost), [tkTheme](tkTheme)
- [tkForms](tkForms), [tkLayout](tkLayout)
