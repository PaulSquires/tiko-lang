[Home](Home) › [Operators](Category-Operators) › **Operator Next (Iteration)**

# Operator Next (Iteration)

Determines if a For...Next loop should be terminated

## Syntax

```freebasic
{ Type | Class | Union } typename
Declare Operator Next ( [ ByRef | ByVal ] cond As typename ) As Integer
Declare Operator Next ( [ ByRef | ByVal ] cond As typename, [ ByRef | ByVal ] stp As typename ) As Integer
...
End { Type | Class | Union }
```

## Parameters

- `typename`
- `cond`
- `end_value`
- `typename`
- `stp`
- `step_value`
- `typename`
- `iterator`
- `typename`
- `start_value`
- `typename`

## Description

[`Operator For`](Operator-for-Iteration), `Operator Next` and [`Operator Step`](Operator-Step-Iteration) can be overloaded in user-defined type definitions to allow objects of that type to be used as iterators and step values in [`For...Next`](For-Next) loops.  
 As all non-static member procedures, they have passed a hidden [`This`](This) parameter that allows to access by reference to the iterator object in the code body of the 3 operators.

 `Operator Next` is called every time the iterator object needs to be checked against the end value. This happens immediately after the call to its [`Operator For`](Operator-for-Iteration), and immediately after any calls to its [`Operator Step`](Operator-Step-Iteration). `Operator Next` should return zero (0) if the loop should be terminated, or non-zero if the loop should continue iterating. The first time `Operator Next` is called, no statements in the [`For...Next`](For-Next) body, if any, have been executed yet.

 The first version of `Operator Next` is used if no step value is given in the [`For...Next`](For-Next) statement. If a step value is given, the second version is used and is passed the step value because testing for iterating end may depend on it.

 *Advanced usage*

The above description seems to imply that the 3 arguments `start_value`, `end_value`, and `step_value` must be of the same type as the `iterator` (this is the more obvious use), but it is not quite true:

**-** The `start_value`, `end_value`, and `step_value` arguments can be of any type (of different types among themselves and also of different types from the one of the `iterator`).
 **-** The only constraint is that the `iterator` could be constructed (in case of local `iterator`) or assigned (in case of global `iterator`) from the `start_value` argument (because the `iterator` is implicitly constructed or assigned under the hood).
 **-** Similarly the other parameters `end_value`, and `step_value` must be able to be converted into objects of the same type as the `iterator`.

## Remarks

### Usage

```freebasic
For iterator [ As typename ] = start_value To end_value [ Step step_value ]

[ ...statements... ]

Next
```

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### See also

- [`Operator For`](Operator-for-Iteration)
- [`Operator Step`](Operator-Step-Iteration)
- [`For...Next`](For-Next)

## Examples

See the [Operator Step](Operator-Step-Iteration) examples.

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
