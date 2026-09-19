[Home](Home) › [Variable Declarations](Category-Variable-Declarations) › **Shared**

# Shared

Variable declaration modifier specifying visibility throughout a module

## Syntax

```freebasic
Dim Shared ...
ReDim Shared ...
Common Shared ...
Static Shared ...
[Static] Var Shared ...
```

## Description

`Shared` makes module-level variables visible inside [`Sub`](Sub)s and [`Function`](procedures-Function)s.  
 If `Shared` is not used on a module-level variable's declaration, the variable is only visible to the module-level code in that file (furthermore, only a variable declared with `Dim` without `Shared` modifier, and not inside a Namespace block, is stored on the stack).

 NOTES (for `Shared` variables excluding [`Common`](Common) variables):

To access from a local scope block to duplicated symbols of `Shared` variables defined in the global namespace, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).

## Remarks

### Differences from QB

- The `Shared` statement inside scope blocks -- functions, subs, if/thens, and loops -- is not supported. Use `Dim`|`Redim`|`Common`|`Static Shared` in the main program instead. Or if you're inside a scope block and `Redim`ming a variable or array previously set up with `Shared`, just do a `Redim` without `Shared`; it will work fine and won't ruin anything.

### See also

- [`Common`](Common)
- [`Dim`](Dim)
- [`Erase`](Erase)
- [`Extern`](Extern)
- [`LBound`](Lbound)
- [`ReDim`](Redim)
- [`Preserve`](Preserve)
- [`Static`](procedures-Static)
- [`UBound`](Ubound)
- [`Var`](Var)
- [`Byref (Variables)`](Byref-Variables)

## Examples

```freebasic
'' Compile with -lang qb or fblite

'$lang: "qb"

Declare Sub MySub

Dim Shared x As Integer

Dim y As Integer

x = 10

y = 5

MySub

Sub MySub

    Print "x is "; x 'this will report 10 as it is shared

    Print "y is "; y 'this will not report 5 because it is not shared

End Sub
```

---

**Category:** [Variable Declarations](Category-Variable-Declarations)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
