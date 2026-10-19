[Home](Home) › [Screen Functions](Category-Screen-Functions) › **Event (Message Data From Screenevent)**

# Event (Message Data From Screenevent)

Holds one event fetched by ScreenEvent: its type and its key or mouse data.

## Syntax

```freebasic
#include once "fbgfx.bi"
using fb
Dim variable As Event
```

## Description

Here we report the `EVENT` structure for clarity:

```freebasic
Type Event Field = 1

    Type As Long

    Union

        Type

            scancode As Long

            ascii As Long

        End Type

        Type

            x As Long

            y As Long

            dx As Long

            dy As Long

        End Type

        button As Long

        z As Long

        w As Long

    End Union

End Type
```

 The `Type` field will contain the event type ID, while the remaining 4 integers will hold sensitive data to the event type.

 *Event types*

The event type is identified by an ID number returned into the first integer of the `event` buffer (the `.type` field in the `EVENT` structure). Known event type IDs - and their values at time of writing - are:

The `fbgfx.bi` header file contains a definition of the `EVENT` user data type, so it is not necessary to declare it manually.

## Remarks

### Dialect Differences

- In *lang fb*, the structure and constants are stored in the `FB` [`Namespace`](Namespace). This is not the case in other dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`ScreenEvent`](Screenevent)
- [Keyboard scancodes](Dos-Keyboard-Scancodes)

## Examples

See example at [`ScreenEvent`](Screenevent).

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
