[Home](Home) › [String Functions](Category-String-Functions) › **MKLongInt**

# MKLongInt

Copies a LongInt's bytes into an 8-byte string.

## Syntax

```freebasic
Declare Function MKLongInt ( ByVal number As LongInt ) As String
```

## Parameters

- `number`

## Description

Does a binary copy from a [`LongInt`](Longint) variable to a string, setting its length to 8 bytes. The resulting string can be read back to a longint by [`CVLongInt`](Cvlongint)

 This function is useful to write numeric values to buffers without using a [`Type`](Type-Udt) definition.

## Return Value

Returns a [`String`](String) with a binary copy of the [`LongInt`](Longint).

## Remarks

### Usage

`result = MKLongInt[$]( number )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Mklongint`.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- New to FreeBASIC

### See also

- [`CVLongInt`](Cvlongint)

## Examples

```freebasic
Dim a As LongInt, b As String

a = 4534

b = MKLongInt(a)

Print a, CVLongInt(b)

Sleep
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
