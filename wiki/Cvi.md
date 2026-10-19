[Home](Home) › [String Functions](Category-String-Functions) › **CVI**

# CVI

Reads an integer back from a string of its bytes.

## Syntax

```freebasic
32-bit:
Declare Function CVI ( ByVal f As Single ) As Integer
64-bit:
Declare Function CVI ( ByVal f As Double ) As Integer
Declare Function CVI ( ByRef str As Const String ) As Integer
Declare Function CVI<bits> ( expr As DataType ) As Integer<bits>
```

## Parameters

- `f`
- `str`
- `bits`
- `expr`
- `expr`

## Description

Returns an integer value using the binary data contained in a floating-point value, or a [`String`](String). A value of zero (`0`) is returned if the string contains fewer characters than the size of the return type.

 `CVI` can be used to convert strings created with [`MKI`](Mki).

 This function can also be used to convert [`Integer`](Integer)-sized values from a memory or file buffer without the need for a [`Type`](Type-Udt) structure. However, just as with the type structure, special care should be taken when using `CVI` to convert strings that have been read from a buffer.

 `CVI` supports an optional `<bits>` parameter before the argument. If `bits` is `16`, [`CVShort`](Cvshort) will be called instead; if `bits` is `32`, [`CVL`](Cvl) will be called; if `bits` is `64`, [`CVLongInt`](Cvlongint) will be called. The return type and accepted argument types will depend on which function is called. See each function's page for more information.

 `CVI`'s behaviour changes depending on the size of the [`Integer`](Integer) data type on the current platform.

- For 16-bit [`Integer`](Integer) (*[-lang qb](Compiler-Option-Lang)*), a 16-bit value is returned, and no floating-point types are accepted.
  For 32-bit [`Integer`](Integer), a 32-bit value is returned, and numeric arguments are interpreted as [`Single`](Single) precision values.  
  For 64-bit [`Integer`](Integer), a 64-bit value is returned, and numeric arguments are interpreted as [`Double`](Double) precision values.

## Return Value

An [`Integer`](Integer) or `Integer<bits>` variable containing a binary copy of the input expression.

## Remarks

### Usage

```freebasic
result = CVI( sng )

result = CVI( str )

result = CVI<bits>( expr )
```

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, `CVI` expects a 2-byte string, since a QB integer is only 16 bits. Only the first two bytes of the string are used, even if the string happens to be longer than two bytes.
  In the *[-lang qb](Compiler-Option-Lang)* dialect, `CVI` will not take a floating-point argument, since a QB integer is only 16 bits and there is no 16-bit floating-point data type. Instead, `CVI<32>`/`CVI<64>` or [`CVL`](Cvl)/[`CVLongInt`](Cvlongint) may be used.

### Differences from QB

- In QB an error occurs if the string passed is fewer than two bytes in length.
- QB did not support floating-point arguments.
- QB did not support a `<bits>` parameter.

### See also

- [`MKI`](Mki)
- [`CVShort`](Cvshort)
- [`CVL`](Cvl)
- [`CVLongInt`](Cvlongint)
- [`Integer`](Integer)

## Examples

```freebasic
Dim i As Integer, s As String

s = "ABCD"

i = CVI(s)

Print Using "s = ""&"""; s

Print Using "i = _&H&"; Hex(i)
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
