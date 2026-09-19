[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Public: (Access Control)**

# Public: (Access Control)

Specifies public member access control in a Type or Class

## Syntax

```freebasic
Type typename
Public:
member declarations
End Type
```

## Parameters

- `typename`
- `member declarations`

## Description

`Public:` indicates that `member declarations` following it have public access.  
 Public members are accessible with any usage of the [`Type`](Type-Udt) or [`Class`](Class).

 `member declarations` following `Public:` are public until a different access control specifier is given, like [`Private:`](Private-Access-Control) or [`Protected:`](Protected-Access-Control)

 Members in a [`Type`](Type-Udt) declaration are `Public:` by default if no member access control specifier is given.

## Remarks

### Dialect Differences

- Available only in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Class`](Class)
- [`Private:`](Private-Access-Control) (Access Control)
- [`Protected:`](Protected-Access-Control) (Access Control)
- [`Public`](Public)
- [`Type`](Type-Udt)

## Examples

```freebasic
Type testing

  Private:

    nome As String

  Public:

    number As Integer

  Declare Sub setNome( ByRef newnome As String )

End Type

Sub testing.setnome( ByRef newnome As String )

  this.nome = newnome

End Sub

Dim As testing myVariable

'' We can access these members anywhere since

'' they're public

myVariable.number = 69 ''

myVariable.setNome( "FreeBASIC" )
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
