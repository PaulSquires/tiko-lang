[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_UNIQUEID_PUSH__**

# __FB_UNIQUEID_PUSH__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_UNIQUEID_PUSH__( stack-id )
```

## Parameters

- `stack-id`

## Description

Pushes a new unique identifier on to a stack identified by `stack-id` (the size of the stack is increased by 1).  
 ([`__FB_UNIQUEID__`](Fb-Uniqueid) allows to get the identifier at the top of the stack, and [`__FB_UNIQUEID_POP__`](Fb-Uniqueid-Pop) allows to pop an identifier off of the stack)

 Note:

**-** The "stack-id" name itself is a separate namespace from all other symbols.
 **-** The stack can only contain "unique identifiers".
 **-** "unique identifier" is a name of an fb symbol that is unique to the module, so does not conflict or shadow other symbol names ("unique identifier" will have the form "LT_xxxx" as a name so it might not be completely unique).
 **-** fb uses the form "LT_xxxx" internally for labels, symbols, temp variables, etc (so should avoid naming symbols of this form for any program).

When such a stack is no longer in use, it is recommended that it be empty (at the end there must have been applied as many [`__FB_UNIQUEID_POP__`](Fb-Uniqueid-Pop) as [`__FB_UNIQUEID_PUSH__`](Fb-Uniqueid-Push) for this stack).  
 At any time of its use, the number of [`__FB_UNIQUEID_POP__`](Fb-Uniqueid-Pop) applied from the beginning must always be less than or equal to the number of [`__FB_UNIQUEID_PUSH__`](Fb-Uniqueid-Push) applied.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_UNIQUEID_POP__`](Fb-Uniqueid-Pop)
- [`__FB_UNIQUEID__`](Fb-Uniqueid)

## Examples

See also [`__FB_UNIQUEID__`](Fb-Uniqueid) example.

```freebasic
' As the "unique identifiers" (used as jump labels) are successively pushed on to a stack,

' the jump-code bodies must be defined in the reversed order than the jump calls.

#macro go

    __FB_UNIQUEID_PUSH__( stk )

    Goto __FB_UNIQUEID__( stk )

    End If

#endmacro

#macro end_go

    __FB_UNIQUEID__( stk ):

    __FB_UNIQUEID_POP__( stk )

#endmacro

Dim As Integer N

Do

    Input "Enter a value between 1 and 4 (0 or empty input for exit) ? ", N

    If N = 0 Then go

    If N = 1 Then go

    If N = 2 Then go

    If N = 3 Then go

    If N = 4 Then go

    Continue Do

    end_go

        Print "You entered 4" : Continue Do

    end_go

        Print "You entered 3" : Continue Do

    end_go

        Print "You entered 2" : Continue Do

    end_go

        Print "You entered 1" : Continue Do

    end_go

        Print "End"           : Exit Do

Loop

Sleep
```

 See also [`__FB_UNIQUEID_POP__`](Fb-Uniqueid-Pop) example.

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
