[Home](Home) › [All Categories](Categories) › **Defer**

# Defer

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

```freebasic
sub Load( byref path as string )
    dim as HANDLE h = CreateFile( path, ... )
    if( h = INVALID_HANDLE_VALUE ) then exit sub

    defer CloseHandle( h )

    ...                              ' any number of early exits
    if( bad ) then exit sub          ' CloseHandle runs
    if( worse ) then return          ' CloseHandle runs
    goto finish                      ' CloseHandle runs
end sub                              ' CloseHandle runs
```

## Why It Exists

FreeBASIC has deterministic destructors, which handle cleanup well -- but only if you declare a type for every cleanup action. A one-off CloseHandle, DeleteObject, ReleaseDC or free in a procedure with four early exits gets written four times, or forgotten once. That is the most common resource-leak shape in Win32 code, and Win32 code is FreeBASIC's home ground.

DEFER is for the cleanup that does not justify a type.

## Rules

```freebasic
defer <statement>
```

- Runs at the exit of the ENCLOSING SCOPE, not of the procedure. - Runs in REVERSE registration order. - Runs on EVERY path out: falling off the end, 'exit sub', 'exit function',

```freebasic
'return', 'exit for/while/do' including 'exit for, for', and 'goto' out of
any number of nested scopes.
```

- In a loop body, runs on EVERY ITERATION -- the loop body is a scope. - Takes ONE statement. There is no block form.

## It Interleaves With Destructors

Defers and local destructors are not two passes. They live in one list in declaration order and unwind together:

```freebasic
scope
    dim a as Tr : a.nm = "a"
    defer print "[1]"
    dim b as Tr : b.nm = "b"
    defer print "[2]"
end scope

' [2]  ~b  [1]  ~a
```

so a defer can rely on a local declared before it still being alive, and a destructor can rely on a defer registered after it having already run.

## The Statement Is Evaluated At Exit

Everything the deferred statement reads is read when it RUNS, not when it was written:

```freebasic
dim as long v = 7
defer print v
v = 9
' prints 9
```

This is the single most common surprise. It matters most in a loop, where it does not look like a defer question at all:

```freebasic
dim as long i = 0
while( i < 3 )
    defer print i        ' prints 1, then 2 -- not 0, then 1
    i += 1
    if( i = 2 ) then exit while
wend
```

If you need the value as it was, copy it into a scope-local first.

## Registration Is Lexical, NOT Dynamic

This is the one place DEFER here differs from Go's, and it is worth knowing.

The cleanup is derived from the scope's SYMBOL TABLE at compile time. Nothing is recorded at run time, so a 'defer' that was never "reached" still runs:

```freebasic
scope
    goto skip
    defer print "runs anyway"        ' error 349
    skip:
end scope
```

Because that reads as if the jump skips the defer and it does not, crossing a DEFER with a branch is refused:

```freebasic
error 349: Branch crossing a DEFER statement, to label: SKIP
```

which is the same rule FreeBASIC already applies to jumping past a local with a constructor. What IS honoured is position: a defer placed after an early exit never runs on that exit, because it is outside the exit's statement window.

```freebasic
sub f( )
    print "before"
    exit sub
    defer print "never"              ' correctly does not run
end sub
```

## NOT At Module Level

```freebasic
defer print "x"      ' error 348: DEFER is not allowed at module level
```

There is no scope to exit, so nothing would ever run it.

## 'defer' IS A CONTEXTUAL KEYWORD

It is NOT a reserved word. Making it one would break every existing program that uses 'defer' as a name, and a contextual keyword costs nothing to programs that do not use the feature.

It is read as the keyword only when the NEXT token begins a statement. So all of this still compiles and behaves exactly as before:

```freebasic
dim defer as long = 3
defer = 4
defer += 5                  ' note: '+=' lexes as '+' then '='
dim deferArr( 0 to 2 ) as long
type T : as long defer : end type
h.defer = 5
x = defer( 6 )              ' a function named 'defer'
```

THE ONE INCOMPATIBILITY: a PAREN-LESS call in statement position to a sub named 'defer':

```freebasic
defer 6                     ' now a DEFER of the statement '6'
defer( 6 )                  ' still a call
```

Every call that produces a value is unaffected, because it needs the parentheses anyway. This is the same trade FOR EACH already makes with 'each'.

> **Under tiko** (measured 2026-09-24 at origin/master 50c71751), with `sub defer( byval n as long )` declared, NEITHER statement calls it. `defer( 6 )` and `defer 6` are both dropped without a diagnostic; `--dump-ir` reports `1 statements not lowered`. FBC-Modern's `fbc64` calls the sub for both. Rename the sub. The variable forms above (`dim defer`, `defer = 4`, `defer += 5`) work under tiko.

## Diagnostics

fbc (FBC-Modern's `fbc64` 1.20.0) reports these three:

```freebasic
error 347: DEFER requires a statement
error 348: DEFER is not allowed at module level
error 349: Branch crossing a DEFER statement
```

tiko does not report them yet. Measured 2026-09-24 at origin/master 50c71751, one case per file:

- a bare `defer` with no statement is `TKO0405: expected 'end SUB'`, reported at the end of the file;
- a module-level `defer print "x"` compiles, and the program prints `x`;
- a `goto` that crosses a DEFER compiles, and the deferred statement runs at the scope's exit.

The last two are programs fbc rejects, so code that relies on them will not build with fbc.

## Implementation

tiko's implementation is its own. The parser recognises the contextual keyword (`src/parser/parser.bas`), and the MIR lowering (`src/mir/lower.bas`) registers the deferred statement in the same per-scope cleanup list that local destructors are registered in, so reverse order and the interleaving with destructors come from that one list. Its run-time behaviour matches fbc's on fbc's own DEFER programs -- see Tests.

## Tests

fbc's own DEFER tests are vendored in tiko-lang under `tests/vendor/fbc-tests/`.

generics/defer.bas is exhaustive: reverse order, fallthrough off 'end scope' / 'end sub' / 'end function', every break path including 'exit for, for' and 'goto' out of three nested scopes, a loop body, defers in IF / SELECT / WITH arms, interleaving with destructors asserted in BOTH orders and on BOTH the fallthrough and break paths, a defer that is never reached, and backward compatibility for 'defer' as a variable, array, field and shared.

Order is asserted by accumulating into a string and comparing the exact sequence. A defer that runs at the wrong time still runs, so only the sequence distinguishes right from wrong.

generics/defer-identifier.bas covers 'defer' as a PROCEDURE name -- separate, because FreeBASIC refuses a local that shadows a module-level procedure of the same name.

errors/defer-errors.bas holds fbc's golden output for all three diagnostics. tiko does not produce it -- see Diagnostics.

Under tiko, measured 2026-09-24 at origin/master 50c71751: defer.bas and defer-identifier.bas build and run with exit 0 and the same output as fbc's builds -- none, because every assertion passes. Both are among the 68 in-scope run programs that `build/runscan.sh` (2026-09-20) found byte-identical to fbc's builds. tiko's own suite adds `tests/mir/defer-contextual.test` (the contextual keyword) and `tests/mir/cleanup.test` (defer order against destructors, checked against traces of fbc's output in `tests/semantic/cleanup/`).

---

**Source:** `docs/defer/defer.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
