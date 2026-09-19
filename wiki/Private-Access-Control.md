[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Private: (Access Control)**

# Private: (Access Control)

Specifies private member access control in a Type or Class

## Syntax

```freebasic
Type typename
Private:
member declarations
End Type
```

## Parameters

- `typename`
- `member declarations`

## Description

`Private:` indicates that `member declarations` following it have private access.  
 Private members are accessible only from inside a member procedure of their [`Type`](Type-Udt) or [`Class`](Class). Seen from inside such a member procedure, it is as if the protected member is in fact public, and that regardless of the object on which the access operator is applied.

 `member declarations` following `Private:` are private until a different access control specifier is given, like [`Public:`](Public-Access-Control) or [`Protected:`](Protected-Access-Control).

 Members in a [`Type`](Type-Udt) declaration are `Public:` by default if no member access control specifier is given.

## Remarks

### Dialect Differences

- Available only in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Private`](Private)
- [`Public:`](Public-Access-Control) (Access Control)
- [`Protected:`](Protected-Access-Control) (Access Control)
- [`Type`](Type-Udt)

## Examples

```freebasic
Type testing

  number As Integer

  Private:

    nome As String

  Declare Sub setNome( ByRef newnome As String )

End Type

Sub testing.setnome( ByRef newnome As String )

  '' This is OK. We're inside a member function for the type

  this.nome = newnome

End Sub

Dim As testing myVariable

'' This is OK, number is public

myVariable.number = 69

'' this would generate a compile error

'' - nome is private and we're trying to access it outside any of this TYPE's member functions

'' myVariable.nome = "FreeBASIC"
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
