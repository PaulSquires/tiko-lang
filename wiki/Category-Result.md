[Home](Home) › [All Categories](Categories) › **Result**

# Result

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

```freebasic
#include once "fb/result.bi"
using FB

type ParseResult as Result( of long, string )

function Parse( byref s as string ) as ParseResult
    if( len( s ) = 0 ) then
        return Fail( of long, string )( "empty" )
    end if
    ...
    return Ok( of long, string )( n )
end function

dim r as ParseResult = Parse( input_ )

if( r.IsOk( ) ) then
    print r.Value( )
else
    print "cannot parse: "; r.Failure( )
end if
```

## Why It Exists

The error was not part of the return type. It lived in a global status code, did not participate in the type system, and was trivially ignored:

```freebasic
dim v as long = Parse( s )           ' did it work?  ask err, maybe
if( err <> 0 ) then
```

Result puts the reason IN THE RETURN TYPE, where it has a name and cannot be read by accident as a value.

## Result OR OPTIONAL?

```freebasic
Optional( of T )        "nothing is here"
Result( of T, E )       "nothing is here, AND this is why"
```

Use Optional when the absence needs no explanation -- a lookup that missed, a list that was empty. Use Result when it does. A Result whose E is never inspected should have been an Optional.

## Members

```freebasic
IsOk( ) as boolean                        O(1)
Value( ) byref as T                       O(1)   RAISES if failed
Failure( ) byref as E                     O(1)   RAISES if successful
ValueOr( byref dflt as T ) byref as T     O(1)   never raises
```

and two FREE PROCEDURES, not constructors:

```freebasic
Ok( of T, E )( v ) as Result( of T, E )
Fail( of T, E )( e ) as Result( of T, E )
```

There is deliberately no operator '=', no comparison, no ToString and no GetIterator. See WHY THERE ARE SO FEW MEMBERS below.

There is no FailureOr( ): a default reason for a success is not a thing anyone wants.

## A DEFAULT-CONSTRUCTED Result Is A Failure

```freebasic
dim r as Result( of long, string )   ' failed, with an empty reason
```

This is the most important property of the type, and the choice is not arbitrary. A Result that nobody has set must not read as success, or every forgotten assignment becomes a silent Ok. There is no third state.

## Both Type Arguments Must Be Written Out

Inference reads parameter positions only, and Ok( ) mentions just T while Fail( ) mentions just E, so neither call can infer the pair:

```freebasic
return Ok( of long, string )( 3L )
return Fail( of long, string )( "not a number" )
```

That is more ceremony than Optional's Some( x ), and it is the reason the pairing is normally named once:

```freebasic
type ParseResult as Result( of long, string )
```

The usual inference rule still applies inside: an untyped integer literal is an INTEGER, so Ok( of long, string )( 3 ) is a mismatch and Ok( ... )( 3L ) is not.

## Reading The Wrong Side Raises

Value( ) on a failure and Failure( ) on a success BOTH raise FB_RTERROR_ILLEGALFUNCTIONCALL. With no handler installed the program stops:

```freebasic
Aborting due to runtime error 1 (illegal function call)
  at line 87 of ...\inc\fb\result.bi()
```

The symmetry is deliberate. Asking why something failed when it did not fail is the same class of mistake as reading a value that is not there, and it is the one a one-sided implementation would let through silently.

IsOk( ) is the guard and costs nothing. ValueOr( ) is the branch-free alternative for the value side and never raises.

Both accessors return BYREF, so they can be written through:

```freebasic
r.Value( ) = 3
dim byref as string f = r.Failure( )
```

and ValueOr( ) aliases either the stored value or the CALLER'S default, so passing a temporary gives a reference that dies at the end of the statement -- the same hazard as any byref return, not a Result one.

## Zero Is A Value

```freebasic
Ok( of long, string )( 0L )          ' a success whose value is 0
Fail( of long, string )( "" )        ' a failure whose reason is ""
```

Neither collapses into the other. Every "0 means error" or "empty means failed" convention Result replaces gets one of these wrong.

## It Is NOT A Sum Type

Result is a T and an E and a boolean -- three fields, not a tagged union:

```freebasic
sizeof( Result( of T, E ) ) >= sizeof( T ) + sizeof( E ) + sizeof( boolean )
```

Consequences, all of them observable:

- BOTH T and E must be default-constructible, and both default constructors

```freebasic
run for every Result. A T or an E declaring any constructor suppresses the
implicit default one and is refused:

    error 183: TYPE or CLASS has no default constructor
      in instantiation of 'Result( of long, NODEFAULTCTOR )'
```

- Both slots are destroyed, always -- not just the active one. A union-based

```freebasic
implementation that destroyed only the live side would leak.
```

- The slots are independent, so T and E may be the SAME type.

```freebasic
Result( of string, string ) -- a parsed word, or a message saying why not --
is legal and keeps the two apart.
```

This is the price of having no sum types in the language.

## Why There Are So Few Members

Not minimalism. Every member of a generic is instantiated whether it is called or not, so a member needing '=' on T or E would make the WHOLE TYPE unusable for a T or an E without one -- the same rule that forced Array's Sort, IndexOf and Contains to become free procedures.

So the members here use only default construction, copy and destruction, and Result instantiates over anything with those, including containers, which have no '=':

```freebasic
dim r as Result( of Array( of long ), string )          ' fine
dim s as Result( of long, Array( of long ) )            ' fine
dim n as Result( of Result( of long, string ), string ) ' fine
```

## Library Only

No compiler change went into this, and several things were deliberately NOT done:

```freebasic
no '?' operator                     ' propagating early-return
no must-use diagnostic              ' see below
no sum type underneath              ' see above
no implicit conversion to boolean   ' 'if( r ) then' does not compile
```

IGNORING A RESULT STAYS A CONVENTION. Nothing stops this:

```freebasic
Parse( s )                          ' return value dropped, silently
```

A must-use diagnostic needs a compiler change and is not part of this. What the type buys is that the failure has a name and a type -- not that you are forced to look at it. That is the honest limit of a library-only version.

## Ownership AND Copying

Copy and assignment are DEEP, because both slots are stored by value and FreeBASIC's value semantics do the work. The two Results are independent afterwards in BOTH directions, in either state.

A Result( of T ptr, ... ) copies the POINTER. There are no smart pointers.

## A Naming Trap

The failure field is named 'f', not the obvious 'e'. FreeBASIC identifiers are case-insensitive, so a field named 'e' IS the type parameter 'E', and the instantiation fails with a misleading

```freebasic
error 14: Expected identifier, found 'E'
```

The same collision bites CALLERS, and much more sharply: a variable named 'e' anywhere in scope at the point Result is instantiated breaks that instantiation with the same error. This is a defect in the generics implementation, not a property of Result -- the type parameter is being resolved against the instantiation site's scope -- and it applies to 't' and Array( of T ) and every other shipped generic equally. Until it is fixed, avoid single-letter variables named after a type parameter near a generic instantiation.

Source: src/inc/fb/result.bi

## Tests

src/tests/generics/container-result.bas is exhaustive: every member, both states, both free constructors, all four assignment transitions, self-assignment, slot independence, copy independence in both directions, byref mutation through Value( ) and Failure( ), distinct T and E in both orders, T = E, a container in each position and in both at once, a nested Result, a Result as a return value, and destructor balance over BOTH slots -- asserted for the mixed case and for the never-set case separately.

src/tests/generics/result-value-on-failure.bas and result-failure-on-ok.bas are COMPILE_AND_RUN_FAIL tests pinning the two raising paths. They are separate modules because each raise ends the process.

src/tests/generics/fail-result-nodefaultctor.bas pins the diagnostic for a type with no default constructor in the E position.

## API reference

One page per entry, 9 in all:

[Fail](Modern-Result-Fail) · [Failure](Modern-Result-Failure) · [IsOk](Modern-Result-IsOk) · [Ok](Modern-Result-Ok) · [Optional](Modern-Result-Optional) · [Result](Modern-Result-Result) · [Value](Modern-Result-Value) · [ValueOr](Modern-Result-ValueOr)

---

**Source:** `docs/result/result.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)
