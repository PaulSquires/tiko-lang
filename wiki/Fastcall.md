[Home](Home) › [Procedures](Category-Procedures) › **__Fastcall**

# __Fastcall

Specifies the Fastcall calling convention in a procedure declaration

## Syntax

```freebasic
declare Sub name __Fastcall [Overload] [Alias "alias"] ( parameters )
declare Function name __Fastcall [Overload] [Alias "alias"] ( parameters ) [ ByRef ] As return_type
Sub name [__Fastcall] [Overload] [Alias "alias"] ( parameters )
Function name [__Fastcall] [Overload] [Alias "alias"] ( parameters ) [ ByRef ] As return_type
```

## Description

`Fastcall` is a calling convention for x86 targets where the first and second integer arguments are passed in the in `ECX` and `EDX` registers respectively instead of on the stack. All other arguments are passed right to left and callee cleans up the stack (like Stdcall).

 `Fastcall` can be specified at both the declaration and the definition.  
 If a procedure definition has a declaration (with calling convention explicit or by default) and the definition does not explicitly specify a calling convention, then the calling convention is implied by the declaration.

 **Note:** Default calling convention on win32 x86 inside an extern "c++" block for non-static member procedures is [Thiscall](Thiscall).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`cdecl`](Cdecl), [`stdcall`](Stdcall), [`Thiscall`](Thiscall)
- [`Declare`](Declare)
- [`Sub`](Sub), [`Function`](procedures-Function)

## Examples

```freebasic
Extern "c++"

    Declare Function Example __Fastcall (param1 As Long, param2 As Byte, param3 As LongInt, param4 As String) As Integer

End Extern
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
