[Home](Home) › [Modularizing](Category-Modularizing) › **Import**

# Import

External linkage attribute for public data located in DLL's

## Syntax

```freebasic
Extern Import symbolname[( subscripts)] [ Alias "aliasname"] [ As DataType] [, ...]
```

## Description

Is used only (with the [`Extern`](Extern) keyword) in external modules to access global variables from Win32 DLLs: the variable names will be added to the dynamic library import list so that their addresses can be fixed at run-time.  
 This is due to the level of indirection on any such access: an implicit pointer dereference.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Import`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Extern`](Extern)

## Examples

```freebasic
/* mydll.c :

    compile With

      gcc -Shared -Wl,--strip-all -o mydll.dll mydll.c

*/

__declspec( dllexport ) Int MyDll_Data = 0x1234;
```

```freebasic
/'  import.bas :

 Compile with

   fbc import.bas

'/

#inclib "mydll"

Extern Import MyDll_Data Alias "MyDll_Data" As Integer

Print "&h" + Hex( MyDll_Data )

' Output:

' &h1234
```

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
