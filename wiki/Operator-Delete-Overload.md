[Home](Home) › [Operators](Category-Operators) › **Operator Delete Overload**

# Operator Delete Overload

Member operator to overload memory deallocation process part provided by Operator Delete Statement when applying to a UDT (User Defined Type).

## Syntax

```freebasic
Declare Operator Delete ( buf As Any Ptr )
Declare Operator delete[] ( buf As Any Ptr )
```

## Parameters

- `buf`

## Description

The member operator `Delete Overload` overloads the memory deallocation process part provided by the [`Delete Statement`](Operator-Delete-Statement) operator when applying to a UDT (User Defined Type). So the user can define its own memory deallocation process part.  
 But before that, the UDT instance destruction process part provided by the [`Delete Statement`](Operator-Delete-Statement) operator is not modified.

 `Delete[] Overload` operator is the array-version of `Delete Overload` operator and overloads the memory deallocation process provided by the `Delete[] Statement` operator when applying to a UDT (User Defined Type).

 Memory freed with `Delete Overload` operator must have be allocated by also defining a [`New Overload`](Operator-New-Overload) operator. Memory freed with `Delete[] Overload` operator must have been allocated by also defining a `New[] Overload operator`, the array-version of [`New Overload`](Operator-New-Overload) operator. You cannot mix and match the different versions of the operators.

 Member operators `Delete Overload`, and `Delete[] Overload` are always static, even if not explicitly declared ([`Static`](Static-Member) keyword is unnecessary but allowed). Thus, they do not have an implicit [`This`](This) instance argument passed to them (because instance already been destroyed).

## Remarks

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Delete Statement`](Operator-Delete-Statement)
- [`New Overload`](Operator-New-Overload)
- [`Deallocate`](Deallocate)

## Examples

See the [`New Overload`](Operator-New-Overload) operator examples.

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
