[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_ARG_EXTRACT__**

# __FB_ARG_EXTRACT__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_ARG_EXTRACT__( index, args... )
```

## Parameters

- `index`
- `args...`

## Description

Returns the argument from the argument list (`args...`) corresponding to the index value (`index`).

 If the requested index value refers to an argument that does not exist in the supplied argument list (index value too large), nothing is returned.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_ARG_LEFTOF__`](Fb-Arg-Leftof)
- [`__FB_ARG_RIGHTOF__`](Fb-Arg-Rightof)
- [`__FB_ARG_COUNT__`](Fb-Arg-Count)
- [`__Fb_Arg_Listexpand__`](Fb-Arg-Listexpand)

## Examples

```freebasic
#print __FB_ARG_EXTRACT__( 1, 7, 89.78, "Postman" )

/' Compiler output:

89.78

'/
```

```freebasic
'   In this example, the '__FB_EVAL__' is absolutely mandatory in this 'print_last' macro,

'   because the numeric expression '__FB_ARG_COUNT__( args ) - 1' must be fully evaluated

'   before being used as the index argument of '__FB_ARG_EXTRACT__'

#macro print_last( args... )

    #define last_arg_num __FB_EVAL__( __FB_ARG_COUNT__( args ) - 1 )

    #print __FB_ARG_EXTRACT__( last_arg_num, args )

#endmacro

print_last( 7, 89.78, "Postman" )

/' Compiler output:

Postman

'/
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
