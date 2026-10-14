[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_UNIQUEID__**

# __FB_UNIQUEID__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_UNIQUEID__( stack-id )
```

## Parameters

- `stack-id`

## Description

Gets the identifier at the top of stack identified by `stack-id` (the size of the stack is not modified).  
 ([`__FB_UNIQUEID_PUSH__`](Fb-Uniqueid-Push) allows to push a new unique identifier on to the stack, and [`__FB_UNIQUEID_POP__`](Fb-Uniqueid-Pop) allows to pop an identifier off of the stack)

 Note:

**-** The 'stack-id' name itself is a separate namespace from all other symbols.
 **-** The stack can only contain 'unique identifiers'.
 **-** 'unique identifier' is a name of an fb symbol that is unique to the module, so does not conflict or shadow other symbol names ('unique identifier' will have the form 'LT_xxxx' as a name so it might not be completely unique).
 **-** fb uses the form 'LT_xxxx' internally for labels, symbols, temp variables, etc (so should avoid naming symbols of this form in any program).

`__FB_UNIQUEID__` simply expands to unquoted text. So the name, for example 'Lt_0004', can be used wherever an fb symbol is required (a variable, procedure name, type name, etc.).  
 `__FB_UNIQUEID__` returns an unquoted empty string when the stack is empty or has never been filled.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_UNIQUEID_PUSH__`](Fb-Uniqueid-Push)
- [`__FB_UNIQUEID_POP__`](Fb-Uniqueid-Pop)

## Examples

```freebasic
__FB_UNIQUEID_PUSH__( stk )

#print __FB_UNIQUEID__( stk )

    __FB_UNIQUEID_PUSH__( stk )

    #print __FB_UNIQUEID__( stk )

        __FB_UNIQUEID_PUSH__( stk )

        #print __FB_UNIQUEID__( stk )

        __FB_UNIQUEID_POP__( stk )

    #print __FB_UNIQUEID__( stk )

    __FB_UNIQUEID_POP__( stk )

#print __FB_UNIQUEID__( stk )

__FB_UNIQUEID_POP__( stk )

/' Compiler output example:

Lt_0006

Lt_0007

Lt_0008

Lt_0007

Lt_0006

'/
```

 See also [`__FB_UNIQUEID_PUSH__`](Fb-Uniqueid-Push) and [`__FB_UNIQUEID_POP__`](Fb-Uniqueid-Pop) examples.

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
