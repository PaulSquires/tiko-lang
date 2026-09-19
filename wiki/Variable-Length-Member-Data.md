[Home](Home) › [Tutorials](Category-Tutorials) › **Variable-length member data**

# Variable-length member data

Management of **variable-length strings/arrays** as **members** of a Type.

 **Preamble:**

 In FreeBASIC, Type data structures must ultimately be fixed-size, such that the compiler knows how much memory to allocate for objects of that Type.  
 Nevertheless, Types may contain variable-length string or array data members.

 However, the string's/array's data will not be embedded in the Type directly. Instead, the Type will only contain a string/array descriptor structure, which FreeBASIC uses behind the scenes to manage the variable-length string/array data.  
 For sizing the structure of the array descriptor in the Type, a variable-length array data member must be always declared by using Any(S) in place of the array bounds, in order to fix the amount of dimensions based on the number of Anys specified. A variable-length array data member can also be pre-sized in its declaration by using syntax with `ReDim`.

 Variable-length array fields are considered as pseudo-objects when they are declared in a Type (variable-length strings are real objects).  
 So the implicit copy constructor and the implicit let operator of the Type themselves support \[re\]sizing and copying such strings/arrays, or their erasing.

Implicit string/array sizing and copying by the compiler code

When the compiler build a default copy-constructor and a default copy-assignment operator for such a Type (having string/array members), it also includes all code for sizing the destination string/array and copying the data from the source string/array, if needed.

 Example:

```freebasic
Type UDT

    Dim As String s

    Dim As Integer array(Any)

End Type

Dim As UDT u1, u2

u1.s = "FreeBASIC"

ReDim u1.array(1 To 9)

For I As Integer = LBound(u1.array) To UBound(u1.array)

    u1.array(I) = I

Next I

u2 = u1

Print u2.s

For I As Integer = LBound(u2.array) To UBound(u2.array)

    Print u2.array(I);

Next I

Print

Print

Dim As UDT u3 = u1

Print u3.s

For I As Integer = LBound(u3.array) To UBound(u3.array)

    Print u3.array(I);

Next I

Print

Sleep
```

 Output:

```freebasic
FreeBASIC
 1 2 3 4 5 6 7 8 9

FreeBASIC
 1 2 3 4 5 6 7 8 9

```

Implicit string/array sizing and copying by the compiler code broken by an explicit copy-constructor and copy-assignment operator

If the user want to specify his own copy-constructor and copy-assignment operator (to initialize additional complex field members for example), the above automatic string/array sizing and copying by compiler code is broken.

 Example:

```freebasic
Type UDT

    Dim As String s

    Dim As Integer array(Any)

    Declare Constructor ()

    Declare Constructor (ByRef u As UDT)

    Declare Operator Let (ByRef u As UDT)

    'user fields

End Type

Constructor UDT ()

    'code for user fields in constructor

End Constructor

Constructor UDT (ByRef u As UDT)

    'code for user fields in copy-constructor

End Constructor

Operator UDT.Let (ByRef u As UDT)

    'code for user fields in copy-assignement operator

End Operator

Dim As UDT u1, u2

u1.s = "FreeBASIC"

ReDim u1.array(1 To 9)

For I As Integer = LBound(u1.array) To UBound(u1.array)

    u1.array(I) = I

Next I

u2 = u1

Print u2.s

For I As Integer = LBound(u2.array) To UBound(u2.array)

    Print u2.array(I);

Next I

Print

Print

Dim As UDT u3 = u1

Print u3.s

For I As Integer = LBound(u3.array) To UBound(u3.array)

    Print u3.array(I);

Next I

Print

Sleep
```

 Output (blank):

```freebasic

```

String/Array sizing and copying explicitly set in the user copy-constructor and copy-assignment operator

The variable-length array cannot be processed as a true object like a variable-length string, because for example there is no implicit assignment.  
 Referring to the above example, `This.array() = u.array()` is disallowed, while `This.s = u.s` is allowed.  
 The user must code explicitly the sizing and the copying of the array member (for the array data copy, a C run-time function `memcpy()` is used to optimize the execution time).

 Example:

```freebasic
#include "crt/string.bi"  '' C run-time header for 'memcpy()'

Type UDT

    Dim As String s

    Dim As Integer array(Any)

    Declare Constructor ()

    Declare Constructor (ByRef u As UDT)

    Declare Operator Let (ByRef u As UDT)

    'user fields

End Type

Constructor UDT ()

    'code for user fields in constructor

End Constructor

Constructor UDT (ByRef u As UDT)

    This.s = u.s

    If UBound(u.array) >= LBound(u.array) Then  '' explicit array sizing and copying

        ReDim This.array(LBound(u.array) To UBound(u.array))

        memcpy(@This.array(LBound(This.array)), @u.array(LBound(u.array)), (UBound(u.array) - LBound(u.array) + 1) * SizeOf(@u.array(LBound(u.array))))

    End If

    'code for user fields in copy-constructor

End Constructor

Operator UDT.Let (ByRef u As UDT)

    If @This <> @u Then  '' not self-assignment

        This.s = u.s

        If UBound(u.array) >= LBound(u.array) Then  '' explicit array sizing and copying

            ReDim This.array(LBound(u.array) To UBound(u.array))

            memcpy(@This.array(LBound(This.array)), @u.array(LBound(u.array)), (UBound(u.array) - LBound(u.array) + 1) * SizeOf(@u.array(LBound(u.array))))

        End If

        'code for user fields in copy-assignement operator

    End If

End Operator

Dim As UDT u1, u2

u1.s = "FreeBASIC"

ReDim u1.array(1 To 9)

For I As Integer = LBound(u1.array) To UBound(u1.array)

    u1.array(I) = I

Next I

u2 = u1

Print u2.s

For I As Integer = LBound(u2.array) To UBound(u2.array)

    Print u2.array(I);

Next I

Print

Print

Dim As UDT u3 = u1

Print u3.s

For I As Integer = LBound(u3.array) To UBound(u3.array)

    Print u3.array(I);

Next I

Print

Sleep
```

 Output:

```freebasic
FreeBASIC
 1 2 3 4 5 6 7 8 9

FreeBASIC
 1 2 3 4 5 6 7 8 9

```

Using an extra base Type containing the variable-length string and array

Another elegant possibility is to keep this sizing/copying, automatically coded by the compiler, but by simply calling it explicitly.  
 For this, an elegant solution for the member array is to no longer put it at the level of the Type itself, but rather in another specific Type which is inherited (seen from the outside, it is exactly the same). This is not necessary for the member string, but including also allows to save one code line each time.

 Example:

```freebasic
Type UDT0

    Dim As String s

    Dim As Integer array(Any)

End Type

Type UDT Extends UDT0

    Declare Constructor ()

    Declare Constructor (ByRef u As UDT)

    Declare Operator Let (ByRef u As UDT)

    'user fields

End Type

Constructor UDT ()

    'code for user fields in constructor

End Constructor

Constructor UDT (ByRef u As UDT)

    Base(u)  '' inherited string copying plus array sizing and copying from Base implicit copy-constructor call

    'code for user fields in copy-constructor

End Constructor

Operator UDT.Let (ByRef u As UDT)

    Cast(UDT0, This) = u  '' inherited string copying plus array sizing and copying from Base implicit copy-assignement operator call

    'code for user fields in copy-assignement operator

End Operator

Dim As UDT u1, u2

u1.s = "FreeBASIC"

ReDim u1.array(1 To 9)

For I As Integer = LBound(u1.array) To UBound(u1.array)

    u1.array(I) = I

Next I

u2 = u1

Print u2.s

For I As Integer = LBound(u2.array) To UBound(u2.array)

    Print u2.array(I);

Next I

Print

Print

Dim As UDT u3 = u1

Print u3.s

For I As Integer = LBound(u3.array) To UBound(u3.array)

    Print u3.array(I);

Next I

Print

Sleep
```

 Output:

```freebasic
FreeBASIC
 1 2 3 4 5 6 7 8 9

FreeBASIC
 1 2 3 4 5 6 7 8 9

```

See also

- [Constructors, '=' Assignment-Operators, and Destructors (advanced, part #1)](Constructors-Assignment-Operators-and-Destructors-Advanced-Part-1)
  [Constructors, '=' Assignment-Operators, and Destructors (advanced, part #2)](Constructors-Assignment-Operators-and-Destructors-Advanced-Part-2)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
