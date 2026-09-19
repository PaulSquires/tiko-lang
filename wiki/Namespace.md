[Home](Home) › [Modularizing](Category-Modularizing) › **Namespace**

# Namespace

Declares a namespace block.

## Syntax

```freebasic
Namespace identifier [ Alias "aliasname" ]
statements
End Namespace
```

## Parameters

- `identifier`
- `aliasname`

## Description

Namespaces allow to group entities like objects (predefined data-types and UDTs including Union and Enum) and procedures (including their declarations) under a name. This way the global scope can be divided in "sub-scopes", each one with its own name.

 Whether or not explicitly declared a namespace in a source file, the compiler adds a default namespace. This unnamed namespace, called the global namespace, is present in every file.  
 Any identifier in the global namespace is available for use in a named namespace (even global symbols with the same name as keywords may be declared inside a namespace).

 Namespaces implicitly have public access and this is not modifiable.  
 A variable declared inside a namespace is always implicitly static and visible throughout the entire program even if the declaration modifier [Shared](Shared) is not specified (static and shared are optional, but this may improve code readability).

 Namespaces do not have any effect on the visibility of a define.  
 It is possible to define a namespace in two or more declarations.

 Namespaces are commonly used in libraries where you don't want all the symbols from that library to crowd the user's space (called the global namespace).  
 For example, if you used the "Forms" library, it might define the Point type for describing an X and Y coordinate, and you might also define it for another purpose. This can be resolved by creating the namespace Forms for the library, and then referring to its Point type as Forms.Point, and yours as just Point.

 To access from outside a defined symbol in a namespace, add the namespace identifier followed by a dot as a prefix of the symbol, or bring the namespace symbols into the current scope by means of the [Using (Namespaces)](Using-Namespaces) statement.  
 To access duplicated symbols defined as global outside the namespace, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).

 **Note:** The parser allows to define anonymous Namespaces (without `identifier` term), but this is the only similarity with the actual C++ capability: The FB compiler automatically generates multiple separate anonymous Namespaces instead of one only per module in such a case.
 The FB anonymous Namespaces are almost unusable because all their declarations are inaccessible, even from the body of the module that contains them. Apart from encapsulating module constructors/destructors also inside, nothing else can be done with them.

## Remarks

### Dialect Differences

- Namespaces are not supported in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [Using (Namespaces)](Using-Namespaces)

## Examples

```freebasic
Namespace Forms

    Type Point '' A 2D point

        As Integer x

        As Integer y

    End Type

    '' Since we are inside of the namespace, Point resolves to Forms.Point.

    Sub AdjustPoint( ByRef pt As Point, ByVal newx As Integer, ByVal newy As Integer )

        pt.x = newx

        pt.y = newy

    End Sub

End Namespace

Type Point '' A 3D point

    As Integer x

    As Integer y

    As Integer z

End Type

Sub AdjustPoint( ByRef pt As Point, ByVal newx As Integer, ByVal newy As Integer, ByVal newz As Integer )

    pt.x = newx

    pt.y = newy

    pt.z = newz

End Sub

Dim pt1 As Point

AdjustPoint( pt1, 1, 1, 1 )

Dim pt2 As Forms.Point

Forms.AdjustPoint( pt2, 1, 1 )
```

 Namespaces are GCC C++ compatible, the following code aims to test that.

```freebasic
(cpp)
// mylib.cpp
// To compile:
//	g++ -c mylib.cpp -o mylib.o
//	ar rcs libmylib.a mylib.o

#include <string.h>
#include <ctype.h>

namespace mylib
{
	int test()
	{
		return 123;
	}
}
```

```freebasic
'' test.bas

Extern "c++" Lib "mylib"

    Namespace mylib Alias "mylib"

        Declare Function test() As Integer

    End Namespace

End Extern

Print mylib.test()
```

---

**Category:** [Modularizing](Category-Modularizing)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
