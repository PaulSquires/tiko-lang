[Home](Home) › [Tutorials](Category-Tutorials) › **Constants**

# Constants

Constants are identifiers that represent literals or constant expressions that can not be changed after they are defined.

 For example, `Const PI = 3.1415926535897932` will always mean that the identifier `PI` refers to the number `3.1415926535897932`. The identifier `PI` can be used instead of repeating the full number in source.

 Global constants once defined, are available globally and the identifier can be used to refer to the constant anywhere in the source program.

 After an identifier is defined with the [`Const`](Const) statement, the symbol cannot be altered. If code tries to alter a constant, an error message will result upon code compilation.

 Built-in constants include the [`Boolean`](Boolean) data type values [`True`](True) and [`False`](False).

 A constant definition differs from a variable definition. Variables hold values that can be changed.

Example

```freebasic
Declare Sub PrintConstants ()

Const FirstNumber = 1

Const SecondNumber = 2

Const FirstString = "First string."

Const FirstBoolean = False

Const SecondBoolean = True

Print FirstNumber, SecondNumber 'This will print 1      2

Print FirstString 'This will print First string.

Print FirstBoolean, SecondBoolean 'This will print false      true

Print

PrintConstants ()

Sub PrintConstants ()

    Print FirstNumber, SecondNumber 'This will also print 1        2

    Print FirstString 'This will also print First string.

    Print FirstBoolean, SecondBoolean 'This will also print false      true

End Sub
```

See also

- [`Constant Expressions`](Constant-Expressions)
- [`Literals`](Literals)
- [`Const`](Const)
- [`Enum`](Enum)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
