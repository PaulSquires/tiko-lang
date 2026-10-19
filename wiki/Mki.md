[Home](Home) › [String Functions](Category-String-Functions) › **MKI**

# MKI

Copies an integer's bytes into a string.

## Syntax

```freebasic
Declare Function MKI ( ByVal number As Integer ) As String
Declare Function MKI<bits> ( ByVal number As Integer<bits> ) As String
```

## Parameters

- `number`

## Description

Does a binary copy from an [`Integer`](Integer) or `Integer<bits>` variable to a [`String`](String), setting its length to the number of bytes in the type. The resulting string can be read back to an integer type using [`CVI`](Cvi) or `CVI<bits>`.

 This function is useful to write numeric values to buffers without using a [`Type`](Type-Udt) definition.

 `MKI` supports an optional `<bits>` parameter before the argument. If `bits` is `16`, [`MKShort`](Mkshort) will be called instead; if `bits` is `32`, [`MKL`](Mkl) will be called; if `bits` is `64`, [`MKLongInt`](Mklongint) will be called. The length of the return value and the required `number` argument type will depend on which function is called. See each function's page for more information.

## Return Value

Returns a [`String`](String) containing a binary copy of `number`.

## Remarks

### Usage

```freebasic
result = MKI[$]( number )

result = MKI[$]<bits>( number )
```

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, `MKI` returns a 2-byte-string, since a QB integer is only 16 bits.
  In the *[-lang qb](Compiler-Option-Lang)* dialect, `<bits>` parameter is not supported.  
  The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### See also

- [`CVI`](Cvi)
- [`MKShort`](Mkshort)
- [`MKL`](Mkl)
- [`MKLongInt`](Mklongint)
- [`Integer`](Integer)

## Examples

```freebasic
Dim a As Integer, b As String

a=4534

b=MKI(a)

Print a, CVI(b)
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
