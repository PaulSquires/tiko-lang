[Home](Home) › [String Functions](Category-String-Functions) › **CVLongInt**

# CVLongInt

Reads a LongInt back from an 8-byte string.

## Syntax

```freebasic
Declare Function CVLongInt ( ByVal dbl As Double ) As LongInt
Declare Function CVLongInt ( ByRef str As Const String ) As LongInt
```

## Parameters

- `dbl`
- `str`

## Description

Returns a 64-bit [`LongInt`](Longint) value using the binary data contained in a [`Double`](Double), or a [`String`](String) of at least eight bytes in length. A value of zero (`0`) is returned if the string is less than eight bytes in length.

 `CVLongInt` is used to convert 8-byte strings created with [`MKLongInt`](Mklongint).

 This function can also be used to convert 64-bit integer values from a memory or file buffer without the need for a [`Type`](Type-Udt) structure. However, just as with the type structure, special care should be taken when using `CVLongInt` to convert strings that have been read from a buffer.

## Return Value

A [`LongInt`](Longint) variable holding a binary copy of the input variable.

## Remarks

### Usage

```freebasic
result = CVLongInt( dbl )

result = CVLongInt( str )
```

### Differences from QB

- In QB an error occurs if the string passed is less than eight bytes in length.
- QB did not support floating-point arguments.

### See also

- [`MKLongInt`](Mklongint)
- [`CVShort`](Cvshort)
- [`CVI`](Cvi)
- [`CVL`](Cvl)

## Examples

```freebasic
Dim ll As LongInt, s As String

s = "ABCDEFGH"

ll = CVLongInt(s)

Print Using "s = ""&"""; s

Print Using "ll = _&H&"; Hex(ll)
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
