[Home](Home) › [All Categories](Categories) › **Tuples**

# Tuples

```freebasic
declare function MinMax( a( ) as int32 ) as (min as int32, max as int32)

var (lo, hi) = MinMax( arr( ) )

dim p as (int32, ustring) = (3, "hi")
dim q as (int32, ustring) = (3, "hi")
print p = q                          ' true
```

A tuple is an anonymous aggregate spelled '(T, U)' in any type position and '(a, b)' in any expression position. No '#include', no namespace, no runtime support -- it is a language feature.

## Why It Exists

FreeBASIC could not return two values. Every function that needed to picked one of three workarounds, and all three are worse than the problem:

```freebasic
declare sub MinMax1( a( ) as int32, byref lo as int32, byref hi as int32 )

type MinMaxResult                    ' a TYPE used in exactly one place
    as int32 lo, hi
end type
declare function MinMax2( a( ) as int32 ) as MinMaxResult

dim shared as int32 g_lo, g_hi        ' the honest version of the same thing
declare sub MinMax3( a( ) as int32 )
```

An out-parameter cannot be used in an expression and cannot be const. A one-off TYPE has to be named, declared somewhere, and then read by whoever calls the function. A shared global is not re-entrant.

## The Type

```freebasic
dim p as (int32, ustring)
dim q as (float32, float32, float32)
dim n as ((int32, int32), ustring)     ' elements nest
type Pair as (int32, ustring)         ' a typedef, if you want a name

declare function f( ) as (int32, int32)
declare sub g( byval p as (int32, int32) )
declare sub h( byref p as (int32, int32) )
```

Minimum arity is TWO. '(long)' is a syntax error, not a 1-tuple -- see NO 1-TUPLES below.

The fields are named '\_1' through '\_N':

```freebasic
p._1 = 3
p._2 = "hi"
print p._1, p._2
```

Layout is the layout of the equivalent hand-written TYPE -- same size, same offsets, same alignment -- because a tuple IS an ordinary UDT underneath. A STRING element is constructed, copied and destroyed exactly as a STRING field is.

## Element Names

An element may carry a name. The name is checked for duplicates within the declaration.

Under tiko the name also reaches its element:

```freebasic
function GetRect( ) as (tl as (x as int32, y as int32), br as (x as int32, y as int32))
    return ((100, 200), (300, 400))
end function

var r = GetRect( )
print r.tl.x, r.tl.y                 ' 100  200
print r._1._1, r._1._2               ' the same elements
```

Code can also use `_1`..`_N`, or destructure:

```freebasic
var (lo, hi) = MinMax( arr( ) )
```

THE NAMES ARE NOT PART OF THE TYPE. `(min as int32, max as int32)` and `(int32, int32)` are still one type -- see below -- with one layout and one mangled name. The names travel with the DECLARATION that an expression reaches, which is C#'s rule:

```freebasic
type Pt as (x as int32, y as int32)

dim a as Pt = (1, 2)
dim b as (lo as int32, hi as int32) = a    ' one type, so assignable
print b.lo, a.x                          ' each read with its own declaration's names
```

- a variable, parameter or field takes the names in its own type, through a typedef or a pointer (`p->x`);
- `var r = f( )` takes the names of f's result;
- a call's result is named by the function's declaration: `GetRect( ).br.y`;
- an array element takes the array's element names: `arr( 1 ).x`;
- a WITH block's `.name` uses the names of the WITH subject.

A POSITIONAL NAME ALWAYS WINS. Over `(_2 as int32, _1 as int32)`, `t._1` is the FIRST element.

What carries no names, so only `_1`..`_N` reach its elements:
- a tuple LITERAL -- `(lo, hi)` does not name its elements after the variables;
- a `for each` loop variable, an IIF or cast result, and a tuple written inside a generic template.

An unknown name is TKO0739.

## Identity Is Structural

Two tuple types are THE SAME TYPE when they have the same element types in the same order. How they are spelled, and what the elements are called, never enters:

```freebasic
dim a as (int32, int32)
dim b as (min as int32, max as int32)
dim c as (lo  as int32, hi  as int32)
type Pair as (int32, int32) : dim d as Pair
type MyLong as int32      : dim e as (MyLong, MyLong)
```

All five are one type, mutually assignable, and one interned symbol program-wide. This is C#'s rule, not Nim's -- Nim makes field names part of tuple equivalence.

THE CONSEQUENCE, STATED PLAINLY: a tuple cannot give you nominal type safety. If '(long, long)' meaning a screen coordinate must be rejected where '(long, long)' meaning min/max is expected, a tuple is the wrong tool and a TYPE is the right one. Tuples are for values grouped by position at a call boundary, not for domain types.

## The Literal

A parenthesised comma list of two or more expressions:

```freebasic
dim t as (int32, ustring) = (3, "hi")
t = (4, "bye")
return (lo, hi)
Consume( (1, 2) )                    ' ONE argument, of type (long, long)
```

Elements are evaluated left to right, exactly once each.

## A Literal Adapts To Its Target; Two Tuples Do NOT Convert

```freebasic
dim t as (float64, ustring) = (1, "hi")       ' 1 -> 1.0, "hi" -> USTRING
dim u as (int32, int32) = (cshort(1), cbyte(2))

function f( ) as (float64, ustring)
    return (0, "")                           ' converts per element
end function
```

...but two tuple VALUES of different types do not convert:

```freebasic
dim a as (int32, int32)
dim b as (float64, float64) = a                ' error: type mismatch
```

The literal is not converted -- it is BUILT AT the target type, each element converted as it is stored into its field. That works in the four places the target type is known: assignment, DIM initialisation, RETURN, and a call argument.

Arity is never inferred and never padded, in any direction:

```freebasic
dim v as (int32, int32) = (1, 2, 3)    ' error 370
```

THE ONE LIMITATION: a NESTED literal is not context-typed. The outer literal's elements are parsed before the outer target type has been applied, so an inner literal sees only whatever context was already open. Where the inner elements' natural types already fit this is invisible:

```freebasic
dim ok as ((float64, float64), int32) = ((1, 2), 3)      ' fine
```

Where they do not, it fails -- a string LITERAL is not a STRING:

```freebasic
dim n as ((int32, string), int32) = ((1, "x"), 3)       ' error
```

Build the inner tuple first:

```freebasic
dim inner as (int32, string) = (1, "x")
dim n as ((int32, string), int32) = (inner, 3)
```

This is pinned by a golden test so it cannot change by accident. Lifting it would mean putting speculative state on the hottest parse path in the language, for a case with a one-line workaround.

## Destructuring

Two forms. 'var' declares; the bare paren list assigns.

```freebasic
var (lo, hi) = MinMax( arr( ) )      ' declares lo and hi, infers both

dim x as int32, y as ustring
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
dim x1 as (int32, int32)
dim x2 as (float64, float64)
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
print sizeof( (int32, string) )       ' error
dim x as typeof( (int32, string) )    ' error
const c as (int32, int32) = 0          ' error 14: Expected identifier
type Derived extends (int32, int32)    ' error 14: Expected identifier
```

SIZEOF, LEN and TYPEOF decide "type or expression?" BEFORE parsing the argument, and then rely on being able to retry the same tokens as an expression if the type parse fails without consuming anything. The tuple arm cannot make that promise, and lookahead cannot rescue it: the lexer offers three tokens, and '( Foo ptr, long )' needs three just to reach the comma. Use a typedef:

```freebasic
type P as (int32, string)
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

Only the FIRST bad element in a list is reported; the rest are suppressed. Parsing continues past a bad element so the list is consumed, not so that every element gets its own message.

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

## Separate Compilation

Two modules that both mention '(long, string)' must produce the same external symbol, or a tuple-returning function cannot be called across a module boundary. Nothing is shared between them and nothing is written to disk: each module RE-DERIVES the name from the element types alone.

That is why the name is a pure function of the element types and of nothing else -- not a counter, not declaration order, not the compilation order, and not element names:

```freebasic
(int32, int32)            -> 8FBTUPLE2IiiE
(int32, string)          -> 8FBTUPLE2Ii8FBSTRINGE
((int32,int32), string)   -> 8FBTUPLE2I8FBTUPLE2IiiE8FBSTRINGE
```

So the two sides may spell the element names differently, or not at all, and still link.

## Diagnostics

tiko reports:
- an unterminated element list, and `var (arr(1), b) = ...` (`TKO0401: expected ')'`);
- a tuple constant (`TKO0748: a constant cannot have the type of 'c'`);
- a 1-tuple (`TKO0821`), a duplicated element name (`TKO0822`), and an ANY or fixed-length-string element (`TKO0823`) -- only the first problem in a list reported;
- `extends (int32, int32)` (`TKO0824`; a typedef of a tuple after `extends` compiles);
- destructuring with too few or too many targets, and `var (a, b)` of the wrong arity (`TKO0825`), over a UDT or a scalar (`TKO0826`), and `var (a) = 1` (`TKO0821`). `let ( a, b ) = udt` is FreeBASIC's multiple assignment, which takes a UDT's fields in order, and is accepted;
- `<`, `>`, `<=` and `>=` on tuples, and `=` or `<>` between two DIFFERENT tuple types -- `(int32, int32)` against `(float64, float64)`, against the literal `(1, 2)`, which is `(integer, integer)`, or against a scalar (`TKO0720`). One tuple type on both sides compares.

tiko compiles three cases with no diagnostic: SIZEOF and TYPEOF of a tuple type, and a nested tuple literal that is not context-typed.

`print (a, b)` compiles too. SIZEOF and `print (a, b)` are silently left out of the program (`--dump-ir` reports them as not lowered).

A tuple element whose value is of ANOTHER type is converted by the element type's own `operator let`, over an element that has already been constructed -- `return ( wszKLID, bRes )` out of a function `as (DVARIANT, BOOLEAN)` takes DVARIANT's `let` from a wstring. Without a `let` that takes the value, tiko refuses the element with `TKO0831`. A `let` from a `int32` takes a `float64` and not a string; a constructor from the value's type is not enough. A plain type -- no constructor, no string field, no `extends object` -- takes a number without one. A string element does not take a number, nor a number element a string.

A tuple VALUE of another tuple type is refused everywhere, since two tuple types never convert. A `(int32, int32)` target given a `(integer, integer)` variable gets `TKO0738` in an initialiser, an assignment, a `return` or `function =`. As an argument, byval or byref, it gets `TKO0698`. As an element of a literal, as in `return (t, 3)`, it gets `TKO0831`. The fix is to declare the value at the target's type, `dim as (int32, int32) t = (5, 6)`, or to write the literal where it is used.

A comparison of two tuples of one type is an `integer`, -1 or 0: `print a = b`, `str( a = b )` and `-( a = b )` all work. A tuple compares only if every element does. A UDT element needs the operator written for that comparison, over two of itself: with only `operator =` declared for it, `=` works and `<>` is `TKO0720`, and an `operator cast` does not help. A nested tuple element is judged by its own elements.

## Implementation

tiko's implementation is in its type table and its MIR lowering.

tiko mangles a tuple type as SEPARATE COMPILATION above says: an instantiation of 'FBTUPLE<N>', its element types the arguments. Two separately compiled tiko modules sharing a namespaced procedure over '(Pt, long)', with Pt declared in a different order in each, link and run.

## Tests

The `tuple/` tests, vendored in tiko-lang at `tests/vendor/fbc-tests/tuple/`:

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
int16-circuit proven with a counting element type.
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

`tests/vendor/fbc-tests/errors/tuple-errors.bas` is the golden file for every diagnostic, and also PINS THE TWO DOCUMENTED LIMITATIONS -- 'sizeof( (long, string) )' and the nested literal -- so they cannot change by accident.

`errors/tuple-foreach-errors.bas`, beside it, covers the 'for each (k, v)' diagnostics. AS and BYREF on the list form get a file each: they are rejected while the binding is still being read, before the FOR compound is pushed, so the error skip leaves the following 'next' orphaned and suppresses every later diagnostic in the same file.

fblite/tuple.bas, qb/tuple.bas and deprecated/tuple.bas run the destructuring forms in the three dialects that never had 'LET(a, b) ='. They are outside tiko's scope, which is `#lang "fb"` only.

Under tiko: basic, identity, literal, dtor, destructure, equality, equality-overload and for-each build and run with exit 0; no-regress.bas compiles; and the two-module tuple-mm-main.bas + tuple-mm-a.bas builds and runs clean when both files are given to one `tiko` invocation (see IMPLEMENTATION for separate compilation). tiko's own suite: `tests/types/tuple-type.test` and eight `tests/mir/tuple-*.test` files.

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
