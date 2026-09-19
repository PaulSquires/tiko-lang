[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Enum**

# Enum

Declares an enumerated type.

## Syntax

```freebasic
Enum [typename [ Explicit ] ]
symbolname [= expression] [, ...]
...
End Enum
```

## Parameters

- `typename`
- `symbolname`
- `expression`
- `typename.symbolname`

## Description

`Enum`, short for enumeration, declares a list of symbol names that correspond to discrete values. If no initial value is given, the first item will be set to `0`. Each subsequent symbol has a value one more than the previous unless `expression` is given.

 Symbols may be each on their own line, or separated on a single line by commas.

 An `Enum` is a useful way of grouping together a set of related [`Const`](Const)ants. A symbol can be accessed like a constant, e.g: `a = symbolname`. But if the name clashes with another symbol, it must be resolved using `typename.symbolname`. This resolution method is always required if you make the enum `Explicit`.

 A non-`Explicit` `Enum` declared inside an [`Extern ... End Extern`](Extern-End-Extern) block will add its constants to the parent namespace directly, as in C, instead of acting as a namespace on its own. It disallows the `typename.symbolname` style of access, and the constants may conflict with other symbols from the parent namespace.

 `Enum` can not contain any member procedure or member data (only symbols), but it can be included (named or unnamed) in a [`Type`](Type-Udt) by having.

 An `Enum` instance can be passed, as any user defined instance, to a procedure (including for the definition of [`Overload`](Overload)ed operators).  
 The size of an `Enum` instance will be always that of an [`Integer`](Integer) (no matter how many defined symbols are just declarations for the compiler assignment).

## Remarks

### Dialect Differences

- Explicit Enum not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Explicit`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Const`](Const)
- [`Operator`](Operator)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
Enum MyEnum

    option1 = 1

    option2

    option3

End Enum

Dim MyVar As MyEnum

MyVar = option1

Select Case MyVar

    Case option1

        Print "Option 1"

    Case option2

        Print "Option 2"

    Case option3

        Print "Option 3"

End Select
```

 You can reference formerly declared symbol names within the same enum:

```freebasic
Enum MyEnum

    option1 = 1

    option2

    option3

    __

    MAX_VALUE = __ -1

End Enum

Print "Option #1:", MyEnum.option1

Print "Option #2:", MyEnum.option2

Print "Option #3:", MyEnum.option3

Print "Max Value:", MyEnum.MAX_VALUE
```

 Output:

```freebasic
Option #1:     1
Option #2:     2
Option #3:     3
Max Value:     3
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
