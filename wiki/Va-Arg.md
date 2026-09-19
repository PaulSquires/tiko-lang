[Home](Home) › [Procedures](Category-Procedures) › **va_arg**

# va_arg

Returns the current argument from a variable argument list.

## Syntax

```freebasic
variable = va_arg ( argument_list, datatype )
```

## Description

The `va_arg` macro allows the use of a variable number of arguments within a function:

Not supported when using [`-gen gcc`](Compiler-Option-Gen). Use [`Cva_List`](Cva-List) variadic argument list type for cross platform compatibility.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__va_arg`.

### Differences from QB

- New to FreeBASIC

### See also

- [`... (Ellipsis)`](Ellipsis)
- [`va_first`](Va-First)
- [`va_next`](Va-Next)

## Examples

See the [`Va_First()`](Va-First) examples.

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
