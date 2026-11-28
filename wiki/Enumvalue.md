[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **EnumValue**

# EnumValue

Returns an enum's i-th constant, counting from 0 in declaration order.

## Syntax

```freebasic
result = enumvalue( enumtype, i )
```

## Parameters

- `enumtype`: the name of an [`Enum`](Enum) type, qualified if it is in a namespace (`Ns.Inner`).
- `i`: the position of the constant, from 0 to `enumcount( enumtype ) - 1`.

## Return Value

The constant at position `i`, as a value of `enumtype`.

## Description

`enumvalue` and [`enumcount`](Enumcount) walk every constant of an enum in the order they are declared, including constants that share a value and enums whose values are not consecutive.

- With a constant `i` the call folds to the constant itself, and an `i` out of range is a compile-time error (TKO1273).
- With a variable `i`, under [`-exx`](Compiler-Option-Exx) (or `-earray`) an `i` out of range stops the program with run-time error 6, as an array index out of bounds does. Without the check the result is not meaningful.
- The first argument must be an enum type, not a value of one (TKO1272).

## Examples

```freebasic
enum Colour
    RED = 1
    GREEN = 2
    BLUE = 4
    PRIMARY = 1
end enum

for i as int32 = 0 to enumcount( Colour ) - 1
    print i, enumvalue( Colour, i ), enumname( enumvalue( Colour, i ) )
next
```

```
 0             1            RED
 1             2            GREEN
 2             4            BLUE
 3             1            RED
```

`PRIMARY` is the fourth constant, and its value is `RED`'s, so [`enumname`](Enumname) names it `RED`, the first declared.

Reading a name back into a value is the same loop:

```freebasic
enum Level
    Debug, Info, Warn, Error_
end enum

function ParseLevel( byref s as string, byref out_ as Level ) as boolean
    for i as int32 = 0 to enumcount( Level ) - 1
        if lcase( enumname( enumvalue( Level, i ) ) ) = lcase( s ) then
            out_ = enumvalue( Level, i )
            return true
        end if
    next
    return false
end function

dim as Level lv
print ParseLevel( "warn", lv ), lv, enumname( lv )
print ParseLevel( "loud", lv )
```

```
true            2            Warn
false
```

## Remarks

- **Not a reserved word.** A procedure, variable or other symbol of your own named `enumvalue` wins, and the built-in is then out of reach in that scope.
- `enumvalue` is a tiko addition.

### See also

- [`Enum`](Enum)
- [`enumcount`](Enumcount) · [`enumname`](Enumname)
- [`-exx`](Compiler-Option-Exx)

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)
**Kind:** function
