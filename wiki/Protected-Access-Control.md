[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Protected: (Access Control)**

# Protected: (Access Control)

Specifies protected member access control in a Type or Class

## Syntax

```freebasic
Type typename
Protected:
member declarations
End Type
```

## Parameters

- `typename`
- `member declarations`

## Description

`Protected:` indicates that `member declarations` following it have protected access.  
 Protected members are accessible only from inside a member procedure of their [`Type`](Type-Udt) or [`Class`](Class), and classes which are derived from this [`Type`](Type-Udt) or [`Class`](Class). Seen from inside such a member procedure, it is as if the protected member is in fact public, and that regardless of the object on which the access operator is applied.

 `member declarations` following `Protected:` are protected until a different access control specifier is given, like [`Private:`](Private-Access-Control) or [`Public:`](Public-Access-Control).

 Members in a [`Type`](Type-Udt) declaration are `Public:` by default if no member access control specifier is given.

## Remarks

### Dialect Differences

- Available only in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Class`](Class)
- [`Private:`](Private-Access-Control) (Access Control)
- [`Public:`](Public-Access-Control) (Access Control)
- [`Type`](Type-Udt)

## Examples

```freebasic
Type animal

  Dim As String animalName

  Protected:

    Dim As Integer serialNumber

End Type

Type dog Extends animal

  Dim As String masterName

  Declare Sub setSerialNumber ( ByVal number As Integer )

End Type

Sub dog.setSerialNumber ( ByVal number As Integer )

  '' This is OK. We're inside a member function of the derived type

  This.serialNumber = number

End Sub

Dim As dog d

'' This is OK, animalName is public

d.animalName = "Buddy"

'' this would generate a compile error:

'' - serialNumber is protected and we're trying to access it outside its type and the derived type

'' d.serialNumber = 123456789
```

```freebasic
' Example to illustrate the access control 'Protected' with a token provided by an admin right for an user right:

'    - The 'admin_right' type extends the 'user_right' type.

'    - Create directly an 'user_right' object is forbidden.

'         ('default user_right.constructor' access and 'copy user_right.constructor' access are 'Protected')

'    - The 'user_right' type has only the access right to get the token.

'         ('user_right.token' get-property access is 'Public' and 'user_right.token' set-property access is 'protected')

'    - The 'admin_right' type has the access rights to set and to get the token.

'         ('admin_right.token' get-property access and 'admin_right.token' set-property access are 'Public')

'

' An 'admin_right' object is created, and then a reference of type 'user_right' to this object is defined.

'    (create directly an 'user_right' object is forbidden)

Type user_right

  Public:

    Declare Property token () As String          '' 'Public' to authorize user_right token get

  Protected:

    Declare Constructor ()                       '' 'Protected' to forbid user_right object default-construction

    Declare Constructor (ByRef u As user_right)  '' 'Protected' to forbid user_right object copy-construction

    Declare Property token (ByRef s As String)   '' 'Protected' to forbid user_right token set

  Private:

    Dim As String user_right_token               '' 'Private' to forbid access from outside user_right

End Type

Constructor user_right ()  '' Default-constructor

End Constructor

Constructor user_right (ByRef u As user_right)  '' Protected copy-constructor

  This.user_right_token = u.user_right_token

End Constructor

Property user_right.token () As String  '' Public property user_right token get

  Return This.user_right_token

End Property

Property user_right.token (ByRef s As String)  '' Protected property user_right token set

  This.user_right_token = s

End Property

Type admin_right Extends user_right

  Public:

    Declare Property token () As String         '' 'Public' to authorize admin_right token get

    Declare Property token (ByRef s As String)  '' 'Public' to authorize admin_right token set

End Type

Property admin_right.token () As String  '' Public property admin_right token get

  Return Base.token                      '' 'Base.' to access to the base type property shadowed by this property name

End Property

Property admin_right.token (ByRef s As String)  '' Public property admin_right token set

  Base.token = s                                '' 'Base.' to access to the base type property shadowed by this property name

End Property

Dim As admin_right ar       '' Create an admin_right type object 'ar'

ar.token = "fxm123456789"   '' admin_right set the token for user_right

Print "'" & ar.token & "'"  '' admin_right get the user_right token

Print

Dim ByRef As user_right ur = ar  '' Create a user_right type reference 'ur' to the 'ar' instance of admin_right type

Print "'" & ur.token & "'"       '' user_right get its token

'ur.token = "fxm0"               '' Error: Illegal member access, USER_RIGHT.TOKEN.property.set (user_right cannot set its token)

'Dim As user_right ur1       '' Error: The default constructor has no public access

'Dim As user_right ur2 = ar  '' Error: Constructor has no public access

Sleep
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
