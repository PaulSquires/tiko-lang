[Home](Home) › [Modularizing](Category-Modularizing) › **Extern**

# Extern

Declares a variable, array or object having external linkage

## Syntax

```freebasic
Extern [ Import ] symbolname[ (subscripts) ] [ Alias "aliasname" ] As DataType [, ...]
```

## Parameters

- `symbolname`
- `aliasname`

## Description

Declares `symbolname` as an external name, meaning it is global to external modules including those to be compiled as static and dynamic libraries (DLLs).  
 `Extern` only declares variables, arrays and objects, and does not define them (different from [`Common`](Common) or [`Dim`](Dim)). It also has the effect of making `symbolname` a *shared* name, meaning it is visible within procedures (see [`Shared`](Shared)). A `symbolname` declared as external name can be (re)defined (using Dim or Redim) only in a single external module.

 If [`Alias`](Alias-Name) is used, `aliasname` will be used as the external name rather than `symbolname`, and its case will be preserved.

 `Extern` was added in order to support the C libraries.

 If [`Import`](Import) is used, the name will be added to the dynamic library import list so its address can be fixed at run-time.

## Remarks

### Platform Differences

- Windows does not support `Extern` with a dynamic library (compiled with -dll or -dylib).

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Extern...End Extern`](Extern-End-Extern)
- [`Common`](Common)
- [`Dim`](Dim)
- [`Shared`](Shared)
- [`Alias (Name)`](Alias-Name)
- [`Alias (Modifier)`](Alias-Modifier)

## Examples

```freebasic
'' extern1.bas

Extern Foo Alias "foo" As Integer

Sub SetFoo

    foo = 1234

End Sub
```

```freebasic
'' extern2.bas

Declare Sub SetFoo

Extern Foo Alias "foo" As Integer

Dim foo As Integer = 0

SetFoo

Print Foo
```

 Output:

```freebasic
 1234
```

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
