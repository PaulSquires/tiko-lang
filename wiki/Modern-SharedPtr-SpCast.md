[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **SpCast**

# SpCast

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [SharedPtr and WeakPtr](Category-Smart-Pointers), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
SpCast( of D, B )
```

## Examples

```freebasic
#include once "fb/sharedptr.bi"
using FB

type Shape extends Object
    as long id
    declare virtual destructor( )
end type
virtual destructor Shape( ) : end destructor

type Circle extends Shape
end type

dim d as SharedPtr( of Circle ) = MakeShared( of Circle )( )
d.Ref( ).id = 7

'' Both type arguments must be written out: inference reads parameter
'' positions only, and the target type appears in none of them
dim b as SharedPtr( of Shape ) = SpCast( of Circle, Shape )( d )

print b.Ref( ).id            '' 7
print b.UseCount( )          '' 2 -- one object, two handles, shared count

'' THE BASE MUST HAVE A VIRTUAL DESTRUCTOR: the returned handle destroys
'' through `delete cptr( Shape ptr, obj )`, and nothing here can check it.
'' (The type is not called Base because BASE is a FreeBASIC keyword.)
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers) ✨  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
