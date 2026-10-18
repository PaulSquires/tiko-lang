# Assertions

Each assertion macro checks one thing and records the result. Choosing the
macro that says what you mean makes a failure message easier to read.

```tiko
{{#include ../../examples/testing/assertions.tiko}}
```

**Output**

```text
{{#include ../../examples/testing/assertions.out}}
```

| Macro | Passes when |
|---|---|
| `CU_ASSERT( c )` | `c` is true |
| `CU_ASSERT_TRUE( c )`, `CU_ASSERT_FALSE( c )` | `c` is true, or false |
| `CU_ASSERT_EQUAL( a, b )` | `a = b` |
| `CU_ASSERT_NOT_EQUAL( a, b )` | `a <> b` |
| `CU_ASSERT_DOUBLE_EQUAL( a, e, g )` | `a` is within `g` of `e` |
| `CU_FAIL( msg )` | never: marks code a test must not reach |

The `floating_point` test shows why `CU_ASSERT_DOUBLE_EQUAL` exists. `0.1 + 0.2`
is not exactly `0.3` in binary floating point, so `CU_ASSERT_NOT_EQUAL( sum,
0.3 )` passes. A test of a computed `float64` compares it within a tolerance
that fits the calculation.

A failed assertion does not stop its test: the test carries on, and every
failure is listed before the summary. That is what lets one test hold several
related checks.

### Activities

1. Add `CU_ASSERT_EQUAL( sum, 0.3 )` to `floating_point` and read the failure.
2. Tighten the tolerance to `1e-20` and see whether the test still passes.
