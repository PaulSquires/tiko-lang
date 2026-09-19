[Home](Home) › [String Functions](Category-String-Functions) › **MKS**

# MKS

Does a binary copy from a Single variable to a String, setting its length to 4 bytes

## Syntax

```freebasic
Declare Function MKS ( ByVal number As Single ) As String
```

## Parameters

- `number`

## Description

Does a binary copy from a [`Single`](Single) variable to a [`String`](String), setting its length to 4 bytes. The resulting string can be read back to a [`Single`](Single) by [`CVS`](Cvs).

 This function is useful to write numeric values to buffers without using a [`Type`](Type-Udt) definition.

## Return Value

Returns a [`String`](String) with a binary copy of the [`Single`](Single).

## Remarks

### Usage

`result = MKS[$]( number )`

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- None

### See also

- [`MKI`](Mki)
- [`MKL`](Mkl)
- [`MKD`](Mkd)
- [`CVD`](Cvd)
- [`CVI`](Cvi)
- [`CVL`](Cvl)
- [`CVS`](Cvs)

## Examples

```freebasic
Dim n As Single, e As String

n = 1.2345

e = MKS(n)

Print n, CVS(e)
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
