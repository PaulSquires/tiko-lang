[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **Direct2D stroke styles and multithreading**

# Direct2D stroke styles and multithreading
Holds Direct2D stroke styles, reads back their settings and locks a multithreaded factory.

<!-- scope: CID2D1StrokeStyle -->
<!-- scope: CID2D1StrokeStyle1 -->
<!-- scope: CID2D1Multithread -->

Holds Direct2D stroke styles, reads back their settings and locks a multithreaded factory.

**Stroke styles.** A stroke style says how a line or an outline is drawn beyond its colour and
width: the shape of its two ends and of the ends of each dash (the caps), how two segments meet at
a corner (the join), how far a mitred corner may stick out (the miter limit), and the dash
pattern. A [CD2D1Factory](CD2D1Factory) creates one with
[CreateStrokeStyle](CD2D1Factory#createstrokestyle) or
[CreateStrokeStyle1](CD2D1Factory#createstrokestyle1); a render target's `DrawLine`,
`DrawRectangle`, `DrawEllipse` and `DrawGeometry` take it as their last argument, and `NULL` there
means a solid line with flat caps. A stroke style cannot be changed after it is created.

**The wrappers.** `CID2D1StrokeStyle` holds one `ID2D1StrokeStyle` pointer, in its public field
`m_pStrokeStyle`, and releases it in its destructor. It **takes over** the reference of the
pointer you construct it from, without adding one, so it suits the result of `CreateStrokeStyle`
directly: `dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( … )`. To wrap a pointer
you go on using yourself, call its `AddRef` first. The object converts to an
`ID2D1StrokeStyle ptr` wherever one is expected. Initialise a wrapper where you declare it:
assigning a pointer to an existing wrapper does not compile. Never copy one by value (`dim b as
CID2D1StrokeStyle = a`, or a `byval` parameter): the copy holds the same pointer and both release
it.

`CID2D1StrokeStyle1` does the same for `ID2D1StrokeStyle1`, the stroke style of
[CD2D1Factory1](CD2D1Factory#cd2d1factory1) that adds a transform type. It inherits every reader
of `CID2D1StrokeStyle`.

**Multithreading.** A factory created with `D2D1_FACTORY_TYPE_MULTI_THREADED` locks itself around
every Direct2D call, so several threads may share it and its resources. When a thread also uses
Direct3D or DXGI objects that Direct2D uses, it must hold that same lock: query the factory for
`IID_ID2D1Multithread` and wrap the result in a `CID2D1Multithread`, which takes over that
reference like the stroke-style wrapper.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A window with one line in each of four stroke styles: solid with round ends, dashed, dotted with
round dots, and a custom dash-dot pattern with square ends. The wrappers release the stroke
styles when `RenderScene` returns:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/direct2d"
using win, gui, direct2d

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

' Draws one line in each of four stroke styles into a GDI device context
function RenderScene( byval hDC as HDC, byval nWidth as long, byval nHeight as long ) as HRESULT
    dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
    dim pRT as ID2D1DCRenderTarget ptr = factory.CreateDCRenderTarget()
    if pRT = NULL then return GetLastError()
    dim rc as RECT = ( 0, 0, nWidth, nHeight )
    pRT->BindDC( hDC, rc )

    ' the wrappers release their stroke styles when they go out of scope
    dim custom(3) as FLOAT = { 4, 1, 1, 1 }   ' dash 4, gap 1, dot 1, gap 1, in line widths
    dim solid as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( D2D1_CAP_STYLE_ROUND, D2D1_CAP_STYLE_ROUND ), byval NULL, 0 )
    dim dashed as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , , , , D2D1_DASH_STYLE_DASH ), byval NULL, 0 )
    dim dotted as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , D2D1_CAP_STYLE_ROUND, , , D2D1_DASH_STYLE_DOT ), byval NULL, 0 )
    dim mixed as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , D2D1_CAP_STYLE_SQUARE, , , D2D1_DASH_STYLE_CUSTOM ), custom(0), 4 )

    dim pBrush as ID2D1SolidColorBrush ptr
    pRT->CreateSolidColorBrush( D2D1_ColorF( D2D1_DarkSlateBlue ), byval NULL, pBrush )
    pRT->BeginDraw()
    pRT->Clear( D2D1_ColorF( D2D1_White ) )
    pRT->DrawLine( D2D1_Point2F( 30, 40 ), D2D1_Point2F( 270, 40 ), pBrush, 6, solid )
    pRT->DrawLine( D2D1_Point2F( 30, 80 ), D2D1_Point2F( 270, 80 ), pBrush, 6, dashed )
    pRT->DrawLine( D2D1_Point2F( 30, 120 ), D2D1_Point2F( 270, 120 ), pBrush, 6, dotted )
    pRT->DrawLine( D2D1_Point2F( 30, 160 ), D2D1_Point2F( 270, 160 ), pBrush, 6, mixed )
    dim hr as HRESULT = pRT->EndDraw()
    D2D1_SafeRelease( pBrush )
    D2D1_SafeRelease( pRT )
    return hr
end function

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "D2DStrokeDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Direct2D stroke styles", @WndProc )
    pWindow.SetClientSize( 300, 200 )
    pWindow.Center()
    dim pGraphCtx as CGraphCtx = CGraphCtx( @pWindow, 1001, "", 0, 0, pWindow.ClientWidth, pWindow.ClientHeight )
    RenderScene( pGraphCtx.GetMemDc(), pGraphCtx.GetVirtualBufferWidth(), pGraphCtx.GetVirtualBufferHeight() )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

Dash and gap lengths are multiples of the line width, so the 6-DIP custom line has 24-DIP dashes
and 6-DIP gaps and dots. The dash cap shapes the ends of every dash; the start and end caps shape
only the two ends of the line.

## Members

| Member | Does |
| --- | --- |
| **CID2D1StrokeStyle** | |
| [Constructor](#constructor) | Creates an empty wrapper, or takes over a stroke style pointer. |
| [Destructor](#destructor) | Releases the stroke style. |
| [Cast, Operator @, Operator *](#cast-operator--operator-) | Give the `ID2D1StrokeStyle` pointer, or its address. |
| [GetFactory](#getfactory) | Returns the factory that created the stroke style. |
| [GetStartCap](#getstartcap) | Returns the cap at the start of a line. |
| [GetEndCap](#getendcap) | Returns the cap at the end of a line. |
| [GetDashCap](#getdashcap) | Returns the cap at the ends of each dash. |
| [GetMiterLimit](#getmiterlimit) | Returns the miter limit. |
| [GetLineJoin](#getlinejoin) | Returns how segments meet at corners. |
| [GetDashOffset](#getdashoffset) | Returns how far into the dash pattern a line starts. |
| [GetDashStyle](#getdashstyle) | Returns the dash style. |
| [GetDashesCount](#getdashescount) | Returns the number of lengths in the dash pattern. |
| [GetDashes](#getdashes) | Copies the dash pattern into an array. |
| **CID2D1StrokeStyle1** | |
| [Constructor](#constructor-1) | Creates an empty wrapper, or takes over an `ID2D1StrokeStyle1` pointer. |
| [Destructor](#destructor-1) | Releases the stroke style. |
| [Cast, Operator @, Operator *](#cast-operator--operator--1) | Give the `ID2D1StrokeStyle1` pointer, or its address. |
| [GetFactory](#getfactory-1) | Returns the factory that created the stroke style. |
| [GetStrokeTransformType](#getstroketransformtype) | Returns whether the stroke follows the world transform. |
| **CID2D1Multithread** | |
| [Constructor](#constructor-2) | Creates an empty wrapper, or takes over an `ID2D1Multithread` pointer. |
| [Destructor](#destructor-2) | Releases the interface. |
| [Cast, Operator @, Operator *](#cast-operator--operator--2) | Give the `ID2D1Multithread` pointer, or its address. |
| [GetMultithreadProtected](#getmultithreadprotected) | Tells whether the factory locks itself. |
| [Enter](#enter) | Takes the factory's lock. |
| [Leave](#leave) | Releases the factory's lock. |

## Reference

## CID2D1StrokeStyle

### Constructor

```freebasic
constructor
constructor( byval pStrokeStyle as ID2D1StrokeStyle ptr )
```

The form with `pStrokeStyle` stores the pointer in `m_pStrokeStyle` without adding a reference:
the wrapper now owns the reference you had and releases it when it goes. The form without
arguments makes an empty wrapper, whose readers all return 0 and whose
[GetFactory](#getfactory) returns `NULL`.

| Parameter | Meaning |
| --- | --- |
| `pStrokeStyle` | A stroke style whose reference the wrapper takes over. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , , , , D2D1_DASH_STYLE_DASH ), byval NULL, 0 )
print style.GetDashStyle()   ' 1 (D2D1_DASH_STYLE_DASH)
```

Microsoft Learn: [ID2D1StrokeStyle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1strokestyle)

### Destructor

```freebasic
destructor
```

Releases the stroke style, if the wrapper holds one. Keep the wrapper alive until the drawing that
uses it has ended with `EndDraw`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pStyle as CID2D1StrokeStyle ptr = new CID2D1StrokeStyle( factory.CreateStrokeStyle( D2D1_StrokeStyleProperties(), byval NULL, 0 ) )
delete pStyle
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1StrokeStyle ptr ptr
operator cast() as ID2D1StrokeStyle ptr
operator *( byref gradientStopCollection as CID2D1StrokeStyle ) as ID2D1StrokeStyle ptr
```

`cast` gives the `ID2D1StrokeStyle` pointer, so the wrapper can be passed straight to a drawing
call; `*style` gives the same pointer. Neither adds a reference. `@` returns the address of
`m_pStrokeStyle`, for a call that writes a stroke style pointer into an output parameter; it does
not release a pointer the wrapper already holds. Applying `@` to the object currently stops the
build with an internal compiler error; pass `@style.m_pStrokeStyle` instead.

**Returns** the interface pointer (`NULL` for an empty wrapper), or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties(), byval NULL, 0 )
dim pStyle as ID2D1StrokeStyle ptr = style
print ( pStyle = *style )   ' -1: the same pointer
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Returns the factory that created the stroke style. The pointer comes with a new reference:
release it when you are done.

**Returns** the factory, or `NULL` for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties(), byval NULL, 0 )
dim pFactory as ID2D1Factory ptr = style.GetFactory()
print ( pFactory = *factory )   ' -1
D2D1_SafeRelease( pFactory )
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### GetStartCap

```freebasic
function GetStartCap() as D2D1_CAP_STYLE
```

Returns the shape drawn at the start of a line or open figure: `D2D1_CAP_STYLE_FLAT` (0, the line
stops at its end point), `…_SQUARE` (1, it goes on half the line width), `…_ROUND` (2, a half
circle) or `…_TRIANGLE` (3, a point).

**Returns** the cap, or 0 for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( D2D1_CAP_STYLE_ROUND ), byval NULL, 0 )
print style.GetStartCap()   ' 2
```

Microsoft Learn: [ID2D1StrokeStyle::GetStartCap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1strokestyle-getstartcap)

### GetEndCap

```freebasic
function GetEndCap() as D2D1_CAP_STYLE
```

Returns the shape drawn at the end of a line or open figure, one of the `D2D1_CAP_STYLE_*` values.

**Returns** the cap, or 0 for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , D2D1_CAP_STYLE_TRIANGLE ), byval NULL, 0 )
print style.GetEndCap()   ' 3
```

Microsoft Learn: [ID2D1StrokeStyle::GetEndCap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1strokestyle-getendcap)

### GetDashCap

```freebasic
function GetDashCap() as D2D1_CAP_STYLE
```

Returns the shape drawn at both ends of every dash, one of the `D2D1_CAP_STYLE_*` values. Round
or square dash caps make each dash longer by the line width, so a dot pattern needs them to show.

**Returns** the cap, or 0 for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , D2D1_CAP_STYLE_SQUARE ), byval NULL, 0 )
print style.GetDashCap()   ' 1
```

Microsoft Learn: [ID2D1StrokeStyle::GetDashCap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1strokestyle-getdashcap)

### GetMiterLimit

```freebasic
function GetMiterLimit() as FLOAT
```

Returns the miter limit: how long the point of a mitred corner may be, as a multiple of half the
line width. A sharper corner is clipped at that length, or bevelled with
`D2D1_LINE_JOIN_MITER_OR_BEVEL`. `D2D1_StrokeStyleProperties` uses 10.

**Returns** the limit, or 0 for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties(), byval NULL, 0 )
print style.GetMiterLimit()   ' 10
```

Microsoft Learn: [ID2D1StrokeStyle::GetMiterLimit](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1strokestyle-getmiterlimit)

### GetLineJoin

```freebasic
function GetLineJoin() as D2D1_LINE_JOIN
```

Returns how two segments of an outline meet: `D2D1_LINE_JOIN_MITER` (0, a sharp point, clipped
at the miter limit), `…_BEVEL` (1, cut off), `…_ROUND` (2, rounded) or `…_MITER_OR_BEVEL`
(3, a sharp point, or a bevel when the point would pass the miter limit).

**Returns** the join, or 0 for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , , D2D1_LINE_JOIN_BEVEL ), byval NULL, 0 )
print style.GetLineJoin()   ' 1
```

Microsoft Learn: [ID2D1StrokeStyle::GetLineJoin](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1strokestyle-getlinejoin)

### GetDashOffset

```freebasic
function GetDashOffset() as FLOAT
```

Returns how far into the dash pattern a line starts, in multiples of the line width. A positive
offset shifts the pattern towards the start of the line, so animating it makes the dashes march.

**Returns** the offset, or 0 for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , , , , D2D1_DASH_STYLE_DASH, 0.5 ), byval NULL, 0 )
print style.GetDashOffset()   ' 0.5
```

Microsoft Learn: [ID2D1StrokeStyle::GetDashOffset](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1strokestyle-getdashoffset)

### GetDashStyle

```freebasic
function GetDashStyle() as D2D1_DASH_STYLE
```

Returns the dash style: `D2D1_DASH_STYLE_SOLID` (0), `…_DASH` (1), `…_DOT` (2), `…_DASH_DOT` (3),
`…_DASH_DOT_DOT` (4) or `…_CUSTOM` (5, the pattern given to the factory).

**Returns** the dash style, or 0 for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , , , , D2D1_DASH_STYLE_DASH_DOT ), byval NULL, 0 )
print style.GetDashStyle()   ' 3
```

Microsoft Learn: [ID2D1StrokeStyle::GetDashStyle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1strokestyle-getdashstyle)

### GetDashesCount

```freebasic
function GetDashesCount() as UINT32
```

Returns how many lengths the dash pattern has. A solid stroke has none; the predefined styles have
their own patterns, two lengths for a dash or a dot and four for a dash-dot; a custom style has the
number given to the factory.

**Returns** the count, or 0 for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , , , , D2D1_DASH_STYLE_DASH_DOT ), byval NULL, 0 )
print style.GetDashesCount()   ' 4
```

Microsoft Learn: [ID2D1StrokeStyle::GetDashesCount](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1strokestyle-getdashescount)

### GetDashes

```freebasic
sub GetDashes( byref dashes as FLOAT, byval dashesCount as UINT32 )
```

Copies the dash pattern, alternating dash and gap lengths in multiples of the line width, into an
array of `dashesCount` elements; pass the array's first element. Size the array with
[GetDashesCount](#getdashescount). The predefined `D2D1_DASH_STYLE_DASH` pattern reads back as
2, 2 and `D2D1_DASH_STYLE_DOT` as 0, 2: a dot is a dash of length 0 that only its dash caps make
visible.

| Parameter | Meaning |
| --- | --- |
| `dashes` | The first element of the array that receives the pattern. |
| `dashesCount` | The number of elements in the array. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pattern(2) as FLOAT = { 4, 1, 2 }
dim style as CID2D1StrokeStyle = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( , , , , , D2D1_DASH_STYLE_CUSTOM ), pattern(0), 3 )
dim got(2) as FLOAT
style.GetDashes( got(0), style.GetDashesCount() )
print got(0); got(1); got(2)   ' 4 1 2
```

Microsoft Learn: [ID2D1StrokeStyle::GetDashes](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1strokestyle-getdashes)

## CID2D1StrokeStyle1

`CID2D1StrokeStyle1` extends `CID2D1StrokeStyle` and holds an `ID2D1StrokeStyle1` in
`m_pStrokeStyle1`. The constructor stores the same object in the inherited `m_pStrokeStyle` too,
so every reader above works on it. The wrapper converts to an `ID2D1StrokeStyle1 ptr`, which in
turn converts to the `ID2D1StrokeStyle ptr` a drawing call takes; the wrapper itself does not go
there directly, so write `dim p as ID2D1StrokeStyle1 ptr = style` first, or pass
`style.m_pStrokeStyle`.

### Constructor

```freebasic
constructor
constructor( byval pStrokeStyle1 as ID2D1StrokeStyle1 ptr )
```

The form with `pStrokeStyle1` takes over the reference of the pointer, like the
[CID2D1StrokeStyle constructor](#constructor): it stores the pointer in both fields and adds one
reference, which its two destructors release. The form without arguments makes an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle1 = factory.CreateStrokeStyle1( D2D1_StrokeStyleProperties1( D2D1_CAP_STYLE_ROUND ), byval NULL, 0 )
print style.GetStartCap()   ' 2: the inherited readers work
```

Microsoft Learn: [ID2D1StrokeStyle1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1strokestyle1)

### Destructor

```freebasic
destructor
```

Releases `m_pStrokeStyle1`; the inherited destructor then releases `m_pStrokeStyle`.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pStyle as CID2D1StrokeStyle1 ptr = new CID2D1StrokeStyle1( factory.CreateStrokeStyle1( D2D1_StrokeStyleProperties1(), byval NULL, 0 ) )
delete pStyle
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1StrokeStyle1 ptr ptr
operator cast() as ID2D1StrokeStyle1 ptr
operator *( byref gradientStopCollection as CID2D1StrokeStyle1 ) as ID2D1StrokeStyle1 ptr
```

`cast` and `*` give the `ID2D1StrokeStyle1` pointer without adding a reference. `@` returns the
address of `m_pStrokeStyle1` only: a pointer stored through it leaves `m_pStrokeStyle` empty, so
the inherited readers would return 0. Applying `@` to the object currently stops the build with an
internal compiler error.

**Returns** the interface pointer, or the address of `m_pStrokeStyle1`.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle1 = factory.CreateStrokeStyle1( D2D1_StrokeStyleProperties1(), byval NULL, 0 )
dim p1 as ID2D1StrokeStyle1 ptr = style
dim p as ID2D1StrokeStyle ptr = p1   ' what DrawLine and DrawGeometry take
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Returns the factory that created the stroke style, with a new reference that you release, like
[CID2D1StrokeStyle.GetFactory](#getfactory).

**Returns** the factory, or `NULL` for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim style as CID2D1StrokeStyle1 = factory.CreateStrokeStyle1( D2D1_StrokeStyleProperties1(), byval NULL, 0 )
dim pFactory as ID2D1Factory ptr = style.GetFactory()
D2D1_SafeRelease( pFactory )
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### GetStrokeTransformType

```freebasic
function GetStrokeTransformType() as D2D1_STROKE_TRANSFORM_TYPE
```

Returns how the stroke reacts to the render target's world transform:
`D2D1_STROKE_TRANSFORM_TYPE_NORMAL` (0, the width and dashes are scaled with the shape),
`…_FIXED` (1, they keep their size whatever the transform) or `…_HAIRLINE` (2, the stroke is
always one pixel wide).

**Returns** the transform type, or 0 for an empty wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim props as D2D1_STROKE_STYLE_PROPERTIES1 = D2D1_StrokeStyleProperties1( , , , , , , , D2D1_STROKE_TRANSFORM_TYPE_HAIRLINE )
dim style as CID2D1StrokeStyle1 = factory.CreateStrokeStyle1( props, byval NULL, 0 )
print style.GetStrokeTransformType()   ' 2
```

Microsoft Learn: [ID2D1StrokeStyle1::GetStrokeTransformType](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1strokestyle1-getstroketransformtype)

## CID2D1Multithread

`CID2D1Multithread` holds an `ID2D1Multithread` in `m_pMultithread`: the lock of one factory.
Every factory answers to `IID_ID2D1Multithread`; only a multithreaded one has a lock behind it.

### Constructor

```freebasic
constructor
constructor( byval pMultithread as ID2D1Multithread ptr )
```

The form with `pMultithread` stores the pointer without adding a reference, taking over the one
that `QueryInterface` gave you. The form without arguments makes an empty wrapper, on which
[Enter](#enter) and [Leave](#leave) do nothing and
[GetMultithreadProtected](#getmultithreadprotected) returns `false`.

| Parameter | Meaning |
| --- | --- |
| `pMultithread` | The factory's `ID2D1Multithread` interface. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_MULTI_THREADED
dim pMT as ID2D1Multithread ptr
( *factory )->QueryInterface( @IID_ID2D1Multithread, cast( any ptr ptr, @pMT ) )
dim mtLock as CID2D1Multithread = pMT
```

Microsoft Learn: [ID2D1Multithread](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1multithread)

### Destructor

```freebasic
destructor
```

Releases the interface, if the wrapper holds one. It does not leave a lock that is still held:
call [Leave](#leave) first.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_MULTI_THREADED
dim pMT as ID2D1Multithread ptr
( *factory )->QueryInterface( @IID_ID2D1Multithread, cast( any ptr ptr, @pMT ) )
dim pLock as CID2D1Multithread ptr = new CID2D1Multithread( pMT )
delete pLock
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1Multithread ptr ptr
operator cast() as ID2D1Multithread ptr
operator *( byref gradientMultithread as CID2D1Multithread ) as ID2D1Multithread ptr
```

`cast` and `*` give the `ID2D1Multithread` pointer without adding a reference. `@` returns the
address of `m_pMultithread`, for `QueryInterface` to write into; it does not release a pointer the
wrapper already holds. Applying `@` to the object currently stops the build with an internal
compiler error; pass `@mtLock.m_pMultithread` instead.

**Returns** the interface pointer (`NULL` for an empty wrapper), or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_MULTI_THREADED
dim mtLock as CID2D1Multithread
( *factory )->QueryInterface( @IID_ID2D1Multithread, cast( any ptr ptr, @mtLock.m_pMultithread ) )
dim pMT as ID2D1Multithread ptr = mtLock
print ( pMT = *mtLock )   ' -1
```

### GetMultithreadProtected

```freebasic
function GetMultithreadProtected() as boolean
```

Tells whether the factory locks itself, that is whether it was created with
`D2D1_FACTORY_TYPE_MULTI_THREADED`.

**Returns** `true` for a multithreaded factory; `false` for a single-threaded one or an empty
wrapper.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim mtLock as CID2D1Multithread
( *factory )->QueryInterface( @IID_ID2D1Multithread, cast( any ptr ptr, @mtLock.m_pMultithread ) )
print mtLock.GetMultithreadProtected()   ' false
```

Microsoft Learn: [ID2D1Multithread::GetMultithreadProtected](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1multithread-getmultithreadprotected)

### Enter

```freebasic
sub Enter()
```

Takes the factory's lock, waiting while another thread holds it. Until the matching
[Leave](#leave), no other thread can run a Direct2D call on this factory or its resources, so the
current thread may use the Direct3D and DXGI objects Direct2D shares. The same thread may enter
again; each `Enter` needs its own `Leave`. On a single-threaded factory there is no lock and
nothing happens.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_MULTI_THREADED
dim mtLock as CID2D1Multithread
( *factory )->QueryInterface( @IID_ID2D1Multithread, cast( any ptr ptr, @mtLock.m_pMultithread ) )
mtLock.Enter()
' ... use the Direct3D device that Direct2D draws on ...
mtLock.Leave()
```

Microsoft Learn: [ID2D1Multithread::Enter](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1multithread-enter)

### Leave

```freebasic
sub Leave()
```

Releases the lock that [Enter](#enter) took. Call it once for each `Enter`, from the same thread.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_MULTI_THREADED
dim mtLock as CID2D1Multithread
( *factory )->QueryInterface( @IID_ID2D1Multithread, cast( any ptr ptr, @mtLock.m_pMultithread ) )
mtLock.Enter()
mtLock.Leave()
```

Microsoft Learn: [ID2D1Multithread::Leave](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1multithread-leave)

## See also

- [sys/win/direct2d](SysWin-Direct2D)
- [CD2D1Factory](CD2D1Factory), which creates stroke styles and the factories that `CID2D1Multithread` locks
- [CID2D1RenderTarget](CID2D1RenderTarget) for the drawing calls that take a stroke style
- [Direct2D helpers](SysWin-Direct2D-Helpers) for `D2D1_StrokeStyleProperties` and `D2D1_StrokeStyleProperties1`
- [CGpPen](CGpPen), the GDI+ counterpart of a stroke style
