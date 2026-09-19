[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Virtual**

# Virtual

Declare virtual methods

## Syntax

```freebasic
Type typename Extends base_typename
Declare Virtual Sub|Function|Property|Operator|Destructor ...
End Type
```

## Description

**Virtual** methods are methods that can be overridden by data types derived from the type they were declared in, allowing for dynamic polymorphism. In contrast to [`Abstract`](Abstract) methods, virtual methods must have an implementation, which is used when the virtual is not overridden.

 A derived type can override virtual methods declared in its base type by declaring a non-static method with the same identifier and signature, meaning same number and type of parameters (invariant parameters), same calling convention, and if any, same return type (or a covariant return type for return by reference or by pointer):

The property of being a virtual method is not implicitly inherited by the overriding method in the derived type. If this overriding method must be overridden in turn in a lower level derived type, it must also be declared as virtual.  
 On the other hand, since a derived static method can never override a base virtual/abstract method, it can therefore shadow any base method (including virtual/abstract) with same identifier and regardless of the signature.

 When calling virtual methods, the compiler may need to do a vtable lookup in order to find out which method must be called for a given object. This requires an extra hidden vtable pointer field to be added at the top of each type with virtual methods. This hidden vptr is provided by the built-in [`Object`](Object) type. Because of that, virtual methods can only be declared in a type that directly or indirectly [`Extends`](Extends) [`Object`](Object).

 Dynamic polymorphism by using override procedures:

[Constructors](Constructor) cannot be virtual because they create objects, while virtual methods require an already-existing object with a specific type. The type of the constructor to call is determined at compile-time from the code.  
 In addition, when calling a virtual method inside a constructor, only the version of the method corresponding to an object of type of this constructor is used. That is because the vptr has not yet been set up by the derived type constructor, but only by the local type constructor.

 [Destructors](Destructor) often must be virtual when deleting an object manipulated through a pointer to its base type, so that the destruction starts at the most derived type and works its way down to the base type. To do this, it may be necessary to add virtual destructors with an empty body anywhere an explicit destruction was not yet required, in order to supersede each non-virtual implicit destructor built by the compiler.  
 On the other hand, when calling a virtual (or abstract) method inside a destructor (virtual or not), only the version of the method corresponding to an object of type of this destructor is used because the vptr is reset at the top of the destructor according to its own type's vtable. This avoids to access child methods and so to refer to child members previously destroyed by the child destructor execution.

 For member methods with `Virtual` in their declaration, `Virtual` can also be specified on the corresponding method bodies, for improved code readability.

 **Caution:** In a multi-level inheritance, a same named method (same identifier and signature) can be declared [`Abstract`](Abstract), `Virtual` or normal (without specifier) at each inheritance hierarchy level. When there is mixing of specifiers, the usual order is abstract -> virtual -> normal, from top to bottom of the inheritance hierarchy.
 The access control ([`Public`](Public-Access-Control)/[`Protected`](Protected-Access-Control)/[`Private`](Private-Access-Control)) of an overriding method is not taken into account by the internal polymorphism process, but only for the initial call at compile-time.  
 `Base (Member Access).`method() calls always the base's own method, never the overriding method.

 **Note:** `Virtual` is also used as qualifier for [`ProcPtr`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index) to request it to return the index in the vtable for a virtual/abstract member procedure or member operator.

`ProcPtr ( identifier, Virtual [ Any|user_proctype ] )`

## Remarks

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Type`](Type-Udt)
- [`Object`](Object)
- [`Extends`](Extends)
- [`Extends Zstring`](Extends-Zstring)
- [`Extends Wstring`](Extends-Wstring)
- [`Abstract`](Abstract)
- [`Override`](Override)

## Examples

```freebasic
'' Example with overriding subroutines

Type Hello Extends Object

    Declare Virtual Sub hi( )

End Type

Type HelloEnglish Extends Hello

    Declare Sub hi( )            '' overriding subroutine

End Type

Type HelloFrench Extends Hello

    Declare Sub hi( )            '' overriding subroutine

End Type

Type HelloGerman Extends Hello

    Declare Sub hi( )            '' overriding subroutine

End Type

Sub Hello.hi( )

    Print "hi!"

End Sub

Sub HelloEnglish.hi( )           '' overriding subroutine

    Print "hello!"

End Sub

Sub HelloFrench.hi( )            '' overriding subroutine

    Print "Salut!"

End Sub

Sub HelloGerman.hi( )            '' overriding subroutine

    Print "Hallo!"

End Sub

Randomize( Timer( ) )

Dim As Hello Ptr h

For i As Integer = 0 To 9

    Select Case( Int( Rnd( ) * 4 ) + 1 )

    Case 1

        h = New HelloEnglish

    Case 2

        h = New HelloFrench

    Case 3

        h = New HelloGerman

    Case Else

        h = New Hello

    End Select

    h->hi( )

    Delete h

Next

Sleep
```

```freebasic
'' Example with overriding destructor and

''              overriding function with covariant return

Type myBase Extends Object

  Declare Virtual Function clone () As myBase Ptr

  Declare Virtual Sub Destroy ()

End Type

Function myBase.clone () As myBase Ptr

  Dim As myBase Ptr pp = New myBase(This)

  Print "myBase.clone() As myBase Ptr", pp

  Function = pp

End Function

Sub myBase.Destroy ()

  Print "myBase.Destroy()", , @This

  Delete @This

End Sub

Type myDerived Extends myBase

  Declare Function clone () As myDerived Ptr     '' overriding member function with covariant return

  Declare Sub Destroy ()                         '' overriding member subroutine

End Type

Function myDerived.clone () As myDerived Ptr     '' overriding member function with covariant return

  Dim As myDerived Ptr pc = New myDerived(This)

  Print "myDerived.clone() As myDerived Ptr", pc

  Function = pc

End Function

Sub myDerived.Destroy ()                         '' overriding member subroutine

  Print "myDerived.Destroy()", , @This

  Delete @This

End Sub

Dim As myDerived c

Dim As myBase Ptr ppc = @c

Dim As myDerived Ptr pcc = @c

Dim As myBase Ptr ppc1 = ppc->clone()            '' using base pointers and polymorphism

Dim As myDerived Ptr pcc1 = pcc->clone()         '' using derived pointers and covariance of return value

Print

ppc1->Destroy()                                  '' using base pointer and polymorphism

pcc1->Destroy()                                  '' using derived pointer

Sleep
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
