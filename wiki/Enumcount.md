[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **EnumCount**

# EnumCount

Returns the number of constants an enum declares, as a compile-time constant.

## Syntax

```freebasic
result = enumcount( enumtype )
```

## Parameters

- `enumtype`: the name of an [`Enum`](Enum) type, qualified if it is in a namespace (`Ns.Inner`).

## Return Value

The number of constants in the declaration, as an `integer` constant. Constants that share a value each count.

## Description

`enumcount` folds to a constant, so it can go wherever a constant can: a `const`, an array bound, a fixed-size array field of a type.

Together with [`enumvalue`](Enumvalue) it walks every constant of an enum in declaration order: `for i = 0 to enumcount( E ) - 1`, then `enumvalue( E, i )`.

The argument must be an enum type, not a value or a constant of one: `enumcount( Monday )` is an error (TKO1272).

## Examples

```freebasic
enum Weekday
    Monday, Tuesday, Wednesday, Thursday, Friday
end enum

const DAYS = enumcount( Weekday )           '' a constant
dim as int32 hours( 0 to DAYS - 1 )         '' so it can size an array
type Week
    as int32 worked( 0 to enumcount( Weekday ) - 1 )
end type

print DAYS, ubound( hours ), sizeof( Week )
```

```
 5             4             20
```

## Remarks

- **Not a reserved word.** A procedure, variable or other symbol of your own named `enumcount` wins, and the built-in is then out of reach in that scope.
- `enumcount` is a tiko addition.

### See also

- [`Enum`](Enum)
- [`enumvalue`](Enumvalue) · [`enumname`](Enumname)

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)
**Kind:** function
