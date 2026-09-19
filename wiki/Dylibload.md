[Home](Home) › [Modularizing](Category-Modularizing) › **DyLibLoad**

# DyLibLoad

Loads to a Dynamic Link Library (DLL) into memory at runtime

## Syntax

```freebasic
Declare Function DyLibLoad ( ByRef libname As String ) As Any Pointer
```

## Parameters

- `libname`

## Description

[`DyLibLoad`](Dylibload) is used to link at runtime libraries to your program. This function does the link and returns a handle that must be used with [`DyLibSymbol`](Dylibsymbol) when calling a function in the library and with [`DyLibFree`](Dylibfree) when releasing the library.

 Note: If the `libname` string (without extension) already includes a character dot (`.`), it may be mandatory to explicitly specify the filename extension to avoid any parser ambiguity.

## Return Value

The [`Pointer`](Pointer-Ptr) handle of the library loaded. Zero on error

## Remarks

### Usage

`result = DyLibLoad ( libname )`

### Platform Differences

- DOS: dynamic link libraries have ".dxe" file name extension and the full `libname` must be specified: "\<name>.dxe".
- DOS: calling `dylibload(``"``"``)`, using an empty file name will initialize the run time library exports.
- DOS: see specific [Shared Libraries - DOS](Shared-Libraries-Dos) page

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Dylibload`.

### Differences from QB

- New to FreeBASIC

### See also

- [`DyLibSymbol`](Dylibsymbol)
- [`DyLibFree`](Dylibfree)
- [`Export`](Export)

## Examples

See the dynamic loading example on the [Shared Libraries](Shared-Libraries) page.

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
