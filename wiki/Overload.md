[Home](Home) › [Procedures](Category-Procedures) › **Overload**

# Overload

Specifies that a procedure name can be overloaded

## Syntax

```freebasic
Declare [Static] Sub procedure_name [cdecl|stdcall|pascal] Overload [Alias "external_name"] [([parameter_list])] [Constructor [priority]] [Static] [Export]
Declare [Static] Function procedure_name [cdecl|stdcall|pascal] Overload [Alias "external_name"] [([parameter_list])] [ ByRef ] As return_type [Static] [Export]
[Public|Private] Sub procedure_name [cdecl|stdcall|pascal] Overload [Alias "external_name"] [([parameter_list])] [Constructor [priority]] [Static] [Export]
..procedure body..
End Sub
[Public|Private] Function procedure_name [cdecl|stdcall|pascal] Overload [Alias "external_name"] [([parameter_list])] [ ByRef ] As return_type [Static] [Export]
..procedure body..
End Function
```

## Description

In procedure declarations, `Overload` allows procedure names to be overloaded, that is, other procedures (regardless of whether to be subs or functions) can then be declared with the same name if their parameter lists are unique. Two parameter lists are unique if they contain a different number of parameters, or have parameters of different types. Note that this means that two or more procedures cannot be declared with the same name if they differ in return type alone.  
 A variadic procedure name can never be overloaded.

 Once a procedure name has been declared overloaded, further declarations using the name need not specify `Overload`, but it is allowed.

 `Overload` is not necessary in member procedure declarations, as they are always implicitly overloaded.

 When calling an overloaded procedure name, a match score is calculated comparing the call argument types with the parameter types for each candidate procedure (major resolution on datatypes themselves, minor resolution on datatype sizes).  
 The highest matching score wins. If this highest score is too low, or if several overloaded procedures have the same highest score, the compiler then generates an error at compile time (no matching procedure, or ambiguous call).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Declare`](Declare)
- [`Sub`](Sub), [`Function`](procedures-Function)

## Examples

```freebasic
Declare Function SUM Overload (A As Integer,B As Integer) As Integer

Declare Function SUM Overload (A As Single,B As Single) As Single

Function SUM  (A As Integer,B As Integer) As Integer

   Function=A+B

End Function

Function SUM  (A As Single,B As Single) As Single

   Function=A+B

End Function

Dim As Integer A,B

Dim As Single A1,B1

A=2

B=3

A1=2.

b1=3.

Print SUM(A,B)

Print SUM (A1,B1)

Sleep
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
