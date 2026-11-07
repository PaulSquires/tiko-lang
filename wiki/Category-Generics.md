[Home](Home) › [All Categories](Categories) › **Generics**

# Generics

```freebasic
type Box( of T )
    as T value
end type

dim b as Box( of int32 )
b.value = 7

function Max( of T )( byval a as T, byval b as T ) as T
    if a > b then return a
    return b
end function

print Max( 3, 9 )               '' T inferred as INTEGER
print Max( of float64 )( 1.5, 2.5 )
```

A generic is declared once and compiled once per distinct type-argument list. There is no textual substitution, no macro, and no separate template language: the body is captured as tokens at declaration and replayed through the real parser at instantiation, so the code inside a generic is ordinary tiko-lang and is diagnosed as such.

FOR EACH, the iterator protocol and the standard containers are all built on top of it.

## Why It Exists

Without generics, a container that works for more than one element type has to be written with macros, with ANY PTR, or once per type. All three lose something: a macro has no scope and reports errors at the expansion; ANY PTR discards the type and moves every mistake to run time; copies drift.

A generic keeps the type. Box( of long ) and Box( of string ) are two distinct types, each fully checked, both written once.

## Declaring A Generic Type

```freebasic
type Box( of T )
    as T value
end type

type Pair( of K, V )
    as K k
    as V v
end type
```

'of' introduces the type parameter list. One or more parameters, separated by commas, each an ordinary identifier. The parameters are visible throughout the body -- fields, member prototypes, member bodies, base type, array element types, pointers.

The name of a generic is not a type by itself. It must always be written with a type argument list:

```freebasic
dim a as Box                    '' TKO0815
type Bad extends Box            '' TKO0815
```

## Instantiation AND Identity

An instantiation is created the first time a particular type-argument list is seen, and cached. The SAME argument list always yields the SAME type:

```freebasic
dim b1 as Box( of int32 )
dim b2 as Box( of int32 )
b2 = b1                         '' fine -- one type, not two
```

Different argument lists are unrelated types with no conversion between them:

```freebasic
dim c as Box( of float64 )
c = b1                          '' TKO0738: no conversion between these two types
```

Type arguments may be anything a type can be: scalars, strings, UDTs, pointers, and other instantiations.

```freebasic
dim n as Box( of Box( of int32 ) )
```

SIZEOF, VAR, arrays, pointers, BYREF and BYVAL parameters, function results and UDT fields all work on an instantiation exactly as on any other type.

Declaration order does not matter. A generic may be used before its member bodies appear, and a member body may be written before any instantiation exists -- both are captured and replayed at the next module-level statement boundary.

## Members

A prototype inside the body needs nothing special. An out-of-line body repeats the type parameter list after the generic's name:

```freebasic
type Stack( of T )
    as T items( 0 to 15 )
    as integer count
    declare sub Push( byval x as T )
    declare function Pop( ) as T
end type

sub Stack( of T ).Push( byval x as T )
    this.items( this.count ) = x
    this.count += 1
end sub
```

The list must match the declaration in arity and in NAME. Renaming a parameter in the out-of-line body is TKO0817, not an alias:

```freebasic
sub Stack( of U ).Push( byval x as U )      '' TKO0817
```

Constructors, destructors, copy constructors and LET all work, and run for fields of a generic exactly as for a plain UDT -- a Box( of string ) constructs and destroys its string.

Member operators and properties work:

```freebasic
type Arr( of T )
    as T e( 0 to 3 )
    declare operator [] ( byval i as integer ) byref as T
    declare operator cast( ) as integer
    declare property first( ) as T
    declare property first( byval x as T )
end type

operator Arr( of T ).[] ( byval i as integer ) byref as T
    return this.e( i )
end operator
```

including the FOR / STEP / NEXT trio, which is what makes an instantiation usable as an ordinary FOR counter.

## Generic Procedures

```freebasic
sub Swap2( of T )( byref a as T, byref b as T )
function Max( of T )( byval a as T, byval b as T ) as T
function Pick( of A, B )( byval x as A, byval y as B ) as A
```

Call with explicit type arguments, or let them be inferred from the argument types:

```freebasic
print Max( of float64 )( 1.5, 2.5 )      '' explicit
print Max( 3, 9 )                       '' inferred
```

Inference reads the parameter positions only. A type parameter that appears only in the return type is therefore callable but not inferable, which is correct rather than a gap:

```freebasic
function MakeZero( of T )( ) as T
dim z as int32 = MakeZero( of int32 )( )
```

When two arguments would bind the same parameter to different types, inference does not pick a winner -- it reports TKO0809 and asks for the arguments to be written out. An implicit promotion is not a match.

A generic procedure may call another generic procedure, and a generic type's member may call a generic procedure.

## Generic Global Operators

```freebasic
operator + ( of T )( byref x as Box( of T ), byref y as Box( of T ) ) as Box( of T )
    dim as Box( of T ) r
    r.v = x.v + y.v
    return r
end operator
```

There is nowhere in 'a + b' to write type arguments, so they are inferred from the operand types, including through the nested position: an operand that is an instantiation of Box binds T from ITS argument list. Nothing is registered until an instantiation exists -- '+' for Box( of integer ) exists because somebody added two of them.

Self-assignment operators (+=, -=, ...) must be members:

```freebasic
operator += ( of T )( ... )     '' TKO0697: operator '+=' must be a member of a type
```

## Inheritance, Virtual AND RTTI

All three directions work:

```freebasic
type Sq( of T ) extends Shape           '' generic extends concrete
type IntBox extends Box( of integer )   '' concrete extends instantiation
type Der( of T ) extends Root( of T )   '' generic extends generic
```

VIRTUAL, ABSTRACT, overriding an override, and OBJECT-derived RTTI all behave as they do for plain types. 'x is T' works through a base pointer, and -- because RTTI compares mangled name strings at run time -- two DIFFERENT instantiations correctly report false for each other:

```freebasic
print ( *r is Der( of int32 ) )          '' from a Root( of long ) ptr
```

## Interfaces AND Constraints

A generic can be an interface, and a type parameter can be required to implement one:

```freebasic
interface IComparable( of T )
    function CompareTo( byref other as T ) as int32
end interface

function Largest( of T as IComparable( of T ) )( a( ) as T ) as T
    dim as int32 best = lbound( a )
    for i as int32 = lbound( a ) + 1 to ubound( a )
        if a( i ).CompareTo( a( best ) ) > 0 then best = i
    next
    return a( best )
end function

type SortedBag( of K as { IComparable( of K ), IShow }, V )
    ' ...
end type
```

`of T as I` requires the type argument to implement `I`; `of T as { I, J }` requires both. A constraint may name the parameter itself, as `IComparable( of T )` does. It is checked once, where the generic is used, and a type argument that falls short is refused there with one message instead of an error from inside the body:

```freebasic
dim as int32 counts( 0 to 2 ) = { 3, 1, 2 }
print Largest( counts( ) )      '' TKO1022: type argument 'long' does not implement
                                '' 'icomparable( of long )', which 'largest( of t )' requires
```

The argument may implement the interface itself, through its base class, or through an interface that inherits it, or be the interface. A constraint that names a type that is no interface is TKO1002.

**A constraint does not change how the body calls.** `Largest` is still compiled once per T, and `a( i ).CompareTo( … )` is an ordinary call to T's own `CompareTo`: no interface value, no indirect call. The call is resolved by name on the concrete type, so a method that implements `IComparable.CompareTo` under a different name satisfies the constraint but is not reachable as `.CompareTo` inside the body.

**A generic interface** is instantiated like a generic type, and each instance is an interface of its own: `IComparer( of ustring )` and `IComparer( of float64 )` are unrelated. A generic procedure that takes `byval cmp as IComparer( of T )` infers T from an argument that implements one instance of it -- a `ByLength` declared `implements IComparer( of ustring )` gives T = ustring. See [Interfaces](Category-Interfaces) and the [Interfaces Tutorial](Interfaces-Tutorial).

## SELF-REFERENCE, Nesting AND Depth

A generic may refer to itself through a pointer, which is what makes linked structures expressible:

```freebasic
type Node( of T )
    as T v
    as Node( of T ) ptr nxt
end type
```

Nesting a generic in its own type ARGUMENT list is fine and terminates: Box( of Box( of long ) ) resolves the inner instantiation before the outer body is replayed, so it costs no depth.

Depth accrues only when one generic's BODY drives another instantiation.

tiko takes '-maxinstdepth' (default 64), and reports going past it as `TKO0829`:

- **A field's type** is one deeper than the type that holds it: A3 holding a B3 holding a C3 is refused at `-maxinstdepth 2` and accepted at 3.
- **A member or procedure body** is replayed at depth 1 however deep the instantiation that owns it. So what a body names is depth 2 -- refused at 1, accepted at 2 -- and a chain of bodies (A3's body naming B3, whose body names C3) is accepted at 2 as well.
- **A type argument** costs nothing: `Box( of Box( of Box( of int32 ) ) )` is accepted at 1.

tiko reports each one, on the line that asked for the instantiation.

**That rule never stops a runaway.** A member body that instantiates `R( of R( of T ) )` makes a deeper R whose own body does the same, and every body replays at depth 1. tiko also caps the real chain -- the one a body DOES extend -- at 256, or at the limit if that is higher, and reports `TKO0829` there. The runaway stops in about two seconds.

## How It Works

tiko's implementation is in `src/symbols/generic.tiko` and `src/symbols/genericinfer.tiko`.

## Names AND Linkage

Instantiations are mangled Itanium-style, so they demangle to something a human recognises and are byte-identical regardless of declaration order:

```freebasic
$3BoxIiE           ->  Box<int>
$3BoxIdE           ->  Box<double>
$3BoxI3BoxIiEE     ->  Box<Box<int> >
```

Two modules that both write Box( of long ) mean the same type, and each emits the members it reached. tiko emits every instantiated member 'linkonce_odr' in a COMDAT, so the linker keeps one copy. The member symbols carry the names above -- '_ZN3BoxIdE4SETVEd' for the SETV member of Box( of double ) -- and two separately compiled modules that both instantiate Box( of long ) link and run.

## Diagnostics

tiko reports these, one case per file:

| tiko |
| --- |
| `TKO0321: expected a type parameter name` |
| `TKO0322: duplicated type parameter 't'` |
| `TKO0815: 'box' is generic; write its type arguments, as 'box( of ... )'` |
| `TKO0816: 'pair' takes 2 type argument(s), and 1 are written here` |
| `TKO0405: expected 'end OPERATOR'` |
| `TKO0829` -- see SELF-REFERENCE, NESTING AND DEPTH |
| `TKO0809: cannot infer the type arguments of 'make'; write them, as 'make( of ... )( ... )'` |
| `TKO0817: the type parameters written for 'stack.push' do not match its declaration, 'of t'` -- a renamed, extra, missing or reordered parameter |

Inside a generic body tiko reports the offending line and column itself -- `TKO0743: 'nosuchvar' is not declared` at the line that says it -- but without the instantiation chain. An undeclared type named in a generic TYPE's field is `TKO0808` at the field, once the generic is instantiated. One body error it does not report at all: an unknown field written through 'this' in a member body compiles, and the statement using it is left out.

Across the 30 generics `fail-*.bas` files in `tests/vendor/fbc-tests/generics/`, tiko rejects 26 with a diagnostic, compiles 1 with no error, fails 2 only in code generation (an internal compiler error, TKO0993: `fail-container-nohash.bas` and `fail-container-nohash-set.bas`), and rejects `fail-instdepth.bas` with `TKO0829`. Each was compiled to an object. The 1 is `fail-lambda-capture-typaram`: a capturing lambda in a generic body that names T in its own parameter list, which tiko builds.

A diagnostic raised inside an instantiated body -- `IndexOf` over a type with no `operator =` is array.tiko's own comparison failing -- is reported at the line in the generic that fails.

## Known Limits

All measured, none blocking.

- Constraints name interfaces, and nothing else. `of T as IComparable( of T )` can be required; an operator such as '=' cannot. A container member that needs '=' on T makes the whole type unusable for a T without one -- which is why Array's Sort, IndexOf and Contains are free procedures rather than members -- and that diagnostic lands inside the container module at the instantiation site.

- Generic procedures cannot be overloaded. One name, one generic procedure. A second generic procedure of the same name in the same scope, whether it differs in arity, in type-parameter count or in parameter type, is TKO0600 ("'f' is already declared in this scope"). The same name in two different namespaces is fine. This is why the sort library spells its variants SortBy, StableSort and SortList rather than overloading Sort.

- typeof( T ) does not see through a type parameter. An ordinary TYPEDEF is transparent to typeof; the one an instantiation binds is not, so a generic body cannot branch on what T is bound to. This is why the hash contract is an overloaded HashOf( ) rather than an #if dispatch.

- Debug names. Under -g a debugger shows an instantiation's fields, parameters and locals with their types, but names the instantiated type by an internal number rather than by its argument list: `Box( of long )` appears as `box<6>`, and its method's frame as `box<6>.SetV`.

- In a generic body, tiko reports the offending line and column itself. Where the error depends on the type argument, a note names the instantiation that produced it: `note: in instantiation of 'apply( of long )'`.

- Function-template return types are not mangled: `_Z3IncIu7INTEGERES0_` where Itanium wants the return type after the I...E list. Names are unique and stable, which is what is claimed.

## Tests

The `generics/` tests, vendored in tiko-lang at `tests/vendor/fbc-tests/generics/` -- 72 files at the vendored commit.

instantiate-type.bas        instantiation, identity, nesting, UDT arguments member-procs.bas            out-of-line bodies, both parameter orders member-operators.bas        operators, properties, FOR/STEP/NEXT global-operators.bas        generic global operators and their inference generic-procs.bas           explicit and inferred type arguments ctor-dtor.bas               construction, destruction, copy inheritance.bas             all three EXTENDS directions, virtual, RTTI recursive-generic.bas       self-reference through a pointer lambda-in-generic.bas       lambdas and generics in one body -- both token

```freebasic
captures, and every spelling of SUB|FUNCTION that
does not open a block
```

generic-procptr-typearg.bas a procedure pointer as a type argument, from

```freebasic
every scope that can supply one
```

container-sort.bas          introsort, stable sort and the LinkedList sort container-orderedmap.bas    the red-black tree map: every member, the container-orderedset.bas    invariants after every destructive phase, and a

```freebasic
differential stress against the hash versions
```

sizeof-instantiation.bas    layout member-mangling.bas         mangled names are distinct and stable capture-boundary.bas        deferral to the statement boundary multimodule/                two modules instantiating the same generics fail-\*.bas                  one diagnostic per file, with golden output

The fail-*.bas results are under DIAGNOSTICS. tiko's own suite: 25 `tests/mir/generic-*.test` files, `tests/parser/generic-instantiation.test`, `tests/types/generic-union-layout.test`, `tests/types/generic-virtual-slots.test`, and three in `tests/diagnostics/`: `generic-member-missing.test`, `generic-infer.test` (the inference case) and `override-unused-generic.test`.

See also: [For Each](Category-For-Each), for the iterator protocol and FOR EACH; [Array](Category-Array), [Map](Category-Map), [Set](Category-Set) and [LinkedList](Category-LinkedList), the containers.

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
