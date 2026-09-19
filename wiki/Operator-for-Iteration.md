[Home](Home) › [Operators](Category-Operators) › **Operator For (Iteration)**

# Operator For (Iteration)

Declares or defines operators used by a For...Next loop with user defined type variables

## Syntax

```freebasic
{ Type | Class | Union } typename
Declare Operator For ()
Declare Operator For ( [ ByRef | ByVal ] stp As typename )
...
End { Type | Class | Union }
```

## Parameters

- `typename`
- `stp`
- `step_value`
- `typename`
- `iterator`
- `typename`
- `end_value`
- `typename`
- `start_value`
- `typename`

## Description

`Operator For`, [`Operator Next`](Operator-Next-Iteration) and [`Operator Step`](Operator-Step-Iteration) can be overloaded in user-defined type definitions to allow objects of that type to be used as iterators and step values in [`For...Next`](For-Next) loops.  
 As all non-static member procedures, they have passed a hidden [`This`](This) parameter that allows to access by reference to the iterator object in the code body of the 3 operators.

 `Operator For` is called once after copy constructing or assigning to the iterator object, and allows the object to perform any additional initialization needed in preparation for the loop.

 The first version of `Operator For` is used if no step value is given in the [`For...Next`](For-Next) statement. If a step value is given, the second version is used and is passed the step value because eventual additional initialization may use it.

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

- [`Operator Next`](Operator-Next-Iteration)
- [`Operator Step`](Operator-Step-Iteration)
- [`For...Next`](For-Next)

## Examples

See the [Operator Step](Operator-Step-Iteration) examples.

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
