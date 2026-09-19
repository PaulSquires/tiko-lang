[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CPtr**

# CPtr

Converts a pointer expression to a specified data type pointer

## Syntax

```freebasic
CPtr( PointerDataType, expression )
```

## Description

Converts `expression` to `PointerDataType`.

 `PointerDataType` must be a [`Pointer`](Pointer-Ptr) type (e.g. a DataType [`Ptr`](Pointer-Ptr) or an [`Any`](Any) [`Ptr`](Pointer-Ptr)), or a [`Type (Alias)`](Type-Alias) to one.  
 `expression` may have a different pointer type or be an [`Integer`](Integer).

 *Note: Currently, FB does not actually enforce that*PointerDataType*must be a pointer. This will likely change in future versions though. Currently, it may display a warning if you try to convert to a non-pointer (for any conversion type if you compile with the `-w pedantic` compiler switch).*

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cptr`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Ptr`](Pointer-Ptr)
- [`Cast`](Cast)
- [`CByte`](Cbyte)
- [`CShort`](Cshort)
- [`CInt`](Cint)
- [`CLngInt`](Clngint)
- [`CSng`](Csng)
- [`CDbl`](Cdbl)

## Examples

```freebasic
Dim intval As Integer

Dim intptr As Integer Ptr

intval = &h0080

intptr = @intval

'' will print -128 and 128, as the first expression will be "seen" as an signed byte

Print *CPtr( Byte Ptr, intptr ), *intptr
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
