[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Constructor**

# Constructor

Called automatically when a class or user defined type is created

## Syntax

```freebasic
Type typename
Declare Constructor ( )
Declare Constructor ( [ ByRef | ByVal ] parameter As datatype [ = default ] [, ... ] )
End Type
Constructor typename ( [ parameters ] ) [ Export ]
statements
End Constructor
```

## Parameters

- `typename`

## Description

`Constructor` methods are called when a user defined [`Type`](Type-Udt) or [`Class`](Class) variable is created.

 `typename` is the name of the type for which the `Constructor` method is declared and defined. Name resolution for `typename` follows the same rules as procedures when used in a [`Namespace`](Namespace).

 More than one constructor may exist for a [`Type`](Type-Udt) or [`Class`](Class), but only one will be called when a user defined [`Type`](Type-Udt) or [`Class`](Class) variable is created, and the exact constructor method called depends on the `parameter` signature matched when the variable is initialized.  
 More than one `parameter` may exist in a constructor method declaration.

 A constructor method is passed a hidden [`This`](This) parameter having the same type as `typename`. [`This`](This) is optionally used to access the fields of the [`Type`](Type-Udt) or [`Class`](Class) which is to be initialized in the `Constructor` method.

 Constructors are called when declaring global or local static instances of `typename` and when allocating `typename` dynamically using the [`New Expression`](Operator-New-Expression) operator. See examples below for different constructor syntaxes.

 A copy `Constructor` is a special constructor that initializes a new object from an existing object. There are three general cases where the copy `Constructor` is called: when instantiating one object and initializing it with another object (in one instruction), when passing an object by value, when an object is returned from a function by value (by using `Return x` statement).

Note: When an object is returned from a function by value, but by using `Function = x` (or `function_identifier = x`) assignment, the `Constructor` is called once at first, and then the [`Let (Assign)`](Operator-Let-Assign) operator at each assignment.

A copy `Constructor` must be defined if the shallow implicit copy constructor is not sufficient. This happens in cases when the object manages dynamically allocated memory or other resources which need to be specially constructed or copied (for example if a member pointer points to dynamically allocated memory, the implicit copy constructor will simply do an implicit pointer construction and a copy of value instead of allocate memory and then perform the copy of data).

Note: Even if is defined an explicit default `Constructor`, it is never called by the implicit copy constructor.

A copy `Constructor` can not declare its parameter (the object to clone) by value.

 Chaining of constructors in nested types is supported. Any fields that have their own default constructor are called first.  
 Chaining together constructors of a same type is allowed by using the keyword `Constructor(parameters)` at the top of constructor. It prevents the compiler from emitting field initialization code (instead, it relies on the chained constructor to initialize everything).

 `Constructor` can be also called directly from the `typename` instance like the other member methods ([`Sub`](Sub)) and with the same syntax, i.e. using a member access operator, e.g. `obj.Constructor(parameters)`. In particular, doing `this.Constructor(parameters)` is not treated as chaining together constructors of a same type, and it is allowed anywhere (not only at the top of constructors). In general it's not safe to manually call the constructor on an object, because no [`Destructor`](Destructor) is called, and the old object state - if any - is overwritten without any of its old members being destroyed, which could cause memory/resource leaks.

## Remarks

### Dialect Differences

- Object-related features are supported only in the *[-lang fb](Compiler-Option-Lang)* option

### Differences from QB

- New to FreeBASIC

### See also

- [`Class`](Class)
- [`Constructor (Module)`](Constructor-Module)
- [`New Expression`](Operator-New-Expression)
- [`Destructor`](Destructor)
- [`Type`](Type-Udt)

## Examples

Simple constructor example for beginners:

```freebasic
Type MyObj

  Foo As Integer Ptr

    '' Constructor to create our integer, and set its value.

  Declare Constructor( ByVal DefVal As Integer = 0 )

    '' Destroy our integer on object deletion.

  Declare Destructor()

End Type

Constructor MyObj( ByVal DefVal As Integer = 0 )

  Print "Creating a new integer in MyObj!"

  Print "The Integer will have the value of: " & DefVal

  Print ""

    '' Create a pointer, and set its value to the one passed to the

    '' Constructor.

  This.Foo = New Integer

  *This.Foo = DefVal

End Constructor

Destructor MyObj()

  Print "Deleting our Integer in MyObj!"

  Print ""

    '' Delete the pointer we created in MyObj.

  Delete This.Foo

  This.Foo = 0

End Destructor

Scope

    '' Create a MyObj type object

    '' Send the value of '10' to the constructor

  Dim As MyObj Bar = 10

    '' See if the integer's been created.  Print its value.

  Print "The Value of our integer is: " & *Bar.Foo

  Print ""

  Sleep

End Scope

  '' We've just gone out of a scope.  The Destructor should be called now

  '' Because our objects are being deleted.

Sleep
```

More advanced construction example, showing constructor overloading among other things:

```freebasic
Type sample

  _text As String

  Declare Constructor ()

  Declare Constructor ( a As Integer )

  Declare Constructor ( a As Single  )

  Declare Constructor ( a As String, b As Byte )

  Declare Operator Cast () As String

End Type

Constructor sample ()

  Print "constructor sample ()"

  Print

  this._text = "Empty"

End Constructor

Constructor sample ( a As Integer )

  Print "constructor sample ( a as integer )"

  Print "  a = "; a

  Print

  this._text = Str(a)

End Constructor

Constructor sample ( a As Single )

  Print "constructor sample ( a as single )"

  Print "  a = "; a

  Print

  this._text = Str(a)

End Constructor

Constructor sample ( a As String, b As Byte )

  Print "constructor sample ( a as string, b as byte )"

  Print "  a = "; a

  Print "  b = "; b

  Print

  this._text = Str(a) + "," + Str(b)

End Constructor

Operator sample.cast () As String

  Return this._text

End Operator

Print "Creating x1"

Dim x1 As sample

Print "Creating x2"

Dim x2 As sample = 1

Print "Creating x3"

Dim x3 As sample = 99.9

Print "Creating x4"

Dim x4 As sample = sample( "aaa", 1 )

Print "Values:"

Print "  x1 = "; x1

Print "  x2 = "; x2

Print "  x3 = "; x3

Print "  x4 = "; x4
```

Example of copy constructor:

```freebasic
Type UDT

  Dim As String Ptr p                     ''pointer to string

  Declare Constructor ()                  ''default constructor

  Declare Constructor (ByRef rhs As UDT)  ''copy constructor

  Declare Destructor ()                   ''destructor

End Type

Constructor UDT ()

  This.p = CAllocate(1, SizeOf(String))

End Constructor

Constructor UDT (ByRef rhs As UDT)

  This.p = CAllocate(1, SizeOf(String))

  *This.p = *rhs.p

End Constructor

Destructor UDT ()

  *This.p = ""

  Deallocate This.p

End Destructor

Dim As UDT u0

*u0.p = "copy constructor exists"

Dim As UDT u = u0

*u0.p = ""  ''to check the independance of the result copy with the object copied

Print *u.p

Sleep
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
