# Random numbers

A test or a simulation wants random numbers it can repeat; a game wants
different ones each time. Both come from a *seed*: the same seed gives the same
sequence.

```tiko
{{#include ../../examples/numbers/random.tiko}}
```

**Output**

```text
{{#include ../../examples/numbers/random.out}}
```

The built-in pair is `randomize`, which seeds the program's one generator, and
`rnd( )`, which returns a value from 0 up to but not including 1. With a fixed
seed, as here, every run prints the same numbers.

`numeric.Rng` is a generator you hold. **An `Rng` is a value**: each one is its
own stream, so one part of a program can have a repeatable stream without
disturbing another's, and a copy carries on from the same point.
`RngSeeded( seed )` gives the same numbers on every platform, which is what
tests need; `RngFromEntropy( )` seeds from the operating system for a different
stream on each run.

| Member | Gives |
|---|---|
| `NextInt( lo, hi )` | a whole number from `lo` to `hi`, **both included**, with no bias |
| `NextDouble( )` | a `float64` from 0 up to but not including 1 |
| `NextBoolean( )`, `NextBooleanP( p )` | true half the time, or with probability `p` |
| `NextNormal( )`, `NextNormalP( mean, sd )` | values on a bell curve |

`numeric.Shuffle( rng, a( ) )` puts an array in random order, every order
equally likely, and `numeric.Choice( rng, a( ) )` picks one element. For keys
and tokens, where nobody may predict the value, use `numeric.CryptoBytes` or
`numeric.CryptoULongInt`; they have no seed.

`int( rnd( ) * 6 ) + 1` is the classic die roll. It is very slightly biased;
`NextInt( 1, 6 )` is not.

### Activities

1. Roll two dice 1000 times with a seeded `Rng` and count how often they sum
   to 7.
2. Seed with `RngFromEntropy( )` and run the program twice.
