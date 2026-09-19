[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Object**

# Object

Built-in type providing run-time type information

## Syntax

```freebasic
Type Object
As fb_BaseVT Ptr vtable_ptr
Declare Constructor()
End Type
```

## Description

**Object** is a built-in type which provides Run-Time Type Information (RTTI) for all types derived from it using [`Extends`](Extends), allowing them to be used with [`Operator Is`](Operator-Is-Run-Time-Type-Information), and to support [`Virtual`](Virtual) and [`Abstract`](Abstract) methods.

 Extending the built-in **Object** type allows to add an extra hidden vtable pointer field at the top of the [`Type`](Type-Udt). The vtable is used to dispatch [`Virtual`](Virtual) and [`Abstract`](Abstract) methods and to access information for run-time type identification used by [`Operator Is`](Operator-Is-Run-Time-Type-Information).

## Remarks

### Usage

```freebasic
Type typename Extends Object

End Type

Dim variable As Object
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Object`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Extends`](Extends)
- [`Extends Zstring`](Extends-Zstring)
- [`Extends Wstring`](Extends-Wstring)
- [`Operator Is`](Operator-Is-Run-Time-Type-Information)
- [`Virtual`](Virtual)
- [`Abstract`](Abstract)

## Examples

See the [`Operator Is`](Operator-Is-Run-Time-Type-Information) page, the [`Virtual`](Virtual) and [`Abstract`](Abstract) pages.

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
