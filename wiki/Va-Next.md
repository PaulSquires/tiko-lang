[Home](Home) › [Procedures](Category-Procedures) › **va_next**

# va_next

Returns a pointer to the next argument in a variable argument list

## Syntax

```freebasic
Argument_Pointer = va_next ( Argument_List, datatype )
```

## Description

The `va_next` macro provides a `datatype` pointer value that points to the next argument within the list `Argument_List`, `datatype` being the type of the current argument being stepped over.

 Not supported when using [`-gen gcc`](Compiler-Option-Gen). Use [`Cva_List`](Cva-List) variadic argument list type for cross platform compatibility.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Va_next`.

### Differences from QB

- New to FreeBASIC

### See also

- [... (Ellipsis)](Ellipsis)
- [`va_arg`](Va-Arg)
- [`va_first`](Va-First)

## Examples

See the [`Va_First()`](Va-First) examples.

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
