# Statistics

`std/numeric` has the common summary statistics. They take their data as a
`containers.Array` of numbers, not a fixed-size array, so import
`std/containers` beside it.

```tiko
{{#include ../../examples/numbers/stats.tiko}}
```

**Output**

```text
{{#include ../../examples/numbers/stats.out}}
```

| Function | Gives |
|---|---|
| `Count`, `Sum`, `Mean` | how many, the total, the average |
| `Median`, `Percentile( a, p )` | the middle value, and the value `p` percent of the way up |
| `MinOf`, `MaxOf`, `Range` | the extremes, and the distance between them |
| `Variance`, `StdDev` | spread, for a sample (dividing by n - 1) |
| `VariancePopulation`, `StdDevPopulation` | spread, for a whole population (dividing by n) |
| `Covariance`, `Correlation` | how two arrays move together |

`Median` and `Percentile` sort a copy, so asking does not reorder the array.
The mean of an empty array is NaN, not zero, because zero is a real mean.

**`RunningStats`** sees each value once and keeps only a few numbers, so it
can summarise a stream too large to hold: `Add`, then `Count`, `Mean`,
`Variance`, `StdDev`, `MinValue` and `MaxValue`. It cannot give a median,
which needs every value.

`Sum` is more careful than a loop: it keeps a running correction, so adding
many small values to a large one does not lose them.

`containers.Array` is covered in [Containers](../containers/index.md).

### Activities

1. Add the scores to a `RunningStats` and print its `StdDev`; compare it with
   `numeric.StdDev`.
2. Print the 25th, 50th and 75th percentiles and check the 50th against
   `Median`.
