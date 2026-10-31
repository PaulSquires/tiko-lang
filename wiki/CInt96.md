[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/com](SysWin-Com) › **CInt96**

# CInt96

Stores a 96-bit signed integer in a COM `DECIMAL` and does arithmetic on it.

`CInt96` holds whole numbers from −(2⁹⁶ − 1) to 2⁹⁶ − 1, about ±7.9 × 10²⁸, far beyond the
±9.2 × 10¹⁸ of a `longint`. The value lives in the public
field `m_int96`, a `DECIMAL` with a scale of 0: a 96-bit magnitude and a separate sign. The
arithmetic is done by the Automation decimal functions (`VarDecAdd`, `VarDecMul` …); the bitwise
operators turn the value into 96-bit two's complement, work on that and turn it back.

What to keep in mind:

- **Literals.** A number that fits in a `longint` or `ulongint` can be assigned directly. Anything
  larger comes in as a string literal when the variable is created, as in the
  [Example](#example), or with `wstr()` when it is assigned ([Let](#let)).
- **Errors are quiet.** Nothing raises an error. On failure the operation stores the `HRESULT` in
  `GetLastError()`, and a binary operator such as `+` or `*` returns its left operand unchanged:
  an overflow or a division by zero leaves you with the first number. Clear the code with
  `SetLastError( 0 )` before an operation whose failure you want to see, and read it straight
  after: converting a `CInt96` to text (printing it) resets it.
- **Rounding.** `/` rounds down, toward negative infinity: `-17 / 5` is −4. `mod` truncates
  toward zero, so `-17 mod 5` is −2 and the two do not add back up for negative numbers.
- **Equality.** The `=` comparison is not available outside the module; compare with
  `not ( a <> b )`. The other comparisons are.
- **Text.** A `CInt96` prints as it is and converts to a `string`.

Nothing has to be freed.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com
```

## Example

Finds the largest factorial that fits, works with a value beyond 64 bits and shows how division
and `mod` round:

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com

' The largest factorial that fits in 96 bits
dim f as CInt96 = 1
dim n as long = 1
do
    SetLastError( 0 )
    dim nxt as CInt96 = f * CInt96( n + 1 )
    if GetLastError() <> 0 then exit do   ' overflow: nxt is f unchanged
    f = nxt
    n += 1
loop
print n; "! = "; f

' Values beyond 64 bits come in as text
dim big as CInt96 = "79228162514264337593543950335"
print "largest: "; big
print "2 ^ 95 = "; CInt96( 1 ) shl 95

' Division rounds down; mod keeps the sign of the dividend
print CInt96( -17 ) / CInt96( 5 ), CInt96( -17 ) mod CInt96( 5 )
```

It prints:

```text
 27! = 10888869450418352160768000000
largest: 79228162514264337593543950335
2 ^ 95 = 39614081257132168796771975168
-4            -2
```

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates a `CInt96` from a number, a string, a `DECIMAL` or another `CInt96`. |
| [Destructor](#destructor) | Does nothing; there is nothing to free. |
| [Let](#let) | Assigns a number, a string, a `DECIMAL` or another `CInt96`. |
| [Cast](#cast) | Converts to `CURRENCY`, `VARIANT` or `string`. |
| [Operator +=, -=, *=, /=](#operator-----) | Adds, subtracts, multiplies or divides in place. |
| [Operator mod=](#operator-mod) | Replaces the value with the remainder of a division. |
| [Operator and=, or=, xor=, imp=, eqv=](#operator-and-or-xor-imp-eqv) | Combines the bits in place. |
| [Operator shl=, shr=](#operator-shl-shr) | Shifts in place. |
| [Sign](#sign) | Returns the sign byte of the `DECIMAL`. |
| [IsSigned, IsUnsigned](#issigned-isunsigned) | Tells whether the value is negative. |
| [ToVar](#tovar) | Returns the value as a `VARIANT`. |

## Reference

### Constructor

```freebasic
constructor
constructor( byref cSrc as CInt96 )
constructor( byref decSrc as DECIMAL )
constructor( byval nInteger as longint )
constructor( byval nUInteger as ulongint )
constructor( byref wszSrc as wstring )
```

- With no argument the value is 0.
- From a `DECIMAL` with a fractional part, the fraction is dropped by rounding down
  (`VarDecInt`): 12.75 gives 12, −12.75 gives −13.
- From a string the text is parsed as a whole number; surrounding spaces are ignored. A string
  containing a `.` is refused with `E_INVALIDARG`, and text that is not a number gives `DISP_E_TYPEMISMATCH`;
  either way the value stays 0 and `GetLastError()` holds the code.
- From `longint` and `ulongint` every value of those types is exact.

| Parameter | Meaning |
| --- | --- |
| `cSrc` | Another `CInt96` to copy. |
| `decSrc` | A `DECIMAL`. |
| `nInteger`, `nUInteger` | A 64-bit number. |
| `wszSrc` | The number as text. |

**Example**

```freebasic
dim a as CInt96 = 123456789012345678ll
dim b as CInt96 = "79228162514264337593543950335"
print a; " "; b
```

Microsoft Learn: [VarDecFromStr](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardecfromstr)

### Destructor

```freebasic
destructor
```

Does nothing: a `CInt96` holds no resources.

**Example**

```freebasic
scope
    dim n as CInt96 = 42
end scope
```

### Let

```freebasic
operator let( byref cSrc as CInt96 )
operator let( byref decSrc as DECIMAL )
operator let( byval n as longint )
operator let( byval u as ulongint )
operator let( byref s as wstring )
```

Assigns a new value, converted as the matching [Constructor](#constructor) does: a `DECIMAL`
with a fraction is rounded down, a string with a `.` is refused with `E_INVALIDARG` and leaves
the value as it was.

Pass text as a wide string. A narrow string literal assigned with `=` (`n = "100"`) currently
reaches the string form unconverted: it fails with `DISP_E_TYPEMISMATCH` and the value stays as
it was. Write `n = wstr( "100" )`, or `n = CInt96( "100" )`. Creating a `CInt96` from a narrow
literal (`dim n as CInt96 = "100"`) is not affected.

**Example**

```freebasic
dim n as CInt96
n = 5
n = wstr( "100000000000000000000000" )
print n
```

### Cast

```freebasic
operator cast() as CURRENCY
operator cast() as VARIANT
operator cast() as string
```

- To `CURRENCY`: the value scaled by 10 000, as `CURRENCY` stores it (12345 becomes an `int64`
  of 12345 × 10 000). A value beyond the range of `CURRENCY` gives 0, with `DISP_E_OVERFLOW` in
  `GetLastError()`.
- To `string`: the number as decimal text, with a leading `-` when negative. This is what
  `print` uses.
- To `VARIANT`: see [ToVar](#tovar), which it matches, including its `vt` of 0.

**Example**

```freebasic
dim n as CInt96 = -42
dim s as string = n
dim cy as CURRENCY = CInt96( 12345 )
print "["; s; "]"; cy.int64 \ 10000   ' [-42] 12345
```

Microsoft Learn: [VarBstrFromDec](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-varbstrfromdec)

### Operator +=, -=, *=, /=

```freebasic
operator +=( byref int96 as CInt96 )
operator -=( byref int96 as CInt96 )
operator *=( byref int96 as CInt96 )
operator /=( byref cOperand as CInt96 )
```

Add, subtract, multiply or divide the value in place. `/=` rounds the quotient down, toward
negative infinity. On overflow or division by zero `GetLastError()` holds the `HRESULT`
(`DISP_E_OVERFLOW`, `DISP_E_DIVBYZERO`).

**Example**

```freebasic
dim n as CInt96 = 100
n += CInt96( 5 )
n /= CInt96( 7 )
print n   ' 15
```

Microsoft Learn: [VarDecAdd](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardecadd)

### Operator mod=

```freebasic
operator mod=( byref rhs as CInt96 )
```

Replaces the value with the remainder of dividing it by `rhs`, truncating the quotient toward
zero: the result has the sign of the value, so `-17 mod= 5` gives −2. Dividing by 0 sets
`DISP_E_DIVBYZERO` in `GetLastError()` and leaves the value alone.

**Example**

```freebasic
dim n as CInt96 = -17
n mod= CInt96( 5 )
print n   ' -2
```

Microsoft Learn: [VarDecFix](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardecfix)

### Operator and=, or=, xor=, imp=, eqv=

```freebasic
operator and=( byref rhs as CInt96 )
operator or=( byref rhs as CInt96 )
operator xor=( byref rhs as CInt96 )
operator imp=( byref rhs as CInt96 )
operator eqv=( byref lhs as CInt96 )
```

Combine the bits of the value with those of the operand in place, both taken as 96-bit two's
complement numbers: `and`, `or` and `xor` as usual, `imp` as `( not a ) or b`, `eqv` as
`not ( a xor b )`. So `5 and= 3` gives 1, `-5 xor= 2` gives −7, `5 imp= 3` gives −5.

**Example**

```freebasic
dim n as CInt96 = 5
n or= CInt96( 3 )
print n   ' 7
```

### Operator shl=, shr=

```freebasic
operator shl=( byval nBits as uinteger )
operator shr=( byval nBits as uinteger )
```

`shl=` multiplies the value by 2 `nBits` times; when it overflows it stops there, with the value
doubled as far as it went and `DISP_E_OVERFLOW` in `GetLastError()`. `shr=` divides by 2 `nBits`
times, rounding down each time, which is an arithmetic shift: `-100 shr= 3` gives −13 and
`-1 shr= 100` stays −1. Both take time in proportion to `nBits`.

**Example**

```freebasic
dim n as CInt96 = 7
n shl= 4
print n   ' 112
```

### Sign

```freebasic
function Sign() as ubyte
```

Returns the sign byte of the `DECIMAL`: 0 for zero and positive values, `&h80` (128) for
negative ones.

**Returns** 0 or 128.

**Example**

```freebasic
print CInt96( -5 ).Sign   ' 128
```

### IsSigned, IsUnsigned

```freebasic
function IsSigned() as boolean
function IsUnsigned() as boolean
```

`IsSigned` is `true` for a negative value; `IsUnsigned` is `true` for zero and positive values.

**Returns** the test result.

**Example**

```freebasic
dim n as CInt96 = -42
print n.IsSigned, n.IsUnsigned   ' true  false
```

### ToVar

```freebasic
function ToVar() as VARIANT
```

Meant to return the value as a `VT_DECIMAL` variant. The type field of a `VARIANT` shares its
memory with the first, reserved field of a `DECIMAL`, and `ToVar` sets the type before copying the
decimal in, so the variant comes back with `vt` = 0 (`VT_EMPTY`) and the number in `decVal`.
Set `vt` to `VT_DECIMAL` afterwards to use it.

**Returns** a `VARIANT` holding the number in `decVal`.

**Example**

```freebasic
dim v as VARIANT = CInt96( 7 ).ToVar()
v.vt = VT_DECIMAL
print v.decVal.Lo32   ' 7
```

## Related functions

| Function | Does |
| --- | --- |
| [Operator +, -, *, /](#operator------1) | Adds, subtracts, negates, multiplies and divides. |
| [Mod](#mod) | Returns the remainder of a division. |
| [And, Or, Xor, Not, Imp, Eqv](#and-or-xor-not-imp-eqv) | Combines or inverts the bits. |
| [Shl, Shr](#shl-shr) | Shifts left or right. |
| [Operator <>, <, >, <=, >=](#operator------2) | Compares two values. |
| [Abs](#abs) | Returns the absolute value. |
| [Operator * (address)](#operator--address) | Returns the address of the `DECIMAL`. |
| [_Bits96_ToTwos](#_bits96_totwos) | Turns a `DECIMAL` into three 32-bit two's complement words. |
| [_Bits96_FromTwos](#_bits96_fromtwos) | Turns three two's complement words back into a `DECIMAL`. |

### Operator +, -, *, /

```freebasic
operator +( byref int961 as CInt96, byref int962 as CInt96 ) as CInt96
operator -( byref int961 as CInt96, byref int962 as CInt96 ) as CInt96
operator -( byref int96Src as CInt96 ) as CInt96
operator *( byref int961 as CInt96, byref int962 as CInt96 ) as CInt96
operator /( byref int96Src as CInt96, byref cOperand as CInt96 ) as CInt96
```

The four operations, and unary minus. `/` rounds the quotient down, toward negative infinity
(`-17 / 5` is −4). On overflow or division by zero the result is the **left operand unchanged**
and `GetLastError()` holds the `HRESULT`.

**Returns** the result.

**Example**

```freebasic
dim a as CInt96 = "40000000000000000000000000000"
SetLastError( 0 )
dim b as CInt96 = a + a
if cast( HRESULT, GetLastError() ) = DISP_E_OVERFLOW then print "overflow, b = a"
```

`GetLastError()` returns a `DWORD`; cast it to `HRESULT` before comparing it with an `HRESULT`
constant, which is negative.

Microsoft Learn: [VarDecMul](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardecmul)

### Mod

```freebasic
operator mod( byref lhs as CInt96, byref rhs as CInt96 ) as CInt96
```

Returns the remainder of `lhs / rhs` with the quotient truncated toward zero, so the remainder
has the sign of `lhs`: `-5 mod 3` is −2, `5 mod -3` is 2. Dividing by 0 returns `lhs` and sets
`DISP_E_DIVBYZERO` in `GetLastError()`.

**Returns** the remainder.

**Example**

```freebasic
print CInt96( 17 ) mod CInt96( 5 )   ' 2
```

### And, Or, Xor, Not, Imp, Eqv

```freebasic
operator and( byref lhs as CInt96, byref rhs as CInt96 ) as CInt96
operator or( byref lhs as CInt96, byref rhs as CInt96 ) as CInt96
operator xor( byref lhs as CInt96, byref rhs as CInt96 ) as CInt96
operator not( byref value as CInt96 ) as CInt96
operator imp( byref lhs as CInt96, byref rhs as CInt96 ) as CInt96
operator eqv( byref lhs as CInt96, byref rhs as CInt96 ) as CInt96
```

Bitwise operations on the 96-bit two's complement form of the values: `5 and 3` is 1, `5 or 3`
is 7, `5 xor 3` is 6, `not 0` is −1, `5 imp 3` is −5 and `5 eqv 3` is −7.

**Returns** the result.

**Example**

```freebasic
print CInt96( 5 ) and CInt96( 3 ), not CInt96( 0 )   ' 1  -1
```

### Shl, Shr

```freebasic
operator shl( byref value as CInt96, byval nBits as uinteger ) as CInt96
operator shr( byref value as CInt96, byval nBits as uinteger ) as CInt96
```

`shl` returns `value` × 2^`nBits`; when that overflows it returns `value` unchanged and sets
`DISP_E_OVERFLOW` in `GetLastError()`. `shr` returns `value` / 2^`nBits` rounded down, an
arithmetic shift: `-3 shr 1` is −2 and `-1 shr 100` is −1. Both work by repeated doubling or
halving.

**Returns** the shifted value.

**Example**

```freebasic
print CInt96( 1 ) shl 95, CInt96( -100 ) shr 3   ' 2^95, then -13
```

### Operator <>, <, >, <=, >=

```freebasic
operator <>( byref int961 as CInt96, byref int962 as CInt96 ) as boolean
operator <( byref int961 as CInt96, byref int962 as CInt96 ) as boolean
operator >( byref int961 as CInt96, byref int962 as CInt96 ) as boolean
operator <=( byref int961 as CInt96, byref int962 as CInt96 ) as boolean
operator >=( byref int961 as CInt96, byref int962 as CInt96 ) as boolean
```

Compare two values numerically. The `=` operator is private to the module: write
`not ( a <> b )` to test for equality.

**Returns** the result of the comparison.

**Example**

```freebasic
dim a as CInt96 = 4
dim b as CInt96 = 4
if not ( a <> b ) andalso a <= b then print "equal"
```

Microsoft Learn: [VarDecCmp](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardeccmp)

### Abs

```freebasic
operator abs( byref c96 as CInt96 ) as CInt96
```

Returns the absolute value.

**Returns** the value without its sign.

**Example**

```freebasic
print abs( CInt96( -42 ) )   ' 42
```

Microsoft Learn: [VarDecAbs](https://learn.microsoft.com/en-us/windows/win32/api/oleauto/nf-oleauto-vardecabs)

### Operator * (address)

```freebasic
operator *( byref int96 as CInt96 ) as DECIMAL ptr
```

Returns the address of `m_int96`, for a function that reads or writes a `DECIMAL`. A value
written there should keep a scale of 0.

**Returns** a pointer to the `DECIMAL`.

**Example**

```freebasic
dim n as CInt96 = -42
dim pd as DECIMAL ptr = *n
print pd->Lo32, pd->sign   ' 42  128
```

### _Bits96_ToTwos

```freebasic
sub _Bits96_ToTwos( byref d as DECIMAL, byref w0 as ulong, byref w1 as ulong, byref w2 as ulong )
```

Writes the 96 bits of a `DECIMAL` with a scale of 0 into three words, low to high, as a two's
complement number: a negative value is complemented and incremented. The bitwise operators are
built on it. The scale is not looked at.

| Parameter | Meaning |
| --- | --- |
| `d` | The decimal. |
| `w0`, `w1`, `w2` | Receive the low, middle and high 32 bits. |

**Example**

```freebasic
dim as ulong w0, w1, w2
_Bits96_ToTwos( CInt96( -1 ).m_int96, w0, w1, w2 )
print hex( w0 ), hex( w1 ), hex( w2 )   ' FFFFFFFF  FFFFFFFF  FFFFFFFF
```

### _Bits96_FromTwos

```freebasic
sub _Bits96_FromTwos( byval w0 as ulong, byval w1 as ulong, byval w2 as ulong, byref d as DECIMAL )
```

The reverse of [_Bits96_ToTwos](#_bits96_totwos): reads three words as a 96-bit two's complement
number, taking the top bit of `w2` as the sign, and stores it in `d` with a scale of 0.

| Parameter | Meaning |
| --- | --- |
| `w0`, `w1`, `w2` | The low, middle and high 32 bits. |
| `d` | Receives the decimal. |

**Example**

```freebasic
dim d as DECIMAL
_Bits96_FromTwos( &hFFFFFFFE, &hFFFFFFFF, &hFFFFFFFF, d )
dim n as CInt96 = d
print n   ' -2
```

## See also

- [sys/win/com](SysWin-Com)
- [DVARIANT](DVARIANT) for `VARIANT` values
- [COM procedures](SysWin-Com-Procedures)
- Microsoft Learn: [DECIMAL structure](https://learn.microsoft.com/en-us/windows/win32/api/wtypes/ns-wtypes-decimal-r1)
