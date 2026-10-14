[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__Fb_Arg_Listexpand__**

# __Fb_Arg_Listexpand__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_ARG_LISTEXPAND__( macroname, macroargcount, args... )
```

## Parameters

- `macroname`
- `macroargcount`
- `args...`

## Description

Expands to one or more 'macroname( .... )' depending on the value of `macroargcount` and number of arguments in the `args...` list.

 Returns empty string on invalid index, rather than compile error.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_ARG_RIGHTOF__`](Fb-Arg-Rightof)
- [`__FB_ARG_LEFTOF__`](Fb-Arg-Leftof)
- [`__FB_ARG_COUNT__`](Fb-Arg-Count)
- [`__FB_ARG_EXTRACT__`](Fb-Arg-Extract)

## Examples

```freebasic
#macro m( arg... )

    #print "   "##arg

#endmacro

#print "macroargcount>0 (=1):"

__FB_ARG_LISTEXPAND__( m, 1, Hello1, Hello2, Hello3, Hello4)

#print " "

#print "macroargcount=0 (=0):"

__FB_ARG_LISTEXPAND__( m, 0, Hello1, Hello2, Hello3, Hello4)

#print " "

#print "macroargcount<0 (=-1):"

__FB_ARG_LISTEXPAND__( m, -1, Hello1, Hello2, Hello3, Hello4)

/' Compiler output:

macroargcount>0 (=1):

   Hello1

   Hello2

   Hello3

   Hello4

macroargcount=0 (=0):

   Hello1, Hello2, Hello3, Hello4

macroargcount<0 (=-1):

   Hello1, Hello2, Hello3, Hello4

   Hello2, Hello3, Hello4

   Hello3, Hello4

   Hello4

'/
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
