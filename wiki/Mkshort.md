[Home](Home) › [String Functions](Category-String-Functions) › **MKShort**

# MKShort

Does a binary copy from a Short variable to a String, setting its length to 2 bytes

## Syntax

```freebasic
Declare Function MKShort ( ByVal number As Short ) As String
```

## Parameters

- `number`

## Description

Does a binary copy from a SHORT variable to a string, setting its length to 2 bytes. The resulting string can be read back to a [`Short`](Short) by [`CVShort`](Cvshort)

 This function is useful to write numeric values to buffers without using a [`Type`](Type-Udt) definition.

## Return Value

Returns a [`String`](String) with a binary copy of the [`Short`](Short).

## Remarks

### Usage

`result = MKShort[$](number)`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Mkshort`.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- In QBasic this function is called `MKI`.

### See also

- [`CVShort`](Cvshort)

## Examples

```freebasic
Dim a As Short, b As String

a = 4534

b = MKShort(a)

Print a, CVShort(b)

Sleep
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
