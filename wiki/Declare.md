[Home](Home) › [Procedures](Category-Procedures) › **Declare**

# Declare

Declares a module-level or member procedure

## Syntax

```freebasic
Declare Sub name [ param_list ]
Declare Function name [ param_list ] [ ByRef ] As return_type
Declare Operator op_symbol param_list [ [ ByRef ] As return_type ]
Type T
Declare Constructor [ param_list ]
Declare Destructor
Declare Sub name [ param_list ]
Declare Function name [ param_list ] [ ByRef ] As return_type
```

## Parameters

- `param_list`
- `return_type`
- `name`
- `op_symbol`
- `T`

## Description

The `Declare` statement declares a [`Sub`](Sub), [`Function`](procedures-Function), [`Operator`](Operator), [`Constructor`](Constructor), or [`Destructor`](Destructor).  
 The procedure can be referred to in code without seeing its definition, although it must be defined somewhere. Essentially, the `Declare` statement introduces a procedure, and states that its definition is elsewhere. For example, a function can be declared at the top of a source module, called, then defined at the bottom of the source file, as shown below the example.

 A procedure's declaration is almost identical to the first line of its definition, except the declaration is preceded by the `Declare` keyword and has no body. Also, attributes such as [Export](Export) are left off the declaration.

 FreeBASIC, as QB, does not require the declaration of the functions unless they are defined in a different source file or in the same file past the point where they are called. This is no longer true for procedures declared inside a [Type](Type-Udt) body, which must **always** be declared first in the [Type](Type-Udt)'s body before use. If you do not declare [Type](Type-Udt) procedures you will receive an error.

 As every file using a function must have its declaration, declarations are usually kept in one or more *include files* to allow usage of the function by any module that needs it using the [`#include`](procedures-Include) statement.

## Remarks

### Dialect Differences

- In the *[-lang fb](Compiler-Option-Lang)* dialect, `ByVal` is the default parameter passing convention.
  In the *[-lang qb](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects, `ByRef` is the default parameter passing convention.  
  Type-level [`Sub`](Sub)/[`Function`](procedures-Function)/[`Operator`](Operator)/[`Constructor`](Constructor)/[`Destructor`](Destructor)'s are only allowed in *[-lang fb](Compiler-Option-Lang)*

### Differences from QB

- In FreeBASIC, the parameter names are optional.

### See also

- [`Sub`](Sub)
- [`Function`](procedures-Function)
- [`Operator`](Operator)
- [`Property`](Property)
- [`Constructor`](Constructor)
- [`Destructor`](Destructor)
- [`Constructor (Module)`](Constructor-Module)
- [`Destructor (Module)`](Destructor-Module)
- [`Type`](Type-Udt)
- [`Dim`](Dim)
- [`Alias (Name)`](Alias-Name)
- [`Alias (Modifier)`](Alias-Modifier)

## Examples

Module-level Function:

```freebasic
'' declare the function sum which takes two integers and returns an integer

Declare Function sum( As Integer, As Integer ) As Integer

   Print "the sum of 420 and 69 is: " & sum( 420, 69 )    '' call the function sum

'' define the function sum which takes two integers and returns an integer

Function sum( a As Integer, b As Integer ) As Integer

   Return a + b

End Function
```

 Type-level Sub:

```freebasic
Type my_type

    my_data As Integer

    Declare Sub increment_data( )

End Type

Sub my_type.increment_data( )

    my_data += 1

End Sub

Dim As my_type an_instance

an_instance.my_data = 68

an_instance.increment_data( )

Print an_instance.my_data
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
