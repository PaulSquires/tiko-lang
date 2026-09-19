[Home](Home) › [Tutorials](Category-Tutorials) › **Variables**

# Variables

Symbols representing data in memory.

Description

Variables are name symbols which can be manipulated. They are declared and referenced using names composed of letters, numbers, and character "\_". These reference names cannot contain most other symbols because such symbols are part of the FreeBASIC programming language. They also cannot contain spaces. See *[Indentifier Rules](Identifier-Rules)*.

 In FreeBASIC, variables can be defined using the [`Dim`](Dim) statement.

 Variables are available for later access depending on where and how the [`Dim`](Dim) declaration for that variable is given. Depending on the [scope](Variable-Scope) of a variable, a defined variable can be available within the main area of a program, within a procedure, through an entire module, or through out an entire program. See *[Variable Scope](Variable-Scope)*.

 Variables are also made available when they are passed as parameters to a procedure such as [`Function`](procedures-Function) or [`Sub`](Sub).

 After a variable is declared with the [`Dim`](Dim) statement, they can be assigned, passed to procedures, and used in expressions wherever their [Standard Data Type](Standard-Data-Types) is similar. Sometimes variables are automatically converted to other data types before being used in expressions, or passed as parameters to procedures. See *[Coercion and Conversion](Coercion-and-Conversion)*.

Example

```freebasic
' compile with -lang qb or fblite

'$lang: "qb"

Declare Sub PrintConstants()

Dim FirstNumber As Integer

Dim Shared SecondNumber As Integer

FirstNumber = 1

SecondNumber = 2

PrintConstants ()

Print FirstNumber, SecondNumber, ThirdNumber 'This will print 1 2 0

Sub PrintConstants ()

    Dim ThirdNumber As Integer

    ThirdNumber = 3

    Print FirstNumber, SecondNumber, ThirdNumber 'This will print 0 2 3

End Sub
```

See also

- [Coercion and Conversion](Coercion-and-Conversion)
- [`Dim`](Dim)
- [Identifier Rules](Identifier-Rules)
- [Variable Scope](Variable-Scope)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
