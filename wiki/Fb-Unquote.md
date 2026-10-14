[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_UNQUOTE__**

# __FB_UNQUOTE__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_UNQUOTE__( arg )
```

## Parameters

- `arg`

## Description

Takes a literal string and converts it back to tokens.  
 More precisely, `__FB_UNQUOTE__` returns a sub-quoted text compared to the one passed through the argument (the argument may already be an over-quoted string, and so the return will be a simple string in this case).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_QUOTE__`](Fb-Quote)
- [`__FB_EVAL__`](Fb-Eval)

## Examples

```freebasic
#macro m( arg )

    Scope

        Var v1 = arg

        #print TypeOf(v1)

        Print v1

        Var v2 = __FB_UNQUOTE__( arg )

        #print TypeOf(v2)

        Print v2

    End Scope

#endmacro

m("""Hello""")

m("1")

Sleep

/' Compiler output:

STRING

STRING

STRING

INTEGER

'/

/' Output:

"Hello"

Hello

1

 1

'/
```

```freebasic
#define X __FB_QUOTE__( Print "hello" )

#macro Y( arg )

  __FB_UNQUOTE__( arg )

#endmacro

Print X

Y( X )

/' Output:

print "hello"

hello

'/
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
