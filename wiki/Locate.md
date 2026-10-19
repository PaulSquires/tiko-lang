[Home](Home) › [Console Functions](Category-Console-Functions) › **Locate**

# Locate

Moves the text cursor to a row and column, and can show or hide it.

## Syntax

```freebasic
Declare Function Locate( row As Long = 0, column As Long = 0, state As Long = -1, start As Long = 0, stop As Long = 0 ) As Long
```

## Parameters

- `row`
- `column`
- `state`
- `start`
- `stop`

## Description

Sets the text cursor in both graphics and console modes.

## Return Value

Returns a 32 bit [`Long`](Long) containing the current cursor position and state. The [Low Byte Of The Low Word](Lobyte) contains the column, the [High Byte Of The Low Word](Hibyte) contains the row, and the [High Word](Hiword) contains the cursor state.

 If any of the *row*, *column* or *state* parameters were just set by the call to `Locate`, then the return value will reflect these new values, not the previous ones. If any of the parameters were omitted in the call to `Locate`, then the return value will reflect the current values, which are the same as before the call to `Locate`.

 `Locate` will attempt to position the cursor at the specified row and column. If the position is beyond the screen extents, cursor will not reposition. And next [`Print`](Print) to the screen will continue at last valid cursor position. When printing to the last line of the screen, and the [`Print`](Print) statement has a new line character, the screen will scroll and reposition the cursor automatically to the last line, column 1.

## Remarks

### Usage

```freebasic
Locate [row], [column], [state]

result = Locate( [row], [column], [state] )

new_column = LoByte( result )

new_row = HiByte( result )

new_state = HiWord( result )
```

### Differences from QB

- The `start` and `stop` arguments have no effect in FreeBASIC.
- QB will raise an error if `row` or `column` are beyond the screen extents.

### See also

- [`CsrLin`](Csrlin)
- [`Pos`](Pos)
- [`Print`](Print)
- [`?`](Print)

## Examples

```freebasic
Locate 10

Print "Current line:"; CsrLin
```

```freebasic
'' Text cursor + mouse tracking

Dim As Long x = 0, y = 0, dx, dy

Cls

Locate , , 1

While Inkey <> Chr(27)

    GetMouse dx, dy

    If( dx <> x Or dy <> y ) Then

        Locate y+1, x+1: Print " ";

        x = dx

        y = dy

        Locate 1, 1: Print x, y, ""

        Locate y+1, x+1: Print "X";

    End If

Wend
```

---

**Category:** [Console Functions](Category-Console-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
