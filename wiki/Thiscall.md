[Home](Home) › [Procedures](Category-Procedures) › **__Thiscall**

# __Thiscall

Specifies the Thiscall calling convention in a procedure declaration

## Syntax

```freebasic
declare Sub name __Thiscall [Overload] [Alias "alias"] ( parameters )
declare Function name __Thiscall [Overload] [Alias "alias"] ( parameters ) [ ByRef ] As return_type
Sub name [__Thiscall] [Overload] [Alias "alias"] ( parameters )
Function name [__Thiscall] [Overload] [Alias "alias"] ( parameters ) [ ByRef ] As return_type
```

## Description

`Thiscall` is a calling convention for x86 targets where the first integral argument is passed in the `ECX` register instead of on the stack. All other arguments are passed right to left and callee cleans up the stack (like Stdcall).

 On win32 x86, mingw+gcc will use `Thiscall` as the default calling convention for non-static member procedures in classes passing the hidden [This](This) parameter by `ECX` register instead of pushing to the stack.

 Default calling convention on win32 x86 inside an extern "c++" block for non-static member procedures is `Thiscall`.

 `Thiscall` can be explicitly specified for normal procedures and static member procedures to override the default calling convention.  
 Other calling conventions (Cdecl/Stdcall/etc) can be explicitly specified to override the default `Thiscall` calling convention on non-static member procedures.

 `Thiscall` can be specified at both the declaration and the definition.  
 If a procedure definition has a declaration (with calling convention explicit or by default) and the definition does not explicitly specify a calling convention, then the calling convention is implied by the declaration.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`cdecl`](Cdecl), [`stdcall`](Stdcall), [`Fastcall`](Fastcall)
- [`Declare`](Declare)
- [`Sub`](Sub), [`Function`](procedures-Function)

## Examples

**-** If inside extern "c++" and also on win32 / x86, and it's a non-static member procedure, and no other calling convention is given, the default is \_\_thiscall:

```freebasic
Extern "c++"

    Type T Extends Object

        Declare Constructor() '' __thiscall is default

    End Type

    Constructor T()  '' __thiscall is default

    End Constructor

End Extern
```

**-** If definition is outside the extern "c++" block, then \_\_thiscall is optional on the definition (if the default for the non-static member procedure was \_\_thiscall):

```freebasic
Extern "c++"

    Type T Extends Object

        Declare Constructor() '' __thiscall is default

    End Type

End Extern

Constructor T() '' __thiscall is implied by declaration

End Constructor
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
