[Home](Home) › [Tutorials](Category-Tutorials) › **Variable Scope**

# Variable Scope

Visibility and access rules for variables and objects

 A variable's scope refers to its visibility in a program. A variable is not visible (cannot be accessed) outside the scope in which it was declared. Where and how a variable is declared determines its scope.

 In FreeBASIC, there are 4 categories of scope: ***local***, ***shared***, ***common*** and ***common shared***. Each of these scopes has different visibility rules, which are detailed below.

Local Scope

Variables declared in the local scope are visible only in the most local instance of the IF, SELECT, WITH, FOR, WHILE, DO, SCOPE, procedure, or module block in which they are declared.

- [`Sub`](Sub), [`Function`](procedures-Function), the main body, and each compound statement implicitly define a new local scope block.
  Explicitly declared variables using [`Dim`](Dim) or [`ReDim`](Redim) or [`Static`](procedures-Static) take the scope of the local most block in which they are declared.  
  Implicit variables take the scope of the the local most [`Scope...End Scope`](Scope-End-Scope) block in which they are first used, otherwise take the scope of the [`Sub`](Sub), [`Function`](procedures-Function), or main body in which they are used.

In the local scope, there is no visibility between module-level code and procedure level code. Furthermore, variables dimensioned within a block decision or loop statement will only be visible within the block in which they are dimensioned. Variables declared in the local scope of a module are not visible in any of the procedures within that module. Similarly, local variables declared inside procedures are not visible in the module-level code, nor any other procedure within the module.

 Variables declared inside [`Scope`](Scope-End-Scope) blocks may only be declared of local scope, and are not visible outside the block. [`Scope`](Scope-End-Scope) blocks, however, inherit the surrounding scope, so local variables declared outside the [`Scope`](Scope-End-Scope) block will be visible inside (*see example program*).

 You can declare a variable to be of local scope explicitly by using the [`Dim`](Dim) statement, or implicitly (for only *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects) by simply introducing the variable (*see [Implicit Declarations](Implicit-Declarations)*). The example program `local.bas` demonstrates visibility rules for the local scope.

 `local.bas`

```freebasic
'' visible only in this module

Dim As Integer local_moduleLevel1

'' OK.

Print local_moduleLevel1

Scope

  '' OK; SCOPE Blocks inherit outer scope

  Print local_moduleLevel1

  '' visible only in this SCOPE Block

  Dim As Integer local_moduleLevel2

  '' OK.

  Print local_moduleLevel2

End Scope

'' Error; can't see inner-SCOPE vars

'' print local_moduleLevel2

Function some_function( ) As Integer

  '' visible only in this function

  Dim As Integer local_functionLevel

  '' OK.

  Print local_functionLevel

  '' Error; can't see local module-level vars

  '' print local_moduleLevel1

  '' Error; can't see local module-level vars

  '' print local_moduleLevel2

  Function = 0

End Function

'' print local_functionLevel                    '' Error; can't see function_level vars

End 0
```

Shared Scope

Variables declared in the shared scope of a module are visible to both the module and all procedures of that module.

 Unlike the local scope, the shared scope makes module-level variables visible to procedures of that module. In other words, the module *shares* its declarations with its procedures.

 Variables can only be declared to be of shared scope at the module-level. Ie., only modules can share variables. Neither procedures nor [`Scope`](Scope-End-Scope) blocks can declare variables in the shared scope, thus variables declared there can only be local to that procedure or block.

 You can declare a variable to be of shared scope by using the DIM (or REDIM or STATIC) statement with the [`Shared`](Shared) keyword. The example program `shared_scope.bas` demonstrates visibility rules for the shared scope.

 `shared.bas`

```freebasic
'' visible throughout this module

Dim Shared As Integer shared_moduleLevel1

'' OK.

Print shared_moduleLevel1

Scope

  '' OK; can see outer-scope vars

  Print shared_moduleLevel1

  '' Error; SCOPE-level vars cannot be shared

  '' dim shared as integer shared_ModuleLevel2

End Scope

End 0

Function some_function( ) As Integer

  '' OK; can see shared module-level vars

  Print shared_moduleLevel1

  '' Error; function-level vars cannot be shared

  '' dim shared as integer sharedFunctionLevel

  Function = 0

End Function
```

Common Scope

Variables declared in the common scope are visible to all modules.

 Variables declared with [`Common`](Common) are visible to other modules with a matching [`Common`](Common) variable declaration. The variable name declared must match from between modules.

 `module1.bas`

```freebasic
'' compile with:

''    fbc -lang qb module1.bas module2.bas

'$lang: "qb"

Declare Sub Print_Values()

Common m1 As Integer

Common m2 As Integer

                      ' This is executed after all other modules

m1 = 1

Print "Module1"

Print "m1 = "; m1     ' m1 = 1 as set in this module

Print "m2 = "; m2     ' m2 = 2 as set in module2

Print_Values
```

 `module2.bas`

```freebasic
Common m1 As Integer

Common m2 As Integer

m2 = 2

Print "Module2"       ' This is executed first

Print "m1 = "; m1     ' m1 = 0 (by default)

Print "m2 = "; m2     ' m2 = 2

Sub Print_Values()

  Print "Module2.Print_Values"

  Print "m1 = "; m1   ' Implicit variable = 0, because '-lang qb' use

  Print "m2 = "; m2   ' Implicit variable = 0, because '-lang qb' use

End Sub
```

 ***`Output:`***

```freebasic
  Module2
  m1 = 0
  m2 = 2
  Module1
  m1 = 1
  m2 = 2
  Module2.Print_Values
  m1 = 0
  m2 = 0
```

Common Shared Scope

Variables declared in the common shared scope are visible to all modules and all procedures of those modules.

 Variables declared with [`Common`](Common) are visible to other modules with a matching [`Common`](Common) variable declaration. The variable name declared must match from between modules. Within a module the [`Shared`](Shared) declaration modifier gives the variable module scope and makes the variable visible to all subs and functions.

 ***`module3.bas`***

```freebasic
'' compile with:

''    fbc module3.bas module4.bas

Declare Sub Print_Values()

Common m1 As Integer

Common m2 As Integer

'' This is executed after all other modules

m1 = 1

Print "Module3"

Print "m1 = "; m1     '' m1 = 1 as set in this module

Print "m2 = "; m2     '' m2 = 2 as set in module2

Print_Values
```

 `module4.bas`

```freebasic
Common Shared m1 As Integer

Common Shared m2 As Integer

m2 = 2

Print "Module4"       '' This is executed first

Print "m1 = "; m1     '' m1 = 0 (by default)

Print "m2 = "; m2     '' m2 = 2

Sub Print_Values()

  Print "Module4.Print_Values"

  Print "m1 = "; m1   '' m1 = 1

  Print "m2 = "; m2   '' m2 = 2

End Sub
```

 ***`Output:`***

```freebasic
  Module4
  m1 = 0
  m2 = 2
  Module3
  m1 = 1
  m2 = 2
  Module4.Print_Values
  m1 = 1
  m2 = 2
```

Example

See examples above.

See also

- [`Scope`](Scope-End-Scope)
- [`Dim`](Dim)
- [`Common`](Common)
- [`Shared`](Shared)
- [Variables](Variables)
- [Implicit Declarations](Implicit-Declarations)
- [Simple Variable Lifetime vs Scope](Simple-Variable-Lifetime-vs-Scope)
- [Dynamic Object and Data Lifetime](Dynamic-Object-and-Data-Lifetime)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
