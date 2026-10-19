[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Randomize**

# Randomize

Seeds the random number generator that Rnd uses, and can choose its algorithm.

## Syntax

```freebasic
Declare Sub Randomize ( ByVal seed As Double = -1.0, ByVal algorithm As Long = 0 )
```

## Parameters

- `seed`
- `algorithm`

## Description

Sets the random seed that helps [`Rnd`](Rnd) generate random numbers, and selects the algorithm to use.  
 The constants for `algorithm` are defined in `fbprng.bi`. In the *[-lang fb](Compiler-Option-Lang)* dialect, these constants are part of the `FB` [`Namespace`](Namespace).  
 Valid values for `algorithm` are:

`FB_RND_AUTO (0)` - Default for current language dialect. This is algorithm `FB_RND_MTWIST (3)` in the *[-lang fb](Compiler-Option-Lang)* dialect, `FB_RND_QB (4)` in the *[-lang qb](Compiler-Option-Lang)* dialect and `FB_RND_CRT (1)` in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
 `FB_RND_CRT (1)` - Uses the C runtime library's `rand()` function. This will give different results depending on the platform.  
 `FB_RND_FAST (2)` - Uses a fast implementation. This should be stable across all platforms, and provides 32-bit granularity, reasonable degree of randomness.  
 `FB_RND_MTWIST (3)` - Uses the Mersenne Twister. This should be stable across all platforms, provides 32-bit granularity, and gives a high degree of randomness.  
 `FB_RND_QB (4)` - Uses a function that is designed to give the same random number sequences as QBASIC. This should be stable across all platforms, and provides 24-bit precision, with a low degree of randomness.  
 `FB_RND_REAL (5)` - Available on Win32 and Linux, using system features (Win32 Crypto API, Linux /dev/urandom) to provide cryptographically random numbers. If those system APIs are unavailable, algorithm `FB_RND_MTWIST (3)` will be used instead.

 For any given seed, each algorithm will produce a specific, deterministic sequence of numbers for that seed. If you want each call to `Randomize` to produce a different sequence of numbers, a seed that is not quite predictable should be used - for example, the value returned from [`Timer`](Timer). Omitting the `seed` parameter will use a value based on this.

 Note: for all algorithms except algorithm #4, because the fractional part of the seed is clipped, the using the [`Timer`](Timer) value directly as a parameter will produce the same seed if used more than once in the same second. However, it is generally not worth calling `Randomize` twice with unpredictable seeds anyway, because the second sequence will be no more random than the first, or even possibly worse by inducing sequence overlapping. In most cases, the Mersenne twister should provide a sufficiently random sequence of numbers, without requiring reseeding between [`Rnd`](Rnd) calls.

 When you call `Randomize` with the QB compatible algorithm, part of the old seed is retained. This means that if you call `Randomize` several times with the same seed, you will **not** get the same sequence each time. To get a specific sequence in QB compatible mode, set the seed by calling [`Rnd`](Rnd) with a negative parameter.

 **Note:**

`Randomize` is thread-safe (by using an internal mutex), but not thread specific.  
 Unfinished structures for other random number generators are also available in the standard header "fbprng.bi".

## Remarks

### Usage

`Randomize [ seed ][, algorithm ]`

### Dialect Differences

 The default algorithm used depends on the current dialect in use:

### Differences from QB

- The `algorithm` parameter is new to FreeBASIC.
  QBASIC only had one algorithm (replicated in FB in algorithm number `4`, and set as the default in the *[-lang qb](Compiler-Option-Lang)* dialect).

### See also

- [`Rnd`](Rnd)

## Examples

```freebasic
'' Seed the RNG to the method using C's rand()

Randomize , 1

'' Print a sequence of random numbers

For i As Integer = 1 To 10

    Print Rnd

Next
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
