[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_JOIN__**

# __FB_JOIN__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_JOIN__( arg1, arg2 )
```

## Parameters

- `arg1`
- `arg2`

## Description

Joins two token arguments together as one, similar to token pasting operator ([`##`](Operator-Preprocessor-Concatenate)) but more powerfull (will resolve arguments before joining).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator ## (Preprocessor Concatenate)`](Operator-Preprocessor-Concatenate)

## Examples

```freebasic
#macro m ( arg1, arg2 )

    #print arg1##arg2

    #print __FB_JOIN__( arg1, arg2 )

#endmacro

m(Free, BASIC)

/' Compiler output:

FreeBASIC

FreeBASIC

'/
```

```freebasic
#define PREFIX p

#define SUFFIX _T

'' this won't work - arguments not expanded

#define   makename1( x )  PREFIX##x##SUFFIX

'' this will work

#define join( a, b ) a##b

#define makename2( x ) join( PREFIX, join( x, SUFFIX ) )

'' built in __FB_JOIN__() -- works pretty much like join() above

#define   makename3( x )  __FB_JOIN__( PREFIX, __FB_JOIN__( x, SUFFIX ) )

#macro dump( arg )

    #print #arg

#endmacro

dump( makename1(text) )

dump( makename2(text) )

dump( makename3(text) )

/' Compiler output:

PREFIXtextSUFFIX

ptext_T

ptext_T

'/
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
