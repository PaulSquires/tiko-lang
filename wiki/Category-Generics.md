[Home](Home) › [All Categories](Categories) › **Generics**

# Generics

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

```freebasic
type Box( of T )
    as T value
end type

dim b as Box( of long )
b.value = 7

function Max( of T )( byval a as T, byval b as T ) as T
    if a > b then return a
    return b
end function

print Max( 3, 9 )               '' T inferred as INTEGER
print Max( of double )( 1.5, 2.5 )
```

A generic is declared once and compiled once per distinct type-argument list. There is no textual substitution, no macro, and no separate template language: the body is captured as tokens at declaration and replayed through the real parser at instantiation, so the code inside a generic is ordinary FreeBASIC and is diagnosed as such.

This is RFC-0001. FOR EACH (RFC-0003), the iterator protocol (RFC-0002) and the standard containers (RFC-0004) are all built on top of it.

## Why It Exists

Before this, a container that worked for more than one element type had to be written with macros, with ANY PTR, or once per type. All three lose something: a macro has no scope and reports errors at the expansion; ANY PTR discards the type and moves every mistake to run time; copies drift.

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
dim a as Box                    '' error 335
type Bad extends Box            '' error 335
```

## Instantiation AND Identity

An instantiation is created the first time a particular type-argument list is seen, and cached. The SAME argument list always yields the SAME type:

```freebasic
dim b1 as Box( of long )
dim b2 as Box( of long )
b2 = b1                         '' fine -- one type, not two
```

Different argument lists are unrelated types with no conversion between them:

```freebasic
dim c as Box( of double )
c = b1                          '' error 181: Invalid assignment/conversion
```

Type arguments may be anything a type can be: scalars, strings, UDTs, pointers, and other instantiations.

```freebasic
dim n as Box( of Box( of long ) )
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

The list must match the declaration in arity and in NAME. Renaming a parameter in the out-of-line body is error 341, not an alias:

```freebasic
sub Stack( of U ).Push( byval x as U )      '' error 341
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
print Max( of double )( 1.5, 2.5 )      '' explicit
print Max( 3, 9 )                       '' inferred
```

Inference reads the parameter positions only. A type parameter that appears only in the return type is therefore callable but not inferable, which is correct rather than a gap:

```freebasic
function MakeZero( of T )( ) as T
dim z as long = MakeZero( of long )( )
```

When two arguments would bind the same parameter to different types, inference does not pick a winner -- it reports error 340 and asks for the arguments to be written out. An implicit promotion is not a match.

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

Self-assignment operators (+=, -=, ...) must be members, as in plain FreeBASIC:

```freebasic
operator += ( of T )( ... )     '' error 152: Operator must be a member function
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
print ( *r is Der( of long ) )          '' from a Root( of long ) ptr
```

## SELF-REFERENCE, Nesting AND Depth

A generic may refer to itself through a pointer, which is what makes linked structures expressible:

```freebasic
type Node( of T )
    as T v
    as Node( of T ) ptr nxt
end type
```

Nesting a generic in its own type ARGUMENT list is fine and terminates: Box( of Box( of long ) ) resolves the inner instantiation before the outer body is replayed, so it costs no depth.

Depth accrues only when one generic's BODY drives another instantiation. Under fbc the limit is '-maxinstdepth' (default 64); exceeding it is error 339, and a genuinely runaway self-instantiation is usually caught earlier by the forward-reference machinery, so the counter is a backstop.

tiko has no '-maxinstdepth' (it is `TKO0100: unknown option`), and nothing stopped a runaway instantiation. Measured 2026-09-24 at origin/master 50c71751: a member body that instantiates 'R( of R( of T ) )' did not finish compiling under tiko within 120 seconds. (FBC-Modern's `fbc64` crashes on the same file.)

## How It Works

FBC-Modern captures a generic's body as a token chain and replays it through its parser once per distinct type-argument list, at module level. tiko's implementation is its own -- `src/symbols/generic.bas` and `src/symbols/genericinfer.bas` -- and it is measured against fbc's behaviour, not built from fbc's design: see TESTS.

## Names AND Linkage

Instantiations are mangled Itanium-style, so they demangle to something a human recognises and are byte-identical regardless of declaration order:

```freebasic
$3BoxIiE           ->  Box<int>
$3BoxIdE           ->  Box<double>
$3BoxI3BoxIiEE     ->  Box<Box<int> >
```

Two modules that both write Box( of long ) mean the same type, and each emits the members it reached. tiko emits every instantiated member 'linkonce_odr' in a COMDAT, so the linker keeps one copy. Measured 2026-09-24 at origin/master 50c71751: the member symbols carry the names above -- '_ZN3BoxIdE4SETVEd' for the SETV member of Box( of double ) -- exactly as fbc spells them, and two separately compiled modules that both instantiate Box( of long ) link and run. fbc keeps a private copy per module instead (see KNOWN LIMITS).

## Diagnostics

fbc (FBC-Modern's `fbc64` 1.20.0) reports:

```freebasic
error 333: Expected type parameter name
error 334: Duplicated type parameter
error 335: Generic used without a type argument list
error 336: Wrong number of type arguments
error 337: Type argument list given for something that is not generic
error 338: Unbalanced block in generic body
error 339: Generic instantiation too deep
error 340: Unable to infer type arguments, specify them explicitly
error 341: Type parameter list does not match the generic's declaration
```

Everything else is an ordinary FreeBASIC diagnostic, reported from the replayed body and followed by the instantiation chain that reached it, so it is possible to see which type argument caused it:

```freebasic
box.bas(13) error 14: Expected identifier, found 'Wdiget'
  in instantiation of 'Box( of long )'
  required from box.bas(18)
```

tiko reports its own ids, and fewer of these. Measured 2026-09-24 at origin/master 50c71751, one case per file:

| fbc | tiko |
| --- | --- |
| 333 | `TKO0321: expected a type parameter name` |
| 334 | `TKO0322: duplicated type parameter 't'` |
| 335 | `TKO0815: 'box' is generic; write its type arguments, as 'box( of ... )'` (2026-09-25) |
| 336 | `TKO0816: 'pair' takes 2 type argument(s), and 1 are written here` (2026-09-25) |
| 338 | `TKO0405: expected 'end OPERATOR'` |
| 339 | none -- the runaway case did not finish; see SELF-REFERENCE, NESTING AND DEPTH |
| 340 | `TKO0809: cannot infer the type arguments of 'make'; write them, as 'make( of ... )( ... )'` |
| 341 | `TKO0817: the type parameters written for 'stack.push' do not match its declaration, 'of t'` -- a renamed, extra, missing or reordered parameter (2026-09-25) |

(337 has no case: FBC-Modern declares the message but no code raises it.)

Inside a generic body tiko reports the offending line and column itself -- `TKO0743: 'nosuchvar' is not declared` at the line that says it -- but without the instantiation chain. An undeclared type named in a generic TYPE's field ('Wdiget' above) is `TKO0808` at the field, once the generic is instantiated (2026-09-25). One body error it does not report at all: an unknown field written through 'this' in a member body (fbc's error 18) compiles, and the statement using it is left out.

Across fbc's 30 generics `fail-*.bas` files, tiko rejects 21 with a diagnostic of its own, compiles 6 with no error, fails 2 only in code generation (an internal compiler error, TKO0993: `fail-container-nohash.bas` and `fail-container-nohash-set.bas`), and refuses `fail-instdepth.bas` for its `#cmdline "-maxinstdepth 2"`. Measured 2026-09-25 by compiling each to an object; the 6 are `fail-foreach-byref`, `fail-foreach-nextvar`, `fail-globalop-conflict`, `fail-infer-mixed-promotion`, `fail-lambda-capture-typaram` and `fail-result-nodefaultctor`.

A diagnostic raised inside an instantiated body -- `IndexOf` over a type with no `operator =` is fb/array.bi's own comparison failing -- is reported at the line in the generic that fails. fbc reports it too, on its own line numbering of the instantiation.

## Known Limits

All measured, none blocking.

- No constraints on type parameters. A member that needs '=' on T makes the

```freebasic
whole type unusable for a T without one -- which is why Array's Sort,
IndexOf and Contains are free procedures rather than members. The
diagnostic lands inside the container header at the instantiation site,
which is honest but not friendly. This is the strongest practical argument
for adding constraints later; four fail-container-* tests pin the current
behaviour.
```

- Generic procedures cannot be overloaded. One name, one generic procedure:

```freebasic
a second one is error 4, Duplicated definition, whether it differs in
arity, in type-parameter count or in parameter type. This is why the sort
library spells its variants SortBy, StableSort and SortList rather than
overloading Sort.
```

- Under fbc, a CAPTURING lambda cannot name the enclosing generic's type

```freebasic
parameter in its own parameter list -- error 59, at parameter 1 of
__FBINVOKE; fail-lambda-capture-typaram.bas pins it. tiko ACCEPTS it and runs
it correctly (measured 2026-09-24 at origin/master 50c71751: 'sub[ byref
total ]( byval v as T )' inside 'Outer( of T )' stores 5 for a long and 2.5
for a double), so code that relies on this builds with tiko and not with fbc.
```

- typeof( T ) does not see through a type parameter. An ordinary TYPEDEF is

```freebasic
transparent to typeof; the one an instantiation binds is not, so a generic
body cannot branch on what T is bound to. This is why the hash contract is
an overloaded HashOf( ) rather than an #if dispatch.
```

- fbc keeps one private copy of each instantiation per module. tiko does

```freebasic
not: it emits every instantiated member 'linkonce_odr' in a COMDAT and the
linker keeps one (measured 2026-09-24 at origin/master 50c71751 with
--emit-ir; two separately compiled modules instantiating Box( of long ) link
and run). See NAMES AND LINKAGE.
```

- Debug names. Under fbc every instantiation of Box reports as 'Box' to the

```freebasic
debugger, so GDB sees N distinct types sharing one name. tiko's -g describes
no types at all -- measured 2026-09-24 at origin/master 50c71751, its
--emit-ir output holds no DICompositeType -- and names each instantiated
procedure by its mangled symbol, e.g. _ZN3BoxIiE4SETVEi.
```

- Under fbc, in-body line numbers point at the body's opening line, not the

```freebasic
offending line inside it, and the instantiation chain supplies the detail.
tiko reports the offending line and column itself, without the chain -- and
some errors inside a generic body it does not report at all (see
DIAGNOSTICS).
```

- Function-template return types are not mangled: '\_Z3IncIiEi' where Itanium

```freebasic
wants the return type after the I...E list. Names are unique and stable,
which is what is claimed.
```

- A type parameter cannot be named K. Plain FreeBASIC already rejects a

```freebasic
TYPEDEF named K used as a parameter type; this is not a generics rule, but
it is met most often here. Names also collide case-insensitively, so a
parameter T and a variable t are the same identifier.
```

## Tests

fbc's `generics/` tests, vendored in tiko-lang at `tests/vendor/fbc-tests/generics/` -- 72 files at the vendored commit.

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

One caveat on member-mangling.bas: since instantiations became module-private, an exact-mangled-name link assertion is no longer expressible. The test still catches a COLLAPSE -- two instantiations sharing a name -- but would not catch a drift to a different, still-distinct scheme.

Under tiko, measured 2026-09-24 at origin/master 50c71751: `build/runscan.sh` (2026-09-20) has every in-scope run program of the corpus -- generics/ included -- byte-identical to fbc's build, and the fail-*.bas results are under DIAGNOSTICS. tiko's own suite: 25 `tests/mir/generic-*.test` files, `tests/parser/generic-instantiation.test`, `tests/types/generic-union-layout.test`, `tests/types/generic-virtual-slots.test`, and three in `tests/diagnostics/`: `generic-member-missing.test`, `generic-infer.test` (the 340 case) and `override-unused-generic.test`.

See also: docs/for_each/iterator-protocol.txt   the RFC-0002 contract docs/for_each/for-each.txt            RFC-0003 docs/array|map|set|linkedlist/        RFC-0004, written entirely in FB

---

**Source:** `docs/generics/generics.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
