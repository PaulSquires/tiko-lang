[Home](Home) › [Modularizing](Category-Modularizing) › **DyLibFree**

# DyLibFree

Unloads a dynamic link library from memory

## Syntax

```freebasic
Declare Sub DyLibFree ( ByVal libhandle As Any Pointer )
```

## Parameters

- `libhandle`

## Description

`DyLibFree` is used to release at runtime libraries previously linked to your program with [`DyLibLoad`](Dylibload). The argument is the handle to the library returned by [`DyLibLoad`](Dylibload).

## Remarks

### Usage

`DyLibFree( libhandle )`

### Platform Differences

- DOS: see specific [Shared Libraries - DOS](Shared-Libraries-Dos) page

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Dylibfree`.

### Differences from QB

- New to FreeBASIC

### See also

- [`DyLibSymbol`](Dylibsymbol)
- [`DyLibLoad`](Dylibload)
- [`Export`](Export)

## Examples

See the dynamic loading example on the [Shared Libraries](Shared-Libraries) page.

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
