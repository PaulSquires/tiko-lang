[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **OffsetOf**

# OffsetOf

Returns the offset of a field within a type.

## Syntax

```freebasic
#define OffsetOf(typename, fieldname) CInt( @Cast( typename Ptr, 0 )->fieldname )
```

## Parameters

- `typename`
- `fieldname`

## Description

For a non-derived type, `OffsetOf` will return the location `fieldname` as offset in bytes from the beginning of `typename`.

 For a derived type, `OffsetOf` will return the location `fieldname` as offset in bytes from the beginning of its highest base type.  
 Note: if a member of the base type is overridden by a new member, the offset of the old member cannot be accessed from the derived type.

## Remarks

### Usage

`result = OffsetOf( typename, fieldname )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Offsetof`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Type...End Type`](Type-Udt)
- [`SizeOf`](Sizeof)

## Examples

```freebasic
Type MyType

  x As Single

  y As Single

  Union

    b As Byte

    i As Integer

  End Union

End Type

Print "OffsetOf x = "; OffsetOf(MyType, x)

Print "OffsetOf y = "; OffsetOf(MyType, y)

Print "OffsetOf b = "; OffsetOf(MyType, b)

Print "OffsetOf i = "; OffsetOf(MyType, i)
```

 **Output**

```freebasic
OffsetOf x =  0
OffsetOf y =  4
OffsetOf b =  8
OffsetOf i =  8
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
