[Home](Home) › [Tutorials](Category-Tutorials) › **Constructors and Destructors (basics)**

# Constructors and Destructors (basics)

In charge of the creation and destruction of objects.

 **Overview**
 **Declaration**
 **Default constructors**
 **Copy constructors**
 **Calling constructors**
 **Compiler-provided constructors and destructors**

Overview

Constructors and destructors are responsible for creating and destroying objects, respectively. In general, constructors give objects their initial state, that is, they give meaningful values to their objects' member data. Destructors perform the opposite function; they make sure any resources owned by their objects are properly freed.

 Simply, constructors are special member procedures that are called when an object is created, and destructors are special member procedures called when an object is destroyed. Both constructors and destructors are called automatically by the compiler whenever an object is created or destroyed, whether explicitly with the use of the [`Dim`](Dim) or [`New Expression`](Operator-New-Expression)/[`Delete Statement`](Operator-Delete-Statement) keywords, or implicitly by passing an object to a procedure by value or through an object going out of scope.

Declaration

Constructors and destructors are declared like member procedures but with the [`Constructor`](Constructor) keyword instead of [`Sub`](Sub-Member) or [`Function`](Function-Member), and without a name. Similarly, they are defined with only the name of the [`Type`](Type-Udt) or [`Class`](Class) they are declared in.

 A [`Type`](Type-Udt) or [`Class`](Class) can have multiple constructors, but only one destructor.

Default constructors

Default constructors are constructors that either have no parameters, or all of their parameters have a default value. They are called when an object is defined but not initialized, or is created as part of an array, with the [`Dim`](Dim), [`ReDim`](Redim) or [`New`](Operator-New-Expression)\[\] expression keywords. The first constructor declared in the example below is a default constructor.

Copy constructors

Copy constructors are constructors called when an object is created, or cloned, from another object of the same type (or an object that can be converted to that type). This happens explicitly when initializing an object with another object, or implicitly by passing an object to a procedure by value. Copy constructors are declared having one parameter: an object of the same type passed by reference.

 Copy constructors are only called when creating and initializing object instances. Assignment to objects is handled by the [`Member Operator Let`](Operator).

Calling constructors

Unlike other member procedures, constructors are generally not called directly from an object instance. Instead, a constructor is specified in a [`Dim`](Dim) statement either with an initializer or without one, or in a [`New Expression`](Operator-New-Expression) statement with or without arguments.

 When specifying an initializer for an object, the name of the type followed by any arguments it requires is used.

```freebasic
Type foo

    '' Declare a default ctor, copy ctor and normal ctor

    Declare Constructor

    Declare Constructor (ByRef As foo)

    Declare Constructor (As Integer)

    '' Declare a destructor

    Declare Destructor

    ints As Integer Ptr

    numints As Integer

End Type

'' Define a constructor that creates 100 integers

Constructor foo

    ints = New Integer(100)

    numints = 100

End Constructor

'' Define a constructor that copies the integers from another object

Constructor foo (ByRef x As foo)

    ints = New Integer(x.numints)

    numints = x.numints

End Constructor

'' Define a constructor that creates some integers based on a parameter

Constructor foo (n As Integer)

    ints = New Integer(n)

    numints = n

End Constructor

'' Define a destructor that destroys those integers

Destructor foo

    Delete[] ints

End Destructor

Scope

    '' calls foo's default ctor

    Dim a As foo

    Dim x As foo Ptr = New foo

    '' calls foo's copy ctor

    Dim b As foo = a

    Dim y As foo Ptr = New foo(*x)

    '' calls foo's normal ctor

    Dim c As foo = foo(20)

    Dim z As foo Ptr = New foo(20)

    '' calls foo's dtor

    Delete x

    Delete y

    Delete z

End Scope '' <- a, b and c are destroyed here as well
```

Compiler-provided constructors and destructors

If no copy constructor is declared for a [`Type`](Type-Udt) or [`Class`](Class), the compiler provides one. If no constructor has been declared, the compiler also provides a default constructor.

 The compiler-provided default constructor initializes member data to default values, that is, numeric and pointer members are set to zero (0), and object members are default-constructed. The copy constructor that the compiler declares shallow-copies all member data from one type to another: numeric and pointer types are initialized with the corresponding data members in the object that is copied, and object members are copy-constructed from their corresponding object members. This means that dynamic resources, such as memory pointed to by a pointer data member, is not copied; only the address is copied. So if an object owns a resource, meaning it is responsible for its creation and destruction, then the compiler-generated copy constructor will not be sufficient.

 If a destructor is not declared, the compiler generates one. This destructor calls object members' destructors and does nothing for numeric and pointer types. Again, if an object owns a dynamic resource, then the compiler-generated destructor will not be sufficient, as the resource will not be freed when the object is destroyed.

 This is commonly referred to as the "Rule of 3": If an object needs a custom copy constructor, assignment operator or destructor, chances are it needs all three.

See also

- [`Constructor`](Constructor), [`Destructor`](Destructor)
  [Constructors, '=' Assignment-Operators, and Destructors (advanced, part #1)](Constructors-Assignment-Operators-and-Destructors-Advanced-Part-1)  
  [Constructors, '=' Assignment-Operators, and Destructors (advanced, part #2)](Constructors-Assignment-Operators-and-Destructors-Advanced-Part-2)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
