[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Field**

# Field

Specifies field alignment.

## Syntax

```freebasic
Type|Union typename Field = { 1 | 2 | 4 }
...
End Type|Union
```

## Description

`Field` can be used to pack [`Types`](Type-Udt) or [`Unions`](Union) more tightly than the default layout. The most commonly used value is `Field = 1`, which causes the `Type` or `Union` to be packed as tightly as possible, without any padding bytes being added between the fields or at the end of the `Type`. `Field` can only be used to decrease field alignment, but it cannot be used to increase it. In order to add padding bytes, a `Union` with appropriate members could be used instead.

## Remarks

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, the compiler assumes `Field = 1` by default, if no other `Field` was specified, causing all structures to be tightly packed, without added padding, as in QB.

### Differences from QB

- In QB `Field` was used to define fields in a file buffer at run time. This feature is not implemented in FB, so the keyword has been redefined. To define fields in a file buffer, `Types` must be used.

### See also

- [`Type`](Type-Udt)
- [`Union`](Union)

## Examples

```freebasic
Type bitmap_header Field = 1

    bfType          As UShort

    bfsize          As ULong

    bfReserved1     As UShort

    bfReserved2     As UShort

    bfOffBits       As ULong

    biSize          As ULong

    biWidth         As ULong

    biHeight        As ULong

    biPlanes        As UShort

    biBitCount      As UShort

    biCompression   As ULong

    biSizeImage     As ULong

    biXPelsPerMeter As ULong

    biYPelsPerMeter As ULong

    biClrUsed       As ULong

    biClrImportant  As ULong

End Type

Dim bmp_header As bitmap_header

'Open up bmp.bmp and get its header data:

'Note: Will not work without a bmp.bmp to load . . .

Open "bmp.bmp" For Binary As #1

    Get #1, , bmp_header

Close #1

Print bmp_header.biWidth, bmp_header.biHeight

Sleep
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
