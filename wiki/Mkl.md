[Home](Home) › [String Functions](Category-String-Functions) › **MKL**

# MKL

Copies a Long's bytes into a 4-byte string.

## Syntax

```freebasic
Declare Function MKL ( ByVal number As Long ) As String
```

## Parameters

- `number`

## Description

Does a binary copy from a [`Long`](Long) variable to a [`String`](String), setting its length to 4 bytes. The resulting string can be read back to a [`Long`](Long) by [`CVL`](Cvl).

 This function is useful to write numeric values to buffers without using a [`Type`](Type-Udt) definition.

## Return Value

Returns a [`String`](String) with a binary copy of the [`Long`](Long).

## Remarks

### Usage

`result = MKL( number )`

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- None

### See also

- [`MKD`](Mkd)
- [`MKI`](Mki)
- [`MKS`](Mks)
- [`CVD`](Cvd)
- [`CVI`](Cvi)
- [`CVL`](Cvl)
- [`CVS`](Cvs)

## Examples

```freebasic
Dim a As Long, b As String

a = 4534

b = MKL(a)

Print a, CVL(b)

Sleep
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
