[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/com](SysWin-Com) › **DSafeArray**

# DSafeArray

Holds a COM `SAFEARRAY` and destroys it, with all its elements, when it goes out of scope.

A `SAFEARRAY` is the array type of COM and Automation. Its descriptor records the element type
(a `VARTYPE` such as `VT_BSTR`, `VT_I4` or `VT_VARIANT`), the number of dimensions, the number of
elements and lower bound of each dimension, a lock count and some flags. Arrays travel between
COM objects this way, usually inside a `VARIANT` whose type has the `VT_ARRAY` bit set.

`DSafeArray` holds one descriptor in its public field `m_psa`. The model to keep in mind:

- **It owns the array.** The destructor destroys the descriptor and every element: strings are
  freed, variants cleared and interface pointers released. [Detach](#detach) hands the array
  over to you; [Attach](#attach) takes one over.
- **Locked and unlocked arrays.** An array made by a [Constructor](#constructor) is unlocked.
  One made by [Create](#create), [CreateEx](#createex), [CreateVector](#createvector) or
  [CreateVectorEx](#createvectorex), and every copy (the copy constructor, [Let](#let),
  [CopyFrom](#copyfrom), the constructors that take a `SAFEARRAY ptr` or a `VARIANT ptr`, and the
  arrays [StrSplit](#strsplit) and [FileReadAllLinesA, FileReadAllLinesW](#filereadalllinesa-filereadalllinesw)
  return) and an attached one is kept locked. A locked array cannot change size: the `Append`,
  `Insert`, `Delete` and `Remove` methods and the count-and-bound forms of [Redim](#redim) fail on it with
  `DISP_E_ARRAYISLOCKED`. **To build a list that grows, create it with a constructor.**
  [LocksCount](#lockscount) tells you which kind you have, and `SafeArrayUnlock( *dsa )` turns a
  locked one into an unlocked one.
- **Indexes include the lower bound.** An array created with 5 elements and a lower bound of 1
  has indexes 1 to 5. The two-dimensional overloads take the index in the first dimension, then
  the index in the second; elements are stored with the first index varying fastest.
- **Three kinds of element access.** Methods ending in `Str` work on `VT_BSTR` arrays and methods
  ending in `Var` on `VT_VARIANT` arrays, and return `E_FAIL` for any other type. The forms that
  take an `any ptr` copy one element of [ElemSize](#elemsize) bytes to or from the address you
  give, as `SafeArrayGetElement` and `SafeArrayPutElement` do: for a `VT_BSTR` array the pointer
  given to a put is the `BSTR` itself, and a string got out is a copy you free.
- **Results.** Most methods return an `HRESULT`: `S_OK` (0) on success.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com
```

## Example

Builds a sorted list of names, fills an array of numbers through a pointer and copies it into a
`VARIANT`:

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com

' A list that grows: create it with a constructor, which leaves it unlocked
dim names as DSafeArray = DSafeArray( VT_BSTR, 0, 0 )
names.AppendStr( "Pear" )
names.AppendStr( "apple" )
names.AppendStr( "Fig" )
names.InsertStr( 0, "Banana" )
names.Sort()
print StrJoin( names, ", " ); " ("; names.Count; " items)"
print "fig is at index"; names.Find( "fig" )

' A fixed array of numbers, filled through a pointer to its data
dim squares as DSafeArray = DSafeArray( VT_I4, 5, 1 )
dim p as long ptr = squares.AccessData()
for i as long = 0 to squares.Count - 1
    p[i] = ( i + 1 ) * ( i + 1 )
next
squares.UnaccessData()
dim n as long
squares.GetElement( 5, @n )
print "squares("; squares.LBound; " to"; squares.UBound; ") end with"; n

' Hand a copy to COM in a VARIANT
dim v as VARIANT
squares.CopyToVariant( @v )
print "vt = &h"; hex( v.vt )
VariantClear( @v )
```

It prints (the sort is by character code, so capitals come first):

```text
Banana, Fig, Pear, apple (4 items)
fig is at index 1
squares( 1 to 5) end with 25
vt = &h2003
```

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates an empty `DSafeArray`, a new array, or a copy of another array. |
| [Destructor](#destructor) | Destroys the array and its elements. |
| [Let](#let) | Replaces the array with a copy of another. |
| [GetPtr](#getptr) | Returns the `SAFEARRAY` descriptor. |
| [Create](#create) | Creates the array of an empty `DSafeArray`. |
| [CreateEx](#createex) | Creates the array with an interface id or record description. |
| [CreateVector](#createvector) | Creates a one-dimensional array in a single allocation. |
| [CreateVectorEx](#createvectorex) | The same, with an interface id or record description. |
| [NumDims](#numdims) | Returns the number of dimensions. |
| [LBound, UBound](#lbound-ubound) | Return the lowest and highest index of a dimension. |
| [Count](#count) | Returns the number of elements in a dimension. |
| [ElemSize](#elemsize) | Returns the size of one element in bytes. |
| [IsResizable](#isresizable) | Tells whether the array may change size. |
| [GetType](#gettype) | Returns the `VARTYPE` of the elements. |
| [LocksCount](#lockscount) | Returns the lock count. |
| [Flags, Features](#flags-features) | Return the `FADF_*` flags. |
| [AccessData](#accessdata) | Locks the array and returns a pointer to its data. |
| [UnaccessData](#unaccessdata) | Releases the pointer from `AccessData`. |
| [Redim](#redim) | Changes the number of elements of the last dimension. |
| [Copy](#copy) | Returns a separate copy of the array. |
| [CopyData](#copydata) | Copies the elements into another array of the same shape. |
| [CopyFrom](#copyfrom) | Replaces the array with a copy of a `SAFEARRAY`. |
| [PtrOfIndex](#ptrofindex) | Returns the address of one element. |
| [Destroy, Clear](#destroy-clear) | Destroys the array. |
| [DestroyData, Erase, Reset](#destroydata-erase-reset) | Frees the elements and keeps the descriptor. |
| [CopyFromVariant](#copyfromvariant) | Replaces the array with a copy of the one in a `VARIANT`. |
| [MoveFromVariant](#movefromvariant) | Copies the array out of a `VARIANT` and empties the `VARIANT`. |
| [CopyToVariant](#copytovariant) | Puts a copy of the array in a `VARIANT`. |
| [MoveToVariant](#movetovariant) | Moves the array into a `VARIANT`. |
| [Attach](#attach) | Takes over a `SAFEARRAY`. |
| [Detach](#detach) | Gives up the `SAFEARRAY` and returns it. |
| [GetIID, SetIID](#getiid-setiid) | Read or set the interface id of an array of interfaces. |
| [GetRecordInfo, SetRecordInfo](#getrecordinfo-setrecordinfo) | Read or set the record description of an array of records. |
| [AppendElement, Append](#appendelement-append) | Adds an element at the end. |
| [AppendStr](#appendstr) | Adds a string at the end of a `VT_BSTR` array. |
| [AppendVar](#appendvar) | Adds a `DVARIANT` at the end of a `VT_VARIANT` array. |
| [InsertElement, Insert](#insertelement-insert) | Inserts an element. |
| [InsertStr](#insertstr) | Inserts a string into a `VT_BSTR` array. |
| [InsertVar](#insertvar) | Inserts a `DVARIANT` into a `VT_VARIANT` array. |
| [DeleteElement, Remove](#deleteelement-remove) | Removes an element of a numeric array. |
| [DeleteStringElement, RemoveStr](#deletestringelement-removestr) | Removes a string. |
| [DeleteVariantElement, RemoveVar](#deletevariantelement-removevar) | Removes a variant. |
| [FindElement, Find](#findelement-find) | Finds a string in a `VT_BSTR` array. |
| [Sort](#sort) | Sorts a `VT_BSTR` array. |
| [GetElement, Get](#getelement-get) | Copies one element out. |
| [GetStr](#getstr) | Returns one string of a `VT_BSTR` array. |
| [GetVar](#getvar) | Returns one element of a `VT_VARIANT` array. |
| [PutElement, Put](#putelement-put) | Stores one element. |
| [PutStr](#putstr) | Stores one string in a `VT_BSTR` array. |
| [PutVar](#putvar) | Stores one `DVARIANT` in a `VT_VARIANT` array. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval vt as VARTYPE, byval cDims as UINT, byval prgsabounds as SAFEARRAYBOUND ptr )
constructor( byval vt as VARTYPE, byval cElements as ulong = 0, byval lLBound as long = 0 )
constructor( byval vt as VARTYPE, byval cElements1 as ulong, byval lLBound1 as long, byval cElements2 as ulong, byval lLBound2 as long )
constructor( byref strType as string, byval cDims as UINT, byval prgsabounds as SAFEARRAYBOUND ptr )
constructor( byref strType as string, byval cElements as ulong = 0, byval lLBound as long = 0 )
constructor( byref strType as string, byval cElements1 as ulong, byval lLBound1 as long, byval cElements2 as ulong, byval lLBound2 as long )
constructor( byref dsa as DSafeArray )
constructor( byval psa as SAFEARRAY ptr )
constructor( byval psa as SAFEARRAY ptr, byval fAttach as boolean )
constructor( byval pvar as VARIANT ptr )
```

- With no argument the `DSafeArray` is empty: `m_psa` is `NULL` until [Create](#create),
  [Attach](#attach) or an assignment gives it an array.
- With a `VARTYPE` and bounds it creates a new, unlocked array whose elements are all zero:
  numbers are 0, strings are `NULL` `BSTR`s (which COM reads as empty) and variants are empty. The one-dimensional form defaults to no elements and a lower
  bound of 0; the general form takes `cDims` bounds from `prgsabounds`. `VT_EMPTY` and `VT_NULL`
  are not element types, and neither `VT_ARRAY` nor `VT_BYREF` may be added.
- With a type name instead of a `VARTYPE` it picks the type from the name, in any case:
  `"STRING"`, `"BSTR"` and `"BSTRING"` give `VT_BSTR`; `"BOOL"`, `"BOOLEAN"` `VT_BOOL`; `"BYTE"`
  `VT_I1`; `"UBYTE"` `VT_UI1`; `"SHORT"` `VT_I2`; `"USHORT"` `VT_UI2`; `"INT"` `VT_INT`;
  `"UINT"` `VT_UINT`; `"LONG"` `VT_I4`; `"ULONG"` `VT_UI4`; `"LONGINT"` `VT_I8`; `"ULONGINT"`
  `VT_UI8`; `"SINGLE"`, `"FLOAT"` `VT_R4`; `"DOUBLE"` `VT_R8`; `"VARIANT"`, `"DVARIANT"`
  `VT_VARIANT`; `"CY"`, `"CURRENCY"` `VT_CY`; `"DECIMAL"` `VT_DECIMAL`; `"UNKNOWN"`
  `VT_UNKNOWN`; `"DISPATCH"` `VT_DISPATCH`; `"FILETIME"` `VT_FILETIME`; `"DATE"` `VT_DATE`;
  `"USERDEFINED"` `VT_USERDEFINED`; `"PTR"` `VT_PTR`. Any other name creates no array.
- From another `DSafeArray`, a `SAFEARRAY ptr` or a `VARIANT ptr` holding an array it makes a
  copy, which is locked. With `fAttach` = `true` it takes over `psa` itself instead of copying
  it: the `DSafeArray` then destroys it.

| Parameter | Meaning |
| --- | --- |
| `vt` | The element type. |
| `strType` | The element type as a name. |
| `cDims`, `prgsabounds` | The number of dimensions and an array of one `SAFEARRAYBOUND` (count, lower bound) per dimension. |
| `cElements`, `lLBound` | The number of elements and the lowest index of a one-dimensional array. |
| `cElements1`, `lLBound1`, `cElements2`, `lLBound2` | The same for the two dimensions of a two-dimensional array. |
| `dsa`, `psa`, `pvar` | The array to copy. |
| `fAttach` | `true` to take over `psa`, `false` to copy it. |

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR, 3, 1 )        ' 3 strings, indexes 1 to 3
dim b as DSafeArray = DSafeArray( "DOUBLE", 4, 0, 2, 0 )  ' 4 x 2 doubles
print a.Count, b.NumDims   ' 3  2
```

Microsoft Learn: [SafeArrayCreate](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraycreate)

### Destructor

```freebasic
destructor
```

Unlocks the array and destroys it with `SafeArrayDestroy`, freeing every string, clearing every
variant and releasing every interface pointer it holds. It unlocks once: an array that is still
locked after that (an array from [Create](#create) or a copy, inside an
[AccessData](#accessdata) without its [UnaccessData](#unaccessdata)) is not destroyed.

**Example**

```freebasic
scope
    dim a as DSafeArray = DSafeArray( VT_BSTR, 100, 0 )
end scope   ' the array and its strings are freed here
```

Microsoft Learn: [SafeArrayDestroy](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraydestroy)

### Let

```freebasic
operator let( byref dsa as DSafeArray )
operator let( byval psa as SAFEARRAY ptr )
operator let( byval pvar as VARIANT ptr )
```

Destroys the current array and replaces it with a copy of the one assigned: another
`DSafeArray`, a `SAFEARRAY ptr`, or the array inside a `VARIANT` (which must have `VT_ARRAY` in
its type). The copy is locked. The source is not changed.

**Example**

```freebasic
dim src as DSafeArray = DSafeArray( VT_I4, 4, 0 )
dim copy as DSafeArray
copy = src
print copy.Count, copy.LocksCount   ' 4  1
```

### GetPtr

```freebasic
function GetPtr() as SAFEARRAY ptr
```

Returns the `SAFEARRAY` descriptor, `m_psa`, to pass to a function that takes a
`SAFEARRAY ptr`. It still belongs to the `DSafeArray`: do not destroy it. `*dsa` returns the
same.

**Returns** the descriptor, or `NULL` for an empty `DSafeArray`.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 4, 0 )
print SafeArrayGetDim( a.GetPtr() )   ' 1
```

### Create

```freebasic
function Create( byval vt as VARTYPE, byval cDims as UINT, byval prgsabound as SAFEARRAYBOUND ptr ) as HRESULT
function Create( byval vt as VARTYPE, byval cElements as ulong, byval lLBound as long ) as HRESULT
function Create( byval vt as VARTYPE, byval cElements1 as ulong, byval lLBound1 as long, byval cElements2 as ulong, byval lLBound2 as long ) as HRESULT
```

Creates the array of an empty `DSafeArray`, as the constructors do, and **locks it**, so it
cannot be resized with [Append](#appendelement-append) or the count-and-bound forms of [Redim](#redim).

**Returns** `S_OK`; `E_FAIL` when the `DSafeArray` already holds an array; `E_INVALIDARG` for a
`NULL` bounds pointer or no dimensions; `E_OUTOFMEMORY` when the array could not be created.

**Example**

```freebasic
dim a as DSafeArray
if a.Create( VT_R8, 10, 0 ) = S_OK then print a.Count, a.LocksCount   ' 10  1
```

Microsoft Learn: [SafeArrayCreate](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraycreate)

### CreateEx

```freebasic
function CreateEx( byval vt as VARTYPE, byval cDims as UINT, byval prgsabound as SAFEARRAYBOUND ptr, byval pvExtra as PVOID ) as HRESULT
function CreateEx( byval vt as VARTYPE, byval cElements as ulong, byval lLBound as long, byval pvExtra as any ptr ) as HRESULT
function CreateEx( byval vt as VARTYPE, byval cElements1 as ulong, byval lLBound1 as long, byval cElements2 as ulong, byval lLBound2 as long, byval pvExtra as any ptr ) as HRESULT
```

Like [Create](#create), with `pvExtra` describing the elements: for `VT_RECORD` an `IRecordInfo`
pointer, for `VT_UNKNOWN` or `VT_DISPATCH` a pointer to the `GUID` of the interface every
element holds (the array then has `FADF_HAVEIID` and [GetIID](#getiid-setiid) returns it). The
array is locked.

**Returns** as [Create](#create).

**Example**

```freebasic
dim a as DSafeArray
a.CreateEx( VT_UNKNOWN, 4, 0, cast( any ptr, @IID_IDispatch ) )
```

Microsoft Learn: [SafeArrayCreateEx](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraycreateex)

### CreateVector

```freebasic
function CreateVector( byval vt as VARTYPE, byval cElements as ulong, byval lLBound as long ) as HRESULT
```

Creates a one-dimensional array whose descriptor and data are one block of memory, and locks it.
It does not get `FADF_FIXEDSIZE`: the pointer form of [Redim](#redim) resizes it.

**Returns** `S_OK`; `E_FAIL` when the `DSafeArray` already holds an array; `E_OUTOFMEMORY` on
failure.

**Example**

```freebasic
dim a as DSafeArray
a.CreateVector( VT_I4, 3, 0 )
```

Microsoft Learn: [SafeArrayCreateVector](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraycreatevector)

### CreateVectorEx

```freebasic
function CreateVectorEx( byval vt as VARTYPE, byval cElements as ulong, byval lLBound as long, byval pvExtra as any ptr ) as HRESULT
```

[CreateVector](#createvector) with `pvExtra` as in [CreateEx](#createex). The array is locked.

**Returns** as [CreateVector](#createvector).

**Example**

```freebasic
dim a as DSafeArray
a.CreateVectorEx( VT_UNKNOWN, 2, 0, cast( any ptr, @IID_IUnknown ) )
```

Microsoft Learn: [SafeArrayCreateVectorEx](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraycreatevectorex)

### NumDims

```freebasic
function NumDims() as UINT
```

**Returns** the number of dimensions, or 0 for an empty `DSafeArray`.

**Example**

```freebasic
print DSafeArray( VT_I4, 3, 0, 2, 0 ).NumDims   ' 2
```

Microsoft Learn: [SafeArrayGetDim](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetdim)

### LBound, UBound

```freebasic
function LBound( byval nDim as UINT = 1 ) as long
function UBound( byval nDim as UINT = 1 ) as long
```

Return the lowest and the highest valid index of dimension `nDim` (1 is the first). Loop from
`LBound` to `UBound` to visit every element.

**Returns** the index, or 0 for an empty `DSafeArray` or a dimension that does not exist.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR, 3, 1 )
for i as long = a.LBound to a.UBound
    a.PutStr( i, BSTRING( "item" ) )
next
```

Microsoft Learn: [SafeArrayGetLBound](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetlbound)

### Count

```freebasic
function Count( byval nDim as UINT = 1 ) as DWORD
```

**Returns** the number of elements in dimension `nDim`, or 0 for an empty `DSafeArray` or a
dimension that does not exist.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 3, 1, 2, 1 )
print a.Count( 1 ), a.Count( 2 )   ' 3  2
```

### ElemSize

```freebasic
function ElemSize() as UINT
```

**Returns** the size of one element in bytes (8 for a `BSTR`, which is a pointer, 24 for a
`VARIANT`), or 0 for an empty `DSafeArray`. Pointed-to data is not counted.

**Example**

```freebasic
print DSafeArray( VT_R8, 1, 0 ).ElemSize   ' 8
```

Microsoft Learn: [SafeArrayGetElemsize](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetelemsize)

### IsResizable

```freebasic
function IsResizable() as boolean
```

Tells whether the array lacks the `FADF_FIXEDSIZE` flag. It does not look at the lock count, so
an array that is resizable in this sense may still refuse to grow while locked (see the
introduction).

**Returns** `true` when the array has no fixed size; `false` for a fixed-size or empty array.

**Example**

```freebasic
print DSafeArray( VT_I4, 2, 0 ).IsResizable   ' true
```

### GetType

```freebasic
function GetType() as VARTYPE
```

**Returns** the `VARTYPE` of the elements (`VT_BSTR`, `VT_I4` …), or 0 for an empty
`DSafeArray`.

**Example**

```freebasic
if DSafeArray( "LONG", 2, 0 ).GetType = VT_I4 then print "an array of long"
```

Microsoft Learn: [SafeArrayGetVartype](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetvartype)

### LocksCount

```freebasic
function LocksCount() as UINT
```

**Returns** how many times the array is locked without a matching unlock, read from the
descriptor: 0 for an array made by a constructor, 1 for one made by `Create` or copied, one more
while [AccessData](#accessdata) is in effect.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 2, 0 )
print a.LocksCount   ' 0
```

### Flags, Features

```freebasic
function Flags() as ushort
function Features() as ushort
```

Both return the `fFeatures` field of the descriptor: `FADF_*` flags such as `FADF_BSTR`,
`FADF_VARIANT`, `FADF_HAVEIID` and `FADF_FIXEDSIZE`.

**Returns** the flags, or 0 for an empty `DSafeArray`.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR, 1, 0 )
if a.Flags and FADF_BSTR then print "holds BSTRs"
```

Microsoft Learn: [SAFEARRAY structure](https://learn.microsoft.com/en-us/windows/win32/api/oaidl/ns-oaidl-safearray)

### AccessData

```freebasic
function AccessData() as any ptr
```

Locks the array and returns a pointer to its first element, for fast reading and writing in a
loop. The elements are stored one after the other, with the first index varying fastest. Call
[UnaccessData](#unaccessdata) when done. Do not resize the array in between: the pointer form of
[Redim](#redim) does not refuse, and the pointer may then no longer point at the data.

**Returns** the address of the data, or `NULL`.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 3, 0 )
dim p as long ptr = a.AccessData()
p[0] = 10 : p[1] = 20 : p[2] = 30
a.UnaccessData()
```

Microsoft Learn: [SafeArrayAccessData](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearrayaccessdata)

### UnaccessData

```freebasic
function UnaccessData() as HRESULT
```

Undoes one [AccessData](#accessdata): decrements the lock count and invalidates the pointer.

**Returns** `S_OK`, or `E_UNEXPECTED` when the array was not locked.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_R8, 2, 0 )
dim p as double ptr = a.AccessData()
p[1] = 2.5
a.UnaccessData()
```

Microsoft Learn: [SafeArrayUnaccessData](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearrayunaccessdata)

### Redim

```freebasic
function Redim( byval pnewsabounds as SAFEARRAYBOUND ptr ) as HRESULT
function Redim( byval cElements as DWORD, byval lLBound as long ) as HRESULT
function Redim( byval cElements1 as ulong, byval lLBound1 as long, byval cElements2 as ulong, byval lLBound2 as long ) as HRESULT
```

Changes the bounds of the **last** dimension, the only one a `SAFEARRAY` can resize. Elements
in both the old and new bounds keep their values, new ones are zero or empty, and those that
fall outside are freed.

The forms differ in which arrays they accept:

- The pointer form temporarily unlocks the array, so it works on an array with **one** lock (made
  by [Create](#create) or copied). On an unlocked array, one made by a constructor, it fails with
  `E_UNEXPECTED`.
- The one-dimensional form, with a count and a lower bound, works on an **unlocked** array and
  fails with `DISP_E_ARRAYISLOCKED` on a locked one.
- The two-dimensional form applies `cElements1` and `lLBound1` to the last dimension and ignores
  `cElements2` and `lLBound2`; like the one-dimensional form it needs an unlocked array.

**Returns** `S_OK`; `E_FAIL` for an empty or fixed-size array; `DISP_E_ARRAYISLOCKED` or
`E_UNEXPECTED` as above.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR, 2, 0 )
a.Redim( 10, 0 )   ' now 10 strings, indexes 0 to 9
```

Microsoft Learn: [SafeArrayRedim](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearrayredim)

### Copy

```freebasic
function Copy() as SAFEARRAY ptr
```

Makes a complete, separate copy of the array, strings and all, and gives it to you: destroy it
with `SafeArrayDestroy`, or [Attach](#attach) it to another `DSafeArray`. The copy is unlocked.

**Returns** the new descriptor, or `NULL` for an empty `DSafeArray` or on failure.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 3, 0 )
dim psa as SAFEARRAY ptr = a.Copy()
SafeArrayDestroy( psa )
```

Microsoft Learn: [SafeArrayCopy](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraycopy)

### CopyData

```freebasic
function CopyData( byval psaTarget as SAFEARRAY ptr ) as HRESULT
```

Copies every element into `psaTarget`, an existing array of the same type, dimensions and sizes,
after freeing what it held. The target is not allocated or resized.

**Returns** `S_OK`, or `E_INVALIDARG` when the arrays do not match.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 3, 0 )
dim b as DSafeArray = DSafeArray( VT_I4, 3, 0 )
a.CopyData( b.GetPtr() )
```

Microsoft Learn: [SafeArrayCopyData](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraycopydata)

### CopyFrom

```freebasic
function CopyFrom( byval psaSrc as SAFEARRAY ptr ) as HRESULT
```

Destroys the current array and replaces it with a locked copy of `psaSrc`. This is what the copy
constructor and [Let](#let) call.

**Returns** the result of the copy: `S_OK`, or an error; `E_INVALIDARG` for a `NULL` source.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 3, 0 )
dim b as DSafeArray
b.CopyFrom( a.GetPtr() )
```

### PtrOfIndex

```freebasic
function PtrOfIndex( byval prgIndices as long ptr ) as any ptr
function PtrOfIndex( byval idx as long ) as any ptr
function PtrOfIndex( byval cElem as long, byval cDim as long ) as any ptr
```

Returns the address of one element, without locking the array. For a multi-dimensional array
pass an array of indexes, one per dimension, the first dimension first.

**Returns** the address, or `NULL` for an empty `DSafeArray` or a bad index.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 3, 0 )
dim p as long ptr = a.PtrOfIndex( 2 )
*p = 99
```

Microsoft Learn: [SafeArrayPtrOfIndex](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearrayptrofindex)

### Destroy, Clear

```freebasic
function Destroy() as HRESULT
function Clear() as HRESULT
```

Unlock and destroy the array with all its elements, leaving the `DSafeArray` empty. `Clear` is
another name for `Destroy`.

It unlocks once before destroying, so an unlocked array inside [AccessData](#accessdata) is
destroyed too, and the data pointer becomes invalid.

**Returns** `S_OK` (also for an empty `DSafeArray`), or `DISP_E_ARRAYISLOCKED` when the array is
still locked after that one unlock; it is then kept.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR, 10, 0 )
a.Destroy()
print a.GetPtr() = NULL   ' -1: true
```

### DestroyData, Erase, Reset

```freebasic
function DestroyData() as HRESULT
function Erase() as HRESULT
function Reset() as HRESULT
```

Unlock the array and free all its elements, but keep the descriptor: the bounds are still
reported, the data is gone and puts fail with `E_INVALIDARG`. The three names do the same; to
start over, [Destroy](#destroy-clear) the array and create a new one.

**Returns** `S_OK` (also for an empty `DSafeArray`), or an error from `SafeArrayDestroyData`.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR, 3, 0 )
a.DestroyData()
```

Microsoft Learn: [SafeArrayDestroyData](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraydestroydata)

### CopyFromVariant

```freebasic
function CopyFromVariant( byval pvar as VARIANT ptr ) as HRESULT
```

Replaces the array with a locked copy of the one in `pvar`. The `VARIANT` is not changed.

**Returns** `S_OK`; `E_INVALIDARG` for `NULL`; `HRESULT_FROM_WIN32( ERROR_INVALID_DATA )`
(`&h8007000D`) when the `VARIANT` does not hold an array.

**Example**

```freebasic
dim v as VARIANT
DSafeArray( VT_I4, 3, 0 ).CopyToVariant( @v )
dim a as DSafeArray
a.CopyFromVariant( @v )
VariantClear( @v )
```

### MoveFromVariant

```freebasic
function MoveFromVariant( byval pvar as VARIANT ptr ) as HRESULT
```

Replaces the array with a copy of the one in `pvar` and sets the `VARIANT` to `VT_EMPTY`. The
array the `VARIANT` held is not destroyed, and nothing refers to it any more: it leaks. Use
[CopyFromVariant](#copyfromvariant) and then `VariantClear`, or [Attach](#attach)
`pvar->parray` and set `pvar->vt` to `VT_EMPTY` yourself, to take the array over.

**Returns** as [CopyFromVariant](#copyfromvariant).

**Example**

```freebasic
dim v as VARIANT
DSafeArray( VT_I4, 3, 0 ).CopyToVariant( @v )
dim a as DSafeArray
a.Attach( v.parray )   ' takes the array over without a copy
v.vt = VT_EMPTY
```

### CopyToVariant

```freebasic
function CopyToVariant( byval pvar as VARIANT ptr ) as HRESULT
```

Clears `pvar` and stores a copy of the array in it, with the element type plus `VT_ARRAY` as its
type (`VT_ARRAY or VT_BSTR` for an array of strings). Free it with `VariantClear`.

**Returns** `S_OK`; `E_FAIL` for an empty `DSafeArray`; `E_INVALIDARG` for `NULL`.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR, 2, 0 )
dim v as VARIANT
a.CopyToVariant( @v )
VariantClear( @v )
```

Microsoft Learn: [SafeArrayCopy](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraycopy)

### MoveToVariant

```freebasic
function MoveToVariant( byval pvar as VARIANT ptr ) as HRESULT
```

Clears `pvar`, stores the array itself in it with the element type plus `VT_ARRAY`, and leaves
the `DSafeArray` empty. The array is unlocked first and now belongs to the `VARIANT`.

**Returns** the result of the unlock: `S_OK` for a locked array, but `E_UNEXPECTED` for one made
by a constructor, which was never locked; the move happens either way. `E_FAIL` for an empty
`DSafeArray`, `E_INVALIDARG` for `NULL`.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 3, 0 )
dim v as VARIANT
a.MoveToVariant( @v )
VariantClear( @v )
```

### Attach

```freebasic
function Attach( byval psaSrc as SAFEARRAY ptr ) as HRESULT
```

Destroys the current array and takes over `psaSrc`, locking it. The `DSafeArray` destroys it
later, so do not attach the same array to two of them or destroy it yourself.

**Returns** `S_OK`; `E_FAIL` for `NULL`; an error when the current array cannot be destroyed.

**Example**

```freebasic
dim psa as SAFEARRAY ptr = SafeArrayCreateVector( VT_I4, 0, 5 )
dim a as DSafeArray
a.Attach( psa )
```

### Detach

```freebasic
function Detach() as SAFEARRAY ptr
```

Unlocks the array and gives it to you, leaving the `DSafeArray` empty. Destroy it with
`SafeArrayDestroy` when done.

**Returns** the descriptor, or `NULL` for an empty `DSafeArray`.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 5, 0 )
dim psa as SAFEARRAY ptr = a.Detach()
SafeArrayDestroy( psa )
```

### GetIID, SetIID

```freebasic
function GetIID() as GUID
function SetIID( byval pguid as GUID ptr ) as HRESULT
```

Read or set the `GUID` of the interface held by an array of `VT_UNKNOWN` or `VT_DISPATCH`
elements created with an interface id ([CreateEx](#createex)), which has `FADF_HAVEIID` set.

**Returns** `GetIID`: the `GUID`, or a null `GUID` when there is none. `SetIID`: `S_OK`; `E_FAIL`
for an empty `DSafeArray`; `&h8007000D` when the array has no `FADF_HAVEIID`.

**Example**

```freebasic
dim a as DSafeArray
a.CreateEx( VT_DISPATCH, 2, 0, cast( any ptr, @IID_IDispatch ) )
dim iid as GUID = a.GetIID()
```

Microsoft Learn: [SafeArrayGetIID](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetiid)

### GetRecordInfo, SetRecordInfo

```freebasic
function GetRecordInfo() as IRecordInfo ptr
function SetRecordInfo( byval prinfo as IRecordInfo ptr ) as HRESULT
```

Read or set the `IRecordInfo` that describes the structure held by an array of `VT_RECORD`
elements, which has `FADF_RECORD` set.

**Returns** `GetRecordInfo`: the interface, with a reference you release, or `NULL` when the
array has none. `SetRecordInfo`: `S_OK`; `E_FAIL` for an empty `DSafeArray`; `&h8007000D` when
the array has no `FADF_RECORD`.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 2, 0 )
dim pri as IRecordInfo ptr = a.GetRecordInfo()   ' NULL: not an array of records
```

Microsoft Learn: [SafeArrayGetRecordInfo](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetrecordinfo)

### AppendElement, Append

```freebasic
function AppendElement( byval pData as any ptr ) as HRESULT
function AppendElement( byref bsData as BSTRING ) as HRESULT
function AppendElement( byref dvData as DVARIANT ) as HRESULT
function AppendElement( byval vData as VARIANT ) as HRESULT
function Append( byval pData as any ptr ) as HRESULT
function Append( byref bsData as BSTRING ) as HRESULT
function Append( byref dvData as DVARIANT ) as HRESULT
function Append( byval vData as VARIANT ) as HRESULT
```

Grow a one-dimensional, unlocked array by one element and store the value there. The `any ptr`
form copies the data at `pData` like [PutElement](#putelement-put); the `BSTRING` form needs a
`VT_BSTR` array and the `DVARIANT` and `VARIANT` forms a `VT_VARIANT` array, and they store copies.

**Returns** `S_OK`; `E_FAIL` for an empty, multi-dimensional, fixed-size or wrongly typed array;
`DISP_E_ARRAYISLOCKED` for a locked one.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_R8 )
dim x as double = 1.5
a.Append( @x )
print a.Count   ' 1
```

Microsoft Learn: [SafeArrayRedim](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearrayredim)

### AppendStr

```freebasic
function AppendStr( byval pwszData as wstring ptr ) as HRESULT
```

Grows a one-dimensional, unlocked `VT_BSTR` array by one element holding a copy of `pwszData`.

**Returns** as [AppendElement](#appendelement-append).

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR )
a.AppendStr( "first" )
a.AppendStr( "second" )
```

### AppendVar

```freebasic
function AppendVar( byref dvData as DVARIANT ) as HRESULT
```

Grows a one-dimensional, unlocked `VT_VARIANT` array by one element holding a copy of `dvData`.

**Returns** as [AppendElement](#appendelement-append).

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_VARIANT )
dim dv as DVARIANT = 123
a.AppendVar( dv )
```

### InsertElement, Insert

```freebasic
function InsertElement( byval nPos as long, byval pData as any ptr ) as HRESULT
function InsertElement( byval pData as any ptr ) as HRESULT
function InsertElement( byval nPos as long, byref bsData as BSTRING ) as HRESULT
function InsertElement( byref bsData as BSTRING ) as HRESULT
function InsertElement( byval nPos as long, byref dvData as DVARIANT ) as HRESULT
function InsertElement( byval nPos as long, byval vData as VARIANT ) as HRESULT
function InsertElement( byref dvData as DVARIANT ) as HRESULT
function InsertElement( byval vData as VARIANT ) as HRESULT
function Insert( byval nPos as long, byval pData as any ptr ) as HRESULT
function Insert( byval pData as any ptr ) as HRESULT
function Insert( byval nPos as long, byref bsData as BSTRING ) as HRESULT
function Insert( byref bsData as BSTRING ) as HRESULT
function Insert( byval nPos as long, byref dvData as DVARIANT ) as HRESULT
function Insert( byval nPos as long, byval vData as VARIANT ) as HRESULT
function Insert( byref dvData as DVARIANT ) as HRESULT
function Insert( byval vData as VARIANT ) as HRESULT
```

Insert a value at index `nPos`, or at the lower bound when there is no `nPos`, moving the
elements from there on up by one. `nPos` must be an existing index; to add at the end use
[Append](#appendelement-append). An empty array accepts its lower bound and the value is
appended. The array must be one-dimensional and unlocked.

- The `any ptr` forms move the elements through an 8-byte buffer, so they suit arrays of
  numbers of up to 8 bytes; and they treat the element count as an index, which is only right
  for a lower bound of 0 or 1: with a higher lower bound an element is overwritten.
- The `BSTRING` forms need a `VT_BSTR` array, the `DVARIANT` and `VARIANT` forms a `VT_VARIANT`
  array; they store copies.

**Returns** `S_OK`; `DISP_E_BADINDEX` for an index outside the bounds; `E_FAIL` or
`DISP_E_ARRAYISLOCKED` as for [Append](#appendelement-append).

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 3, 0 )
dim v as long = 7
a.Insert( 0, @v )   ' 7 0 0 0
```

### InsertStr

```freebasic
function InsertStr( byval nPos as long, byval pwszData as wstring ptr ) as HRESULT
function InsertStr( byval pwszData as wstring ptr ) as HRESULT
```

Inserts a copy of `pwszData` at index `nPos` (or at the lower bound) of a one-dimensional,
unlocked `VT_BSTR` array, moving the later strings up. Any lower bound works.

**Returns** as [InsertElement](#insertelement-insert).

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR )
a.AppendStr( "b" )
a.InsertStr( 0, "a" )   ' a, b
```

### InsertVar

```freebasic
function InsertVar( byref dvData as DVARIANT ) as HRESULT
function InsertVar( byval nPos as long, byref dvData as DVARIANT ) as HRESULT
```

Inserts a copy of `dvData` at index `nPos` (or at the lower bound) of a one-dimensional, unlocked
`VT_VARIANT` array, moving the later elements up. Any lower bound works.

**Returns** as [InsertElement](#insertelement-insert).

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_VARIANT )
dim dv as DVARIANT = "text"
a.AppendVar( dv )
a.InsertVar( 0, dv )
```

### DeleteElement, Remove

```freebasic
function DeleteElement( byval nPos as long ) as HRESULT
function Remove( byval nPos as long ) as HRESULT
```

Remove the element at index `nPos` of a one-dimensional, unlocked array and shrink it by one. The
elements are moved through an 8-byte buffer, so these suit numbers of up to 8 bytes; for strings
and variants use [RemoveStr](#deletestringelement-removestr) and
[RemoveVar](#deletevariantelement-removevar). They treat the element count as an index, which is
only right for a lower bound of 0 or 1: with a higher lower bound the last element is removed
instead.

**Returns** `S_OK`; `E_FAIL` for an index outside the bounds or an unsuitable array;
`DISP_E_ARRAYISLOCKED` for a locked one.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 3, 0 )
a.Remove( 1 )
print a.Count   ' 2
```

### DeleteStringElement, RemoveStr

```freebasic
function DeleteStringElement( byval nPos as long ) as HRESULT
function RemoveStr( byval nPos as long ) as HRESULT
```

Remove the string at index `nPos` of a one-dimensional, unlocked `VT_BSTR` array, freeing it, and
shrink the array by one. Any lower bound works.

**Returns** `S_OK`; `E_FAIL` for an index outside the bounds or an unsuitable array;
`DISP_E_ARRAYISLOCKED` for a locked one.

**Example**

```freebasic
dim a as DSafeArray = StrSplit( "a b c", " " )
SafeArrayUnlock( *a )   ' the result of StrSplit is locked
a.RemoveStr( 2 )        ' a, c
```

### DeleteVariantElement, RemoveVar

```freebasic
function DeleteVariantElement( byval nPos as long ) as HRESULT
function RemoveVar( byval nPos as long ) as HRESULT
```

Remove the variant at index `nPos` of a one-dimensional, unlocked `VT_VARIANT` array, clearing
it, and shrink the array by one. Any lower bound works.

**Returns** as [RemoveStr](#deletestringelement-removestr).

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_VARIANT, 3, 0 )
a.RemoveVar( 0 )
```

### FindElement, Find

```freebasic
function FindElement( byref wszFind as wstring, byval IgnoreCase as boolean = true ) as long
function Find( byref wszFind as wstring, byval IgnoreCase as boolean = true ) as long
```

Search a one-dimensional `VT_BSTR` array for a string equal to `wszFind`, ignoring case unless
`IgnoreCase` is `false`.

**Returns** the index of the first match, or 0 when there is none or the array is not a
one-dimensional `VT_BSTR` array. In an array whose lower bound is 0 a match at the first index
also gives 0: compare the element when that matters.

**Example**

```freebasic
dim a as DSafeArray = StrSplit( "red green blue", " " )
print a.Find( "GREEN" ), a.Find( "GREEN", false )   ' 2  0
```

### Sort

```freebasic
function Sort( byval bAscend as boolean = true ) as HRESULT
```

Sorts a one-dimensional `VT_BSTR` array in place, ascending, or descending when `bAscend` is
`false`. Strings compare by character code, so capitals come before small letters. It works on
locked and unlocked arrays.

**Returns** `S_OK`; `E_FAIL` for an empty or unsuitable array.

**Example**

```freebasic
dim a as DSafeArray = StrSplit( "pear Fig apple", " " )
a.Sort()
print StrJoin( a, "," )   ' Fig,apple,pear
```

### GetElement, Get

```freebasic
function GetElement( byval prgIndices as long ptr, byval pData as any ptr ) as HRESULT
function GetElement( byval idx as long, byval pData as any ptr ) as HRESULT
function GetElement( byval cElem as long, byval cDim as long, byval pData as any ptr ) as HRESULT
function Get( byval prgIndices as long ptr, byval pData as any ptr ) as HRESULT
function Get( byval idx as long, byval pData as any ptr ) as HRESULT
function Get( byval cElem as long, byval cDim as long, byval pData as any ptr ) as HRESULT
function GetElement( byval prgIndices as long ptr, byref bsData as BSTRING ) as HRESULT
function GetElement( byval idx as long, byref bsData as BSTRING ) as HRESULT
function GetElement( byval cElem as long, byval cDim as long, byref bsData as BSTRING ) as HRESULT
function Get( byval prgIndices as long ptr, byref bsData as BSTRING ) as HRESULT
function Get( byval idx as long, byref bsData as BSTRING ) as HRESULT
function Get( byval cElem as long, byval cDim as long, byref bsData as BSTRING ) as HRESULT
function GetElement( byval prgIndices as long ptr, byref dvData as DVARIANT ) as HRESULT
function GetElement( byval idx as long, byref dvData as DVARIANT ) as HRESULT
function GetElement( byval cElem as long, byval cDim as long, byref dvData as DVARIANT ) as HRESULT
function Get( byval prgIndices as long ptr, byref dvData as DVARIANT ) as HRESULT
function Get( byval idx as long, byref dvData as DVARIANT ) as HRESULT
function Get( byval cElem as long, byval cDim as long, byref dvData as DVARIANT ) as HRESULT
```

Copy the element at an index into your variable. A multi-dimensional array takes `prgIndices`,
an array of one index per dimension, the first dimension first; a two-dimensional one can take
the two indexes directly.

- The `any ptr` forms copy [ElemSize](#elemsize) bytes to `pData`: give the address of a
  variable of the element type. From a `VT_BSTR` array you receive a new `BSTR` to free, from a
  `VT_VARIANT` array a copy of the `VARIANT` to clear.
- The `DVARIANT` forms copy the element of a `VT_VARIANT` array into `dvData`.
- The `BSTRING` forms do not work as intended: they pass the `BSTRING`'s text where the address
  of a `BSTR` is expected, so the copy of the element is written over the first characters of
  `bsData` (or to address 0 when `bsData` is empty) and is never freed. Use [GetStr](#getstr).

**Returns** `S_OK`; `DISP_E_BADINDEX` for an index outside the bounds; `E_FAIL` for an empty or
wrongly typed array.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( "LONG", 3, 1, 2, 1 )
dim v as long = 32
a.PutElement( 3, 2, @v )
dim r as long
a.GetElement( 3, 2, @r )   ' r = 32
```

Microsoft Learn: [SafeArrayGetElement](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearraygetelement)

### GetStr

```freebasic
function GetStr( byval prgIndices as long ptr ) as BSTRING
function GetStr( byval idx as long ) as BSTRING
function GetStr( byval cElem as long, byval cDim as long ) as BSTRING
```

Returns the string at an index of a `VT_BSTR` array as a `BSTRING`. Each call also allocates one
copy of the string that is not freed, so avoid it in long loops; reading through
[AccessData](#accessdata) costs nothing.

**Returns** the string, or an empty `BSTRING` for an empty or wrongly typed array.

**Example**

```freebasic
dim a as DSafeArray = StrSplit( "one two", " " )
dim u as ustring = a.GetStr( 2 )
print u   ' two
```

### GetVar

```freebasic
function GetVar( byval prgIndices as long ptr ) as DVARIANT
function GetVar( byval idx as long ) as DVARIANT
function GetVar( byval cElem as long, byval cDim as long ) as DVARIANT
```

Returns the element at an index of a `VT_VARIANT` array as a `DVARIANT`.

**Returns** the value. For an empty or wrongly typed array the result is a `DVARIANT` holding the
number `E_FAIL` (`VT_I4`), not an empty one.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_VARIANT )
dim dv as DVARIANT = 3.5
a.AppendVar( dv )
dim r as DVARIANT = a.GetVar( 0 )
```

### PutElement, Put

```freebasic
function PutElement( byval prgIndices as long ptr, byval pData as any ptr ) as HRESULT
function PutElement( byval idx as long, byval pData as any ptr ) as HRESULT
function PutElement( byval cElem as long, byval cDim as long, byval pData as any ptr ) as HRESULT
function Put( byval prgIndices as long ptr, byval pData as any ptr ) as HRESULT
function Put( byval idx as long, byval pData as any ptr ) as HRESULT
function Put( byval cElem as long, byval cDim as long, byval pData as any ptr ) as HRESULT
function PutElement( byval prgIndices as long ptr, byref bsData as BSTRING ) as HRESULT
function PutElement( byval idx as long, byref bsData as BSTRING ) as HRESULT
function PutElement( byval cElem as long, byval cDim as long, byref bsData as BSTRING ) as HRESULT
function PutElement( byval prgIndices as long ptr, byref dvData as DVARIANT ) as HRESULT
function PutElement( byval idx as long, byref dvData as DVARIANT ) as HRESULT
function PutElement( byval cElem as long, byval cDim as long, byref dvData as DVARIANT ) as HRESULT
```

Store a value at an index, freeing the value it replaces. Indexes are given as in
[GetElement](#getelement-get).

- The `any ptr` forms copy the data at `pData`: the address of a number for a numeric array, the
  `BSTR` itself for a `VT_BSTR` array, the address of a `VARIANT` for a `VT_VARIANT` array. Strings,
  variants and interfaces are copied or `AddRef`ed.
- The `BSTRING` forms need a `VT_BSTR` array, the `DVARIANT` forms a `VT_VARIANT` array.

`Put` has only the `any ptr` forms: with a `BSTRING` or a `DVARIANT` call `PutElement`,
[PutStr](#putstr) or [PutVar](#putvar).

**Returns** `S_OK`; `DISP_E_BADINDEX` for an index outside the bounds; `E_FAIL` for an empty or
wrongly typed array.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR, 2, 0 )
a.PutElement( 0, BSTRING( "zero" ) )
dim v as DSafeArray = DSafeArray( VT_I4, 2, 0 )
dim n as long = 5
v.Put( 1, @n )
```

Microsoft Learn: [SafeArrayPutElement](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-safearrayputelement)

### PutStr

```freebasic
function PutStr( byval prgIndices as long ptr, byref bsData as BSTRING ) as HRESULT
function PutStr( byval idx as long, byref bsData as BSTRING ) as HRESULT
function PutStr( byval cElem as long, byval cDim as long, byref bsData as BSTRING ) as HRESULT
```

Stores a copy of `bsData` at an index of a `VT_BSTR` array, freeing the string it replaces.

**Returns** as [PutElement](#putelement-put).

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_BSTR, 2, 1 )
a.PutStr( 1, BSTRING( "one" ) )
```

### PutVar

```freebasic
function PutVar( byval prgIndices as long ptr, byref dvData as DVARIANT ) as HRESULT
function PutVar( byval idx as long, byref dvData as DVARIANT ) as HRESULT
function PutVar( byval cElem as long, byval cDim as long, byref dvData as DVARIANT ) as HRESULT
```

Stores a copy of `dvData` at an index of a `VT_VARIANT` array, clearing the variant it replaces.

**Returns** as [PutElement](#putelement-put).

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_VARIANT, 2, 0 )
dim dv as DVARIANT = 42
a.PutVar( 0, dv )
```

## Related functions

| Function | Does |
| --- | --- |
| [Operator * (descriptor)](#operator--descriptor) | Returns the `SAFEARRAY` descriptor. |
| [StrSplit](#strsplit) | Splits a string into a `VT_BSTR` array. |
| [StrJoin](#strjoin) | Joins the strings of a `VT_BSTR` array. |
| [FileReadAllLinesA, FileReadAllLinesW](#filereadalllinesa-filereadalllinesw) | Read the lines of a text file into a `VT_BSTR` array. |
| [DSafeArrayCompare, DSafeArrayReverseCompare](#dsafearraycompare-dsafearrayreversecompare) | Compare two `BSTR`s for `qsort`. |

### Operator * (descriptor)

```freebasic
operator *( byref dsa as DSafeArray ) as SAFEARRAY ptr
```

Returns `m_psa`, like [GetPtr](#getptr).

**Returns** the descriptor, or `NULL`.

**Example**

```freebasic
dim a as DSafeArray = DSafeArray( VT_I4, 4, 0 )
print SafeArrayGetDim( *a )   ' 1
```

### StrSplit

```freebasic
function StrSplit( byref wszStr as wstring, byref wszDelimiters as wstring ) as DSafeArray
```

Splits `wszStr` at every character that occurs in `wszDelimiters` and returns the pieces in a
`VT_BSTR` array with a lower bound of 1. Each delimiter is a single character; runs of delimiters
and delimiters at either end produce no empty pieces. The array is locked (see the introduction).

**Returns** the pieces; an array with no elements when there are none.

**Example**

```freebasic
dim a as DSafeArray = StrSplit( "- This, a sample string.", " ,.-" )
print a.Count; ": "; StrJoin( a, "|" )   ' 4: This|a|sample|string
```

### StrJoin

```freebasic
function StrJoin( byref dsa as DSafeArray, byref wszDelimiter as wstring ) as ustring
```

Joins the strings of a one-dimensional `VT_BSTR` array with `wszDelimiter` between them. When the
delimiter is the three characters `","` (quote, comma, quote) every piece is also enclosed in
quotes, giving a line of quoted comma-separated fields. An empty delimiter joins the pieces
directly.

**Returns** the joined text, or an empty string for an array that is empty, multi-dimensional or
not `VT_BSTR`.

**Example**

```freebasic
dim a as DSafeArray = StrSplit( "a b c", " " )
print StrJoin( a, chr( 34, 44, 34 ) )   ' "a","b","c"
```

### FileReadAllLinesA, FileReadAllLinesW

```freebasic
function FileReadAllLinesA( byref wszFileName as wstring, byref szDelimiter as const zstring = chr( 13, 10 ) ) as DSafeArray
function FileReadAllLinesW( byref wszFileName as wstring, byref wszDelimiter as const wstring = chr( 13, 10 ) ) as DSafeArray
```

Read a text file and return its lines in a `VT_BSTR` array with a lower bound of 1.
`FileReadAllLinesA` reads an ANSI file (a UTF-8 byte-order mark is skipped, but the text is
converted from the ANSI code page); `FileReadAllLinesW` reads a UTF-16 file, skipping a
byte-order mark. The lines end at `szDelimiter` / `wszDelimiter`, CR LF by default.

Both have limits to know about:

- A line after the last delimiter is not returned, so end the file with a delimiter.
- A line no longer than the delimiter (2 characters with CR LF in `FileReadAllLinesA`; 4 with
  CR LF in `FileReadAllLinesW`, which compares characters with bytes) comes back empty.
- The file is read into a buffer with no terminating null, which the delimiter search can run
  past.

The array is locked (see the introduction). A file that cannot be opened gives an empty array.

**Returns** the lines.

**Example**

```freebasic
dim lines as DSafeArray = FileReadAllLinesA( "notes.txt" )
for i as long = lines.LBound to lines.UBound
    print lines.GetStr( i ).Utf8
next
```

Microsoft Learn: [CreateFileW](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew)

### DSafeArrayCompare, DSafeArrayReverseCompare

```freebasic
function DSafeArrayCompare cdecl( byval a as BSTR ptr, byval b as BSTR ptr ) as long
function DSafeArrayReverseCompare cdecl( byval a as BSTR ptr, byval b as BSTR ptr ) as long
```

The comparison functions [Sort](#sort) passes to `qsort`: `DSafeArrayCompare` compares the two
strings by character code (`wcscmp`), `DSafeArrayReverseCompare` turns −1 into 1 and 1 into −1.
They take pointers to `BSTR`s, as `qsort` passes pointers to the elements.

**Returns** −1, 0 or 1.

**Example**

```freebasic
dim x as BSTR = SysAllocString( "apple" )
dim y as BSTR = SysAllocString( "banana" )
print DSafeArrayCompare( @x, @y ), DSafeArrayReverseCompare( @x, @y )   ' -1  1
SysFreeString( x ) : SysFreeString( y )
```

## See also

- [sys/win/com](SysWin-Com)
- [BSTRING](BSTRING) and [DVARIANT](DVARIANT), the element types of string and variant arrays
- [CDispInvoke](CDispInvoke), whose methods return arrays inside a `DVARIANT`
- [COM procedures](SysWin-Com-Procedures)
- Microsoft Learn: [SAFEARRAY structure](https://learn.microsoft.com/en-us/windows/win32/api/oaidl/ns-oaidl-safearray), [SAFEARRAYBOUND structure](https://learn.microsoft.com/en-us/windows/win32/api/oaidl/ns-oaidl-safearraybound)
