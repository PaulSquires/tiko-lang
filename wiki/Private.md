[Home](Home) › [Modularizing](Category-Modularizing) › **Private**

# Private

Specifies a procedure having internal linkage

## Syntax

```freebasic
Private Sub procedure_name [cdecl|stdcall|pascal] [Overload] [Alias "external_name"] [([parameter_list])] [Constructor [priority]] [Static] [Export]
..procedure body..
End Sub
Private Function procedure_name [cdecl|stdcall|pascal] [Overload] [Alias "external_name"] [([parameter_list])] [ ByRef ] As return_type [Static] [Export]
..procedure body..
End Function
```

## Description

In procedure definitions (forbidden at declaration line level), `Private` specifies that a procedure has internal linkage, meaning its name is not visible to external modules.  
 Therefore among the compiled modules, two procedures with the same identifier, but defined inside different modules, may exist if both are `Private`.

 The compiler removes the `Private` procedures that are not called, but this does not currently work for `Private` procedures that are only called by other `Private` procedures that are not called themselves, because the first one appears as being called.

 The `Option Private` statement allows procedures to be defined with internal linkage by default.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Private:`](Private-Access-Control) (Access Control)
- [`Public`](Public)
- [`Sub`](Sub)
- [`Function`](procedures-Function)

## Examples

```freebasic
'e.g.

Private Sub i_am_private

End Sub

Sub i_am_public

End Sub
```

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
