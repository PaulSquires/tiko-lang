[Home](Home) › **Operator Precedence**

# Operator Precedence

When several operations occur in a single expression, each operation is evaluated and resolved in a predetermined order. This is called the order of operation or operator precedence.

 If an operator in an expression has a higher precedence, it is evaluated before an operator of lower precedence.

 If operators have equal precedence, they then are evaluated in the order in of their associativity. The associativity may be Left-to-Right or Right-to-Left order.

 As a rule, binary operators (such as [`+`](Operator-Addition), [`^`](Operator-Exponentiate)) and unary postfix operators (such as [`()`](Operator-Array-Index), [`->`](Operator-Pointer-to-Member-Access)) are evaluated Left-to-Right, and unary prefix operators (such as [`Not`](Operator-Not-Complement), [`@`](Operator-Address-of)) are evaluated Right-to-Left.

 Operators that have an associativity of "N/A" indicate that there is no expression in which the operator can be used where its order of operation would need to be checked, either by precedence or by associativity. Function-like operators such as [`Cast`](Cast) are always the first to be evaluated due to the parentheses required in their syntax. And assignment operators are always the last to be evaluated.

 Parentheses can be used to override operator precedence. Operations within parentheses are performed before other operations. Within the parentheses normal operator precedence is used.

 The following table lists operator precedence from highest to lowest. Breaks in the table mark the groups of operators having equal precedence.

***Highest Precedence***

| Operator | Description | Associativity |
| --- | --- | --- |
| | | |
| CAST | Type Conversion | N/A |
| PROCPTR | Procedure pointer | N/A |
| STRPTR | String pointer | N/A |
| VARPTR | Variable pointer | N/A |
| | | |
| \[\] | String index | Left-to-Right |
| \[\] | Pointer index | Left-to-Right |
| () | Array index | Left-to-Right |
| () | Function Call | Left-to-Right |
| . | Member access | Left-to-Right |
| -> | Pointer to member access | Left-to-Right |
| | | |
| @ | Address of | Right-to-Left |
| \* | Value of | Right-to-Left |
| New | Allocate Memory | Right-to-Left |
| Delete | Deallocate Memory | Right-to-Left |
| | | |
| ^ | Exponentiate | Left-to-Right |
| | | |
| - | Negate | Right-to-Left |
| | | |
| \* | Multiply | Left-to-Right |
| / | Divide | Left-to-Right |
| | | |
| \\ | Integer divide | Left-to-Right |
| | | |
| MOD | Modulus | Left-to-Right |
| | | |
| SHL | Shift left | Left-to-Right |
| SHR | Shift right | Left-to-Right |
| | | |
| + | Add | Left-to-Right |
| - | Subtract | Left-to-Right |
| | | |
| & | String concatenation | Left-to-Right |
| | | |
| Is | Run-time type information check | N/A |
| | | |
| = | Equal | Left-to-Right |
| <> | Not equal | Left-to-Right |
| < | Less than | Left-to-Right |
| <= | Less than or equal | Left-to-Right |
| >= | Greater than or equal | Left-to-Right |
| > | Greater than | Left-to-Right |
| | | |
| NOT | Complement | Right-to-Left |
| | | |
| AND | Conjunction | Left-to-Right |
| | | |
| OR | Inclusive Disjunction | Left-to-Right |
| | | |
| EQV | Equivalence | Left-to-Right |
| IMP | Implication | Left-to-Right |
| XOR | Exclusive Disjunction | Left-to-Right |
| | | |
| ANDALSO | Short Circuit Conjunction | Left-to-Right |
| ORELSE | Short Circuit Inclusive Disjunction | Left-to-Right |
| | | |
| =\[>\] | Assignment | N/A |
| &= | Concatenate and Assign | N/A |
| += | Add and Assign | N/A |
| -= | Subtract and Assign | N/A |
| \*= | Multiply and Assign | N/A |
| /= | Divide and Assign | N/A |
| \\= | Integer Divide and Assign | N/A |
| ^= | Exponentiate and Assign | N/A |
| MOD= | Modulus and Assign | N/A |
| AND= | Conjunction and Assign | N/A |
| EQV= | Equivalence and Assign | N/A |
| IMP= | Implication and Assign | N/A |
| OR= | Inclusive Disjunction and Assign | N/A |
| XOR= | Exclusive Disjunction and Assign | N/A |
| SHL= | Shift Left and Assign | N/A |
| SHR= | Shift Right and Assign | N/A |
| LET | Assignment | N/A |
| | | |
| LET() | Assignment | N/A |

 In some cases, the order of precedence can cause confusing or counter-intuitive results. Here are some examples:

```freebasic
'' trying to raise a negated number to a power

-2 ^ 2

Desired result: (-2) ^ 2 = 4

Actual result:   -(2 ^ 2) = -4

'' trying to test a bit in a number

n And 1  <>  0

Desired result: (n And 1) <> 0

Actual result:   n And (1 <> 0)

'' trying to shift a number by n+1 bits

a Shl n+1

Desired result: a Shl (n + 1)

Actual result: (a Shl n) + 1
```

For expressions where the operator precedence may be ambiguous, it is recommended to wrap parts of the expression in parentheses, in order both to minimise the possibility of error and to aid comprehension for people reading the code.

See also

- [Operators](Operators)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
