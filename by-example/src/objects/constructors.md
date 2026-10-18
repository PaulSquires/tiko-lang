# Constructors

A *constructor* runs when an object is created, so an object can never be
seen half-built. A type may have several, told apart by their parameters
like overloaded procedures.

```tiko
{{#include ../../examples/objects/constructors.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/constructors.out}}
```

The constructor with no parameters is the *default constructor*. A plain
`dim as Temperature a` uses it, and so does every element of an array of
objects.

The others are chosen by their arguments, wherever an object is made:

| Form | Calls |
|---|---|
| `dim as Temperature a` | the default constructor |
| `var b = Temperature( 5.5 )` | the `float64` constructor |
| `dim as Temperature c = Temperature( "31" )` | the `ustring` constructor |
| `dim as Temperature d = -4` | the `float64` constructor, as a conversion |

**One constructor can delegate to another** with `this.constructor( ... )`.
The text constructor converts its argument and hands the rest of the work to
the number constructor, so the setup lives in one place.

A type that declares constructors but no default one cannot be created with
a plain `dim`: the compiler refuses it with `TKO0657: the type of 'a' has no
constructor that takes no argument`. Default parameter values, such as
`declare constructor( byval n as int32 = 0 )`, give one constructor that
serves both ways.

```admonish danger title="Pitfall"
A constructor with one parameter is also an **implicit conversion**. Because
`Temperature` can be built from a `float64`, the compiler builds one on its
own whenever a number appears where a `Temperature` is wanted: that is what
`dim as Temperature d = -4` and `Show( 12 )` did. There is no keyword to turn
this off (`declare explicit constructor` is refused with `TKO0936`). If a
silent conversion would be wrong for your type, give the constructor a second
parameter, or create objects through a named function.
```

### Activities

1. Add a constructor that takes a temperature in Fahrenheit. What has to be
   different about its parameter list so the compiler can tell it from the
   Celsius one?
2. Remove the default constructor and read the error for `dim as Temperature a`.
   Then give the `float64` parameter a default value and try again.
