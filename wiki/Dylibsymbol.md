[Home](Home) › [Modularizing](Category-Modularizing) › **DyLibSymbol**

# DyLibSymbol

Returns the address of a function or variable in a dll

## Syntax

```freebasic
Declare Function DyLibSymbol ( ByVal libhandle As Any Ptr, ByRef symbol As String ) As Any Ptr
Declare Function DyLibSymbol ( ByVal libhandle As Any Ptr, ByVal symbol As Short ) As Any Ptr
```

## Parameters

- `libhandle`
- `symbol`

## Description

`DyLibSymbol` returns a pointer to the variable or function named `symbol` , in the dll pointed by `libhandle`. `libhandle` is obtained by loading the dll with [`DyLibLoad`](Dylibload). The symbol must have been [`Export`](Export)ed in the dll.  
 If `libhandle` is 0, the symbol is searched in the current executable or dll.

 If using [`cdecl`](Cdecl) functions, only the name of the procedure needs to be specified. If dynamically linking to a function created using STDCALL (default in windows), then the function must be decorated. To decorate a function, use its name, '@', then the number of bytes passed as arguments. For instance if the function `FOO` takes 3 integer arguments, the decorated function would be 'FOO@12'. Remember, without an explicit [`Alias`](Alias-Name), the procedure name will be uppercase.

 If linking to a dll created in Visual C++(tm), decoration need not be used. For GCC, decoration is needed.

 **Note:** The dylibsymbol, if failing, will attempt to automatically decorate the procedure, from @0 to @256, in 4 byte increments.

## Return Value

A [`Pointer`](Pointer-Ptr) to the function or variable in the library.

 If the function fails, the return value is 0.

## Remarks

### Usage

`result = DyLibSymbol ( libhandle, symbol )`

### Platform Differences

- Ordinals are not supported on Linux, 0 is always returned.
- Ordinals are not supported on DOS, 0 is always returned.
- Windows does not support `DyLibSymbol` use with variables (only with procedures).
- DOS: see specific [Shared Libraries - DOS](Shared-Libraries-Dos) page

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Dylibsymbol`.

### Differences from QB

- New to FreeBASIC

### See also

- [`DyLibLoad`](Dylibload)
- [`DyLibFree`](Dylibfree)
- [`Export`](Export)

## Examples

See the dynamic loading example on the [Shared Libraries](Shared-Libraries) page.

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
