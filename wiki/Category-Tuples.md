[Home](Home) › [All Categories](Categories) › **Tuples**

# Tuples

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

```freebasic
declare function MinMax( a( ) as long ) as (min as long, max as long)

var (lo, hi) = MinMax( arr( ) )

dim p as (long, string) = (3, "hi")
dim q as (long, string) = (3, "hi")
print p = q                          ' true
```

A tuple is an anonymous aggregate spelled '(T, U)' in any type position and '(a, b)' in any expression position. No '#include', no namespace, no runtime support -- it is a language feature.

## Why It Exists

FreeBASIC could not return two values. Every function that needed to picked one of three workarounds, and all three are worse than the problem:

```freebasic
declare sub MinMax1( a( ) as long, byref lo as long, byref hi as long )

type MinMaxResult                    ' a TYPE used in exactly one place
    as long lo, hi
end type
declare function MinMax2( a( ) as long ) as MinMaxResult

dim shared as long g_lo, g_hi        ' the honest version of the same thing
declare sub MinMax3( a( ) as long )
```

An out-parameter cannot be used in an expression and cannot be const. A one-off TYPE has to be named, declared somewhere, and then read by whoever calls the function. A shared global is not re-entrant.

## The Type

```freebasic
dim p as (long, string)
dim q as (single, single, single)
dim n as ((long, long), string)      ' elements nest
type Pair as (long, string)          ' a typedef, if you want a name

declare function f( ) as (long, long)
declare sub g( byval p as (long, long) )
declare sub h( byref p as (long, long) )
```

Minimum arity is TWO. '(long)' is a syntax error, not a 1-tuple -- see NO 1-TUPLES below.

The fields are named '\_1' through '\_N':

```freebasic
p._1 = 3
p._2 = "hi"
print p._1, p._2
```

Layout is the layout of the equivalent hand-written TYPE -- same size, same offsets, same alignment -- because a tuple IS an ordinary UDT underneath. A STRING element is constructed, copied and destroyed exactly as a STRING field is.

## Element Names Are Documentation

An element may carry a name, and the name is checked for duplicates within the declaration and then DISCARDED:

```freebasic
dim r as (min as long, max as long) = (1, 9)
print r._1, r._2                     ' correct
print r.min                          ' error: unknown field
```

They document a signature. They are not accessors, and they are not part of the type -- see below. The way to get named access is to destructure, which is the common case anyway:

```freebasic
var (lo, hi) = MinMax( arr( ) )
```

## Identity Is Structural

Two tuple types are THE SAME TYPE when they have the same element types in the same order. How they are spelled, and what the elements are called, never enters:

```freebasic
dim a as (long, long)
dim b as (min as long, max as long)
dim c as (lo  as long, hi  as long)
type Pair as (long, long) : dim d as Pair
type MyLong as long       : dim e as (MyLong, MyLong)
```

All five are one type, mutually assignable, and one interned symbol program-wide. This is C#'s rule, not Nim's -- Nim makes field names part of tuple equivalence.

THE CONSEQUENCE, STATED PLAINLY: a tuple cannot give you nominal type safety. If '(long, long)' meaning a screen coordinate must be rejected where '(long, long)' meaning min/max is expected, a tuple is the wrong tool and a TYPE is the right one. Tuples are for values grouped by position at a call boundary, not for domain types.

## The Literal

A parenthesised comma list of two or more expressions:

```freebasic
dim t as (long, string) = (3, "hi")
t = (4, "bye")
return (lo, hi)
Consume( (1, 2) )                    ' ONE argument, of type (long, long)
```

Elements are evaluated left to right, exactly once each.

## A Literal Adapts To Its Target; Two Tuples Do NOT Convert

```freebasic
dim t as (double, string) = (1, "hi")        ' 1 -> 1.0, "hi" -> STRING
dim u as (long, long) = (cshort(1), cbyte(2))

function f( ) as (double, string)
    return (0, "")                           ' converts per element
end function
```

...but two tuple VALUES of different types do not convert:

```freebasic
dim a as (long, long)
dim b as (double, double) = a                ' error: type mismatch
```

The literal is not converted -- it is BUILT AT the target type, each element converted as it is stored into its field. That works in the four places the target type is known: assignment, DIM initialisation, RETURN, and a call argument.

Arity is never inferred and never padded, in any direction:

```freebasic
dim v as (long, long) = (1, 2, 3)    ' error 370
```

THE ONE LIMITATION: a NESTED literal is not context-typed. The outer literal's elements are parsed before the outer target type has been applied, so an inner literal sees only whatever context was already open. Where the inner elements' natural types already fit this is invisible:

```freebasic
dim ok as ((double, double), long) = ((1, 2), 3)      ' fine
```

Where they do not, it fails -- a string LITERAL is not a STRING:

```freebasic
dim n as ((long, string), long) = ((1, "x"), 3)       ' error
```

Build the inner tuple first:

```freebasic
dim inner as (long, string) = (1, "x")
dim n as ((long, string), long) = (inner, 3)
```

This is pinned by a golden test so it cannot change by accident. Lifting it would mean putting speculative state on the hottest parse path in the language, for a case with a one-line workaround.

## Destructuring

Two forms. 'var' declares; the bare paren list assigns.

```freebasic
var (lo, hi) = MinMax( arr( ) )      ' declares lo and hi, infers both

dim x as long, y as string
(x, y) = GetPair( )                  ' assigns to existing lvalues
```

'var (…)' takes plain identifiers only -- no AS clause, no subscripts, no SHARED, no STATIC. It is a declaration, not an lvalue list. Scoping and shadowing follow the ordinary VAR rules.

The assigning form takes ANY lvalue:

```freebasic
(h.tag, h.label) = (7, "seven")
(arr(2), arr(3)) = (8, 9)
(*p, arr(2))     = (10, 11)
```

THE RIGHT-HAND SIDE IS EVALUATED ONCE, and bound before any target is written, which is what makes this a swap rather than a copy:

```freebasic
(a, b) = (b, a)                      ' a and b are swapped
```

Targets are assigned left to right. Overlap is NOT diagnosed: '(a, a) = f( )' assigns '\_1' then '\_2' to the same variable and leaves '\_2'. Detecting that in the presence of 'arr(i)' and '\*p' targets is not decidable, and FB does not diagnose aliasing assignments generally.

Arity must match EXACTLY in both directions -- too many targets is error 266, too few is error 370.

The right-hand side must be a tuple. A plain UDT is error 371:

```freebasic
(n1, n2) = someUdt                   ' error 371: Expected a tuple
```

LET IS UNCHANGED. 'LET(a, b) = anyUdt' still walks any UDT's fields in declaration order, still checks only the too-many direction, and now also accepts a tuple, since a tuple is a UDT. Positional unpacking of a NAMED type stays LET-only on purpose: reordering that type's fields silently changes what every unpack site means, and that is not a failure mode worth spreading. tiko implements only `#lang "fb"`, where both forms work.

## FOR EACH (k, v)

A collection whose iterator's Value( ) returns a tuple can be walked with the element destructured in place:

```freebasic
for each (k, v) in m.Pairs( )
    print k, v
next
```

The element is bound once and each name is declared from one field of it, so this is the ordinary FOR EACH lowering with a destructure on top. Both names are copies.

Neither AS nor BYREF is accepted on the list form. One type cannot describe elements that differ, per-name types would spell out what the tuple already says, and binding the whole element by reference is what 'for each byref e' already does. Use that and reach through '\_1' / '\_2' if you need a reference.

The element must be a tuple and the name count must match its arity; both are diagnosed.

## Equality, AND No Ordering

'=' and '<>' work element-wise:

```freebasic
t = u    is    t._1 =  u._1  andalso  t._2 =  u._2  andalso  …
t <> u   is    t._1 <> u._1  orelse   t._2 <> u._2  orelse   …
```

'<>' is deliberately NOT built as 'not (t = u)'. With a NaN element that would be wrong; building both chains directly gives IEEE behaviour per element for free.

THE COMPARISON SHORT-CIRCUITS, THE OPERANDS DO NOT. '(F(1), F(2)) = (F(3), F(4))' makes all four calls -- they are the elements of two literals, and a literal evaluates every element exactly once -- and only then compares, stopping at the first mismatch.

Both sides must be the SAME tuple type, which after structural interning is a pointer comparison. Different arity, or the same arity with different element types, is a type mismatch: a comparison supplies no target type, so nothing context-types anything.

```freebasic
dim x1 as (long, long)
dim x2 as (double, double)
print (x1 = x2)                      ' error 20: Type mismatch
```

Every element type must support '='. A UDT element without one fails with that UDT's own diagnostic, at the element.

A user-written global 'operator =' over a tuple type WINS over the built-in chain -- the built-in is tried after ordinary overload resolution, not before.

'<', '<=', '>' and '>=' are NOT defined. Lexicographic order is only sometimes what the writer meant, and when it is not, the code still compiles and silently sorts wrong; equality has no such ambiguity. It is a pure addition if it is ever wanted. Write the comparison you mean:

```freebasic
if a < b orelse (a = b andalso c < d) then
```

## No 1-TUPLES

'(x)' is a grouped expression, permanently. There is no '(x,)'.

This is not an oversight. '(a) = 5' is legal today, and 'Consume( (a) )' is the established idiom for forcing a byval copy at a byref parameter. A 1-tuple spelling would put a second meaning on '(x)' and add a trailing-comma escape to a language that has never needed one.

Arity 0 is not spellable either -- '()' has no use without a unit type.

## What Is NOT Spellable

```freebasic
print sizeof( (long, string) )       ' error
dim x as typeof( (long, string) )    ' error
const c as (long, long) = 0          ' error 14: Expected identifier
type Derived extends (long, long)    ' error 14: Expected identifier
```

SIZEOF, LEN and TYPEOF decide "type or expression?" BEFORE parsing the argument, and then rely on being able to retry the same tokens as an expression if the type parse fails without consuming anything. The tuple arm cannot make that promise, and lookahead cannot rescue it: the lexer offers three tokens, and '( Foo ptr, long )' needs three just to reach the comma. Use a typedef:

```freebasic
type P as (long, string)
print sizeof( P )
```

EXTENDS is excluded because a tuple has no vtable, no RTTI and no identity to inherit; CONST is excluded because there is nothing a tuple constant could be initialised from. Both simply never opt in to the tuple type syntax, so they report the ordinary "expected identifier". 'expr IS T' is excluded too, and reports error 299.

PRINT of a whole tuple is a deliberate error 24, not an inherited one:

```freebasic
print t                              ' error 24: Invalid data types
print t._1, t._2                     ' say what you mean
```

An element-wise PRINT was considered and rejected -- 'print (a, b)' would then be indistinguishable at a glance from 'print a, b', and the ';' and USING forms would each need a rule. WRITE, LPRINT and the file-I/O quirks behave identically.

## Element Types

Accepted: every scalar, STRING, USTRING, ANY PTR, ZSTRING PTR, function pointers, forward-referenced POINTERS, UDTs with constructors and destructors, and nested tuples.

Rejected, with error 369:

```freebasic
ANY                     has no size; nothing could be stored
STRING * n              the '* n' suffix has no positional spelling
a dynamic array         a field cannot be one without a descriptor pairing
a non-pointer forward reference     the type must be complete when interned
```

Only the FIRST bad element in a list is reported -- fbc's one-error-per- statement filter suppresses the rest. Parsing continues past a bad element so the list is consumed, not so that every element gets its own message.

There is no upper bound on arity.

## Nothing That Compiles Today Changes Meaning

'(' already meant three things in FreeBASIC -- a grouped expression, a call argument list, an array subscript list -- and a comma is already legal inside one of them. Every one of these still compiles and still means what it meant:

```freebasic
(a) = 5                              ' parenthesised lvalue
(*p) = 5
(arr(1,1)) = 5
(x).f = 1
s1( (a) )                            ' the byval-override idiom
s2 (1, 2)                            ' paren-less call: TWO arguments
(pfn)( b )                           ' function-pointer call
print (a)
print sizeof( (a) )
print arr(1, 2)
pset (10, 20)
line (0, 0)-(10, 10)
circle (10, 10), 5
```

Call argument lists and subscript lists never reach the expression parser's paren handler at all, and the graphics quirks match their own '('. That leaves the grouped expression and the paren-less call, and both go through one function which parses the FIRST element before it has to decide anything -- so the fourth meaning is separated with NO lookahead and NO backtracking. A comma is a tuple only when the parens could not belong to a paren-less call, and only when the surrounding context is not demanding some other type.

What changes is exactly the set of programs that were errors:

```freebasic
(a, b) = (1, 2)          was error 7    now destructuring
Consume( (1, 2) )        was error 7    now one tuple argument
if (a, b) = (c, d)       was error 7    now element-wise comparison
print (a, b)             was error 7    now a deliberate error 24
```

## Dialects

tiko implements `#lang "fb"` only -- `#lang "qb"` is `TKO0317: unsupported language mode 'qb'` -- so under tiko the dialect question does not arise.

Under fbc the whole feature is available in all four dialects, and nothing about it is dialect-gated. There, TUPLES DO NOT CROSS DIALECTS: '-lang qb' forces align = 1, so '(long, string)' has a different size, and possibly a different return classification, in QB than in fb -- while mangling to the SAME name. Linking a '-lang qb' object against a '-lang fb' one through a tuple-typed signature is silently wrong, and fbc documents this rather than enforcing it.

## Separate Compilation

Two modules that both mention '(long, string)' must produce the same external symbol, or a tuple-returning function cannot be called across a module boundary. Nothing is shared between them and nothing is written to disk: each module RE-DERIVES the name from the element types alone.

That is why the name is a pure function of the element types and of nothing else -- not a counter, not declaration order, not the compilation order, and not element names:

```freebasic
(long, long)            -> 8FBTUPLE2IiiE
(long, string)          -> 8FBTUPLE2Ii8FBSTRINGE
((long,long), string)   -> 8FBTUPLE2I8FBTUPLE2IiiE8FBSTRINGE
```

So the two sides may spell the element names differently, or not at all, and still link.

## Diagnostics

fbc (FBC-Modern's `fbc64` 1.20.0) reports:

```freebasic
error 367: A tuple needs at least two elements
error 368: Duplicated tuple element name
error 369: Invalid tuple element type
error 370: Tuple element count does not match
error 371: Expected a tuple
```

and three pre-existing ones that a tuple can now reach: error 266 (too many elements, destructuring), error 24 (PRINT of a tuple), error 20 (comparing two different tuple types).

tiko reports almost none of these yet. Measured 2026-09-24 at origin/master 50c71751 against the twenty cases of fbc's own `errors/tuple-errors.bas` (vendored in tiko-lang under `tests/vendor/fbc-tests/`), one case per file: tiko rejects three -- an unterminated element list and `var (arr(1), b) = ...` (`TKO0401: expected ')'`), and a tuple constant (`TKO0748: a constant cannot have the type of 'c'`) -- and compiles the other seventeen with no diagnostic. Among them are a 1-tuple, a duplicated element name, ANY and fixed-length-string elements, `extends (long, long)`, SIZEOF and TYPEOF of a tuple type, arity mismatches in both directions, destructuring a UDT or a scalar, and `<` or `=` between tuples. `print (a, b)` compiles too. In six of these -- SIZEOF, too many targets, destructuring a scalar, `<`, `=` between two different tuple types, and `print (a, b)` -- `--dump-ir` reports the statement as not lowered: it is silently left out of the program. fbc's rejections are the intended behaviour; do not rely on tiko accepting any of these.

## Implementation

tiko's implementation is its own, in its type table and its MIR lowering; none of FBC-Modern's symbol-table or parser code is involved.

tiko mangles a tuple type as fbc does, as SEPARATE COMPILATION above says: an instantiation of 'FBTUPLE<N>', its element types the arguments. Measured 2026-09-24, every procedure and member name tiko emits for (long, long), (long, string), ((long, string), long), (Counted, long) and (integer, integer) is byte-identical to fbc's object file. Two separately compiled tiko modules sharing a namespaced procedure over '(Pt, long)', with Pt declared in a different order in each, link and run. So does a tiko module against an fbc-built one for -target win64. Before, tiko named a tuple by its own type-table indices ('8$TUP:6:6'), which are per-module numbers, and both of those links failed.

The design documents are FBC-Modern's: C:\\dev\\docs\\tuple -- README.md and RFC-0001 through RFC-0004.

## Tests

fbc's `tuple/` tests, vendored in tiko-lang at `tests/vendor/fbc-tests/tuple/`:

basic.bas          every accepted element kind; '\_1'..\_N read and write; a

```freebasic
tuple as a field, an array element, a byval and a byref
parameter, and a result. SIZE AND FIELD OFFSETS ARE
ASSERTED AGAINST THE EQUIVALENT HAND-WRITTEN TYPE rather
than against hardcoded numbers, which would only test win64.
```

identity.bas       named, differently-named, unnamed, typedef'd and

```freebasic
alias-elemented spellings are one type. Every assignment IS
the assertion -- distinct types would not compile.
```

literal.bas        construction in all four context-typed positions;

```freebasic
left-to-right single evaluation with call counts asserted;
nesting; and DESTRUCTION BALANCE with a counting element
type, which is the half that is invisible with scalar data.
```

dtor.bas           ctor/dtor counts for a tuple of STRING and of a UDT with a

```freebasic
destructor, including temporaries.
```

destructure.bas    both forms against all three shapes of right-hand side --

```freebasic
variable, literal, call; field / array / deref targets;
the swap; a call evaluated exactly once; per-element
conversion; a STRING element surviving as an independent
copy; a loop with no accumulation; and LET unchanged.
```

equality.bas       '=' and '<>' over scalar, STRING, pointer and nested

```freebasic
elements; equality across two differently-named
declarations; a NaN element -- 't = u' false AND 't <> u'
true, which is what breaks if '<>' is built as 'not (=)';
short-circuit proven with a counting element type.
```

equality-overload  a user-declared global 'operator =' wins. for-each.bas       'for each (k, v)' over a collection whose Value( ) returns

```freebasic
a tuple with a STRING element -- the shape a real map has,
and the shape that found the TYPE-body crash above.
```

no-regress.bas     COMPILE_ONLY: every line of the "nothing changes meaning"

```freebasic
list above. This file gates the literal.
```

tuple-mm-\*.bas     MULTI-MODULE: the mangling test. One module defines the

```freebasic
tuple-returning functions, the other declares them WITH
DIFFERENT element names and calls them. Only a
link-compatible name passes.
```

`tests/vendor/fbc-tests/errors/tuple-errors.bas` is fbc's golden file for every diagnostic, and also PINS THE TWO DOCUMENTED LIMITATIONS -- 'sizeof( (long, string) )' and the nested literal -- so they cannot change by accident.

`errors/tuple-foreach-errors.bas`, beside it, covers the 'for each (k, v)' diagnostics. AS and BYREF on the list form get a file each: they are rejected while the binding is still being read, before the FOR compound is pushed, so the error skip leaves the following 'next' orphaned and suppresses every later diagnostic in the same file.

fbc's fblite/tuple.bas, qb/tuple.bas and deprecated/tuple.bas run the destructuring forms in the three dialects that never had 'LET(a, b) ='. They are outside tiko's scope, which is `#lang "fb"` only.

Under tiko, measured 2026-09-24 at origin/master 50c71751: basic, identity, literal, dtor, destructure, equality, equality-overload and for-each build and run with exit 0 and the same output as fbc's builds; no-regress.bas compiles; and the two-module tuple-mm-main.bas + tuple-mm-a.bas builds and runs clean when both files are given to one `tiko` invocation (see IMPLEMENTATION for separate compilation). `build/runscan.sh` (2026-09-20) has every in-scope run program of the corpus byte-identical to fbc's builds. tiko's own suite: `tests/types/tuple-type.test` and eight `tests/mir/tuple-*.test` files. What tiko does NOT yet match is the diagnostics -- see DIAGNOSTICS.

---

**Source:** `docs/tuples/tuples.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
