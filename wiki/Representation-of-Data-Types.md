[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **Representation of data types**

# Representation of data types

Almost all parts of the compiler deal with data types in one way or another. Symbols worry about data types the most, this is what most of the compile-time type checks are based on. AST nodes also have data types, that takes care of expressions (including casting/conversions).

 A data type is represented as a combination of:

How many PTR's there are on the type, maximum 8. If > 0, then the data type is a pointer.

```freebasic
    Example                     CONST mask

const integer                   000000001           (first CONST bit set)
integer const ptr               000000001           (ditto)
const integer ptr               000000010           (pointer to const)
const integer ptr const ptr     000000101           (const pointer to pointer to const)
```

This is used in places that have to calculate sizes (e.g. structure size calculations, pointer arithmetic, stack offsets).

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
