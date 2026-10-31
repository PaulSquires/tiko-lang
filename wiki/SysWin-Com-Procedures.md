[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/com](SysWin-Com) › **COM procedures**

# COM procedures

Creates COM objects and handles GUIDs, reference counts, event connections and variants.

These are the free functions of `sys/win/com`: no class to create first. They work with raw
interface pointers, so the COM rules apply to them directly:

- **Initialise COM first.** Call `CoInitialize( NULL )` once on the thread before creating or
  using objects, and `CoUninitialize()` at the end, after the last object is released.
- **Every pointer you are given carries a reference.** [NewCom](#newcom), [GetCom](#getcom),
  [AnyCom](#anycom) and [SafeAddRef](#safeaddref) hand you one; give each back with
  [SafeRelease](#saferelease) when you are done.
- **Memory from COM is freed with `CoTaskMemFree`**, not `deallocate`: the string of
  [WstrAlloc](#wstralloc) is one.

A GUID is the 128-bit identifier COM names every class (CLSID) and interface (IID) with. Its
text form is 38 characters: 32 hexadecimal digits in braces, grouped 8-4-4-4-12 with hyphens.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com
```

## Example

GUIDs in both directions, an object created two ways and released, and a `VARIANT` as text:

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com

function main() as long
    CoInitialize( NULL )

    ' GUIDs: a CLSID to text and back, and a fresh one
    dim clsDic as CLSID = ( &hEE09B103, &h97E0, &h11CF, { &h97, &h8F, &h00, &hA0, &h24, &h63, &hE0, &h6F } )
    dim text as string = GuidText( clsDic )
    dim back as GUID = GetGuid( text )
    print "Scripting.Dictionary is "; text; ", read back equal: "; iif( IsEqualGUID( @back, @clsDic ), "yes", "no" )
    print "a new GUID: "; GuidText( GetGuid() )

    ' create an object by ProgID and by CLSID, then release both
    dim pUnk as any ptr = NewCom( "Scripting.Dictionary" )
    dim pDisp as IDispatch ptr = NewCom( clsDic, IID_IDispatch )
    print "by ProgID: "; iif( pUnk, "created", "failed" ); ", by CLSID: "; iif( pDisp, "created", "failed" )
    SafeRelease( pUnk )
    SafeRelease( pDisp )
    print "after SafeRelease: "; iif( pUnk = NULL andalso pDisp = NULL, "both NULL", "not NULL" )

    ' a plain VARIANT as text
    dim v as VARIANT
    v.vt = VT_R8 : v.dblVal = 0.125
    print "VARIANT: "; VarToStr( @v ); ", a number:"; IsVariantTypeNumber( v.vt )

    CoUninitialize()
    return 0
end function

end main()
```

It prints the dictionary's CLSID in braces, `read back equal: yes`, a different new GUID on each
run, then:

```text
by ProgID: created, by CLSID: created
after SafeRelease: both NULL
VARIANT: 0.125, a number:true
```

## Functions

| Function | Does |
| --- | --- |
| [NewCom](#newcom) | Creates an object from a ProgID, a CLSID, or a DLL file. |
| [GetCom](#getcom) | Attaches to a running instance of an Automation server. |
| [AnyCom](#anycom) | Attaches to a running instance, or creates an in-process one. |
| [SafeAddRef](#safeaddref) | Adds a reference to an interface pointer. |
| [SafeRelease](#saferelease) | Releases an interface pointer and sets it to `NULL`. |
| [Advise](#advise) | Connects an event sink to an object's connection point. |
| [Unadvise](#unadvise) | Disconnects an event sink. |
| [GetOleErrorInfo](#getoleerrorinfo) | Returns the description of the last Automation error. |
| [GetGuid](#getguid) | Converts GUID text to a `GUID`, or makes a new one. |
| [GuidText](#guidtext) | Returns the text form of a GUID. |
| [IsBstr](#isbstr) | Guesses whether a pointer is a `BSTR`. |
| [WstrAlloc](#wstralloc) | Copies a string into memory allocated with `CoTaskMemAlloc`. |
| [OleCreateFontDisp](#olecreatefontdisp) | Creates a standard OLE font and returns its `IFontDisp`. |
| [OleCreateFont](#olecreatefont) | Creates a standard OLE font and returns its `IFont`. |
| [VarToStr](#vartostr) | Returns the contents of a `VARIANT` as text. |
| [GetVarType](#getvartype) | Returns the type code of a `VARIANT`. |
| [IsVariantTypeFloat](#isvarianttypefloat) | Tells whether a type code is `VT_R4` or `VT_R8`. |
| [IsVariantTypeSignedInteger](#isvarianttypesignedinteger) | Tells whether a type code is a signed integer. |
| [IsVariantTypeUnsignedInteger](#isvarianttypeunsignedinteger) | Tells whether a type code is an unsigned integer. |
| [IsVariantTypeInteger](#isvarianttypeinteger) | Tells whether a type code is any integer. |
| [IsVariantTypeNumber](#isvarianttypenumber) | Tells whether a type code is an integer or floating-point number. |

## Types

| Type | Is |
| --- | --- |
| [ComUnknown, LPCOMUNKNOWN](#comunknown-lpcomunknown) | `IUnknown` as an abstract tiko type, and a pointer to it. |
| [ComDispatch, LPCOMDISPATCH](#comdispatch-lpcomdispatch) | `IDispatch` as an abstract tiko type, and a pointer to it. |

## Reference

### NewCom

```freebasic
function NewCom overload( byref wszProgID as const wstring, byref wszLicKey as wstring = "" ) as any ptr
function NewCom overload( byref wszClsID as const wstring, byref wszIID as const wstring ) as any ptr
function NewCom overload( byref classID as const CLSID ) as any ptr
function NewCom overload( byref classID as const CLSID, byref riid as const IID ) as any ptr
function NewCom overload( byref wszLibName as const wstring, byref rclsid as const CLSID, byref riid as const IID, byref wszLicKey as wstring = "" ) as any ptr
function NewCom overload( byref wszLibName as const wstring, byref wszClsid as const wstring, byref wszIid as const wstring, byref wszLicKey as wstring = "" ) as any ptr
```

Creates a new, uninitialised object and returns an interface pointer to it, carrying one
reference.

- **By name** (`wszProgID`): a ProgID such as `"Scripting.Dictionary"`, or a CLSID in braces.
  The result is the object's `IUnknown`. With a licence key, the class object is asked for
  `IClassFactory2` and the instance is created with that key.
- **By CLSID**, optionally with an IID: the result is `IUnknown`, or the interface `riid`.
- **From a DLL file** (`wszLibName`, the full path): the DLL is loaded if it is not already, and
  the object is created through its exported `DllGetClassObject`, **without the class being
  registered**. With a licence key the class object is requested as `IClassFactory` and its
  `IClassFactory2::CreateInstanceLic` is called. This suits plain in-process servers; it does
  not suit system components (XML, ADO, DirectX …), parts of applications such as Office,
  add-ins and snap-ins, or visual ActiveX controls, which need their container. Do not free the
  DLL while any of its objects is alive; `CoUninitialize` unloads it at the end.

The forms by name and by CLSID create **in-process servers only** (DLLs): an application server
such as `Excel.Application` is not started; use [GetCom](#getcom) to attach to one that is
running.

Two overloads take two strings, so a call with two string literals is ambiguous. To pass a
licence key, put it in a `wstring` variable. The CLSID-and-IID text form converts the IID with
`CLSIDFromProgID`, which does not accept an interface ID, so it returns `NULL`; convert both
with [GetGuid](#getguid) and use the CLSID-and-IID form instead.

| Parameter | Meaning |
| --- | --- |
| `wszProgID` | A ProgID, or a CLSID as text. |
| `wszLicKey` | A licence key for a licensed control; empty for none. |
| `classID`, `rclsid`, `wszClsid` | The class to create. |
| `riid`, `wszIid` | The interface wanted. |
| `wszLibName` | The DLL that implements the class. |

**Returns** the interface pointer, or `NULL` when the class is unknown or creation fails.

**Example**

```freebasic
dim clsDic as CLSID = ( &hEE09B103, &h97E0, &h11CF, { &h97, &h8F, &h00, &hA0, &h24, &h63, &hE0, &h6F } )
dim pUnk as any ptr = NewCom( "Scripting.Dictionary" )
dim pDisp as IDispatch ptr = NewCom( clsDic, IID_IDispatch )
dim pFile as IDispatch ptr = NewCom( "C:\Windows\System32\scrrun.dll", clsDic, IID_IDispatch )
print ( pUnk <> NULL ); ( pDisp <> NULL ); ( pFile <> NULL )   ' prints -1-1-1
SafeRelease( pUnk ) : SafeRelease( pDisp ) : SafeRelease( pFile )
```

Microsoft Learn: [CoCreateInstance](https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-cocreateinstance)

### GetCom

```freebasic
function GetCom overload( byref wszProgID as const wstring ) as IDispatch ptr
function GetCom overload( byref classID as const CLSID ) as IDispatch ptr
```

Returns the `IDispatch` of a running instance of an Automation server, found in the Running
Object Table. Applications register there only after starting up; Office applications do so the
first time they lose the focus, so a call made while one has just started can fail.

**Returns** the pointer, carrying a reference, or `NULL` when no instance is registered.

**Example**

```freebasic
dim pExcel as IDispatch ptr = GetCom( "Excel.Application" )
if pExcel = NULL then print "Excel is not running"
SafeRelease( pExcel )
```

Microsoft Learn: [GetActiveObject](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-getactiveobject)

### AnyCom

```freebasic
function AnyCom overload( byref wszProgID as const wstring ) as IDispatch ptr
function AnyCom overload( byref classID as const CLSID ) as IDispatch ptr
```

Returns the `IDispatch` of a running instance, as [GetCom](#getcom) does, and otherwise creates a
new instance as [NewCom](#newcom) does. Creation is in-process only, so for an application server
such as `Excel.Application` it returns `NULL` unless the application is already running.

**Returns** the pointer, carrying a reference, or `NULL`.

**Example**

```freebasic
dim pDic as IDispatch ptr = AnyCom( "Scripting.Dictionary" )
print ( pDic <> NULL )       ' prints -1
SafeRelease( pDic )
```

### SafeAddRef

```freebasic
function SafeAddRef( byval pv as any ptr ) as ULONG
```

Adds a reference to the interface `pv`, which must be a COM interface pointer or `NULL`. Call it
when you keep a second copy of a pointer that must outlive the first; release each copy.

**Returns** the new reference count, meant only for testing, or 0 for `NULL`.

**Example**

```freebasic
dim pDic as IDispatch ptr = AnyCom( "Scripting.Dictionary" )
dim pSecond as IDispatch ptr = pDic
SafeAddRef( pSecond )
SafeRelease( pDic ) : SafeRelease( pSecond )
```

Microsoft Learn: [IUnknown::AddRef](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-addref)

### SafeRelease

```freebasic
function SafeRelease( byref pv as any ptr ) as ULONG
```

Releases the interface `pv` and sets the variable to `NULL`, so a second call does nothing. When
the last reference goes, the object frees itself.

**Returns** the remaining reference count, meant only for testing, or 0 for `NULL`.

**Example**

```freebasic
dim pDic as IDispatch ptr = AnyCom( "Scripting.Dictionary" )
SafeRelease( pDic )
print ( pDic = NULL )      ' prints -1
```

Microsoft Learn: [IUnknown::Release](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-release)

### Advise

```freebasic
function Advise overload( byval pUnk as any ptr, byval pEvtObj as any ptr, byval riid as IID ptr, byval pdwCookie as DWORD ptr ) as HRESULT
function Advise overload( byval pUnk as any ptr, byval pEvtObj as any ptr, byref riid as const IID, byval pdwCookie as DWORD ptr ) as HRESULT
function Advise overload( byval pUnk as any ptr, byval pEvtObj as any ptr, byref riid as IID, byval pdwCookie as DWORD ptr ) as HRESULT
```

Connects your event sink `pEvtObj` to the object `pUnk`, so that the object calls the sink when
the events of the outgoing interface `riid` occur. The object's `IConnectionPointContainer` is
asked for the connection point of `riid`, and the sink is registered with it. Keep the cookie for
[Unadvise](#unadvise).

| Parameter | Meaning |
| --- | --- |
| `pUnk` | The object whose events you want. |
| `pEvtObj` | Your sink: an object implementing the events interface. |
| `riid` | The events interface (the connection point's IID). |
| `pdwCookie` | Receives the cookie that identifies the connection. |

**Returns** `S_OK`; `E_INVALIDARG` when an argument is `NULL`; `E_NOINTERFACE` or
`CONNECT_E_NOCONNECTION` when the object has no such connection point; or the error from
registering the sink.

**Example**

```freebasic
dim as any ptr pSource, pSink        ' your object and your sink
dim cookie as DWORD
if Advise( pSource, pSink, IID_IDispatch, @cookie ) <> S_OK then print "not connected"
```

Microsoft Learn: [IConnectionPoint::Advise](https://learn.microsoft.com/en-us/windows/win32/api/ocidl/nf-ocidl-iconnectionpoint-advise)

### Unadvise

```freebasic
function Unadvise overload( byval pUnk as any ptr, byval riid as IID ptr, byval dwCookie as DWORD ) as HRESULT
function Unadvise overload( byval pUnk as any ptr, byref riid as const IID, byval dwCookie as DWORD ) as HRESULT
function Unadvise overload( byval pUnk as any ptr, byref riid as IID, byval dwCookie as DWORD ) as HRESULT
```

Ends the connection that [Advise](#advise) made, identified by its cookie. Call it before
releasing the sink.

**Returns** `S_OK`; `E_INVALIDARG` when `pUnk` or `riid` is `NULL` or the cookie is 0; or the
error from the connection point.

**Example**

```freebasic
dim pSource as any ptr
dim cookie as DWORD                   ' from Advise
if cookie then Unadvise( pSource, IID_IDispatch, cookie )
```

Microsoft Learn: [IConnectionPoint::Unadvise](https://learn.microsoft.com/en-us/windows/win32/api/ocidl/nf-ocidl-iconnectionpoint-unadvise)

### GetOleErrorInfo

```freebasic
function GetOleErrorInfo() as ustring
```

Returns the description of the most recent Automation error on the thread, and clears it. Call
it right after the failing method call. Only objects that support rich error information
(`IErrorInfo`) leave one.

**Returns** the description, or an empty string when there is none.

**Example**

```freebasic
dim info as ustring = GetOleErrorInfo()
if len( info ) = 0 then print "no error information"
```

Microsoft Learn: [GetErrorInfo](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-geterrorinfo)

### GetGuid

```freebasic
function GetGuid( byval pwszGuidText as wstring ptr = NULL ) as GUID
```

Converts the text form of a GUID, braces included, to a `GUID`; case does not matter. Without an
argument it generates a new, unique GUID.

**Returns** the GUID. `GetLastError()` is 0 afterwards on success and the failing `HRESULT`
otherwise (`CO_E_CLASSSTRING`, &h800401F3, for text that is not a GUID); a failed conversion
returns all zeros.

**Example**

```freebasic
dim g as GUID = GetGuid( GuidText( IID_IDispatch ) )
print IsEqualGUID( @g, @IID_IDispatch )            ' prints -1
dim bad as GUID = GetGuid( "not a guid" )
print "&h"; hex( GetLastError() )                  ' prints &h800401F3
```

Microsoft Learn: [CLSIDFromString](https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-clsidfromstring), [UuidCreate](https://learn.microsoft.com/en-us/windows/win32/api/rpcdce/nf-rpcdce-uuidcreate)

### GuidText

```freebasic
function GuidText overload( byval classID as CLSID ptr ) as string
function GuidText overload( byval classID as CLSID ) as string
function GuidText overload( byval riid as REFIID ) as string
```

Returns the 38-character text form of a GUID, in braces and upper case.

**Returns** the text. `GetLastError()` is the result of the conversion.

**Example**

```freebasic
dim text as string = GuidText( IID_IDispatch )
print len( text ); " "; left( text, 10 )      ' prints  38 {00020400-
```

Microsoft Learn: [StringFromCLSID](https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-stringfromclsid)

### IsBstr

```freebasic
function IsBstr( byval pv as any ptr ) as boolean
```

Guesses whether `pv` points at a `BSTR`. A `BSTR` is stored with its length in bytes in the four
bytes before the text; the function reads those bytes and compares them with the length of the
null-terminated text. It is a heuristic: a `BSTR` that contains a null character is reported as
not one, any other string whose preceding bytes happen to match is reported as one, and reading
before a pointer that is not a string can fault.

**Returns** `true` when the two lengths agree; `false` for `NULL` and otherwise.

**Example**

```freebasic
dim b as BSTR = SysAllocString( "abc" )
print IsBstr( b ); " "; IsBstr( NULL )      ' prints true false
SysFreeString( b )
```

### WstrAlloc

```freebasic
function WstrAlloc( byref wszStr as wstring ) as wstring ptr
```

Copies a string into memory allocated with `CoTaskMemAlloc`, for a method that takes ownership of
the string it is given and frees it itself. Free the copy with `CoTaskMemFree` if it is not
handed over.

**Returns** the copy, or `NULL` when memory runs out.

**Example**

```freebasic
dim pw as wstring ptr = WstrAlloc( "copy me" )
print len( *pw )             ' prints 7
CoTaskMemFree( pw )
```

Microsoft Learn: [SHStrDupW](https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-shstrdupw)

### OleCreateFontDisp

```freebasic
function OleCreateFontDisp( byref wszFontName as wstring, byval cySize as LONGLONG, byval fWeight as short = FW_NORMAL, byval fItalic as WINBOOL = FALSE, byval fUnderline as WINBOOL = FALSE, byval fStrikethrough as WINBOOL = FALSE, byval fCharset as short = DEFAULT_CHARSET ) as IFontDisp ptr
```

Creates a standard OLE font object, the kind ActiveX controls take for their `Font` property,
and returns its `IFontDisp` interface. Release it when you are done.

| Parameter | Meaning |
| --- | --- |
| `wszFontName` | The typeface, such as `"Segoe UI"`. |
| `cySize` | The size in whole points. |
| `fWeight` | `FW_NORMAL` (400), `FW_BOLD` (700) …; above 550 also makes the font bold. |
| `fItalic`, `fUnderline`, `fStrikethrough` | Nonzero for that style. |
| `fCharset` | The character set, such as `DEFAULT_CHARSET` or `SYMBOL_CHARSET`; give the one the typeface uses. |

**Returns** the font, or `NULL` on failure.

**Example**

```freebasic
dim pFont as IFontDisp ptr = OleCreateFontDisp( "Segoe UI", 9 )
SafeRelease( pFont )
```

Microsoft Learn: [OleCreateFontIndirect](https://learn.microsoft.com/en-us/windows/win32/api/olectl/nf-olectl-olecreatefontindirect)

### OleCreateFont

```freebasic
function OleCreateFont( byref wszFontName as wstring, byval cySize as LONGLONG, byval fWeight as short = FW_NORMAL, byval fItalic as WINBOOL = FALSE, byval fUnderline as WINBOOL = FALSE, byval fStrikethrough as WINBOOL = FALSE, byval fCharset as short = DEFAULT_CHARSET ) as IFont ptr
```

Creates a standard OLE font object as [OleCreateFontDisp](#olecreatefontdisp) does and returns it
as an `IFont` pointer, through which the font's size, weight and other properties can be read
and changed, and its `HFONT` obtained. The font reports its size rounded to what the screen can
show: a 10-point Courier New reads back as 9.75 points. Release it when you are done.

**Returns** the font, or `NULL` on failure.

**Example**

```freebasic
dim pFont as IFont ptr = OleCreateFont( "Courier New", 10, FW_BOLD )
dim bold as WINBOOL
if pFont then pFont->lpVtbl->get_Bold( pFont, @bold )
print bold                                   ' prints 1
SafeRelease( pFont )
```

Microsoft Learn: [IFont](https://learn.microsoft.com/en-us/windows/win32/api/ocidl/nn-ocidl-ifont)

### VarToStr

```freebasic
function VarToStr overload( byval pvarIn as VARIANT ptr, byval bClear as boolean = false ) as ustring
```

Returns the contents of a `VARIANT` as text, and with `bClear = true` clears the variant
afterwards (`VariantClear`). This is what [DVARIANT.ToStr](DVARIANT#tostr) uses.

- Numbers are written without grouping, in the invariant format (`.` as decimal point). A single
  has up to 7 significant digits, a double up to 18 (`0.1` stays `0.1`).
- `VT_BOOL` is `-1` or `0`; `VT_ERROR` is its code in decimal.
- `VT_CY` has four decimals (`-1.5000`, `0.0000`), except a whole amount other than zero, which
  has none (`5`). `VT_DECIMAL` keeps its own digits.
- A date is `2026/10/31:12:30:00.000`. `VT_EMPTY` and `VT_NULL` give an empty string.
- A `VT_BYREF` number or string is read through its pointer.
- An array gives its elements joined with `"; "`: `10; 20; 30`. A byte array gives the byte
  values (`65; 66; 67`); use [DVARIANT.ToBuffer](DVARIANT#tobuffer) for the bytes. Arrays of
  `single`, `double` and `VARIANT` elements whose lower bound is not 0 are read from the wrong
  position: the first element is skipped and memory past the end is read in its place. Arrays
  from Automation servers usually start at 0.
- A `VT_CY` or `VT_DECIMAL` variant is not cleared even with `bClear = true`; it holds nothing to
  free.

| Parameter | Meaning |
| --- | --- |
| `pvarIn` | The variant to read. |
| `bClear` | `true` clears the variant after a successful conversion. |

**Returns** the text; an empty string for `NULL` or a value that cannot be converted, in which
case the variant is not cleared.

**Example**

```freebasic
dim v as VARIANT
v.vt = VT_CY : v.cyVal.int64 = -15000
print VarToStr( @v )                       ' prints -1.5000
v.vt = VT_BSTR : v.bstrVal = SysAllocString( "bye" )
print VarToStr( @v, true ); " "; v.vt      ' prints bye 0
```

Microsoft Learn: [VariantToStringAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttostringalloc)

### GetVarType

```freebasic
function GetVarType( byval pvar as VARIANT ptr ) as VARTYPE
```

Returns the type code (`vt`) of a `VARIANT`. `pvar` must not be `NULL`.

**Example**

```freebasic
dim v as VARIANT
v.vt = VT_UI2
print GetVarType( @v )      ' prints 18
```

Microsoft Learn: [VARENUM](https://learn.microsoft.com/en-us/windows/win32/api/wtypes/ne-wtypes-varenum)

### IsVariantTypeFloat

```freebasic
function IsVariantTypeFloat( byval vt as VARTYPE ) as boolean
```

Tells whether `vt` is `VT_R4` or `VT_R8`. Flags such as `VT_ARRAY` or `VT_BYREF` make it `false`.

**Example**

```freebasic
print IsVariantTypeFloat( VT_R8 ); " "; IsVariantTypeFloat( VT_CY )   ' prints true false
```

### IsVariantTypeSignedInteger

```freebasic
function IsVariantTypeSignedInteger( byval vt as VARTYPE ) as boolean
```

Tells whether `vt` is `VT_I1`, `VT_I2`, `VT_I4` or `VT_I8`. `VT_INT` is not included.

**Example**

```freebasic
print IsVariantTypeSignedInteger( VT_I2 )    ' prints true
```

### IsVariantTypeUnsignedInteger

```freebasic
function IsVariantTypeUnsignedInteger( byval vt as VARTYPE ) as boolean
```

Tells whether `vt` is `VT_UI1`, `VT_UI2`, `VT_UI4` or `VT_UI8`. `VT_UINT` is not included.

**Example**

```freebasic
print IsVariantTypeUnsignedInteger( VT_UI2 )   ' prints true
```

### IsVariantTypeInteger

```freebasic
function IsVariantTypeInteger( byval vt as VARTYPE ) as boolean
```

Tells whether `vt` is one of the signed or unsigned integer types above. `VT_INT` and `VT_UINT`
are not included.

**Example**

```freebasic
print IsVariantTypeInteger( VT_UI2 ); " "; IsVariantTypeInteger( VT_INT )   ' prints true false
```

### IsVariantTypeNumber

```freebasic
function IsVariantTypeNumber( byval vt as VARTYPE ) as boolean
```

Tells whether `vt` is an integer type ([IsVariantTypeInteger](#isvarianttypeinteger)) or a
floating-point type. `VT_CY` and `VT_DECIMAL` are not included.

**Example**

```freebasic
print IsVariantTypeNumber( VT_R4 ); " "; IsVariantTypeNumber( VT_BSTR )   ' prints true false
```

### ComUnknown, LPCOMUNKNOWN

```freebasic
type ComUnknown as ComUnknown_
type ComUnknown_ extends object
    declare abstract function QueryInterface( byval riid as REFIID, byval ppvObject as LPVOID ptr ) as HRESULT
    declare abstract function AddRef() as ULONG
    declare abstract function Release() as ULONG
end type
type LPCOMUNKNOWN as ComUnknown ptr
```

`IUnknown` declared as an abstract tiko type. Its virtual-method table has the layout of a COM
interface, so a pointer to a COM object can be held as a `ComUnknown ptr` and its methods called
as methods, `p->Release()`, instead of through `lpVtbl`. Interfaces declared by extending it,
as the Direct2D ones are, inherit the three methods.

**Example**

```freebasic
dim pUnk as LPCOMUNKNOWN = NewCom( "Scripting.Dictionary" )
dim pDisp as any ptr
if pUnk then pUnk->QueryInterface( @IID_IDispatch, @pDisp ) : pUnk->Release()
SafeRelease( pDisp )
```

Microsoft Learn: [IUnknown](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown)

### ComDispatch, LPCOMDISPATCH

```freebasic
type ComDispatch as ComDispatch_
type ComDispatch_ extends ComUnknown
    declare abstract function GetTypeInfoCount( byval pctinfo as UINT ptr ) as HRESULT
    declare abstract function GetTypeInfo( byval iTInfo as UINT, byval lcid as LCID, byval ppTInfo as ITypeInfo ptr ptr ) as HRESULT
    declare abstract function GetIDsOfNames( byval riid as const IID const ptr, byval rgszNames as LPOLESTR ptr, byval cNames as UINT, byval lcid as LCID, byval rgDispId as DISPID ptr ) as HRESULT
    declare abstract function Invoke( byval dispIdMember as DISPID, byval riid as const IID const ptr, byval lcid as LCID, byval wFlags as WORD, byval pDispParams as DISPPARAMS ptr, byval pVarResult as VARIANT ptr, byval pExcepInfo as EXCEPINFO ptr, byval puArgErr as UINT ptr ) as HRESULT
end type
type LPCOMDISPATCH as ComDispatch ptr
```

`IDispatch` declared the same way, extending [ComUnknown](#comunknown-lpcomunknown): the four
Automation methods after the three of `IUnknown`. For calling methods by name,
[CDispInvoke](CDispInvoke) does the `GetIDsOfNames` and `Invoke` work.

**Example**

```freebasic
dim clsDic as CLSID = ( &hEE09B103, &h97E0, &h11CF, { &h97, &h8F, &h00, &hA0, &h24, &h63, &hE0, &h6F } )
dim pDisp as LPCOMDISPATCH = NewCom( clsDic, IID_IDispatch )
dim count as UINT
if pDisp then pDisp->GetTypeInfoCount( @count ) : pDisp->Release()
print count                               ' prints 1
```

Microsoft Learn: [IDispatch](https://learn.microsoft.com/en-us/windows/win32/api/oaidl/nn-oaidl-idispatch)

## See also

- [sys/win/com](SysWin-Com)
- [DVARIANT](DVARIANT), the variant class built on [VarToStr](#vartostr)
- [CDispInvoke](CDispInvoke) for calling Automation objects by name
- [BSTRING](BSTRING) for COM strings
