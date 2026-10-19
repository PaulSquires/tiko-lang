[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Rnd**

# Rnd

Returns a random Double from 0 up to but not including 1.

## Syntax

```freebasic
Declare Function Rnd ( ByVal seed As Single = 1.0 ) As Double
```

## Parameters

- `seed`
- `seed`

## Description

Returns a number of type [`Double`](Double) in the range `[0, 1)` (i.e. `0 <= Rnd < 1`), based on a random seed (see [`Randomize`](Randomize)).

 `Rnd` can use a variety of different algorithms - see [`Randomize`](Randomize) for details of the default and selectable algorithms.

 `Rnd` will return the same sequence of numbers every time a program is run. This sequence can be changed by reseeding the generator.

 **Note:**

`Rnd` is thread-safe (by using an internal mutex), but not thread specific. Used in the context of a multi-threaded program, only the execution speed is significantly slowed down compared to a single thread call context.  
 Unfinished structures for other random number generators are also available in the standard header "fbprng.bi".

## Return Value

Returns the random number generated.

## Remarks

### Usage

`result = Rnd( seed )`

### Dialect Differences

 The default algorithm used depends on the current dialect in use:

### Differences from QB

- None, if compiled in the *[-lang qb](Compiler-Option-Lang)* dialect. Other dialects can also use the same seeding and generating algorithms by calling [`Randomize`](Randomize) with the appropriate parameter.
  For the non-QB-compatible algorithms, if the optional argument is less than 0, it has the same meaning as passing an argument of 1.

### See also

- [`Randomize`](Randomize)
- [`Timer`](Timer)
- [`Int`](Int)

## Examples

```freebasic
'' Function to a random number in the range [first, last), or {first <= x < last}.

Function rnd_range (first As Double, last As Double) As Double

    Function = Rnd * (last - first) + first

End Function

'' seed the random number generator, so the sequence is not the same each time

Randomize

'' prints a random number in the range [0, 1), or {0 <= x < 1}.

Print Rnd

'' prints a random number in the range [0, 10), or  {0 <= x < 10}.

Print Rnd * 10

'' prints a random integral number in the range  [1, 10], or {1 <= n <= 10}.

''     (because: 0 <= Rnd * 10 < 10)

Print Int(Rnd * 10) + 1

'' prints a random integral number in the range [69, 420], or {69 <= n <= 420}.

''     (because: 69 <= rnd_range(69, 421) < 421)

Print Int(rnd_range(69, 421))
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
