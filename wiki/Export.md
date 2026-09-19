[Home](Home) › [Modularizing](Category-Modularizing) › **Export**

# Export

Definition specifier to indicate that a procedure in a DLL should be visible from other programs

## Syntax

```freebasic
{ Sub | Function } proc_name ( argumentlist ) [ [ ByRef ] As datatype ] Export
```

## Description

If a function is defined with this clause in a DLL, it is added to the public export table, so external programs can dynamically link to it using [DyLibSymbol](Dylibsymbol).  
 (specifier to be put at the level of the first line of procedure definition, forbidden at procedure declaration line level)

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Export`.

### Platform Differences

- `Export` has no effect in DOS dynamic link libraries (DXE's); all public procedures are exported.

### Differences from QB

- New to Freebasic

### See also

- [`DyLibLoad`](Dylibload)
- [`DyLibSymbol`](Dylibsymbol)
- [`Alias`](Alias-Name)

## Examples

See the examples on the [Shared Libraries](Shared-Libraries) page.

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
