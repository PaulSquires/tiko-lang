[Home](Home) › [All Categories](Categories) › **Lambdas**

# Lambdas

```freebasic
' non-capturing: an ordinary procedure pointer
dim double_ as function( byval x as int32 ) as int32 = _
    function( byval x as int32 ) as int32 : return x * 2 : end function

' capturing: '[ ]' lists what is captured, and how
dim as int32 total = 0
ForEach( nums, sub[ byref total ]( byref v as int32 )
    total += v
end sub )
```

## Why They Exist

FreeBASIC's function pointers capture nothing, so every callback API passes a handle for the callback to look its own state back up, and the caller keeps a side table keyed by that handle. The Ps\* control family shows it exactly:

```freebasic
type TooltipCallbackFunc as function( byval hListControl as HWND, ... )
```

That HWND is not information the callback wants. It is a MANUAL CLOSURE ENVIRONMENT -- the only way to reach state that was already in scope where the callback was written.

## Two Kinds, AND The Difference Matters

```freebasic
sub( args ) ... end sub                 non-capturing -> a procptr
sub[ byref x ]( args ) ... end sub      capturing     -> a closure object
```

A NON-CAPTURING lambda lowers to a plain module-level procedure plus its address. It is type-identical to '@myproc', converts to any matching procptr, and is what every Win32-style callback wants.

A CAPTURING lambda cannot be a procptr -- it has state and a procptr has nowhere to put it:

```freebasic
dim f as Fn = function[ byval bias ]( byval x as int32 ) as int32 ...
' error 355: A capturing lambda cannot convert to a procedure pointer
```

It reaches an API through a GENERIC parameter instead. That is what containers.ForEach is for, and why it takes 'of F' rather than a procedure pointer.

BOTH kinds are called the same way: 'f( 3 )'.

## Grammar

```freebasic
LambdaExpr  =  (SUB|FUNCTION) CaptureList? CallConv? '(' Params? ')'
               (AS Type)? Body (END SUB|END FUNCTION) .
CaptureList =  '[' ( (BYVAL|BYREF) Id (',' ...)* )? ']' .
```

- The capture list sits between the keyword and the parameter list, where

```freebasic
nothing may legally appear today.
```

- A calling convention is allowed: 'function cdecl( ... )'. Not a nicety --

```freebasic
qsort's comparator is CDECL and most Win32 callbacks are STDCALL.
```

- AN EMPTY LIST '\[ \]' is the NON-capturing form. It means what 'sub( ... )'

```freebasic
means, so a capture can be deleted without re-punctuating.
```

- The body is ordinary statements; the one-line ': ... :' form works because

```freebasic
':' is already the statement separator.
```

No compatibility risk: 'sub' and 'function' in expression position are a syntax error today (verified: "error 9: Expected expression, found 'function'").

## Every Capture States Its Mode

There is no default, no bare '\[ total \]', and no C++-style '\[&\]' / '\[=\]'.

In a language with manual lifetimes the mode IS the lifetime question, and inferring it is how a closure ends up holding a reference to a destroyed frame. Writing it costs one word and puts the answer where it has to be read.

```freebasic
byref x     the closure holds a POINTER to the caller's variable
byval x     the closure holds a COPY, taken when the lambda is EVALUATED
```

The BYVAL snapshot is the one that surprises people:

```freebasic
dim as int32 bias = 10
var a = function[ byval bias ]( byval x as int32 ) as int32
    return x + bias
end function
bias = 999
print a( 5 )                 ' 15, not 1004
```

## What A Closure Is

A struct with one field per capture and the body as its \_\_FBINVOKE method. The value of the expression is an object living in the ENCLOSING SCOPE -- no heap, no allocation, destroyed with the frame.

It is synthesised as a GENERIC with one type parameter per capture, then instantiated with the captured variables' actual types. That is what lets a capture be of any type at all -- see ANYTHING CAN BE CAPTURED above -- and it also hands the member body to the generics machinery, which already replays member bodies once per instantiation.

Two closures over different variables have independent state, which is the case a single static thunk would get wrong.

## Lifetime -- The Hazard That Is NOT Diagnosed

A BYREF capture is '@local' with better ergonomics, and nothing checks it:

```freebasic
function MakeCounter( ) as ???
    dim n as int32 = 0
    return sub[ byref n ]( ) : n += 1 : end sub    ' n dies with the frame
end function
```

A closure holding a BYREF capture must not outlive the frame that owns the captured variable. BYVAL capture is always safe. The explicit capture list is what makes the question visible; it does not answer it.

The closure TYPE is hoisted to module level, so it outlives the scope that named it.

## Anything Can Be Captured

Scalars, strings, UDTs and containers alike:

```freebasic
dim src as Array( of int32 )
var c = sub[ byref src ]( ) : src.Push( 9 ) : end sub
```

A BYVAL capture of a container is a DEEP COPY taken when the lambda is evaluated, because that is what FreeBASIC's value semantics do.

This works because the closure is declared as a GENERIC over its capture types and then instantiated from the captured symbols' types directly -- so a capture's type is never written as text. Naming it was the first approach and could not express a container: a generic instantiation prints as its mangled internal name, which is not an identifier, and

```freebasic
var c = sub[ byref src ]( ) ...
```

failed with "error 14: Expected identifier, found '$'".

## How The Body Sees Its Captures

\_\_FBINVOKE opens with one byref alias per capture:

```freebasic
dim byref as typeof( *this.__cap_total ) total = *this.__cap_total
```

so the body is replayed UNCHANGED. The alternative -- rewriting every 'total' in the body to '\*this.\_\_cap_total' -- would also rewrite a LOCAL named 'total' declared inside the lambda, silently redirecting it. With a real declaration, FreeBASIC's own scoping decides, and a colliding local is a duplicate-definition error the author can see.

## Diagnostics

tiko reports, one case per file:

| Case | tiko |
| --- | --- |
| 33 captures in one list | no diagnostic -- tiko accepted all 33 |
| a capture with no explicit BYVAL or BYREF | `TKO0413: every lambda capture needs an explicit 'byval' or 'byref'` |
| a captured variable that is not declared | no diagnostic from the front end; the build then fails in clang on the IR tiko emitted (`TKO0113: clang failed`) |
| a capturing lambda converted to a procedure pointer | `TKO0738: no conversion between these two types` |
| a malformed lambda header (source ends inside it) | `TKO0401: expected ')'` |
| an unterminated lambda body (source ends inside it) | `TKO0405: expected 'end SUB'` |

## Implementation

`src/parser/lambda.tiko` reads the lambda, the closure type of a capturing lambda is built during name resolution (`src/symbols/resolvesynth.tiko`), and `src/mir/lowerclosure.tiko` builds the closure object -- one field per capture, holding the address for a BYREF capture and the value for a BYVAL one.

## Tests

The lambda tests are vendored in tiko-lang under `tests/vendor/fbc-tests/generics/`.

lambda.bas -- non-capturing: both forms, one-line and multi-line bodies, VAR inference, byref params and a byref return proven to be a reference, inline as an argument, returned from a function, at module level, nested lambdas, a procptr result type, EXIT inside a body, two lambdas staying distinct, interchangeability with @proc, and a real qsort comparator.

lambda-capture.bas -- capturing: byref and byval, the byval snapshot, several captures of mixed mode, independent state, every call position including zero-argument and nested calls, the empty capture list, a capturing AND a non-capturing lambda through the same generic parameter, containers.ForEach, capturing a UDT both ways, and destructor balance showing that byval copies once and byref copies not at all.

Under tiko, lambda.bas, lambda-capture.bas and lambda-in-generic.bas build and run with exit 0, and the three-module lambda-mm-main.bas + lambda-mm-a.bas + lambda-mm-b.bas builds and runs clean. tiko's own suite: `tests/mir/lambda.test`, `lambda-capture.test`, `lambda-byref-arg.test`, `lambda-capture-generic.test`, `lambda-in-generic.test`, `closure-udt-result.test` and `generic-closure-arg.test`.

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
