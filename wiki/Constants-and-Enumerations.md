[Home](Home) › [Tutorials](Category-Tutorials) › **Constants and Enumerations**

# Constants and Enumerations

**Enumeration**, a special User-Defined Type composed of a number of named **constants**.

Syntax

```freebasic
Enum [typename [ Explicit ] ]

symbolname [= expression] [, ...]

...

End Enum
```

Parameters

`typename`

Name of the `Enum`

`symbolname`

Name of the constant

`expression`

A constant expression

`Explicit`

Requires that symbols must be explicitly referred to by `typename.symbolname`

Description

An enumeration is a User-Defined Type that consists of a set of named integer constants.  
 Enumerations are useful for defining sequences and states, particularly when there is a natural progression through those states.

 An enumeration provides context to describe a range of values which are represented as named constants through symbols.  
 Unlike namespaces, enumerations can be also defined in any scope blocks, and their symbols are only visible throughout the scope in which the enumeration is declared.

 Enumerations lend themselves to more maintainable code because they are symbolic, allowing you to work with integer values ​​while using an explicit name.  
 Enumerations are value Types, which means they contain their own value, can not inherit or be inherited from.

 `Enum` can not contain any member procedure or member data (only symbols), but it can be included (named or unnamed) in a `Type` by having.

Usage

Every symbol in an enumeration is implicitly assigned an integer value (positive or negative) that corresponds to its place in the order of the values in the enumeration.  
 Every symbol is treated as a constant.

 By default, the first value is assigned 0, the next one is assigned 1, and so on.  
 But you can explicitly set the value of any symbol (and the next symbol will be implicitly set to the previous value plus an increment of one).

 The values given to the symbols do not have to be unique.

 When an enumeration is qualified as `Explicit`, access to any `symbolname` must be always prefixed by `typename`.  
 Prefixing can also be used to solve ambiguity with other entities.

 An `Enum` instance can be passed, as any User-Defined Type instance, to a procedure (including for the definition of overloaded operators).  
 The size of an `Enum` instance will be always that of an `Integer` (no matter how many defined symbols are just declarations for the compiler assignment).

 An `Enum` instance (or `Enum` symbol) can be implicitly converted to an integer.
 **Note:**

**-** In many languages, no integer variable is implicitly convertible into a scoped enumeration type instance (and vice versa), the latter being strongly typed (declaration equivalent to the `Enum` qualified as `Explicit` with FreeBASIC), and an explicit cast is required for such a conversion.
 **-** But FreeBASIC accepts it (even if the numeric value does not match any `Enum` symbol defined). This is just one of FreeBASIC's many shortcomings over normal `Enum` functionality.
 **-** Therefore, there is not much interest in declaring a real `ENUM` instance (which is sized as an INTEGER), but otherwise any pre-built integer variable can be declared instead.
 **-** If the `Explicit` qualifier is not used (namespace prefix not imposed), there is not much point in using an `ENUM` structure compared to a simple discrete list of constants, except for the auto-increment of values.

Example

Simple example of use:

```freebasic
Enum Colors

    black

    blue

    green

    cyan

    red

    pink

    yellow

    grey

    dark_grey

    bright_blue

    bright_green

    bright_cyan

    bright_red

    bright_pink

    bright_yellow

    white

End Enum

Sub print_fbc (ByVal foreground As Colors, ByVal background As Colors)

    Color foreground, background

    Print " " & __FB_SIGNATURE__ & " "

End Sub

Dim As Colors std_foreground, std_background

std_foreground = LoWord(Color())

std_background = HiWord(Color())

Dim As Colors my_foreground, my_background

my_foreground = bright_yellow

my_background = cyan

print_fbc(my_foreground, my_background)

Color std_foreground, std_background

Print "end"

Sleep
```

Same result, but with a `Type` interfacing `Enum` to impose explicit casting when assigning numeric values to `Enum` instances (see 'Note' above):

```freebasic
Enum Colors Explicit

    black

    blue

    green

    cyan

    red

    pink

    yellow

    grey

    dark_grey

    bright_blue

    bright_green

    bright_cyan

    bright_red

    bright_pink

    bright_yellow

    white

End Enum

Type Console_Colors

    Public:

        Declare Property foreground () As Colors

        Declare Property foreground (ByVal c As Colors)

        Declare Property background () As Colors

        Declare Property background (ByVal c As Colors)

    Private:

        Dim As Colors _foreground

        Dim As Colors _background

End Type

Property Console_Colors.foreground () As Colors

    Return This._foreground

End Property

Property Console_Colors.foreground (ByVal c As Colors)

    This._foreground = c

End Property

Property Console_Colors.background () As Colors

    Return This._background

End Property

Property Console_Colors.background (ByVal c As Colors)

    This._background = c

End Property

Sub print_fbc (ByVal foreground As Colors, ByVal background As Colors)

    Color foreground, background

    Print " " & __FB_SIGNATURE__ & " "

End Sub

Dim As Console_Colors std_colors

std_colors.foreground = Cast(Colors, LoWord(Color()))  '' explicit cast mandatory because of property declaration

std_colors.background = Cast(Colors, HiWord(Color()))  '' explicit cast mandatory because of property declaration

Dim As Console_Colors my_colors

my_colors.foreground = Colors.bright_yellow

my_colors.background = Colors.cyan

print_fbc(my_colors.foreground, my_colors.background)

Color std_colors.foreground, std_colors.background

Print "end"

Sleep
```

See also

- [`Enum`](Enum)
- [`Type`](Type-Udt)
- [Constants](Constants)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
