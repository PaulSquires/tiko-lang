[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **TypeOf**

# TypeOf

Returns the type of a variable.

## Syntax

```freebasic
TypeOf ( variable | datatype )
```

## Parameters

- `variable`
- `datatype`

## Description

`TypeOf` is a compiler intrinsic that replaces itself with the type of the variable passed to it. It can either be used in a variable declaration (Example 1) or it can be used in the preprocessor for comparison, printing. (Example 2)

 `TypeOf` also supports passing any intrinsic data type, or user-defined type (and its data fields), not only variables defined as those types. Also supported are expressions, the type is inferred from the expression (much like [`Var`](Var)).

 If there is both a user defined type and a variable visible with the same name in the current scope, the user defined type takes precedence over the variable. To ensure that the `TypeOf` takes the variable instead of the user defined type, wrap the argument to `TypeOf` with parentheses to force it to be seen as an expression. For example `Typeof((variable))`.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Typeof`.

### Differences from QB

- New to FreeBASIC

### See also

- [`SizeOf`](Sizeof)
- [`Var`](Var)
- [`Type (Alias)`](Type-Alias)
- [`Type...End Type`](Type-Udt)

## Examples

Example 1:

```freebasic
Dim As Integer foo

Dim As TypeOf(67.2) bar '' '67.2' is a literal double

Dim As TypeOf( foo + bar ) teh_double '' double + integer results in double

Print SizeOf(teh_double)
```

Example 2:

```freebasic
Dim As String foo

#print TypeOf(foo)

#if TypeOf(foo) = TypeOf(Integer)

  #print "Never happened!"

#endif

#if TypeOf(foo) = TypeOf(String)

  #print "It's a String!"

#endif
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
