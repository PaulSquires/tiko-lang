[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Extends Wstring**

# Extends Wstring

Specifies a type which inherits a Wstring behavior

## Syntax

```freebasic
Type|Union typename Extends Wstring [, base_typename]
...
End Type|Union
```

## Description

`Extends Wstring` declares `typename` to inherit properties and behaviors of a [`WString`](Wstring). Purpose is to allow users to create custom string types (with i.e. dynamic memory management) that can integrate well in to existing compiler built ins (good interoperability with the [`WString`](Wstring) type).

 This declaration of such a UDT with a suitable [`Cast`](Operator-Cast) operator will instruct compiler to convert the UDT to a [`WString`](Wstring) (in addition, other suitable operators as [`Let`](Operator-Let-Assign), [`[] (Pointer Index)`](Operator-Pointer-Index), [`Len`](Len), ..., can be also declared).

 [`WString`](Wstring) behaviour can be inherited directly, or indirectly and singly from a base-type.  
 [`WString`](Wstring) behaviour can be inherited by a UDT also extending `base_typename` (a kind of pseudo multiple-inheritance).

 By declaring a type (directly or indirectly) as `Extends Wstring` (in addition to defining a suitable [`Cast`](Operator-Cast) operator only), this promotes it fully [`WString`](Wstring) type compatible, even with [`StrPtr`](Operator-Strptr-String-Pointer)/[`SAdd`](Sadd), [`LSet`](Lset)/[`RSet`](Rset), and [`Select Case`](procedures-Select-Case).

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Extends __Wstring`, but unusable because no member procedure is allowed in this dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Type`](Type-Udt)
- [`Union`](Union)
- [`Extends`](Extends)
- [`WString`](Wstring)
- [`Extends Zstring`](Extends-Zstring)

## Examples

See [`Extends Zstring`](Extends-Zstring) for similar examples.

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
