[Home](Home) › [Modularizing](Category-Modularizing) › **Public**

# Public

Specifies a procedure having external linkage.

## Syntax

```freebasic
Public Sub procedure_name [cdecl|stdcall|pascal] [Overload] [Alias "external_name"] [([parameter_list])] [Constructor [priority]] [Static] [Export]
..procedure body..
End Sub
Public Function procedure_name [cdecl|stdcall|pascal] [Overload] [Alias "external_name"] [([parameter_list])] [ ByRef ] As return_type [Static] [Export]
..procedure body..
End Function
```

## Description

In procedure definitions (forbidden at declaration line level), `Public` specifies that a procedure has external linkage, meaning its name is visible to external modules. If `Public` or [`Private`](Private) is not specified, a procedure is defined as if `Public` was specified.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Public:`](Public-Access-Control) (Access Control)
- [`Private`](Private)
- [`Option Private`](Option-Private)
- [`Sub`](Sub)
- [`Function`](procedures-Function)

## Examples

```freebasic
Private Sub i_am_private

End Sub

Public Sub i_am_public

End Sub
```

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
