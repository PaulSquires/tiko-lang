[Home](Home) › [String Functions](Category-String-Functions) › **CVShort**

# CVShort

Reads a Short back from a 2-byte string.

## Syntax

```freebasic
Declare Function CVShort ( ByRef str As Const String ) As Short
```

## Parameters

- `str`

## Description

Returns a 16-bit [`Short`](Short) integer value using the binary data contained in a [`String`](String) of at least two bytes in length. A value of zero (`0`) is returned if the string is less than two bytes in length.

 `CVShort` is used to convert 2-byte strings created with [`MKShort`](Mkshort).

 This function can also be used to convert 16-bit integer values from a memory or file buffer without the need for a [`Type`](Type-Udt) structure. However, just as with the type structure, special care should be taken when using `CVShort` to convert strings that have been read from a buffer.

## Return Value

[`Short`](Short) variable holding the binary copy of a [`Keypgshort`](Short).

## Remarks

### Usage

`result = CVShort( str )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cvshort`.

### Differences from QB

- In QB this function is called CVI

### See also

- [`MKShort`](Mkshort)
- [`CVI`](Cvi)
- [`CVL`](Cvl)
- [`CVLongInt`](Cvlongint)

## Examples

```freebasic
Dim si As Short, s As String

s = "AB"

si = CVShort(s)

Print Using "s = ""&"""; s

Print Using "si = _&H&"; Hex(si)
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
