[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **EnumName**

# EnumName

Returns the name of the enum constant that has a value, as it is spelled in the declaration.

## Syntax

```freebasic
declare function enumname( byval v as any_enum ) as string
```

## Usage

```freebasic
result = enumname( v )
```

## Parameters

- `v`: a value of a named [`Enum`](Enum) type: a constant, a variable or any expression of that type.

## Return Value

The name of the **first declared** constant whose value equals `v`, or `""` when no constant has that value.

## Description

`enumname` turns an enum value back into its name, so code no longer needs a `select case` or a macro that lists the names a second time.

- Constants can share a value, so the first one declared wins.
- The name is spelled as in the declaration, in its own case, not upper-cased.
- With a constant argument the call folds to a string literal. With a variable it runs a short search over the constants.
- A value that is not of a named enum is an error (TKO1271), including a plain integer: `enumname( 3 )` does not know which enum is meant. Write `enumname( cast( Colour, 3 ) )`.
- A constant of an enum in a namespace is named without the namespace: `enumname( Ns.Second )` is `"Second"`.

Reading a name back into a value is a loop over [`enumcount`](Enumcount) and [`enumvalue`](Enumvalue); see the example there.

## Examples

```freebasic
enum Colour
    RED = 1
    GREEN = 2
    BLUE = 4
    PRIMARY = 1
end enum

dim as Colour c = BLUE
print enumname( GREEN )
print enumname( c )
print "["; enumname( cast( Colour, 3 ) ); "]"   '' no constant has the value 3
print enumname( PRIMARY )                       '' 1 is RED's value too, and RED comes first
```

```
GREEN
BLUE
[]
RED
```

## Remarks

- **Not a reserved word.** A procedure, variable or other symbol of your own named `enumname` wins, and the built-in is then out of reach in that scope.
- [`Derive`](Derive)'s `ToText( )` writes an enum field with the same name `enumname` gives, or its decimal value when no constant has it.
- `enumname` is a tiko addition.

### See also

- [`Enum`](Enum)
- [`enumcount`](Enumcount) · [`enumvalue`](Enumvalue)
- [`Derive`](Derive)

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)
**Kind:** function
