[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__Fb_Query_Symbol__**

# __Fb_Query_Symbol__

Intrinsic define (macro) performed by the compiler, and its associated sub-macros.

## Syntax

```freebasic
__FB_QUERY_SYMBOL__( what, sym )
```

## Parameters

- `sym`
- `b`

## Description

**`__FB_QUERY_SYMBOL__`** is a generic built-in macro for querying fbc symbol internals.

 In the file `./inc/fbc-int/symbol.bi`, many convenient and specialized sub-macros with **`'is'`** as name prefix (**`'isXXXXX'`**) are also defined (where **`'XXXXX'`** stands for the kind of query).  
 They help the user to indirectly call the generic built-in macro **`__FB_QUERY_SYMBOL__`** without knowing the encoding of its first parameter and its return value, but passing the only `sym` parameter to those sub-macros which only return `-1` (for `True`) or `0` (for `False`).

 For three of the query types, convenient and specialized sub-macros are available:

- 'class of symbols' (like variable, constant, procedure, namespace, ...),
 - 'class of data' (like integer, float, string, UDT, ...),
 - 'type of data' (like boolean, byte, ubyte, short, ...).

in order to test whether a symbol matches an element of the considered family.

## Remarks

### Usage

 The `./inc/fbc-int/symbol.bi` header exposes internals of the fbc compiler through the built-in macro **`__FB_QUERY_SYMBOL__`**.

 In addition, many convenient sub-macros with **`'is'`** as name prefix (also defined in the file `./inc/fbc-int/symbol.bi`) help the user to indirectly call the generic built-in macro **`__FB_QUERY_SYMBOL__`**:

```freebasic
#include once "fbc-int/symbol.bi"

using FBC

' then:

Dim b As Boolean

...

b = isXXXXX( sym )
```

### Version

- Since fbc 1.20.0 : **`__FB_QUERY_SYMBOL__`** extended to return mangled names
- Since fbc 1.10.0

### Differences from QB

- New to FreeBASIC

## Examples

Using convenient sub-macros from the `./inc/fbc-int/symbol.bi` file (indirectly calling **`__FB_QUERY_SYMBOL__`**)

```freebasic
#include Once "fbc-int/symbol.bi"

Using FBC

Type T

    i As Integer

End Type

Dim x As T

Print isUDT( T )       '' returns -1 (true)

Print isVariable( T )  '' returns 0 (false)

Print isUDT( x )       '' returns 0 (false)

Print isVariable( x )  '' returns -1 (true)

Sleep
```

Using directly **`__FB_QUERY_SYMBOL__`** and some declarations from the `./inc/fbc-int/symbol.bi` file to output the data class of a symbol:

```freebasic
#include Once "fbc-int/symbol.bi"

Using FBC

Function dataclassToStr( ByVal classid As fbc.FB_DATACLASS ) As String

    Static As ZString Ptr classnames _

        ( FB_DATACLASS.FB_DATACLASS_INTEGER To FB_DATACLASS.FB_DATACLASS_UDT ) _

        = { @"integer", @"float", @"string", @"udt" }

    Select Case classid

    Case LBound(classnames) To UBound(classnames)

        Return *classnames(classid)

    Case Else

        Return "*invalid*"

    End Select

End Function

#macro show_dataclass( sym )

    Scope

        Var classid = __FB_QUERY_SYMBOL__( FB_QUERY_SYMBOL.dataclass, sym )

        Print Left( "   [" & classid & "] " & dataclassToStr(classid) + Space(16), 16 ) & ": ";

        Print #sym

    End Scope

#endmacro

Dim As Byte b

Dim As Double d

Dim As String s

Type T

    Dim As Long l

End Type

Dim As T t1

Print "EXAMPLES OF '__FB_QUERY_SYMBOL__( FB_QUERY_SYMBOL.dataclass, sym )':"

show_dataclass( b )

show_dataclass( d )

show_dataclass( s )

show_dataclass( T )

show_dataclass( T.l )

show_dataclass( t1 )

show_dataclass( t1.l )

Sleep
```

Using directly **`__FB_QUERY_SYMBOL__`** and some declarations from the `./inc/fbc-int/symbol.bi` file to output the typename as text, the typename as text with special characters replaced with '\_', and the decorated (mangled) type name (WIP), of a symbol:

```freebasic
#include Once "fbc-int/symbol.bi"

Using FBC

Namespace NS

    Type T

        Dim As Const String Const Ptr Ptr pps

    End Type

End Namespace

#print TypeOf(NS.T.pps)

Print "type name    : " & __FB_QUOTE__( __FB_QUERY_SYMBOL__( FB_QUERY_SYMBOL.typename, NS.T.pps ) )

Print "type name id : " & __FB_QUOTE__( __FB_QUERY_SYMBOL__( FB_QUERY_SYMBOL.typenameid, NS.T.pps ) )

Print "mangled type : " & __FB_QUOTE__( __FB_QUERY_SYMBOL__( FB_QUERY_SYMBOL.mangletype, NS.T.pps ) )

Sleep
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
