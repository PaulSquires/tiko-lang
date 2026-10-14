[Home](Home) › **Bitwise Operators Truth Tables**

# Bitwise Operators Truth Tables

Computed values for the bitwise logical operators.

 **Binary operators**

Operators that take two operands.

**Unary operator**

Operator that take a single operand.

 These logical operators return a value based on the value of their operand(s). For the binary operators, each bit in the left-hand side value is applied logically to the corresponding bit in the right-hand side value. The result of this operation is returned. For the unary operator, ([`Operator Not`](Operator-Not-Complement)), the logic is applied to its right-hand side operand only.

***Binary operators***

**[Operator And (Conjunction)](Operator-and-Conjunction)**

Bits in the result are set if and only if both of the corresponding bits in the left and right-hand side operands are set.

| Lhs | 0 | 0 | 1 | 1 |
| --- | --- | --- | --- | --- |
| Rhs | 0 | 1 | 0 | 1 |
| Result | 0 | 0 | 0 | 1 |

**[Operator Eqv (Equivalence)](Operator-Eqv-Equivalence)**

Bits in the result are set if and only if both of the corresponding bits in the left and right-hand side operands are both either set or unset.

| Lhs | 0 | 0 | 1 | 1 |
| --- | --- | --- | --- | --- |
| Rhs | 0 | 1 | 0 | 1 |
| Result | 1 | 0 | 0 | 1 |

**[Operator Imp (Implication)](Operator-Imp-Implication)**

Bits in the result are set if and only if the corresponding bit in the left-hand side operand implies the bit in the right-hand side operand.

| Lhs | 0 | 0 | 1 | 1 |
| --- | --- | --- | --- | --- |
| Rhs | 0 | 1 | 0 | 1 |
| Result | 1 | 1 | 0 | 1 |

**[Operator Or (Inclusive Disjunction)](Operator-or-Inclusive-Disjunction)**

Bits in the result are set if either of the corresponding bits in the left and right-hand side operands are set.

| Lhs | 0 | 0 | 1 | 1 |
| --- | --- | --- | --- | --- |
| Rhs | 0 | 1 | 0 | 1 |
| Result | 0 | 1 | 1 | 1 |

**[Operator Xor (Exclusive Disjunction)](Operator-Xor-Exclusive-Disjunction)**

Bits in the result are set if and only if one of the corresponding bits in the left and right-hand side operands is set.

| Lhs | 0 | 0 | 1 | 1 |
| --- | --- | --- | --- | --- |
| Rhs | 0 | 1 | 0 | 1 |
| Result | 0 | 1 | 1 | 0 |

***Unary operators***

**[Operator Not (Complement)](Operator-Not-Complement)**

Bits in the result are set if the corresponding bits in the right-hand side operand are unset, and unset if they are set.

| Rhs | 0 | 1 |
| --- | --- | --- |
| Result | 1 | 0 |

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
