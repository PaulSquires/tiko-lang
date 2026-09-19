[Home](Home) › [Procedures](Category-Procedures) › **stdcall**

# stdcall

Specifies a stdcall-style calling convention in a procedure declaration

## Syntax

```freebasic
Sub name stdcall [Overload] [Alias "alias"] ( parameters )
Function name stdcall [Overload] [Alias "alias"] ( parameters ) [ ByRef ] As return_type
```

## Description

In procedure declarations, `stdcall` specifies that a procedure will use the `stdcall` calling convention. In the `stdcall` calling convention, any parameters are to be passed (pushed onto the stack) in the reverse order in which they are listed, that is, from right to left. The procedures need not preserve the `EAX`, `ECX` or `EDX` registers, and must clean up the stack (pop any parameters) before it returns.

 `stdcall` is not allowed to be used with variadic procedure declarations (those with the last parameter listed as "[`...`](Ellipsis)").

 `stdcall` is the default calling convention on Windows, unless another calling convention is explicitly specified or implied by one of the [`Extern Blocks`](Extern-End-Extern). `stdcall` is also the standard (or most common) calling convention used in BASIC languages, and the Windows API.

 If a procedure definition has a declaration (with calling convention explicit or by default) and the definition does not explicitly specify a calling convention, then the calling convention is implied by the declaration.

## Remarks

### Platform Differences

- On Windows systems, `stdcall` procedures have an `"@N"` decoration added to their internal/external name, where `N` is the size of the parameter list, in bytes.

### Differences from QB

- New to FreeBASIC

### See also

- [`pascal`](Pascal), [`cdecl`](Cdecl)
- [`Declare`](Declare)
- [`Sub`](Sub), [`Function`](procedures-Function)

## Examples

```freebasic
Declare Function Example stdcall (param1 As Integer, param2 As Integer) As Integer

Declare Function Example2 cdecl (param1 As Integer, param2 As Integer) As Integer

Function Example stdcall (param1 As Integer, param2 As Integer) As Integer

    ' This is an STDCALL function, the first parameter on the stack is param2, since it was pushed last.

    Print param1, param2

    Return param1 Mod param2

End Function

Function Example2 cdecl (param1 As Integer, param2 As Integer) As Integer

    ' This is a CDECL function, the first parameter on the stack is param1, since it was pushed last.

    Print param1, param2

    Return param1 Mod param2

End Function
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
