[Home](Home) › [Procedures](Category-Procedures) › **pascal**

# pascal

Specifies a Pascal-style calling convention in a procedure declaration

## Syntax

```freebasic
Sub name pascal [Overload] [Alias "alias"] ( parameters )
Function name pascal [Overload] [Alias "alias"] ( parameters ) [ ByRef ] As return_type
```

## Description

In procedure declarations, `pascal` specifies that a procedure will use the `pascal` calling convention. In the *Pascal* calling convention, any parameters are to be passed (pushed onto the stack) in the same order in which they are listed, that is, from left to right. The procedures need not preserve the `EAX`, `ECX` or `EDX` registers, and must clean up the stack (pop any parameters) before it returns.

 `pascal` is not allowed to be used with variadic procedure declarations (those with the last parameter listed as "[`...`](Ellipsis)").

 `pascal` is the default calling convention for procedures in Microsoft QuickBASIC, and is the standard convention used in the Windows 3.1 API.

 If a procedure definition has a declaration (with calling convention explicit or by default) and the definition does not explicitly specify a calling convention, then the calling convention is implied by the declaration.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`cdecl`](Cdecl), [`stdcall`](Stdcall)
- [`Declare`](Declare)
- [`Sub`](Sub), [`Function`](procedures-Function)

## Examples

`Declare Function MyFunc pascal Alias "MyFunc" (MyParm As Integer) As Integer`

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
