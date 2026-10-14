[Home](Home) › [Modularizing](Category-Modularizing) › **Using (Namespaces)**

# Using (Namespaces)

Brings namespace symbols into the current scope

## Syntax

```freebasic
Using identifier [, identifier [, ...] ]
```

## Parameters

- `identifier`

## Description

The `Using` command allows all symbols from a given namespace to be accessed without the namespace's name prefix. Unlike C++ but like C#, the [`Namespace`](Namespace) keyword is not needed after `Using`, because individual symbols cannot be inherited from a namespace.

 `Using` is allowed in namespaces and procedures only (not in type or union or enum declarations).

 Inheriting a whole namespace can save typing, but sometimes some meaning of the code can be lost, and conflicts with other symbols could be created.

## Remarks

### Differences from QB

- QB had the `Using` keyword, but for other purposes. Namespaces did not exist in QB.

### See also

- [`Print Using`](Print-Using)
- [`? Using`](Print-Using)
- [`Palette Using`](Palette)
- [`Namespace`](Namespace)

## Examples

```freebasic
Namespace Sample

    Type T

        x As Integer

    End Type

End Namespace

'' Just using the name T would not find the symbol,

'' because it is inside a namespace.

Dim SomeVariable As Sample.T

'' Now the whole namespace has been inherited into

'' the global namespace.

Using Sample

'' This statement is valid now, since T exists

'' without the "Sample." prefix.

Dim OtherVariable As T
```

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
