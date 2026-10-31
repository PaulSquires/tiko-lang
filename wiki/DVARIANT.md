[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/com](SysWin-Com) › **DVARIANT**

# DVARIANT

Holds a COM `VARIANT` and converts it to and from tiko numbers, strings, dates and arrays.

A `VARIANT` is the tagged union that COM Automation passes everywhere: a type code (`vt`, one of
the `VT_*` values) plus a value of that type. `DVARIANT` wraps one and owns what it holds. When
a `DVARIANT` goes out of scope, or is assigned a new value, the old contents are released with
`VariantClear`: a string is freed, an interface pointer is released, a safe array is destroyed.
Copying a `DVARIANT` makes a deep copy.

The `VARIANT` itself is the public field `vd`; `@dv.vd` (or `*dv`) is the `VARIANT ptr` to pass
to a Windows function that reads one. To pass it to a function that **writes** one, use
[vptr](#vptr), which empties it first so the old contents are not leaked.

Methods that can fail store an `HRESULT` that [GetLastResult](#getlastresult) returns and
[GetErrorInfo](#geterrorinfo) describes; most of them also return it.

**Assignment and the constructor are not the same.** `dv = 3.14` stores a double (`VT_R8`), but
`dim dv as DVARIANT = 3.14` stores a **single** (`VT_R4`), whatever type is asked for; see
[Constructor](#constructor). Assign doubles, or use [PutDouble](#putdouble).

Variants that hold objects need COM: call `CoInitialize( NULL )` once at the start of the thread
(and `CoUninitialize()` at the end, after every `DVARIANT` holding an object is gone).

A `DVARIANT` converts itself to a `ustring` wherever one is expected, so `print dv` and
`"total: " & dv` work. There is no numeric conversion; use [Val](#val).

## Importing

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com
```

## Example

Arithmetic, concatenation, an array and an error message, all through variants:

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com

function main() as long
    dim price as DVARIANT
    price = 19.99                          ' assignment stores a double (VT_R8)
    dim qty as DVARIANT = 3                ' VT_I4
    dim total as DVARIANT = price * qty
    print "total: "; total.ToStr(); ", type "; total.vType()
    print "formatted: "; total.FormatNumber( 2 )

    dim label as DVARIANT = "Qty "
    dim caption as DVARIANT = label & qty
    print caption.ToStr()

    dim days(0 to 2) as long = { 31, 30, 31 }
    dim months as DVARIANT
    months.PutLongArray( @days(0), 3 )
    print "array: "; months.ToStr(); " ("; months.GetElementCount(); " elements)"
    print "second:"; months.GetLongElement( 1 )

    dim bad as DVARIANT = "abc"
    if bad.ChangeType( VT_I4 ) <> S_OK then print bad.GetErrorInfo()
    return 0
end function

end main()
```

It prints:

```text
total: 59.97, type 5
formatted: 59.97
Qty 3
array: 31; 30; 31 (3 elements)
second: 30
Error &h80020005
Type mismatch.
```

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates a variant from a value, a string, an interface, a reference or another variant. |
| [Destructor](#destructor) | Releases what the variant holds. |
| [Let](#let) | Assigns a new value, releasing the old one. |
| [Cast](#cast) | Converts to a `VARIANT`, a pointer or a `ustring`. |
| [vptr](#vptr) | Empties the variant and returns its address, for a function that fills it. |
| [Put](#put) | Assigns a value, optionally of a chosen `VT_*` type. |
| [PutRef](#putref) | Stores a reference to a variable (`VT_BYREF`). |
| [PutNull](#putnull) | Sets the variant to `VT_NULL`. |
| [PutBool](#putbool) | Stores a `BOOL` as `VT_BOOL`. |
| [PutBoolean](#putboolean) | Stores a `boolean` as `VT_BOOL`. |
| [PutByte](#putbyte) | Stores a `byte` as `VT_I1`. |
| [PutUByte](#putubyte) | Stores a `ubyte` as `VT_UI1`. |
| [PutShort](#putshort) | Stores a `short` as `VT_I2`. |
| [PutUShort](#putushort) | Stores a `ushort` as `VT_UI2`. |
| [PutInt](#putint) | Stores an `INT_` as `VT_INT`. |
| [PutUInt](#putuint) | Stores a `UINT` as `VT_UINT`. |
| [PutLong](#putlong) | Stores a `long` as `VT_I4`. |
| [PutULong](#putulong) | Stores a `ulong` as `VT_UI4`. |
| [PutLongInt](#putlongint) | Stores a `longint` as `VT_I8`. |
| [PutULongInt](#putulongint) | Stores a `ulongint` as `VT_UI8`. |
| [PutSingle](#putsingle) | Stores a `single` as `VT_R4`. |
| [PutFloat](#putfloat) | Stores a `single` as `VT_R4`. |
| [PutDouble](#putdouble) | Stores a `double` as `VT_R8`. |
| [PutBuffer](#putbuffer) | Stores a block of bytes as an array of `VT_UI1`. |
| [PutSafeArray](#putsafearray) | Stores a copy of a safe array, or takes it over. |
| [PutResource](#putresource) | Stores a string resource of a module. |
| [PutRecord](#putrecord) | Stores a reference to a user-defined type (`VT_RECORD`). |
| [PutDateString](#putdatestring) | Parses a date string into a `VT_DATE`. |
| [PutVbDate](#putvbdate) | Stores an Automation date (`DATE_`) as `VT_DATE`. |
| [PutSystemTime](#putsystemtime) | Converts a `SYSTEMTIME` into a `VT_DATE`. |
| [PutGuid](#putguid) | Stores a GUID as its string form. |
| [PutFileTime](#putfiletime) | Converts a `FILETIME` into a `VT_DATE`. |
| [PutFileTimeArray](#putfiletimearray) | Converts an array of `FILETIME` into an array of `VT_DATE`. |
| [PutStrRet](#putstrret) | Stores the string of a shell `STRRET`. |
| [PutDec](#putdec) | Stores a `DECIMAL`. |
| [PutDecFromStr](#putdecfromstr) | Parses a string into a `VT_DECIMAL`. |
| [PutDecFromDouble](#putdecfromdouble) | Converts a double into a `VT_DECIMAL`. |
| [PutDecFromCy](#putdecfromcy) | Converts a currency value into a `VT_DECIMAL`. |
| [PutBooleanArray](#putbooleanarray) | Stores an array of `WINBOOL` as an array of `VT_BOOL`. |
| [PutShortArray](#putshortarray) | Stores an array of `short`. |
| [PutUShortArray](#putushortarray) | Stores an array of `ushort`. |
| [PutLongArray](#putlongarray) | Stores an array of `long`. |
| [PutULongArray](#putulongarray) | Stores an array of `ulong`. |
| [PutLongIntArray](#putlongintarray) | Stores an array of `longint`. |
| [PutULongIntArray](#putulongintarray) | Stores an array of `ulongint`. |
| [PutDoubleArray](#putdoublearray) | Stores an array of `double`. |
| [PutStringArray](#putstringarray) | Stores an array of strings as an array of `VT_BSTR`. |
| [PutPropVariant](#putpropvariant) | Converts a `PROPVARIANT` into the variant. |
| [PutVariantArrayElement](#putvariantarrayelement) | Copies one element out of another variant's array. |
| [GetDim](#getdim) | Returns the number of dimensions of an array variant. |
| [GetLBound](#getlbound) | Returns the lower bound of a dimension. |
| [GetUBound](#getubound) | Returns the upper bound of a dimension. |
| [GetVariantElement](#getvariantelement) | Returns one element of an array of variants. |
| [GetElementCount](#getelementcount) | Returns the number of elements; 1 for a value that is not an array. |
| [GetBooleanElement](#getbooleanelement) | Returns one element of a `VT_BOOL` array. |
| [GetShortElement](#getshortelement) | Returns one element of a `short` array. |
| [GetUShortElement](#getushortelement) | Returns one element of a `ushort` array. |
| [GetLongElement](#getlongelement) | Returns one element of a `long` array. |
| [GetULongElement](#getulongelement) | Returns one element of a `ulong` array. |
| [GetLongIntElement](#getlongintelement) | Returns one element of a `longint` array. |
| [GetULongIntElement](#getulongintelement) | Returns one element of a `ulongint` array. |
| [GetDoubleElement](#getdoubleelement) | Returns one element of a `double` array. |
| [GetStringElement](#getstringelement) | Returns one element of a string array. |
| [ToStr](#tostr) | Returns the value as text. |
| [ToBStr](#tobstr) | Returns the value as text in a `BSTRING`. |
| [ToBuffer](#tobuffer) | Copies the bytes of a `VT_UI1` array out. |
| [ToUnknown](#tounknown) | Returns the held object as `IUnknown`, with a reference added. |
| [ToDispatch](#todispatch) | Returns the held object as `IDispatch`, with a reference added. |
| [DecToDouble](#dectodouble) | Converts a `VT_DECIMAL` to a double. |
| [DecToCy](#dectocy) | Converts a `VT_DECIMAL` to a currency value. |
| [ToVbDate](#tovbdate) | Returns a `VT_DATE` as a `DATE_`. |
| [ToSystemTime](#tosystemtime) | Returns a `VT_DATE` as a `SYSTEMTIME`. |
| [ToGuid](#toguid) | Parses a GUID string into a `GUID`. |
| [ToGuidStr](#toguidstr) | Returns a GUID string in its canonical form. |
| [ToDosDateTime](#todosdatetime) | Returns a date as MS-DOS date and time words. |
| [ToFileTime](#tofiletime) | Returns a date as a `FILETIME`. |
| [ToStrRet](#tostrret) | Returns a string as a shell `STRRET`. |
| [ToBooleanArray](#tobooleanarray) | Copies a boolean array into a buffer. |
| [ToBooleanArrayAlloc](#tobooleanarrayalloc) | Copies a boolean array into newly allocated memory. |
| [ToShortArray](#toshortarray) | Copies a `short` array into a buffer. |
| [ToShortArrayAlloc](#toshortarrayalloc) | Copies a `short` array into newly allocated memory. |
| [ToUShortArray](#toushortarray) | Copies a `ushort` array into a buffer. |
| [ToUShortArrayAlloc](#toushortarrayalloc) | Copies a `ushort` array into newly allocated memory. |
| [ToLongArray](#tolongarray) | Copies a `long` array into a buffer. |
| [ToLongArrayAlloc](#tolongarrayalloc) | Copies a `long` array into newly allocated memory. |
| [ToULongArray](#toulongarray) | Copies a `ulong` array into a buffer. |
| [ToULongArrayAlloc](#toulongarrayalloc) | Copies a `ulong` array into newly allocated memory. |
| [ToLongIntArray](#tolongintarray) | Copies a `longint` array into a buffer. |
| [ToLongIntArrayAlloc](#tolongintarrayalloc) | Copies a `longint` array into newly allocated memory. |
| [ToULongIntArray](#toulongintarray) | Copies a `ulongint` array into a buffer. |
| [ToULongIntArrayAlloc](#toulongintarrayalloc) | Copies a `ulongint` array into newly allocated memory. |
| [ToDoubleArray](#todoublearray) | Copies a `double` array into a buffer. |
| [ToDoubleArrayAlloc](#todoublearrayalloc) | Copies a `double` array into newly allocated memory. |
| [ToStringArray](#tostringarray) | Copies a string array into a buffer of string pointers. |
| [ToStringArrayAlloc](#tostringarrayalloc) | Copies a string array into newly allocated memory. |
| [Clear](#clear) | Releases the contents and sets the variant to `VT_EMPTY`. |
| [Attach](#attach) | Takes over the contents of a `VARIANT`. |
| [Detach](#detach) | Hands the contents over to a `VARIANT`. |
| [vType](#vtype) | Returns the `VT_*` type code. |
| [ChangeType](#changetype) | Converts the variant to another type in place. |
| [ChangeTypeEx](#changetypeex) | Converts the variant to another type, using a given locale. |
| [Round](#round) | Rounds to a number of decimal places. |
| [FormatNumber](#formatnumber) | Formats a number as text with grouping and decimals. |
| [GetLastResult](#getlastresult) | Returns the result code of the last operation. |
| [SetResult](#setresult) | Sets the stored result code. |
| [GetErrorInfo](#geterrorinfo) | Describes a result code in words. |
| [Compound assignment](#compound-assignment) | `+=`, `&=`, `-=`, `*=`, `/=`, `\=`, `^=`, `and=`, `or=`, `xor=`, `eqv=`, `imp=`, `mod=`. |
| [Arithmetic operators](#arithmetic-operators) | `+`, `-`, `*`, `/`, `\`, `^` and negation between variants. |
| [Concatenation](#concatenation) | `&` joins two variants as text. |
| [Comparison operators](#comparison-operators) | `<>`, `<`, `>`, `<=`, `>=`. |
| [And, Or, Xor, Eqv, Imp, Mod, Not](#and-or-xor-eqv-imp-mod-not) | Bitwise and remainder operators, returning an `integer`. |
| [Abs, Fix, Int](#abs-fix-int) | Absolute value and truncation, returning an `integer`. |
| [Pointer operator](#pointer-operator) | `*dv` is the address of the `VARIANT`. |

Procedures that take a `DVARIANT`:

| Procedure | Does |
| --- | --- |
| [Left](#left) | Returns the first characters of the variant's text. |
| [Right](#right) | Returns the last characters of the variant's text. |
| [Val](#val) | Returns the variant's text read as a number. |
| [MsgBox](#msgbox) | Shows the variant's text in a message box. |
| [VtError](#vterror) | Returns the `VARIANT` that stands for an omitted optional argument. |
| [VtNULL](#vtnull) | Returns a `VT_NULL` `VARIANT`. |

## Reference

### Constructor

```freebasic
constructor
constructor( byref dv as DVARIANT )
constructor( byval v as VARIANT )
constructor( byval pwsz as wstring ptr )
constructor( byref ustr as ustring )
constructor( byref bs as BSTRING )
constructor( byval pvar as VARIANT ptr )
constructor( byval cy as CURRENCY )
constructor( byval dec as DECIMAL )
constructor( byval _value as long )
constructor( byval pdisp as IDispatch ptr, byval fAddRef as boolean = false )
constructor( byval punk as IUnknown ptr, byval fAddRef as boolean = false )
constructor( byval _value as longint, byval _vType as WORD = VT_I4 )
constructor( byval _value as double, byval _vType as WORD = VT_R8 )
constructor( byval _value as longint, byref strType as string )
constructor( byval _value as double, byref strType as string )
constructor( byval _pvar as any ptr, byval _vType as WORD )
constructor( byval _pvar as any ptr, byref strType as string )
```

Creates a variant. Without an argument it is `VT_EMPTY`.

- **Another variant** (`DVARIANT`, `VARIANT`, `VARIANT ptr`): a deep copy (`VariantCopy`).
- **Text** (`wstring ptr`, `ustring`, `BSTRING`, a literal): a new `VT_BSTR`.
- **`CURRENCY`, `DECIMAL`**: `VT_CY`, `VT_DECIMAL`.
- **`long`** (a plain integer literal): `VT_I4`. `true` and `false` arrive here too, as `VT_I4`
  -1 and 0; use [PutBoolean](#putboolean) for a `VT_BOOL`.
- **An interface pointer**: `VT_DISPATCH` or `VT_UNKNOWN`. The variant **takes over** the
  reference you pass and releases it when it is cleared; pass `fAddRef = true` to keep your
  own reference as well.
- **`longint` and a type**: the value converted to `_vType` (`VT_BOOL`, `VT_I1` … `VT_UI8`,
  `VT_EMPTY`, `VT_NULL`); any other type gives `VT_I4`. A value above the `ulong` range becomes
  `VT_I8` instead. A type with `VT_ARRAY` set gives a variant of that type with no array, for a
  method that wants an empty array of a given type. Other values are cut to 32 bits for `VT_I4`:
  a value from 2^31 up to the top of the `ulong` range wraps to a negative number, and a value
  below -2^31 is cut too. Three thousand million, `DVARIANT( &hB2D05E00ll )`, holds -1294967296.
  Assign such values instead: `dv = x` keeps them, as `VT_I8`.
- **`double` and a type**: `_vType` is ignored. The value is stored as a `single` (`VT_R4`)
  unless it is too small to be one, so `DVARIANT( 1234567.891 )` holds 1234568 and
  `DVARIANT( 1e300 )` holds infinity. For a double, assign it, call [PutDouble](#putdouble), or
  pass the type name `"DOUBLE"`.
- **A value and a type name**: `strType` is one of `"BOOL"`, `"BOOLEAN"`, `"BYTE"`, `"UBYTE"`,
  `"SHORT"`, `"USHORT"`, `"INT"`, `"UINT"`, `"LONG"`, `"ULONG"`, `"LONGINT"`, `"ULONGINT"`,
  `"EMPTY"`, `"NULL"` for an integer (anything else gives `VT_I4`), or `"SINGLE"`, `"FLOAT"`,
  `"DOUBLE"` for a floating-point value (anything else gives `VT_R8`). Case does not matter.
- **A pointer and a type** (`_vType` without `VT_BYREF`, or a name such as `"DOUBLE"`, `"BSTR"`,
  `"VARIANT"`, `"CURRENCY"`, `"SAFEARRAY"`): a `VT_BYREF` variant that points at your variable,
  so it always shows the variable's current value. The variable must outlive the variant. An
  unknown type, or a `NULL` pointer with a type name, leaves the variant `VT_EMPTY`.

| Parameter | Meaning |
| --- | --- |
| `_value` | The number to store. |
| `_vType` | The `VT_*` type wanted. |
| `strType` | The type wanted, by name. |
| `pdisp`, `punk` | The interface pointer to store. |
| `fAddRef` | `true` adds a reference; `false` (the default) takes over the caller's. |
| `_pvar` | The address of the variable to refer to. |

**Example**

```freebasic
dim s as DVARIANT = "Hello"                  ' VT_BSTR
dim n as DVARIANT = 42                       ' VT_I4
dim b as DVARIANT = DVARIANT( 200, "UBYTE" ) ' VT_UI1
dim d as DVARIANT = DVARIANT( 2.5, "DOUBLE" )
print s; " "; n; " "; b; " "; d              ' prints Hello 42 200 2.5
dim dblVal as double = 123456.12
dim r as DVARIANT = DVARIANT( @dblVal, "DOUBLE" )
dblVal = 345.12
print r                                      ' prints 345.12
```

Microsoft Learn: [VARIANT](https://learn.microsoft.com/en-us/windows/win32/api/oaidl/ns-oaidl-variant)

### Destructor

```freebasic
destructor
```

Releases what the variant holds (`VariantClear`): frees a string or a safe array, releases an
interface pointer. A `VT_BYREF` variant releases nothing; the variable it points at is yours.

**Example**

```freebasic
scope
    dim dv as DVARIANT = "freed at end scope"
end scope
```

Microsoft Learn: [VariantClear](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-variantclear)

### Let

```freebasic
operator let( byref dv as DVARIANT )
operator let( byval v as VARIANT )
operator let( byval pvar as VARIANT ptr )
operator let( byval pwszStr as wstring ptr )
operator let( byref ustr as ustring )
operator let( byref bs as BSTRING )
operator let( byval cy as CURRENCY )
operator let( byval dec as DECIMAL )
operator let( byval _value as long )
operator let( byval pdisp as IDispatch ptr )
operator let( byval punk as IUnknown ptr )
operator let( byval _value as longint )
operator let( byval _value as double )
```

Releases the current contents and stores a new value. A variant on the right is deep-copied;
text becomes `VT_BSTR`; a `long` becomes `VT_I4`; a `longint` becomes `VT_I4` when it fits in 32
bits and `VT_I8` otherwise; a `double` becomes `VT_R8`. Assigning an interface pointer **adds a
reference** (unlike the constructor), so you still release your own.

**Example**

```freebasic
dim dv as DVARIANT
dv = "text"         : print dv.vType()   ' prints 8 (VT_BSTR)
dv = 5000000000ll   : print dv.vType()   ' prints 20 (VT_I8)
dv = 3.14           : print dv.vType()   ' prints 5 (VT_R8)
```

Microsoft Learn: [VariantCopy](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-variantcopy)

### Cast

```freebasic
operator cast() as VARIANT
operator cast() as any ptr
operator cast() as ustring
```

Converts the variant where another type is expected. To `VARIANT`, the result is a shallow copy
of `vd`: it shares the string or interface with the `DVARIANT`, so do not clear it. To
`any ptr`, it is `@vd`. To `ustring`, it is [ToStr](#tostr).

**Example**

```freebasic
dim dv as DVARIANT = 12.5
dim text as ustring = dv          ' "12.5"
dim p as any ptr = dv             ' same as @dv.vd
print text; " "; ( p = @dv.vd )   ' prints 12.5 -1
```

### vptr

```freebasic
function vptr() as VARIANT ptr
```

Clears the variant and returns the address of its `VARIANT`. Use it for an output parameter that
a function fills: passing `@dv.vd` there would overwrite the old contents without freeing them.
To pass the current value **in**, use `@dv.vd` or `*dv` instead; `vptr` destroys it.

**Returns** `@vd`, now `VT_EMPTY`.

**Example**

```freebasic
dim dv as DVARIANT = "old value"
dim pv as VARIANT ptr = dv.vptr()   ' "old value" is freed here
pv->vt = VT_I4 : pv->lVal = 12345
print dv                            ' prints 12345
```

### Put

```freebasic
function Put( byref dv as DVARIANT ) as HRESULT
function Put( byref v as VARIANT ) as HRESULT
function Put( byval pvar as VARIANT ptr ) as HRESULT
sub Put( byval pwszStr as wstring ptr )
sub Put( byref ustr as ustring )
sub Put( byref bs as BSTRING )
function Put( byval pdisp as IDispatch ptr, byval fAddRef as boolean = false ) as HRESULT
function Put( byval punk as IUnknown ptr, byval fAddRef as boolean = false ) as HRESULT
sub Put( byval _value as longint, byval _vType as WORD = VT_I4 )
sub Put( byval _value as longint, byref strType as string )
sub Put( byval _value as double, byval _vType as WORD = VT_R8 )
sub Put( byval _value as double, byref strType as string )
```

Releases the current contents and stores a value, as the [Constructor](#constructor) of the same
arguments does, with these differences:

- An interface pointer is taken over unless `fAddRef` is `true`; a `NULL` pointer leaves the
  variant empty and returns `E_INVALIDARG`.
- With an integer, an unknown `_vType` or type name gives `VT_I8`, not `VT_I4`, and `VT_EMPTY`
  is not accepted (it gives `VT_I8`). The same 32-bit cut as the constructor applies to `VT_I4`:
  `Put( &hB2D05E00ll )` stores -1294967296.
- With a `double`, `_vType` is honoured: `VT_R4`, `VT_R8`, or an integer type, to which the value
  is rounded (`Put( 2.7, VT_I4 )` stores 3). A value that is zero, negative, below the smallest
  normal `single` (about 1.2e-38) or above the largest is always stored as `VT_R8`, whatever
  `_vType` says, so `Put( -2.7, VT_I4 )` stores the double -2.7.

**Returns** the result of the copy, or `S_OK`/`E_INVALIDARG` for an interface pointer; the `sub`
forms return nothing (check [GetLastResult](#getlastresult)).

**Example**

```freebasic
dim dv as DVARIANT
dv.Put( 7, VT_UI2 )     : print dv.vType()   ' prints 18 (VT_UI2)
dv.Put( 7, "SHORT" )    : print dv.vType()   ' prints 2 (VT_I2)
dv.Put( 1.5, VT_R4 )    : print dv.vType()   ' prints 4 (VT_R4)
dv.Put( "text" )        : print dv.vType()   ' prints 8 (VT_BSTR)
```

### PutRef

```freebasic
function PutRef( byval _value as any ptr, byval _vType as WORD = VT_I8 ) as HRESULT
function PutRef( byval _pvar as any ptr, byref strType as string ) as HRESULT
```

Clears the variant and makes it a `VT_BYREF` reference to your variable, by `VT_*` type
(`VT_BOOL`, `VT_I1` … `VT_R8`, `VT_BSTR`, `VT_UNKNOWN`, `VT_DISPATCH`, `VT_DECIMAL`, `VT_CY`,
`VT_DATE`, `VT_VARIANT`, `VT_SAFEARRAY`, `VT_ERROR`) or by the type names the
[Constructor](#constructor) takes, plus `"ERROR"`. The variant reads the variable each time it is
used; the variable must outlive it. COM methods use such references for `[out]` arguments.

**Returns** `S_OK`, or `E_INVALIDARG` for a `NULL` pointer or an unknown type (the variant is
then empty).

**Example**

```freebasic
dim counter as long = 5
dim dv as DVARIANT
dv.PutRef( @counter, VT_I4 )
counter = 6
print dv                       ' prints 6
```

### PutNull

```freebasic
sub PutNull
```

Clears the variant and sets it to `VT_NULL`, the Automation "no data" value (distinct from
`VT_EMPTY`, "not set"). Its text is empty.

**Example**

```freebasic
dim dv as DVARIANT = 1
dv.PutNull
print dv.vType()   ' prints 1 (VT_NULL)
```

### PutBool

```freebasic
sub PutBool( byval _value as BOOL )
```

Stores a Windows `BOOL` as `VT_BOOL`: nonzero becomes `VARIANT_TRUE` (-1), zero `VARIANT_FALSE`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutBool( IsWindow( hwnd ) )
```

### PutBoolean

```freebasic
sub PutBoolean( byval _value as boolean )
```

Stores a `boolean` as `VT_BOOL`. Its text is `-1` for `true` and `0` for `false`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutBoolean( true )
print dv; " "; dv.vType()   ' prints -1 11
```

### PutByte

```freebasic
sub PutByte( byval _value as byte )
```

Stores a signed byte as `VT_I1`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutByte( -5 )
```

### PutUByte

```freebasic
sub PutUByte( byval _value as ubyte )
```

Stores an unsigned byte as `VT_UI1`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutUByte( 255 )
```

### PutShort

```freebasic
sub PutShort( byval _value as short )
```

Stores a 16-bit integer as `VT_I2`, the Automation `Integer`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutShort( -1000 )
```

### PutUShort

```freebasic
sub PutUShort( byval _value as ushort )
```

Stores an unsigned 16-bit integer as `VT_UI2`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutUShort( 65535 )
```

### PutInt

```freebasic
sub PutInt( byval _value as INT_ )
```

Stores a 32-bit integer as `VT_INT`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutInt( 100 )
```

### PutUInt

```freebasic
sub PutUInt( byval _value as UINT )
```

Stores an unsigned 32-bit integer as `VT_UINT`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutUInt( 4000000000ul )
```

### PutLong

```freebasic
sub PutLong( byval _value as long )
```

Stores a 32-bit integer as `VT_I4`, the Automation `Long`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutLong( 123456 )
```

### PutULong

```freebasic
sub PutULong( byval _value as ulong )
```

Stores an unsigned 32-bit integer as `VT_UI4`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutULong( 4000000000ul )
```

### PutLongInt

```freebasic
sub PutLongInt( byval _value as longint )
```

Stores a 64-bit integer as `VT_I8`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutLongInt( -9000000000ll )
```

### PutULongInt

```freebasic
sub PutULongInt( byval _value as ulongint )
```

Stores an unsigned 64-bit integer as `VT_UI8`, the full range included.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutULongInt( &hFFFFFFFFFFFFFFFFull ) : print dv   ' prints 18446744073709551615
```

### PutSingle

```freebasic
sub PutSingle( byval _value as single )
```

Stores a single-precision value as `VT_R4`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutSingle( 1.5 )
```

### PutFloat

```freebasic
sub PutFloat( byval _value as single )
```

The same as [PutSingle](#putsingle).

**Example**

```freebasic
dim dv as DVARIANT
dv.PutFloat( 0.25 )
```

### PutDouble

```freebasic
sub PutDouble( byval _value as double )
```

Stores a double-precision value as `VT_R8`, the Automation `Double`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDouble( 12345678.9 )
print dv                      ' prints 12345678.9
```

### PutBuffer

```freebasic
function PutBuffer( byval pv as any ptr, byval cb as UINT ) as HRESULT
```

Clears the variant and stores a copy of `cb` bytes from `pv` as a one-dimensional array of
`VT_UI1` (`VT_ARRAY or VT_UI1`), the usual way to pass binary data through Automation. Read it
back with [ToBuffer](#tobuffer).

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim bytes as string = "ABC"
dim dv as DVARIANT
dv.PutBuffer( strptr( bytes ), len( bytes ) )
print dv; " "; dv.ToBuffer()    ' prints 65; 66; 67 ABC
```

Microsoft Learn: [InitVariantFromBuffer](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfrombuffer)

### PutSafeArray

```freebasic
function PutSafeArray( byval parray as SAFEARRAY ptr, byval fAttach as boolean = false ) as HRESULT
```

Clears the variant and stores a safe array, with `VT_ARRAY` and the array's own element type.
With `fAttach = false` (the default) the array is copied and stays yours to destroy; with
`fAttach = true` the variant takes it over and destroys it when cleared, so do not destroy it
yourself.

**Returns** `S_OK`, `E_INVALIDARG` for a `NULL` array, or the error from reading or copying it.

**Example**

```freebasic
dim psa as SAFEARRAY ptr = SafeArrayCreateVector( VT_I4, 0, 4 )
dim dv as DVARIANT
dv.PutSafeArray( psa, true )     ' dv now owns psa
print dv.GetElementCount()       ' prints 4
```

Microsoft Learn: [SafeArrayCopy](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraycopy)

### PutResource

```freebasic
function PutResource( byval hinst as HINSTANCE, byval id as UINT ) as HRESULT
```

Clears the variant and stores the string resource `id` of the module `hinst` as a `VT_BSTR`.

**Returns** `S_OK` or an error `HRESULT` (for example when there is no such string).

**Example**

```freebasic
dim dv as DVARIANT
if dv.PutResource( GetModuleHandleW( NULL ), 101 ) <> S_OK then print "no string 101"
```

Microsoft Learn: [InitVariantFromResource](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromresource)

### PutRecord

```freebasic
function PutRecord( byval pIRecordInfo as IRecordInfo ptr, byval pRec as any ptr ) as HRESULT
```

Clears the variant and makes it a `VT_RECORD` that refers to the user-defined type at `pRec`,
described by `pIRecordInfo` (from a type library). The variant stores both pointers as given: it
does not copy the record or add a reference to the record info, but clearing it calls the record
info to free the record, so hand over a record and a reference the variant may release.

**Returns** `S_OK`, or `E_INVALIDARG` when either pointer is `NULL`.

**Example**

```freebasic
dim pInfo as IRecordInfo ptr     ' from GetRecordInfoFromGuids
dim rc as RECT
dim dv as DVARIANT
if dv.PutRecord( pInfo, @rc ) = E_INVALIDARG then print "no record info"
```

Microsoft Learn: [IRecordInfo](https://learn.microsoft.com/en-us/windows/win32/api/oaidl/nn-oaidl-irecordinfo)

### PutDateString

```freebasic
function PutDateString( byval pwszDate as wstring ptr, byval lcid as LCID = 0, byval dwFlags as ulong = 0 ) as HRESULT
```

Clears the variant and parses `pwszDate` into a `VT_DATE`. The text is read in the format of the
locale `lcid` (0 is the system default); ISO dates such as `2026-10-31` are accepted as well.

| Parameter | Meaning |
| --- | --- |
| `pwszDate` | The date, a time, or both, as text. |
| `lcid` | The locale whose format the text is in. |
| `dwFlags` | `VAR_*` parsing flags, such as `VAR_DATEVALUEONLY`. |

**Returns** `S_OK`, or an error such as `DISP_E_TYPEMISMATCH`; on failure the variant is empty.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDateString( "2026-10-31" )
print dv.ToVbDate()                 ' prints 46326
```

Microsoft Learn: [VarDateFromStr](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardatefromstr)

### PutVbDate

```freebasic
function PutVbDate( byval vbDate as DATE_ ) as HRESULT
```

Clears the variant and stores an Automation date as `VT_DATE`. An Automation date is a `double`:
the whole part counts days from 30 December 1899, the fraction is the time of day.

**Returns** `S_OK`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutVbDate( 46326.5 )
print dv                  ' prints 2026/10/31:12:00:00.000
```

### PutSystemTime

```freebasic
function PutSystemTime( byval st as SYSTEMTIME ptr ) as boolean
```

Clears the variant and converts a `SYSTEMTIME` into a `VT_DATE`. Milliseconds are dropped.

**Returns** `true` on success; on failure `false`, the variant stays empty and
[GetLastResult](#getlastresult) is `E_FAIL`.

**Example**

```freebasic
dim st as SYSTEMTIME
GetLocalTime( @st )
dim dv as DVARIANT
if dv.PutSystemTime( @st ) then print "now: "; dv
```

Microsoft Learn: [SystemTimeToVariantTime](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-systemtimetovarianttime)

### PutGuid

```freebasic
function PutGuid( byval pGuid as IID ptr ) as HRESULT
```

Clears the variant and stores the GUID as a `VT_BSTR` in its 38-character braced form, as
[GuidText](SysWin-Com-Procedures#guidtext) writes it.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim g as GUID = IID_IDispatch      ' a copy: PutGuid takes a non-const pointer
dim dv as DVARIANT
dv.PutGuid( @g )
print len( dv.ToStr() ); " "; dv.ToStr() = GuidText( g )   ' prints 38 true
```

Microsoft Learn: [InitVariantFromGUIDAsString](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromguidasstring)

### PutFileTime

```freebasic
function PutFileTime( byval pft as FILETIME ptr ) as HRESULT
```

Clears the variant and converts a `FILETIME` into a `VT_DATE`. No time-zone conversion is made.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim ft as FILETIME
GetSystemTimeAsFileTime( @ft )
dim dv as DVARIANT
dv.PutFileTime( @ft )
```

Microsoft Learn: [InitVariantFromFileTime](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromfiletime)

### PutFileTimeArray

```freebasic
function PutFileTimeArray( byval prgft as FILETIME ptr, byval cElems as ulong ) as HRESULT
```

Clears the variant and stores `cElems` `FILETIME` values as an array of `VT_DATE`.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim times(0 to 1) as FILETIME
GetSystemTimeAsFileTime( @times(0) ) : times(1) = times(0)
dim dv as DVARIANT
dv.PutFileTimeArray( @times(0), 2 )
print dv.GetElementCount()             ' prints 2
```

Microsoft Learn: [InitVariantFromFileTimeArray](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromfiletimearray)

### PutStrRet

```freebasic
function PutStrRet( byval pstrret as STRRET ptr, byval pidl as PCUITEMID_CHILD ) as HRESULT
```

Clears the variant and stores, as a `VT_BSTR`, the string held in a shell `STRRET` (as returned
by `IShellFolder::GetDisplayNameOf`). `pidl` is the item the `STRRET` describes; it is needed
only when the `STRRET` holds an offset into it. A string the `STRRET` owns is freed.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim src as DVARIANT = "hello"
dim sr as STRRET = src.ToStrRet()
dim dv as DVARIANT
dv.PutStrRet( @sr, NULL )
print dv                          ' prints hello
```

Microsoft Learn: [InitVariantFromStrRet](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromstrret)

### PutDec

```freebasic
function PutDec( byval dec as DECIMAL ) as HRESULT
```

Clears the variant and stores a `DECIMAL` (96-bit integer with a scale) as `VT_DECIMAL`.

**Returns** `S_OK`.

**Example**

```freebasic
dim d as DECIMAL
VarDecFromStr( "9.75", 0, 0, @d )
dim dv as DVARIANT
dv.PutDec( d )
print dv              ' prints 9.75
```

### PutDecFromStr

```freebasic
function PutDecFromStr( byval pwszIn as wstring ptr, byval lcid as LCID = 0, byval dwFlags as ulong = 0 ) as HRESULT
```

Clears the variant and parses `pwszIn` into a `VT_DECIMAL`, in the number format of the locale
`lcid` (0 is the system default). Decimals keep up to 28 significant digits exactly.

**Returns** `S_OK`, `E_INVALIDARG` for a `NULL` string, or the parsing error (the variant is then
empty).

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDecFromStr( "123.456" )
print dv; " "; dv.vType()       ' prints 123.456 14
```

Microsoft Learn: [VarDecFromStr](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardecfromstr)

### PutDecFromDouble

```freebasic
function PutDecFromDouble( byval dbIn as double ) as HRESULT
```

Clears the variant and converts a double into a `VT_DECIMAL`.

**Returns** `S_OK` or an error `HRESULT` (the variant is then empty).

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDecFromDouble( 2.5 )
print dv                     ' prints 2.5
```

Microsoft Learn: [VarDecFromR8](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardecfromr8)

### PutDecFromCy

```freebasic
function PutDecFromCy( byval cyIn as CY ) as HRESULT
```

Clears the variant and converts a currency value into a `VT_DECIMAL`. A `CY` is a 64-bit integer
counting ten-thousandths, so `int64 = 12345` is 1.2345.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim money as CY
money.int64 = 12345
dim dv as DVARIANT
dv.PutDecFromCy( money )
print dv                   ' prints 1.2345
```

Microsoft Learn: [VarDecFromCy](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardecfromcy)

### PutBooleanArray

```freebasic
function PutBooleanArray( byval prgf as WINBOOL ptr, byval cElems as ulong ) as HRESULT
```

Clears the variant and stores `cElems` `WINBOOL` values as a one-dimensional array of `VT_BOOL`.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim flags(0 to 1) as WINBOOL = { 1, 0 }
dim dv as DVARIANT
dv.PutBooleanArray( @flags(0), 2 )
print dv                             ' prints -1; 0
```

Microsoft Learn: [InitVariantFromBooleanArray](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfrombooleanarray)

### PutShortArray

```freebasic
function PutShortArray( byval prgf as short ptr, byval cElems as ulong ) as HRESULT
```

Clears the variant and stores `cElems` `short` values as an array of `VT_I2`.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim v(0 to 1) as short = { -1, 2 }
dim dv as DVARIANT
dv.PutShortArray( @v(0), 2 )
print dv                       ' prints -1; 2
```

Microsoft Learn: [InitVariantFromInt16Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromint16array)

### PutUShortArray

```freebasic
function PutUShortArray( byval prgf as ushort ptr, byval cElems as ulong ) as HRESULT
```

Clears the variant and stores `cElems` `ushort` values as an array of `VT_UI2`.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim v(0 to 1) as ushort = { 65535, 2 }
dim dv as DVARIANT
dv.PutUShortArray( @v(0), 2 )
```

Microsoft Learn: [InitVariantFromUInt16Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromuint16array)

### PutLongArray

```freebasic
function PutLongArray( byval prgn as long ptr, byval cElems as ulong ) as DVARIANT
```

Clears the variant and stores `cElems` `long` values as an array of `VT_I4`.

**Returns** a new `DVARIANT` holding the `HRESULT` as a `VT_I4` (0 on success), unlike the other
`Put…Array` methods, which return the `HRESULT` itself. [GetLastResult](#getlastresult) has the
same value.

**Example**

```freebasic
dim v(0 to 2) as long = { 10, 20, 30 }
dim dv as DVARIANT
dv.PutLongArray( @v(0), 3 )
print dv; " / hr"; dv.GetLastResult()   ' prints 10; 20; 30 / hr 0
```

Microsoft Learn: [InitVariantFromInt32Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromint32array)

### PutULongArray

```freebasic
function PutULongArray( byval prgn as ulong ptr, byval cElems as ulong ) as HRESULT
```

Clears the variant and stores `cElems` `ulong` values as an array of `VT_UI4`.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim v(0 to 1) as ulong = { 4000000000ul, 2 }
dim dv as DVARIANT
dv.PutULongArray( @v(0), 2 )
```

Microsoft Learn: [InitVariantFromUInt32Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromuint32array)

### PutLongIntArray

```freebasic
function PutLongIntArray( byval prgn as longint ptr, byval cElems as ulong ) as HRESULT
```

Clears the variant and stores `cElems` `longint` values as an array of `VT_I8`.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim v(0 to 1) as longint = { -9000000000ll, 2 }
dim dv as DVARIANT
dv.PutLongIntArray( @v(0), 2 )
```

Microsoft Learn: [InitVariantFromInt64Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromint64array)

### PutULongIntArray

```freebasic
function PutULongIntArray( byval prgn as ulongint ptr, byval cElems as ulong ) as HRESULT
```

Clears the variant and stores `cElems` `ulongint` values as an array of `VT_UI8`.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim v(0 to 1) as ulongint = { 10000000000ull, 2 }
dim dv as DVARIANT
dv.PutULongIntArray( @v(0), 2 )
```

Microsoft Learn: [InitVariantFromUInt64Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromuint64array)

### PutDoubleArray

```freebasic
function PutDoubleArray( byval prgn as double ptr, byval cElems as ulong ) as HRESULT
```

Clears the variant and stores `cElems` `double` values as an array of `VT_R8`.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim v(0 to 1) as double = { 1.5, 2.25 }
dim dv as DVARIANT
dv.PutDoubleArray( @v(0), 2 )
print dv                         ' prints 1.5; 2.25
```

Microsoft Learn: [InitVariantFromDoubleArray](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromdoublearray)

### PutStringArray

```freebasic
function PutStringArray( byval prgsz as PCWSTR ptr, byval cElems as ulong ) as HRESULT
```

Clears the variant and stores `cElems` strings, given as an array of `wstring` pointers, as an
array of `VT_BSTR`. The strings are copied.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim names(0 to 2) as PCWSTR
names(0) = @wstr( "One" ) : names(1) = @wstr( "Two" ) : names(2) = @wstr( "Three" )
dim dv as DVARIANT
dv.PutStringArray( @names(0), 3 )
print dv                            ' prints One; Two; Three
```

Microsoft Learn: [InitVariantFromStringArray](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromstringarray)

### PutPropVariant

```freebasic
function PutPropVariant( byval pPropVar as PROPVARIANT ptr ) as HRESULT
```

Clears the variant and converts a `PROPVARIANT` (the property-system variant used by the shell
and Windows Media) into it. Types a `VARIANT` cannot hold are converted where Windows can, for
example a vector to a safe array.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim pv as PROPVARIANT
pv.vt = VT_I4 : pv.lVal = 77
dim dv as DVARIANT
dv.PutPropVariant( @pv )
print dv                    ' prints 77
```

Microsoft Learn: [PropVariantToVariant](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-propvarianttovariant)

### PutVariantArrayElement

```freebasic
function PutVariantArrayElement( byval pvarIn as VARIANT ptr, byval iElem as ulong ) as DVARIANT
```

Clears the variant and stores a copy of element `iElem` (counted from 0) of the array, or the
value, in `pvarIn`. Pass the source as `*source` or `@source.vd`, not `source.vptr()`, which would
empty it first.

**Returns** a new `DVARIANT` holding the `HRESULT` as a `VT_I4` (0 on success);
[GetLastResult](#getlastresult) has the same value.

**Example**

```freebasic
dim names(0 to 1) as PCWSTR
names(0) = @wstr( "Alpha" ) : names(1) = @wstr( "Beta" )
dim list as DVARIANT
list.PutStringArray( @names(0), 2 )
dim dv as DVARIANT
dv.PutVariantArrayElement( *list, 1 )
print dv                               ' prints Beta
```

Microsoft Learn: [InitVariantFromVariantArrayElem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-initvariantfromvariantarrayelem)

### GetDim

```freebasic
function GetDim() as ulong
```

Returns the number of dimensions of the safe array in a `VT_ARRAY` variant.

**Returns** the dimension count, or 0 when the variant is not an array.

**Example**

```freebasic
dim v(0 to 2) as long = { 1, 2, 3 }
dim dv as DVARIANT
dv.PutLongArray( @v(0), 3 )
print dv.GetDim()             ' prints 1
```

Microsoft Learn: [SafeArrayGetDim](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetdim)

### GetLBound

```freebasic
function GetLBound( byval nDim as UINT = 1 ) as long
```

Returns the lower bound of dimension `nDim` (counted from 1) of an array variant. Arrays from
COM servers do not always start at 0.

**Returns** the lower bound; 0 when the variant is not an array or the dimension does not exist.

**Example**

```freebasic
dim v(0 to 2) as long = { 1, 2, 3 }
dim dv as DVARIANT
dv.PutLongArray( @v(0), 3 )
print dv.GetLBound(); dv.GetUBound()   ' prints  0 2
```

Microsoft Learn: [SafeArrayGetLBound](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetlbound)

### GetUBound

```freebasic
function GetUBound( byval nDim as UINT = 1 ) as long
```

Returns the upper bound of dimension `nDim` (counted from 1) of an array variant.

**Returns** the upper bound; -1 when the variant is not an array.

**Example**

```freebasic
dim dv as DVARIANT = 5
print dv.GetUBound()        ' prints -1
```

Microsoft Learn: [SafeArrayGetUBound](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetubound)

### GetVariantElement

```freebasic
function GetVariantElement( byval iElem as long ) as DVARIANT
```

Returns a copy of element `iElem` of a one-dimensional array of variants
(`VT_ARRAY or VT_VARIANT`), the kind most Automation collections return. `iElem` is the real
index, so loop from [GetLBound](#getlbound) to [GetUBound](#getubound).

The type is **not** checked: on any other variant the call treats the value as a safe array.
On a number it crashes, and on an array of another element type it returns a meaningless
value. Check `vType() = VT_ARRAY or VT_VARIANT` first.

**Returns** the element; empty, with [GetLastResult](#getlastresult) set, when the index is out
of range.

**Example**

```freebasic
dim pDic as CDispInvoke = "Scripting.Dictionary"
pDic.Invoke( "Add", "k1", "first" )
dim keys as DVARIANT = pDic.Invoke( "Keys" )
if keys.vType() = ( VT_ARRAY or VT_VARIANT ) then print keys.GetVariantElement( 0 )   ' prints k1
```

Microsoft Learn: [SafeArrayGetElement](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetelement)

### GetElementCount

```freebasic
function GetElementCount() as ulong
```

Returns the number of elements in an array variant (all dimensions together).

**Returns** the count; 1 for a variant that is not an array, 0 for one with no array.

**Example**

```freebasic
dim dv as DVARIANT = 5
print dv.GetElementCount()   ' prints 1
```

Microsoft Learn: [VariantGetElementCount](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetelementcount)

### GetBooleanElement

```freebasic
function GetBooleanElement( byval iElem as long ) as boolean
```

Returns element `iElem` (counted from 0) of a `VT_BOOL` array, or the value itself when the
variant is not an array.

**Returns** the element; `false` on failure, with [GetLastResult](#getlastresult) set.

**Example**

```freebasic
dim flags(0 to 1) as WINBOOL = { 1, 0 }
dim dv as DVARIANT
dv.PutBooleanArray( @flags(0), 2 )
print dv.GetBooleanElement( 0 )      ' prints true
```

Microsoft Learn: [VariantGetBooleanElem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetbooleanelem)

### GetShortElement

```freebasic
function GetShortElement( byval iElem as long ) as short
```

Returns element `iElem` (counted from 0) of a `VT_I2` array, or the value itself.

**Returns** the element; 0 on failure, with [GetLastResult](#getlastresult) set.

**Example**

```freebasic
dim v(0 to 1) as short = { -1, 2 }
dim dv as DVARIANT
dv.PutShortArray( @v(0), 2 )
print dv.GetShortElement( 0 )   ' prints -1
```

Microsoft Learn: [VariantGetInt16Elem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetint16elem)

### GetUShortElement

```freebasic
function GetUShortElement( byval iElem as long ) as ushort
```

Returns element `iElem` (counted from 0) of a `VT_UI2` array, or the value itself.

**Returns** the element; 0 on failure.

**Example**

```freebasic
dim v(0 to 1) as ushort = { 65535, 2 }
dim dv as DVARIANT
dv.PutUShortArray( @v(0), 2 )
print dv.GetUShortElement( 0 )   ' prints 65535
```

Microsoft Learn: [VariantGetUInt16Elem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetuint16elem)

### GetLongElement

```freebasic
function GetLongElement( byval iElem as long ) as long
```

Returns element `iElem` (counted from 0) of a `VT_I4` array, or the value itself.

**Returns** the element; 0 on failure.

**Example**

```freebasic
dim v(0 to 2) as long = { 10, 20, 30 }
dim dv as DVARIANT
dv.PutLongArray( @v(0), 3 )
print dv.GetLongElement( 1 )      ' prints 20
```

Microsoft Learn: [VariantGetInt32Elem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetint32elem)

### GetULongElement

```freebasic
function GetULongElement( byval iElem as long ) as ulong
```

Returns element `iElem` (counted from 0) of a `VT_UI4` array, or the value itself.

**Returns** the element; 0 on failure.

**Example**

```freebasic
dim v(0 to 1) as ulong = { 70000, 2 }
dim dv as DVARIANT
dv.PutULongArray( @v(0), 2 )
print dv.GetULongElement( 0 )    ' prints 70000
```

Microsoft Learn: [VariantGetUInt32Elem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetuint32elem)

### GetLongIntElement

```freebasic
function GetLongIntElement( byval iElem as long ) as longint
```

Returns element `iElem` (counted from 0) of a `VT_I8` array, or the value itself.

**Returns** the element; 0 on failure.

**Example**

```freebasic
dim v(0 to 1) as longint = { -12345678, 2 }
dim dv as DVARIANT
dv.PutLongIntArray( @v(0), 2 )
print dv.GetLongIntElement( 0 )   ' prints -12345678
```

Microsoft Learn: [VariantGetInt64Elem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetint64elem)

### GetULongIntElement

```freebasic
function GetULongIntElement( byval iElem as long ) as ulongint
```

Returns element `iElem` (counted from 0) of a `VT_UI8` array, or the value itself.

**Returns** the element; 0 on failure.

**Example**

```freebasic
dim v(0 to 1) as ulongint = { 12345678, 2 }
dim dv as DVARIANT
dv.PutULongIntArray( @v(0), 2 )
print dv.GetULongIntElement( 0 )   ' prints 12345678
```

Microsoft Learn: [VariantGetUInt64Elem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetuint64elem)

### GetDoubleElement

```freebasic
function GetDoubleElement( byval iElem as long ) as double
```

Returns element `iElem` (counted from 0) of a `VT_R8` array, or the value itself. Elements of
other numeric arrays are not converted: on a `long` array it returns 0.

**Returns** the element; 0 on failure.

**Example**

```freebasic
dim v(0 to 1) as double = { 1.5, 2.25 }
dim dv as DVARIANT
dv.PutDoubleArray( @v(0), 2 )
print dv.GetDoubleElement( 1 )     ' prints 2.25
```

Microsoft Learn: [VariantGetDoubleElem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetdoubleelem)

### GetStringElement

```freebasic
function GetStringElement( byval iElem as long ) as ustring
```

Returns element `iElem` (counted from 0) of a `VT_BSTR` array, or the string itself.

**Returns** the element; an empty string on failure.

**Example**

```freebasic
dim names(0 to 2) as PCWSTR
names(0) = @wstr( "One" ) : names(1) = @wstr( "Two" ) : names(2) = @wstr( "Three" )
dim dv as DVARIANT
dv.PutStringArray( @names(0), 3 )
print dv.GetStringElement( 2 )      ' prints Three
```

Microsoft Learn: [VariantGetStringElem](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-variantgetstringelem)

### ToStr

```freebasic
function ToStr() as ustring
```

Returns the value as text, the same as [VarToStr](SysWin-Com-Procedures#vartostr) on `vd`. Numbers
are written without grouping; `VT_BOOL` is `-1` or `0`; `VT_CY` has four decimals unless it is a
whole number (`123.4567`, `5`); a date is `2026/10/31:12:30:00.000`; `VT_EMPTY` and `VT_NULL`
are empty. The elements of an array are joined with `"; "`.

**Returns** the text, or an empty string when the value cannot be converted.

**Example**

```freebasic
dim money as CURRENCY
money.int64 = 1234567
dim dv as DVARIANT = money
print dv.ToStr()               ' prints 123.4567
```

Microsoft Learn: [VariantToStringAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttostringalloc)

### ToBStr

```freebasic
function ToBStr() as BSTRING
```

Returns the same text as [ToStr](#tostr), in a [BSTRING](BSTRING), for a method that wants a
`BSTR`.

**Example**

```freebasic
dim dv as DVARIANT = 12345
dim bs as BSTRING = dv.ToBStr()
```

### ToBuffer

```freebasic
function ToBuffer( byval pv as any ptr, byval cb as UINT ) as HRESULT
function ToBuffer() as string
```

Copies the bytes of a `VT_ARRAY or VT_UI1` variant out: the first `cb` bytes into the buffer at
`pv`, or all of them into a new `string`. [GetElementCount](#getelementcount) gives the size.

The first form copies only `cb` bytes when the variant holds more, and fails (`E_FAIL`) when it
holds fewer. The second form does not check the type: for a variant that is not an array it
returns a single space (`" "`), and for an empty array an empty string.

**Returns** `S_OK` or an error `HRESULT`; the second form the bytes.

**Example**

```freebasic
dim data_ as string = "ABC"
dim dv as DVARIANT
dv.PutBuffer( strptr( data_ ), 3 )
dim buf as string = space( dv.GetElementCount() )
dv.ToBuffer( strptr( buf ), len( buf ) )
print buf; " "; dv.ToBuffer()               ' prints ABC ABC
```

Microsoft Learn: [VariantToBuffer](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttobuffer)

### ToUnknown

```freebasic
function ToUnknown() as any ptr
```

Returns the object in a `VT_UNKNOWN` or `VT_DISPATCH` variant as an `IUnknown` pointer, with a
reference added that you release with [SafeRelease](SysWin-Com-Procedures#saferelease). The
variant keeps its own reference.

**Returns** the pointer, or `NULL` when the variant holds no object.

**Example**

```freebasic
dim pDic as IDispatch ptr = AnyCom( "Scripting.Dictionary" )
dim dv as DVARIANT = DVARIANT( pDic )     ' dv takes over pDic
dim pUnk as any ptr = dv.ToUnknown()
if pUnk then SafeRelease( pUnk )
```

Microsoft Learn: [IUnknown](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown)

### ToDispatch

```freebasic
function ToDispatch() as any ptr
```

Returns the object in a `VT_DISPATCH` or `VT_UNKNOWN` variant as an `IDispatch` pointer, with a
reference added that you release. For a `VT_UNKNOWN` object that has no `IDispatch`, it returns
the `IUnknown` pointer instead (also with a reference added).

**Returns** the pointer, or `NULL` when the variant holds no object.

**Example**

```freebasic
dim dv as DVARIANT = DVARIANT( AnyCom( "Scripting.Dictionary" ) )
dim pDisp as IDispatch ptr = dv.ToDispatch()
if pDisp then SafeRelease( pDisp )
```

Microsoft Learn: [IDispatch](https://learn.microsoft.com/en-us/windows/win32/api/oaidl/nn-oaidl-idispatch)

### DecToDouble

```freebasic
function DecToDouble() as double
```

Converts a `VT_DECIMAL` variant to a double.

**Returns** the value, or 0 when the variant is not `VT_DECIMAL`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDecFromStr( "123.456" )
print dv.DecToDouble()          ' prints 123.456
```

Microsoft Learn: [VarR8FromDec](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varr8fromdec)

### DecToCy

```freebasic
function DecToCy() as CY
```

Converts a `VT_DECIMAL` variant to a currency value (ten-thousandths in a 64-bit integer).

**Returns** the value; zero when the variant is not `VT_DECIMAL`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDecFromDouble( 2.5 )
print dv.DecToCy().int64        ' prints 25000
```

Microsoft Learn: [VarCyFromDec](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varcyfromdec)

### ToVbDate

```freebasic
function ToVbDate() as DATE_
```

Returns the Automation date in a `VT_DATE` variant: days since 30 December 1899, with the time
as the fraction.

**Returns** the date; 0 when the variant is not `VT_DATE`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDateString( "2026-10-31 12:00" )
print dv.ToVbDate()                    ' prints 46326.5
```

### ToSystemTime

```freebasic
function ToSystemTime() as SYSTEMTIME
```

Returns the date in a `VT_DATE` variant as a `SYSTEMTIME`.

**Returns** the date; all zeros when the variant is not `VT_DATE`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDateString( "2026-10-31" )
dim st as SYSTEMTIME = dv.ToSystemTime()
print st.wYear & "-" & st.wMonth & "-" & st.wDay   ' prints 2026-10-31
```

Microsoft Learn: [VariantTimeToSystemTime](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varianttimetosystemtime)

### ToGuid

```freebasic
function ToGuid() as GUID
```

Reads a GUID from a variant that holds one as a string (`{…}` form) or as a byte array.

**Returns** the GUID; all zeros on failure.

**Example**

```freebasic
dim dv as DVARIANT = GuidText( IID_IDispatch )   ' the GUID as text
dim g as GUID = dv.ToGuid()
print IsEqualGUID( @g, @IID_IDispatch )          ' prints -1
```

Microsoft Learn: [VariantToGUID](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttoguid)

### ToGuidStr

```freebasic
function ToGuidStr() as ustring
```

Reads a GUID as [ToGuid](#toguid) does and returns it in canonical braced, upper-case form. Unlike
the other methods it does not update [GetLastResult](#getlastresult).

**Returns** the GUID text, or an empty string on failure.

**Example**

```freebasic
dim dv as DVARIANT = lcase( GuidText( IID_IDispatch ) )
print dv.ToGuidStr() = GuidText( IID_IDispatch )      ' prints -1
```

### ToDosDateTime

```freebasic
function ToDosDateTime( byval pwDate as ushort ptr, byval pwTime as ushort ptr ) as HRESULT
```

Converts a date variant into the two 16-bit words of an MS-DOS date and time, as used in ZIP
files and FAT directory entries. MS-DOS times have a two-second resolution.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDateString( "2026-10-31 12:30" )
dim as ushort wDate, wTime
dv.ToDosDateTime( @wDate, @wTime )
print wDate & " " & wTime                ' prints 23903 25536
```

Microsoft Learn: [VariantToDosDateTime](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttodosdatetime)

### ToFileTime

```freebasic
function ToFileTime( byval stfOut as PSTIME_FLAGS ) as FILETIME
```

Converts a date variant into a `FILETIME`. The date is taken to be UTC: with `PSTF_UTC` it is
returned as it is, with `PSTF_LOCAL` it is converted to local time first.

**Returns** the `FILETIME`; zeros on failure, with [GetLastResult](#getlastresult) set.

**Example**

```freebasic
dim dv as DVARIANT
dv.PutDateString( "2026-10-31" )
dim ft as FILETIME = dv.ToFileTime( PSTF_UTC )
```

Microsoft Learn: [VariantToFileTime](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttofiletime)

### ToStrRet

```freebasic
function ToStrRet() as STRRET
```

Copies the string of a `VT_BSTR` variant into a shell `STRRET`. The `STRRET` holds memory
allocated with `CoTaskMemAlloc`; pass it on to whoever frees it (for example
[PutStrRet](#putstrret) or `StrRetToBufW`), or free its `pOleStr` with `CoTaskMemFree`.

**Returns** the `STRRET`; [GetLastResult](#getlastresult) is the result.

**Example**

```freebasic
dim dv as DVARIANT = "hello"
dim sr as STRRET = dv.ToStrRet()
if dv.GetLastResult() = S_OK then CoTaskMemFree( sr.pOleStr )
```

Microsoft Learn: [VariantToStrRet](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttostrret)

### ToBooleanArray

```freebasic
function ToBooleanArray( byval prgf as WINBOOL ptr, byval crgn as ulong ) as ulong
```

Copies the elements of a boolean array variant into the `crgn` `WINBOOL` values at `prgf`.

**Returns** the number of elements copied. When the array holds more than `crgn` elements nothing
is copied, 0 is returned and [GetLastResult](#getlastresult) is `TYPE_E_BUFFERTOOSMALL`
(&h80028016); a variant of another type gives `E_INVALIDARG`.

**Example**

```freebasic
dim src(0 to 2) as WINBOOL = { 1, 0, 1 }
dim dv as DVARIANT
dv.PutBooleanArray( @src(0), 3 )
dim flags(0 to 2) as WINBOOL
print dv.ToBooleanArray( @flags(0), 3 )   ' prints 3
```

Microsoft Learn: [VariantToBooleanArray](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttobooleanarray)

### ToBooleanArrayAlloc

```freebasic
function ToBooleanArrayAlloc( byval pprgf as WINBOOL ptr ptr ) as ulong
```

Allocates an array of `WINBOOL` the size of the variant's array, copies the elements into it and
stores its address in `*pprgf`. Free it with `CoTaskMemFree`.

**Returns** the number of elements; 0 on failure, with [GetLastResult](#getlastresult) set.

**Example**

```freebasic
dim src(0 to 1) as WINBOOL = { 1, 0 }
dim dv as DVARIANT
dv.PutBooleanArray( @src(0), 2 )
dim pf as WINBOOL ptr
dim n as ulong = dv.ToBooleanArrayAlloc( @pf )
CoTaskMemFree( pf )
```

Microsoft Learn: [VariantToBooleanArrayAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttobooleanarrayalloc)

### ToShortArray

```freebasic
function ToShortArray( byval prgn as short ptr, byval crgn as ulong ) as ulong
```

Copies the elements of the array variant into the `crgn` `short` values at `prgn`, converting
them where possible.

**Returns** the number of elements copied; 0 when the buffer is too small
(`TYPE_E_BUFFERTOOSMALL`) or the variant is of the wrong type.

**Example**

```freebasic
dim src(0 to 1) as short = { -1, 2 }
dim dv as DVARIANT
dv.PutShortArray( @src(0), 2 )
dim v(0 to 1) as short
dv.ToShortArray( @v(0), 2 )
```

Microsoft Learn: [VariantToInt16Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttoint16array)

### ToShortArrayAlloc

```freebasic
function ToShortArrayAlloc( byval pprgn as short ptr ptr ) as ulong
```

Allocates an array of `short`, copies the elements into it and stores its address in `*pprgn`.
Free it with `CoTaskMemFree`.

**Returns** the number of elements; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as short = { -1, 2 }
dim dv as DVARIANT
dv.PutShortArray( @src(0), 2 )
dim p as short ptr
if dv.ToShortArrayAlloc( @p ) then CoTaskMemFree( p )
```

Microsoft Learn: [VariantToInt16ArrayAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttoint16arrayalloc)

### ToUShortArray

```freebasic
function ToUShortArray( byval prgn as ushort ptr, byval crgn as ulong ) as ulong
```

Copies the elements of the array variant into the `crgn` `ushort` values at `prgn`.

**Returns** the number of elements copied; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as ushort = { 7, 8 }
dim dv as DVARIANT
dv.PutUShortArray( @src(0), 2 )
dim v(0 to 1) as ushort
dv.ToUShortArray( @v(0), 2 )
```

Microsoft Learn: [VariantToUInt16Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttouint16array)

### ToUShortArrayAlloc

```freebasic
function ToUShortArrayAlloc( byval pprgn as ushort ptr ptr ) as ulong
```

Allocates an array of `ushort`, copies the elements into it and stores its address in `*pprgn`.
Free it with `CoTaskMemFree`.

**Returns** the number of elements; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as ushort = { 7, 8 }
dim dv as DVARIANT
dv.PutUShortArray( @src(0), 2 )
dim p as ushort ptr
if dv.ToUShortArrayAlloc( @p ) then CoTaskMemFree( p )
```

Microsoft Learn: [VariantToUInt16ArrayAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttouint16arrayalloc)

### ToLongArray

```freebasic
function ToLongArray( byval prgn as long ptr, byval crgn as ulong ) as ulong
```

Copies the elements of the array variant into the `crgn` `long` values at `prgn`.

**Returns** the number of elements copied; 0 when the buffer is too small (as the example's second
call shows) or the variant is of the wrong type.

**Example**

```freebasic
dim src(0 to 2) as long = { 10, 20, 30 }
dim dv as DVARIANT
dv.PutLongArray( @src(0), 3 )
dim v(0 to 4) as long, small(0 to 1) as long
print dv.ToLongArray( @v(0), 5 ) & " " & dv.ToLongArray( @small(0), 2 )   ' prints 3 0
```

Microsoft Learn: [VariantToInt32Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttoint32array)

### ToLongArrayAlloc

```freebasic
function ToLongArrayAlloc( byval pprgn as long ptr ptr ) as ulong
```

Allocates an array of `long`, copies the elements into it and stores its address in `*pprgn`.
Free it with `CoTaskMemFree`.

**Returns** the number of elements; 0 on failure.

**Example**

```freebasic
dim src(0 to 2) as long = { 10, 20, 30 }
dim dv as DVARIANT
dv.PutLongArray( @src(0), 3 )
dim p as long ptr
dim n as ulong = dv.ToLongArrayAlloc( @p )
print n; p[2]                              ' prints 3 30
CoTaskMemFree( p )
```

Microsoft Learn: [VariantToInt32ArrayAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttoint32arrayalloc)

### ToULongArray

```freebasic
function ToULongArray( byval prgn as ulong ptr, byval crgn as ulong ) as ulong
```

Copies the elements of the array variant into the `crgn` `ulong` values at `prgn`.

**Returns** the number of elements copied; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as ulong = { 1, 2 }
dim dv as DVARIANT
dv.PutULongArray( @src(0), 2 )
dim v(0 to 1) as ulong
dv.ToULongArray( @v(0), 2 )
```

Microsoft Learn: [VariantToUInt32Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttouint32array)

### ToULongArrayAlloc

```freebasic
function ToULongArrayAlloc( byval pprgn as ulong ptr ptr ) as ulong
```

Allocates an array of `ulong`, copies the elements into it and stores its address in `*pprgn`.
Free it with `CoTaskMemFree`.

**Returns** the number of elements; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as ulong = { 1, 2 }
dim dv as DVARIANT
dv.PutULongArray( @src(0), 2 )
dim p as ulong ptr
if dv.ToULongArrayAlloc( @p ) then CoTaskMemFree( p )
```

Microsoft Learn: [VariantToUInt32ArrayAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttouint32arrayalloc)

### ToLongIntArray

```freebasic
function ToLongIntArray( byval prgn as longint ptr, byval crgn as ulong ) as ulong
```

Copies the elements of the array variant into the `crgn` `longint` values at `prgn`.

**Returns** the number of elements copied; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as longint = { 1, 2 }
dim dv as DVARIANT
dv.PutLongIntArray( @src(0), 2 )
dim v(0 to 1) as longint
dv.ToLongIntArray( @v(0), 2 )
```

Microsoft Learn: [VariantToInt64Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttoint64array)

### ToLongIntArrayAlloc

```freebasic
function ToLongIntArrayAlloc( byval pprgn as longint ptr ptr ) as ulong
```

Allocates an array of `longint`, copies the elements into it and stores its address in
`*pprgn`. Free it with `CoTaskMemFree`.

**Returns** the number of elements; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as longint = { 1, 2 }
dim dv as DVARIANT
dv.PutLongIntArray( @src(0), 2 )
dim p as longint ptr
if dv.ToLongIntArrayAlloc( @p ) then CoTaskMemFree( p )
```

Microsoft Learn: [VariantToInt64ArrayAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttoint64arrayalloc)

### ToULongIntArray

```freebasic
function ToULongIntArray( byval prgn as ulongint ptr, byval crgn as ulong ) as ulong
```

Copies the elements of the array variant into the `crgn` `ulongint` values at `prgn`.

**Returns** the number of elements copied; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as ulongint = { 1, 2 }
dim dv as DVARIANT
dv.PutULongIntArray( @src(0), 2 )
dim v(0 to 1) as ulongint
dv.ToULongIntArray( @v(0), 2 )
```

Microsoft Learn: [VariantToUInt64Array](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttouint64array)

### ToULongIntArrayAlloc

```freebasic
function ToULongIntArrayAlloc( byval pprgn as ulongint ptr ptr ) as ulong
```

Allocates an array of `ulongint`, copies the elements into it and stores its address in
`*pprgn`. Free it with `CoTaskMemFree`.

**Returns** the number of elements; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as ulongint = { 1, 2 }
dim dv as DVARIANT
dv.PutULongIntArray( @src(0), 2 )
dim p as ulongint ptr
if dv.ToULongIntArrayAlloc( @p ) then CoTaskMemFree( p )
```

Microsoft Learn: [VariantToUInt64ArrayAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttouint64arrayalloc)

### ToDoubleArray

```freebasic
function ToDoubleArray( byval prgn as double ptr, byval crgn as ulong ) as ulong
```

Copies the elements of the array variant into the `crgn` `double` values at `prgn`.

**Returns** the number of elements copied; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as double = { 1.5, 2.25 }
dim dv as DVARIANT
dv.PutDoubleArray( @src(0), 2 )
dim v(0 to 1) as double
dv.ToDoubleArray( @v(0), 2 )
```

Microsoft Learn: [VariantToDoubleArray](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttodoublearray)

### ToDoubleArrayAlloc

```freebasic
function ToDoubleArrayAlloc( byval pprgn as double ptr ptr ) as ulong
```

Allocates an array of `double`, copies the elements into it and stores its address in `*pprgn`.
Free it with `CoTaskMemFree`.

**Returns** the number of elements; 0 on failure.

**Example**

```freebasic
dim src(0 to 1) as double = { 1.5, 2.25 }
dim dv as DVARIANT
dv.PutDoubleArray( @src(0), 2 )
dim p as double ptr
if dv.ToDoubleArrayAlloc( @p ) then CoTaskMemFree( p )
```

Microsoft Learn: [VariantToDoubleArrayAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttodoublearrayalloc)

### ToStringArray

```freebasic
function ToStringArray( byval prgsz as PWSTR ptr, byval crgsz as ulong ) as ulong
```

Copies the strings of the array variant into newly allocated `wstring` buffers and stores their
addresses in the `crgsz` pointers at `prgsz`. Free each string with `CoTaskMemFree`.

**Returns** the number of strings copied; 0 on failure.

**Example**

```freebasic
dim names(0 to 1) as PCWSTR
names(0) = @wstr( "Alpha" ) : names(1) = @wstr( "Beta" )
dim dv as DVARIANT
dv.PutStringArray( @names(0), 2 )
dim copies(0 to 3) as PWSTR
dim n as ulong = dv.ToStringArray( @copies(0), 4 )
for i as long = 0 to n - 1 : CoTaskMemFree( copies(i) ) : next
```

Microsoft Learn: [VariantToStringArray](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttostringarray)

### ToStringArrayAlloc

```freebasic
function ToStringArrayAlloc( byval pprgsz as PWSTR ptr ptr ) as ulong
```

Allocates an array of string pointers and a buffer for each string, copies the strings and stores
the array's address in `*pprgsz`. Free each string and then the array with `CoTaskMemFree`.

**Returns** the number of strings; 0 on failure.

**Example**

```freebasic
dim names(0 to 1) as PCWSTR
names(0) = @wstr( "Alpha" ) : names(1) = @wstr( "Beta" )
dim dv as DVARIANT
dv.PutStringArray( @names(0), 2 )
dim pp as PWSTR ptr
dim n as ulong = dv.ToStringArrayAlloc( @pp )
for i as long = 0 to n - 1 : CoTaskMemFree( pp[i] ) : next
CoTaskMemFree( pp )
```

Microsoft Learn: [VariantToStringArrayAlloc](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-varianttostringarrayalloc)

### Clear

```freebasic
sub Clear
```

Releases the contents, as the destructor does, and leaves the variant `VT_EMPTY`.

**Example**

```freebasic
dim dv as DVARIANT = "text"
dv.Clear
print dv.vType()   ' prints 0 (VT_EMPTY)
```

Microsoft Learn: [VariantClear](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-variantclear)

### Attach

```freebasic
function Attach( byval pvar as VARIANT ptr ) as HRESULT
function Attach( byref v as VARIANT ) as HRESULT
```

Clears the variant and takes over the contents of a `VARIANT` without copying them: the
`DVARIANT` now owns the string, object or array, and the source is marked `VT_EMPTY` so that
clearing it frees nothing. Use it for a `VARIANT` a Windows function filled in.

**Returns** `S_OK`, or `E_INVALIDARG` for a `NULL` pointer.

**Example**

```freebasic
dim raw as VARIANT
raw.vt = VT_BSTR : raw.bstrVal = SysAllocString( "owned" )
dim dv as DVARIANT
dv.Attach( raw )
print dv; " "; raw.vt                ' prints owned 0
```

### Detach

```freebasic
function Detach( byval pvar as VARIANT ptr ) as HRESULT
function Detach( byref v as VARIANT ) as HRESULT
```

Clears the target `VARIANT` and moves the contents into it without copying; the `DVARIANT` is
left `VT_EMPTY`. The target now owns them and must be cleared with `VariantClear`.

**Returns** `S_OK`, or `E_INVALIDARG` for a `NULL` pointer (with
[GetLastResult](#getlastresult) set to `E_FAIL`).

**Example**

```freebasic
dim dv as DVARIANT = "moved"
dim v as VARIANT
dv.Detach( v )
print v.vt & " " & dv.vType()     ' prints 8 0
VariantClear( @v )
```

### vType

```freebasic
function vType() as VARTYPE
```

Returns the type code of the variant, `vd.vt`: a `VT_*` value, combined with `VT_ARRAY` for an
array and with `VT_BYREF` for a reference.

**Returns** the type code.

**Example**

```freebasic
dim dv as DVARIANT = "text"
if dv.vType() = VT_BSTR then print "a string"
```

Microsoft Learn: [VARENUM](https://learn.microsoft.com/en-us/windows/win32/api/wtypes/ne-wtypes-varenum)

### ChangeType

```freebasic
function ChangeType( byval vtNew as VARTYPE, byval wFlags as ushort = 0 ) as HRESULT
```

Converts the variant in place to the type `vtNew`. A failed conversion leaves the variant as it
was.

| Parameter | Meaning |
| --- | --- |
| `vtNew` | The type wanted, such as `VT_BSTR`, `VT_I4`, `VT_R8`, `VT_DATE`. |
| `wFlags` | `VARIANT_*` conversion flags, such as `VARIANT_ALPHABOOL` (text `True`/`False`). |

**Returns** `S_OK`, or an error such as `DISP_E_TYPEMISMATCH` (&h80020005) or
`DISP_E_OVERFLOW`.

**Example**

```freebasic
dim dv as DVARIANT = "12"
if dv.ChangeType( VT_I4 ) = S_OK then print dv.vType()   ' prints 3
```

Microsoft Learn: [VariantChangeType](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-variantchangetype)

### ChangeTypeEx

```freebasic
function ChangeTypeEx( byval vtNew as VARTYPE, byval lcid as LCID = 0, byval wFlags as ushort = 0 ) as HRESULT
```

Converts the variant in place like [ChangeType](#changetype), reading and writing text in the
format of the locale `lcid`.

**Returns** `S_OK` or an error `HRESULT`.

**Example**

```freebasic
dim dv as DVARIANT = "1,5"
dv.ChangeTypeEx( VT_R8, MAKELCID( MAKELANGID( LANG_GERMAN, SUBLANG_GERMAN ), SORT_DEFAULT ) )
print dv                     ' prints 1.5
```

Microsoft Learn: [VariantChangeTypeEx](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-variantchangetypeex)

### Round

```freebasic
function Round( byref dv as DVARIANT, byval cDecimals as long ) as DVARIANT
function Round( byval cDecimals as long ) as DVARIANT
```

Rounds a numeric variant to `cDecimals` decimal places; halves round to the even digit.

The one-argument form rounds **this** variant: it changes it and also returns the result. The
two-argument form rounds `dv` and returns the result, leaving both `dv` and this variant
unchanged (only [GetLastResult](#getlastresult) is set).

**Returns** the rounded value; empty on failure.

**Example**

```freebasic
dim dv as DVARIANT
dv = 3.14159
dim r as DVARIANT = dv.Round( 2 )
print r; " "; dv                   ' prints 3.14 3.14
```

Microsoft Learn: [VarRound](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varround)

### FormatNumber

```freebasic
function FormatNumber( byval iNumDig as long = -1, byval ilncLead as long = -2, byval iUseParens as long = -2, byval iGroup as long = -2, byval dwFlags as DWORD = 0 ) as ustring
```

Formats a numeric variant as text with the user's decimal and thousands separators.

| Parameter | Meaning |
| --- | --- |
| `iNumDig` | Digits after the decimal point; -1 uses the regional setting. |
| `ilncLead` | Leading zero for values below 1: -2 regional setting, -1 yes, 0 no. |
| `iUseParens` | Negative values in parentheses: -2 regional setting, -1 yes, 0 no. |
| `iGroup` | Thousands separators: -2 regional setting, -1 yes, 0 no. |
| `dwFlags` | `VAR_CALENDAR_*` and other `VAR_*` flags. |

**Returns** the text, or an empty string when the variant is not a number (with
[GetLastResult](#getlastresult) set).

**Example**

```freebasic
dim dv as DVARIANT
dv = -1234.5
print dv.FormatNumber( 2 ); " "; dv.FormatNumber( 0, , -1, 0 )   ' prints -1,234.50 (1235)
```

The separators come from the user's regional settings; the output shown is for a locale with `,`
grouping thousands and `.` as the decimal point.

Microsoft Learn: [VarFormatNumber](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varformatnumber)

### GetLastResult

```freebasic
function GetLastResult() as long
```

Returns the `HRESULT` that the last method or operator stored. Most methods reset it to `S_OK`
(0) when they start.

**Example**

```freebasic
dim dv as DVARIANT = "abc"
dv.ChangeType( VT_I4 )
print "&h"; hex( dv.GetLastResult() )   ' prints &h80020005
```

### SetResult

```freebasic
function SetResult( byval Result as long ) as long
```

Stores `Result` as the last result code, for code that reports its own errors through the
variant.

**Returns** `Result`.

**Example**

```freebasic
dim dv as DVARIANT
dv.SetResult( E_FAIL )
print dv.GetErrorInfo()
```

### GetErrorInfo

```freebasic
function GetErrorInfo( byval dwError as long = -1 ) as ustring
```

Describes a result code in words, from the system message table. With the default -1 it
describes [GetLastResult](#getlastresult). Any nonzero code is preceded by a line
`Error &h…`; the system text ends with a line break.

**Returns** the description; for a code Windows has no text for, only the `Error &h…` line.

**Example**

```freebasic
dim dv as DVARIANT
print dv.GetErrorInfo( E_INVALIDARG )   ' Error &h80070057, then The parameter is incorrect.
```

Microsoft Learn: [FormatMessageW](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-formatmessagew)

### Compound assignment

```freebasic
operator +=( byref dv as DVARIANT )
operator &=( byref dv as DVARIANT )
operator -=( byref dv as DVARIANT )
operator *=( byref dv as DVARIANT )
operator /=( byref dv as DVARIANT )
operator \=( byref dv as DVARIANT )
operator ^=( byref dv as DVARIANT )
operator and=( byref dv as DVARIANT )
operator or=( byref dv as DVARIANT )
operator xor=( byref dv as DVARIANT )
operator eqv=( byref dv as DVARIANT )
operator imp=( byref dv as DVARIANT )
operator mod=( byref dv as DVARIANT )
```

Combines the variant with `dv` and stores the result, with Automation's rules for mixed types.
The right-hand side must be a `DVARIANT`: write `x += DVARIANT( 1 )`, or keep the value in one.

- `+=` and `&=` **concatenate** when both sides are strings and **add** otherwise, so `&=` on two
  numbers adds them (`5 &= 1` gives 6).
- The other operators do nothing when either side is a string: the variant is left as it was and
  [GetLastResult](#getlastresult) is `S_OK`.
- `and=`, `or=`, `xor=`, `eqv=`, `imp=` are bitwise on integers; `mod=` is the remainder.

On failure the variant keeps its value and [GetLastResult](#getlastresult) holds the error.

**Example**

```freebasic
dim x as DVARIANT = 7, y as DVARIANT = 2
x += y  : print x        ' prints 9
x \= y  : print x        ' prints 4
x ^= y  : print x        ' prints 16
dim s as DVARIANT = "ab"
s &= DVARIANT( "cd" ) : print s    ' prints abcd
```

Microsoft Learn: [VarAdd](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varadd)

### Arithmetic operators

```freebasic
operator +( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as DVARIANT
operator -( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as DVARIANT
operator *( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as DVARIANT
operator /( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as DVARIANT
operator \( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as DVARIANT
operator ^( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as double
operator -( byref dv as DVARIANT ) as DVARIANT
```

Compute with two variants by Automation's rules: the result type widens as needed (`7 / 2` is
the double 3.5), a string that holds a number takes part as that number (`"10" * 2` is 20), and
`\` divides and truncates. `+` **concatenates** when either side is a string, so `"10" + 2` is
`"102"`. `^` returns a `double`; unary `-` negates. A failed operation returns an empty variant.

**Example**

```freebasic
dim x as DVARIANT = 7, y as DVARIANT = 2
dim r as DVARIANT = x / y, q as DVARIANT = x \ y, n as DVARIANT = -x
print r; " "; q; " "; n; x ^ y              ' prints 3.5 3 -7 49
```

Microsoft Learn: [VarDiv](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardiv)

### Concatenation

```freebasic
operator &( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as DVARIANT
```

Joins the text of two variants into a `VT_BSTR`; numbers are converted first.

**Example**

```freebasic
dim a as DVARIANT = "abc", b as DVARIANT = 5
dim c as DVARIANT = a & b
print c                         ' prints abc5
```

Microsoft Learn: [VarCat](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varcat)

### Comparison operators

```freebasic
operator <>( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as boolean
operator <( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as boolean
operator >( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as boolean
operator <=( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as boolean
operator >=( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as boolean
```

Compare two variants with Automation's rules, in the thread's locale: numbers by value, strings
by text (case counts), and a number is always less than a string, so `7 <> "7"` is `true`.
There is **no `=` operator** between two variants: write `not ( a <> b )`.

**Example**

```freebasic
dim x as DVARIANT = 7, y as DVARIANT = 7
print x <> y; " "; not ( x <> y ); " "; DVARIANT( "abc" ) < DVARIANT( "abd" )   ' prints false true true
```

Microsoft Learn: [VarCmp](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varcmp)

### And, Or, Xor, Eqv, Imp, Mod, Not

```freebasic
operator and( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as integer
operator or( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as integer
operator xor( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as integer
operator eqv( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as integer
operator imp( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as integer
operator mod( byref dv1 as DVARIANT, byref dv2 as DVARIANT ) as integer
operator not( byref dv as DVARIANT ) as integer
```

Bitwise operations and the remainder on two variants (one for `not`), returning a plain
`integer`. `VT_BOOL` values are -1 and 0, so these work as logical operators on them too.

**Example**

```freebasic
dim x as DVARIANT = 7, y as DVARIANT = 2
print x and y; x or y; x xor y; x mod y; not x   ' prints  2 7 5 1-8
```

Microsoft Learn: [VarAnd](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varand)

### Abs, Fix, Int

```freebasic
operator abs( byref dv as DVARIANT ) as integer
operator fix( byref dv as DVARIANT ) as integer
operator int( byref dv as DVARIANT ) as integer
```

`abs` is the absolute value, `fix` drops the fraction, `int` rounds down. All three return an
`integer`, so the fraction of `abs` is rounded away: `abs( -3.7 )` is 4.

**Example**

```freebasic
dim w as DVARIANT = -3.7
print abs( w ); fix( w ); int( w )   ' prints  4-3-4
```

Microsoft Learn: [VarFix](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varfix)

### Pointer operator

```freebasic
operator *( byref dv as DVARIANT ) as VARIANT ptr
```

`*dv` is `@dv.vd`, the address of the `VARIANT`, for passing the value to a function that reads
a `VARIANT ptr`. It does not clear anything; for an output parameter use [vptr](#vptr).

**Example**

```freebasic
dim dv as DVARIANT = 5
dim text as ustring = VarToStr( *dv )
print ( *dv )->vt; " "; text          ' prints 3 5
```

### Left

```freebasic
function Left overload( byref dv as DVARIANT, byval nChars as integer ) as ustring
```

Returns the first `nChars` characters of the variant's text ([ToStr](#tostr)).

**Example**

```freebasic
dim dv as DVARIANT = "42.5"
print Left( dv, 2 )           ' prints 42
```

### Right

```freebasic
function Right overload( byref dv as DVARIANT, byval nChars as integer ) as ustring
```

Returns the last `nChars` characters of the variant's text.

**Example**

```freebasic
dim dv as DVARIANT = "42.5"
print Right( dv, 2 )          ' prints .5
```

### Val

```freebasic
function Val overload( byref dv as DVARIANT ) as double
```

Reads the variant's text as a number, the way to get a numeric value out of a `DVARIANT`. Write
it `com.Val`: a bare `Val( dv )` is ambiguous, because the variant also converts to a `ustring`.

**Returns** the number; 0 when the text does not start with one.

**Example**

```freebasic
dim dv as DVARIANT = "42.5"
print com.Val( dv ) + 1        ' prints 43.5
```

### MsgBox

```freebasic
function MsgBox overload( byref dv as DVARIANT, byval pwszCaption as const wstring ptr = NULL, byval uType as DWORD = 0 ) as long
function MsgBox overload( byval hWin as HWND, byref dv as DVARIANT, byval pwszCaption as const wstring ptr = NULL, byval uType as DWORD = 0 ) as long
```

Shows the variant's text in a message box, application-modal, owned by `hWin` or by the active
window. Write it `com.MsgBox`: `sys/win` has a `MsgBox` of its own, so after `using win, com` the
bare name is ambiguous.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The owner window. |
| `dv` | The value to show. |
| `pwszCaption` | The title; `NULL` gives the system's "Error". |
| `uType` | `MB_*` buttons and icon. |

**Returns** the button pressed (`IDOK` …).

**Example**

```freebasic
dim dv as DVARIANT = 42
com.MsgBox( hwnd, dv, "Answer", MB_ICONINFORMATION )
```

Microsoft Learn: [MessageBoxW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messageboxw)

### VtError

```freebasic
function VtError() as VARIANT
```

Returns a `VT_ERROR` `VARIANT` with the code `DISP_E_PARAMNOTFOUND`, which Automation reads as
"argument omitted". Pass it for an optional argument you want to skip.

**Example**

```freebasic
dim skip as VARIANT = VtError()
print skip.vt; " &h"; hex( skip.scode )   ' prints 10 &h80020004
```

### VtNULL

```freebasic
function VtNULL() as VARIANT
```

Returns a `VT_NULL` `VARIANT`.

**Example**

```freebasic
dim v as VARIANT = VtNULL()
print v.vt                   ' prints 1
```

## See also

- [sys/win/com](SysWin-Com)
- [COM procedures](SysWin-Com-Procedures) for `VarToStr`, `NewCom` and the variant-type tests
- [DSafeArray](DSafeArray) for building and reading safe arrays
- [BSTRING](BSTRING) for COM strings
- [CDispInvoke](CDispInvoke), which passes and returns `DVARIANT` values
