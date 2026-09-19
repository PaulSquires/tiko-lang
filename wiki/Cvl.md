[Home](Home) › [String Functions](Category-String-Functions) › **CVL**

# CVL

Converts a single-precision floating-point number or four-byte string to an integer (Long) variable

## Syntax

```freebasic
Declare Function CVL ( ByVal sng As Single ) As Long
Declare Function CVL ( ByRef str As Const String ) As Long
```

## Parameters

- `sng`
- `str`

## Description

Returns a 32-bit [`Long`](Long) integer value using the binary data contained in a [`Single`](Single), or a [`String`](String) of at least four bytes in length. A value of zero (`0`) is returned if the string is less than four bytes in length.

 `CVL` is used to convert 4-byte strings created with [`MKL`](Mkl).

 This function can also be used to convert 32-bit integer values from a memory or file buffer without the need for a [`Type`](Type-Udt) structure. However, just as with the type structure, special care should be taken when using `CVL` to convert strings that have been read from a buffer.

## Return Value

A [`Long`](Long) variable to copy the binary copy of a integer to.

## Remarks

### Usage

```freebasic
result = CVL( sng )

result = CVL( str )
```

### Differences from QB

- In QB an error occurs if the string passed is less than four bytes in length.
- QB did not support floating-point arguments.

### See also

- [`MKL`](Mkl)
- [`CVShort`](Cvshort)
- [`CVI`](Cvi)
- [`CVLongInt`](Cvlongint)

## Examples

```freebasic
Dim l As Long, s As String

s = "ABCD"

l = CVL(s)

Print Using "s = ""&"""; s

Print Using "l = &"; l
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
