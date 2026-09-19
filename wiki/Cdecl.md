[Home](Home) › [Procedures](Category-Procedures) › **cdecl**

# cdecl

Specifies a cdecl-style calling convention in a procedure declaration

## Syntax

```freebasic
Sub name cdecl [Overload] [Alias "alias"] ( parameters )
Function name cdecl [Overload] [Alias "alias"] ( parameters ) [ ByRef ] As return_type
```

## Description

In procedure declarations, `cdecl` specifies that a procedure will use the `cdecl` calling convention. In the `cdecl` calling convention, any parameters are to be passed (pushed onto the stack) in the reverse order in which they are listed, that is, from right to left. The procedures need not preserve the `EAX`, `ECX` or `EDX` registers, and must not clean up the stack (pop any parameters) before it returns - that is left to the calling code.

 `cdecl` is allowed to be used with variadic procedure declarations (those with the last parameter listed as "[`...`](Ellipsis)").

 `cdecl` is the default calling convention on Linux, the \*BSDs, and DOS, unless another calling convention is explicitly specified or implied by one of the [`Extern Blocks`](Extern-End-Extern). `cdecl` is typically the default calling convention for C compilers, and it's used almost exclusively on Unix-like systems.

 If a procedure definition has a declaration (with calling convention explicit or by default) and the definition does not explicitly specify a calling convention, then the calling convention is implied by the declaration.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`pascal`](Pascal), [`stdcall`](Stdcall)
- [`Declare`](Declare)
- [`Sub`](Sub), [`Function`](procedures-Function)

## Examples

```freebasic
' declaring 'strcpy' from the standard C library

Declare Function strcpy cdecl Alias "strcpy" (ByVal dest As ZString Ptr, ByVal src As ZString Ptr) As ZString Ptr
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
