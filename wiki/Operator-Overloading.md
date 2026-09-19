[Home](Home) › [Tutorials](Category-Tutorials) › **Operator Overloading**

# Operator Overloading

Changing the way user defined types work with built-in operators.

 Overview  
 Global Operators  
 Member Operators  
 Special Cases of Operators: '.' (Member access), '@' (Address of), '->' (Pointer to member access), and '\*' (Value of)

Overview

Simply, operators are procedures, and their arguments are called *operands*. Operators that take one operand ([`Operator Not`](Operator-Not-Complement)) are called *unary operators*, operators that take two operands ([`Operator +`](Operator-Addition)) are called *binary operators* and operators taking three operands ([`Operator Iif`](Iif)) are called *ternary operators*.

 Most operators are not called like procedures. Instead, their operator symbol is placed next to their operands. For unary operators, their sole operand is placed to the right of the symbol. For binary operators, their operands - referred to as the left and right-hand side operands - are placed to the left and right of the operator symbol. FreeBASIC has one ternary operator, [`Operator Iif`](Iif), and it is called like a procedure, with its operands comma-separated surrounded by parenthesis.  
 For example, the following code calls [`Operator Iif`](Iif) to determine if a pointer is valid. If it is, [`Operator * (Value Of)`](Operator-Value-of) is called to dereference the pointer, and if not, [`Operator / (Divide)`](Operator-Divide) is called to find the value of twenty divided by four:

```freebasic
Dim i As Integer = 420

Dim p As Integer Ptr = @i

Dim result As Integer = IIf( p, *p, CInt( 20 / 4 ) )
```

 Notice the call to [`Operator Iif`](Iif) is similar to a procedure call, while the calls to [`Operator * (Value Of)`](Operator-Value-of) and [`Operator / (Divide)`](Operator-Divide) are not. In the example, `p` is the operand to [`Operator * (Value Of)`](Operator-Value-of), and `20` and `4` are the left and right-hand side operands of [`Operator / (Divide)`](Operator-Divide), respectively.

All operators in FreeBASIC are predefined to take operands of standard data types, like [`Integer`](Integer) and [`Single`](Single), but they may also be overloaded for user-defined types; that is, they can be defined to accept operands that are objects as well. There are two types of operators that can be overloaded, *global operators* and *member operators*.

Global Operators

Global operators are those that are declared in module-level scope (globally). These are the operators [`- (Negate)`](Operator-Negate), [`Not (Bitwise Not)`](Operator-Not-Complement), [`-> (Pointer To Member Access)`](Operator-Pointer-to-Member-Access), [`* (Value Of)`](Operator-Value-of), [`+ (Add)`](Operator-Addition), [`- (Subtract)`](Operator-Subtract), [`* (Multiply)`](Operator-Multiply), [`/ (Divide)`](Operator-Divide), [`\ (Integer Divide)`](Operator-Integer-Divide), [`& (Concatenate)`](Operator-String-Concatenation-with-Conversion), [`Mod (Modulus)`](Operator-Mod-Modulus), [`Shl (Shift Left)`](Operator-Shl-Shift-Left), [`Shr (Shift Right)`](Operator-Shr-Shift-Right), [`And (Bitwise And)`](Operator-and-Conjunction), [`Or (Bitwise Or)`](Operator-or-Inclusive-Disjunction), [`Xor (Bitwise Xor)`](Operator-Xor-Exclusive-Disjunction), [`Imp (Bitwise Imp)`](Operator-Imp-Implication), [`Eqv (Bitwise Eqv)`](Operator-Eqv-Equivalence), [`^ (Exponentiate)`](Operator-Exponentiate), [`= (Equal)`](Operator-Equal), [`<> (Not Equal)`](Operator-Not-Equal), [`< (Less Than)`](Operator-Less-Than), [`> (Greater Than)`](Operator-Greater-Than), [`<= (Less Than Or Equal)`](Operator-Less-Than-or-Equal), [`>= (Greater Than Or Equal)`](Operator-Greater-Than-or-Equal), [`Abs`](Abs), [`Sgn`](Sgn), [`Fix`](Fix), [`Frac`](Frac), [`Int`](Int), [`Exp`](Exp), [`Log`](Log), [`Sin`](Sin), [`Asin`](Asin), [`Cos`](Cos), [`Acos`](Acos), [`Tan`](Tan), [`Atan`](Atn), [`Len`](Len), and [`Sqr`](Sqr).

 Declaring a custom global operator is similar to declaring a procedure. The [`Declare`](Declare) keyword is used with the [`Operator`](Operator) keyword. The operator symbol is placed next followed by the comma-separated list of parameters surrounded in parenthesis that will represent the operands passed to the operator. Unlike procedures, operators can be overloaded by default, so the [`Overload`](Overload) keyword is not necessary when declaring custom operators. At least one of the operator's parameters must be of user-defined type (after all, operators with built-in type parameters are already defined).

 The following example declares the global operators [`- (Negate)`](Operator-Negate) and [`+ (Multiply)`](Operator-Multiply) to accept operands of a user-defined type:

```freebasic
Type Rational

    As Integer numerator, denominator

End Type

Operator - (ByRef rhs As Rational) As Rational

    Return Type(-rhs.numerator, rhs.denominator)

End Operator

Operator * (ByRef lhs As Rational, ByRef rhs As Rational) As Rational

    Return Type(lhs.numerator * rhs.numerator, _

        lhs.denominator * rhs.denominator)

End Operator

Dim As Rational r1 = (2, 3), r2 = (3, 4)

Dim As Rational r3 = -(r1 * r2)

Print r3.numerator & "/" & r3.denominator
```

 Here the global operators are defined for type `Rational`, and are used in the initialization expression for `r3`. The output is `-6/12`.

Member Operators

Member operators are declared inside a [`Type`](Type-Udt) or [`Class`](Class) definition, like member procedures, and they are the cast and assignment operators [`Operator Cast (Cast)`](Operator-Cast), [`Operator @ (Address Of)`](Operator-Address-of), [`Operator [] (Pointer Index)`](Operator-Pointer-Index), [`Operator New Overload`](Operator-New-Overload), [`Operator Delete Overload`](Operator-Delete-Overload), [`Operator For (Iteration)`](Operator-for-Iteration), [`Operator Step (Iteration)`](Operator-Step-Iteration), [`Operator Next (Iteration)`](Operator-Next-Iteration), [`Let (Assign)`](Operator-Assign), [`+= (Add And Assign)`](Operator-Add-and-Assign), [`-= (Subtract And Assign)`](Operator-Subtract-and-Assign), [`*= (Multiply And Assign)`](Operator-Multiply-and-Assign), [`/= (Divide And Assign)`](Operator-Divide-and-Assign), [`\= (Integer Divide And Assign)`](Operator-Integer-Divide-and-Assign), [`^= (Exponentiate And Assign)`](Operator-Exponentiate-and-Assign), [`&= (Concat And Assign)`](Operator-Concatenate-and-Assign), [`Mod= (Modulus And Assign)`](Operator-Mod-Modulus-and-Assign), [`Shl= (Shift Left And Assign)`](Operator-Shl-Shift-Left-and-Assign), [`Shr= (Shift Right And Assign)`](Operator-Shr-Shift-Right-and-Assign), [`And= (Conjunction And Assign)`](Operator-and-Conjunction-and-Assign), [`Or= (Inclusive Disjunction And Assign)`](Operator-or-Inclusive-Disjunction-and-Assign), [`Xor= (Exclusive Disjunction And Assign)`](Operator-Xor-Exclusive-Disjunction-and-Assign), [`Imp= (Implication And Assign)`](Operator-Imp-Implication-and-Assign) and [`Eqv= (Equivalence And Assign)`](Operator-Eqv-Equivalence-and-Assign).

 When declaring member operators, the [`Declare`](Declare) and [`Operator`](Operator) keywords are used followed by the operator symbol and its parameter list. Like member procedures, member operators are defined outside the [`Type`](Type-Udt) or [`Class`](Class) definition, and the symbol name is prefixed with the name of the [`Type`](Type-Udt) or [`Class`](Class) name.

 The following example overloads the member operators [`Operator Cast (Cast)`](Operator-Cast) and [`*= (Multiply And Assign)`](Operator-Multiply-and-Assign) for objects of a user-defined type:

```freebasic
Type Rational

    As Integer numerator, denominator

    Declare Operator Cast () As Double

    Declare Operator Cast () As String

    Declare Operator *= (ByRef rhs As Rational)

End Type

Operator Rational.cast () As Double

    Return numerator / denominator

End Operator

Operator Rational.cast () As String

    Return numerator & "/" & denominator

End Operator

Operator Rational.*= (ByRef rhs As Rational)

    numerator *= rhs.numerator

    denominator *= rhs.denominator

End Operator

Dim As Rational r1 = (2, 3), r2 = (3, 4)

r1 *= r2

Dim As Double d = r1

Print r1, d
```

 Notice that the member operator [`Cast (Cast)`](Cast) is declared twice, once for the conversion to [`Double`](Double) and once for the conversion to [`String`](String). This is the only operator (or procedure) that can be declared multiple times when only the return type differs. The compiler decides which cast overload to call based on how the object is used (in the initialization of the [`Double`](Double) `d`, `Rational.Cast as double` is called, and in the [`Print`](Print) statement, `Rational.Cast as string` is used instead).

Special Cases of Operators: '.' (Member access), '@' (Address of), '->' (Pointer to member access), and '\*' (Value of)

**-** Overloading `Operator . (Member access)`

The `operator '.' (member access)` cannot be overloaded.

**-** Overloading `Operator @ (Address of)`

The `operator @ (Adress of)` is used to access the address of a variable.  
 There is no many interest to overload this operator for an object, and moreover if we did, we could no longer access its address.

**-** Overloading `Operator -> (Pointer to member access)` and `Operator * (Value of)`

The `operator -> (Pointer to member access)` is used to access any member of an object (instance) via a pointer to this instance.  
 The `operator * (Value of)` is used to access to variable via a pointer to this variable.  
 Under normal circumstances, the operand of these operators must be a pointer:

```freebasic
Declare Operator -> ( ByRef lhs As T Ptr ) ByRef As U

Declare Operator * ( ByRef rhs As T Ptr ) ByRef As T
```

Overloading of these operators allows you to create a pointer wrapper class and let it behave like the pointer itself:

```freebasic
Declare Operator -> ( ByRef lhs As wrapperClass ) ByRef As U

Declare Operator * ( ByRef rhs As wrapperClass ) ByRef As U
```

The wrapper can be then used (to access a member) like:

`wrapper->member`  
 instead of:  
 `wrapper.realPointer->member`  
 and:  
 `(*wrapper).member`  
 instead of:  
 `(*wrapper.realPointer).member`

Clarifying the particular case of overloading the `operator -> (pointer to member access)`:

The `operator -> (pointer to member access)` exhibits a different behavior from the other operators with respect to overloading:

- It doesn't return only the user datatype as indicated in the overloaded procedure header,
 - but it returns this user datatype implicitly followed by the `operator . (member access)`.

The `operator -> (pointer to member access)` is mainly used often in conjunction with the `operator * (Value of)` to implement "smart pointers".

**-** Using smart pointer

The use of smart pointers allows automatic management of dynamic references created by `New` (each reference is destroyed automatically when its smart pointer goes out of scope), without even making any copy of these references.

 Reminder of what a smart pointer:

- A smart pointer is an object which behaves like a pointer but does more than a pointer.
 - This object is flexible as a pointer and has the advantage of being an object (like constructor and destructor called automatically).
 - Therefore, the destructor of the smart pointer will be automatically called when this object goes out of scope, and it will delete the user pointer.

As the smart pointer must behave like a pointer, it must support the same interface as a pointer does.  
 So it must support the following operations:

- Dereferencing (`operator * (Value of)`)
 - Indirection (`operator -> (pointer to member access)`)

The `operator * (Value of)` and the `operator -> (pointer to member access)` must return references (by means of using `Byref As .....` in the declaration of there return type).

 Example of a smart pointer (to UDT) with an interface:

- public default-constructor
 - public copy-constructor
 - public destructor
 - private UDT pointer and public `operator cast (Cast)` to access it in read only mode
 - private operator `let` to disallow assignment not implemented here (to avoid copying the pointers values only)
 - `operator * (Value of)` and `operator -> (pointer to member access)`

```freebasic
Type UDT

    Declare Constructor ()

    Declare Destructor ()

    Dim As String s = "object #0"

End Type

Constructor UDT ()

    Print "  UDT construction "; @This

End Constructor

Destructor UDT ()

    Print "  UDT destruction "; @This

End Destructor

Type SmartPointer

    Public:

        Declare Constructor ()                            '' to construct smart pointer (and UDT object)

        Declare Constructor (ByRef rhs As SmartPointer)   '' to copy construct smart pointer

        Declare Operator Cast () As UDT Ptr               '' to cast private UDT pointer (for read only)

        Declare Destructor ()                             '' to destroy smart pointer (and UDT object)

    Private:

        Dim As UDT Ptr p                                  '' private UDT pointer

        Declare Operator Let (ByRef rhs As SmartPointer)  '' to disallow assignment (to avoid copy of real pointers)

End Type

Constructor SmartPointer ()

    Print "SmartPointer construction "; @This

    This.p = New UDT

End Constructor

Constructor SmartPointer (ByRef rhs As SmartPointer)

    Print "SmartPointer copy-construction "; @This; " from "; @rhs

    This.p = New UDT

    *This.p = *rhs.p

End Constructor

Operator SmartPointer.Cast () As UDT Ptr

    Return This.p

End Operator

Destructor SmartPointer ()

    Print "SmartPointer destruction "; @This

    Delete This.p

End Destructor

Operator * (ByRef sp As SmartPointer) ByRef As UDT   '' overloaded operator '*'

    Print "SmartPointer operator '*'"

    Return *Cast(UDT Ptr, sp)                        ''    (returning byref)

End Operator                                         ''    to behave as pointer

Operator -> (ByRef sp As SmartPointer) ByRef As UDT  '' overloaded operator '->'

    Print "SmartPointer operator '->'"

    Return *Cast(UDT Ptr, sp)                        ''    (returning byref)

End Operator                                         ''    to behave as pointer

Scope

    Dim sp1 As SmartPointer

    Print "'" & sp1->s & "'"

    sp1->s = "object #1"

    Print "'" & sp1->s & "'"

    Print

    Dim sp2 As SmartPointer = sp1

    Print "'" & (*sp2).s & "'"

    (*sp2).s = "object #2"

    Print "'" & (*sp2).s & "'"

    Print

    Dim sp3 As SmartPointer = sp1

    Print "'" & sp3->s & "'"

    *sp3 = *sp2

    Print "'" & sp3->s & "'"

    sp3->s = "object #3"

    Print "'" & sp3->s & "'"

    Print

End Scope

Sleep
```

 Example of output:

```freebasic
SmartPointer construction 1703576
  UDT construction 10693312
SmartPointer operator '->'
'object #0'
SmartPointer operator '->'
SmartPointer operator '->'
'object #1'

SmartPointer copy-construction 1703524 from 1703576
  UDT construction 10693384
SmartPointer operator '*'
'object #1'
SmartPointer operator '*'
SmartPointer operator '*'
'object #2'

SmartPointer copy-construction 1703472 from 1703576
  UDT construction 10693456
SmartPointer operator '->'
'object #1'
SmartPointer operator '*'
SmartPointer operator '*'
SmartPointer operator '->'
'object #2'
SmartPointer operator '->'
SmartPointer operator '->'
'object #3'

SmartPointer destruction 1703472
  UDT destruction 10693456
SmartPointer destruction 1703524
  UDT destruction 10693384
SmartPointer destruction 1703576
  UDT destruction 10693312

```

Example of an extended smart pointer type macro for any UDT (or any predefined type), with an extended interface:

- public constructor
 - public reference counter in read only mode
 - public destructor
 - private UDT pointer and 2 public operators `cast` to access it in read only mode (numeric value and string value)
 - private default-constructor to disallow self construction
 - private copy-constructor to disallow cloning
 - private operator `let` to disallow assignment
 - `operator * (Value of)` and `operator -> (pointer to member access)`

```freebasic
#macro Define_SmartPointer (_UDTname_)

    Type SmartPointer_##_UDTname_

        Public:

            Declare Constructor (ByVal rhs As _UDTname_ Ptr)              '' to construct smart pointer

            '                                                                '' from _UDTname_ pointer,

            '                                                                '' with reference counter increment

            Declare Static Function returnCount () As Integer             '' to return reference counter value

            Declare Operator Cast () As _UDTname_ Ptr                     '' to cast private _UDTname_ pointer

            '                                                                '' to _UDTname_ pointer (read only)

            Declare Operator Cast () As String                            '' to cast private _UDTname_ pointer

            '                                                                '' to string (read only)

            Declare Destructor ()                                         '' to destroy smart pointer

            '                                                                '' and _UDTname_ object

            '                                                                '' with reference counter decrement

        Private:

            Dim As _UDTname_ Ptr p                                        '' private _UDTname_ pointer

            Static As Integer Count                                       '' private reference counter

            Declare Constructor ()                                        '' to disallow default-construction

            Declare Constructor (ByRef rhs As SmartPointer_##_UDTname_)   '' to disallow copy-construction

            Declare Operator Let (ByRef rhs As SmartPointer_##_UDTname_)  '' to disallow copy-assignment

    End Type

    Dim As Integer SmartPointer_##_UDTname_.Count = 0

    Constructor SmartPointer_##_UDTname_ (ByVal rhs As _UDTname_ Ptr)

        If rhs <> 0 Then

            This.p = rhs

            SmartPointer_##_UDTname_.count += 1

        End If

    End Constructor

    Static Function SmartPointer_##_UDTname_.returnCount () As Integer

        Return SmartPointer_##_UDTname_.count

    End Function

    Operator SmartPointer_##_UDTname_.Cast () As _UDTname_ Ptr

        Return This.p

    End Operator

    Operator SmartPointer_##_UDTname_.Cast () As String

        Return Str(This.p)

    End Operator

    Destructor SmartPointer_##_UDTname_ ()

        If This.p <> 0 Then

            Delete This.p

            SmartPointer_##_UDTname_.count -= 1

            This.p = 0

        End If

    End Destructor

    Operator * (ByRef sp As SmartPointer_##_UDTname_) ByRef As _UDTname_  '' operator '*' (return byref)

        '                                                                    '' to behave as pointer

        Return ByVal sp                                                   '' 'Return *sp' would induce an infinite loop

    End Operator

    Operator -> (ByRef sp As SmartPointer_##_UDTname_) ByRef As _UDTname_  '' operator '->' (return byref)

        '                                                                     '' to behave as pointer

        Return ByVal sp

    End Operator

#endmacro

'--------------------------------------------------------------------------------------------------------

' Example using all eight keywords of inheritance:

'   'Extends', 'Base.', 'Base()', 'Object', 'Is' operator, 'Virtual', 'Abstract', 'Override'

Type root Extends Object ' 'Extends' to activate RTTI by inheritance of predefined Object type

    Public:

        Declare Function ObjectHierarchy () As String

        Declare Function ObjectName () As String

        Declare Abstract Function ObjectRealType () As String  '' 'Abstract' declares function without local body

        '                                                         '' which must be overridden

        Declare Virtual Destructor ()                          '' 'Virtual' declares destructor

    Protected:

        Declare Constructor ()                                 '' to avoid default-construction from outside Types

        Declare Constructor (ByRef _name As String = "")       '' to avoid construction from outside Types

        Declare Constructor (ByRef rhs As root)                '' to avoid copy-construction from outside Types

        Declare Operator Let (ByRef rhs As root)               '' to avoid copy-assignment from outside Types

    Private:

        Dim Name As String

End Type                                                   '' derived type may be member data empty

Constructor root ()  '' only to avoid compile error (due to inheritance)

End Constructor

Constructor root (ByRef _name As String = "")              '' only to avoid compile error (due to inheritance)

    This.name = _name

    Print "root constructor:", This.name

End Constructor

Function root.ObjectHierarchy () As String

    Return "Object(forRTTI) <- root"

End Function

Function root.ObjectName () As String

    Return This.name

End Function

Virtual Destructor root ()

    Print "root destructor:", This.name

End Destructor

Operator root.Let (ByRef rhs As root)                      '' only to avoid compile error (due to onheritance)

End Operator

Type animal Extends root                                           '' 'Extends' to inherit of root

    Declare Constructor (ByRef _name As String = "")

    Declare Function ObjectHierarchy () As String

    Declare Virtual Function ObjectRealType () As String Override  '' 'Virtual' declares function with local

    '                                                              ''    body which can be overridden

    '                                                              '' 'Override' to check if the function is

    '                                                              ''    well an override

    Declare Virtual Destructor () Override                         '' 'Virtual' declares destructor with local body

    '                                                              '' 'Override' to check if the destructor is well an override

End Type

Constructor animal (ByRef _name As String = "")

    Base(_name)                                                    '' 'Base()' allows to call parent constructor

    Print "  animal constructor:", This.ObjectName()

End Constructor

Function animal.ObjectHierarchy () As String

    Return Base.ObjectHierarchy & " <- animal"                     '' 'Base.' allows to access to parent member function

End Function

Virtual Function animal.ObjectRealType () As String

    Return "animal"

End Function

Virtual Destructor animal ()

    Print "  animal destructor:", This.ObjectName()

End Destructor

Type dog Extends animal                                    '' 'Extends' to inherit of animal

    Declare Constructor (ByRef _name As String = "")

    Declare Function ObjectHierarchy () As String

    Declare Function ObjectRealType () As String Override  '' 'Override' to check if the function is well an

    '                                                      ''    override

    Declare Destructor () Override                         '' 'Override' to check if the destructor is well an override

End Type                                                   '' derived type may be member data empty

Constructor dog (ByRef _name As String = "")

    Base(_name)                                            '' 'Base()' allows to call parent constructor

    Print "    dog constructor:", This.ObjectName()

End Constructor

Function dog.ObjectHierarchy () As String

    Return Base.ObjectHierarchy & " <- dog"                '' 'Base.' allows to access to parent member function

End Function

Function dog.ObjectRealType () As String

    Return "dog"

End Function

Destructor dog ()

    Print "    dog destructor:", This.ObjectName()

End Destructor

Type cat Extends animal                                  '' 'Extends' to inherit of animal

    Declare Constructor (ByRef _name As String = "")

    Declare Function ObjectHierarchy () As String

    Declare Function ObjectRealType () As String Override  '' 'Override' to check if the function is well an

    '                                                      ''    override

    Declare Destructor () Override                         '' 'Override' to check if the destructor is well an override

End Type                                                   '' derived type may be member data empty

Constructor cat (ByRef _name As String = "")

    Base(_name)                                            '' 'Base()' allows to call parent constructor

    Print "    cat constructor:", This.ObjectName()

End Constructor

Function cat.ObjectHierarchy () As String

    Return Base.ObjectHierarchy & " <- cat"                '' 'Base.' allows to access to parent member function

End Function

Function cat.ObjectRealType () As String

    Return "cat"

End Function

Destructor cat ()

    Print "    cat destructor:", This.ObjectName()

End Destructor

Sub PrintInfo (ByVal p As root Ptr)                                       '' parameter is a 'root Ptr' or compatible (smart pointer)

    Print "  " & p->ObjectName, "  " & p->ObjectRealType, "           ";

    If *p Is dog Then                                                     '' 'Is' allows to check compatibility with type symbol

        Print  Cast(dog Ptr, p)->ObjectHierarchy

    ElseIf *p Is cat Then                                                 '' 'Is' allows to check compatibility with type symbol

        Print Cast(cat Ptr, p)->ObjectHierarchy

    ElseIf *p Is animal Then                                              '' 'Is' allows to check compatibility with type symbol

        Print Cast(animal Ptr, p)->ObjectHierarchy

    End If

End Sub

Define_SmartPointer(root)  '' smart pointer definition

Scope

    Print "reference counter value:"; SmartPointer_root.returnCount()

    Print

    Dim As SmartPointer_root sp(2) = {New animal("Mouse"), New dog("Buddy"), New cat("Tiger")}

    Print

    Print "reference counter value:"; SmartPointer_root.returnCount()

    For I As Integer = 0 To 2

        Print "  " & sp(I), sp(I)->ObjectName()

    Next I

    Print

    Print "Name:", "Object (real):         Hierarchy:"

    For I As Integer = 0 To 2

        #if __FB_VERSION__ = "1.10.0" Or __FB_VERSION__ = "1.10.1"

            PrintInfo(Cast(root Ptr, sp(I)))  '' bug workaround

        #else

            PrintInfo(sp(I))

        #endif

    Next I

    Print

End Scope

Print

Print "reference counter value:"; SmartPointer_root.returnCount()

Print

Sleep
```

 Example of output:

```freebasic
reference counter value: 0

root constructor:           Mouse
  animal constructor:       Mouse
root constructor:           Buddy
  animal constructor:       Buddy
	dog constructor:        Buddy
root constructor:           Tiger
  animal constructor:       Tiger
	cat constructor:        Tiger

reference counter value: 3
  11145960    Mouse
  11151496    Buddy
  11151616    Tiger

Name:         Object (real):         Hierarchy:
  Mouse         animal                 Object(forRTTI) <- root <- animal
  Buddy         dog                    Object(forRTTI) <- root <- animal <- dog
  Tiger         cat                    Object(forRTTI) <- root <- animal <- cat

	cat destructor:         Tiger
  animal destructor:        Tiger
root destructor:            Tiger
	dog destructor:         Buddy
  animal destructor:        Buddy
root destructor:            Buddy
  animal destructor:        Mouse
root destructor:            Mouse

reference counter value: 0

```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
